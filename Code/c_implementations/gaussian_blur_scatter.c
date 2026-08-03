#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <stdint.h>

/*
 * Build the 3×3 fixed-point Gaussian kernel.
 *
 * Identical to the reference (gaussian_blur_nonseparable_3x3.c): weights
 * sum to 256 so the hot path stays pure-integer, with a single >> 8 at
 * the end to recover the true pixel value.
 *
 * Weight layout (row-major, ki = ky*3 + kx, ky/kx ∈ {0,1,2}):
 *   16  32  16
 *   32  64  32
 *   16  32  16
 * Sum = 4×16 + 4×32 + 64 = 256 ✓
 */
static void make_3x3_kernel(uint16_t kernel[9]) {
    kernel[0] = 16; kernel[1] = 32; kernel[2] = 16;
    kernel[3] = 32; kernel[4] = 64; kernel[5] = 32;
    kernel[6] = 16; kernel[7] = 32; kernel[8] = 16;
}

/*
 * Non-separable 3×3 Gaussian interior blur for one channel — scatter /
 * outer-product loop structure.
 *
 * The reference implementation is weights-outer: it fixes one kernel tap
 * and sweeps the whole row into an acc[] array, repeating 9 times per row
 * (each input row is read 3 times, once per row-offset). This version
 * flips the loop order to pixel-outer: for each output pixel we gather
 * its entire 3×3 input neighborhood first, then apply all 9 weights in
 * one shot.
 *
 * Outer-product framing: the 9 kernel weights form a 9×1 column vector;
 * the 9 gathered input pixels form a 1×9 row vector. Their outer product
 * is a 9×9 matrix where cell (i, j) = weight_i * input_j. Here we only
 * ever need the cells where i == j (weight_i applied to its own input
 * pixel) — i.e. one specific diagonal "row" of that conceptual matrix —
 * and every one of those 9 cells contributes to the *same* output pixel.
 * So instead of materializing a matrix or a per-column acc[] array, the
 * 9 products are summed directly into a single scalar the moment they're
 * computed.
 *
 * Register pressure / reuse: I0..I8 are named scalar variables, not
 * array elements. Naming them individually (rather than indexing a
 * local uint8_t block[9]) gives the compiler the freedom to keep all 9
 * live in registers simultaneously with no aliasing between them — each
 * input pixel is loaded from memory exactly once and then reused for
 * its single weighted product. This is the "input block" the outer
 * product is taken against.
 *
 * Why no acc[] array: the reference needs acc[] because its outer loop
 * variable is the kernel tap, so partial sums for many different output
 * columns are in flight at once and must be held between tap iterations.
 * Here the outer loop variable is the output pixel itself, so all 9
 * weighted contributions to that pixel are produced back-to-back and
 * can be summed into one uint32_t and written out immediately — nothing
 * needs to persist across loop iterations.
 *
 * Fixed-point contract (identical to reference):
 *   accumulate : sum += kernel[ki] * Ii              (Σ weights = 256)
 *   normalize  : output[r][c] = (uint8_t)(sum >> 8)   (undo the ×256 scale)
 * Worst-case sum: 256 × 255 = 65 280, which fits uint16_t, but sum is
 * declared uint32_t for clarity/headroom rather than to avoid overflow.
 *
 * Interior vs. border: only pixels with r in [1, height-2] and c in
 * [1, width-2] have a full 3×3 neighborhood inside the image, so only
 * those are computed here (and thus only those are inside the timed
 * region in main()). The 1-pixel border is copied verbatim from input
 * to output outside this function, exactly as in the reference.
 */
static void blur_scatter_ch(
    const uint8_t * restrict input, uint8_t * restrict output,
    int width, int height,
    const uint16_t kernel[9]
) {
    // Only process interior pixels — 1-pixel border is handled outside
    for (int r = 1; r < height - 1; r++) {
        for (int c = 1; c < width - 1; c++) {

            // Load the 3x3 neighborhood into 9 named variables.
            // Named variables — not array indexing — so the compiler
            // can allocate all 9 to registers simultaneously.
            // This is the "input block" of the outer product.
            uint8_t I0 = input[(r-1)*width + (c-1)];  // top-left
            uint8_t I1 = input[(r-1)*width + (c  )];  // top-center
            uint8_t I2 = input[(r-1)*width + (c+1)];  // top-right
            uint8_t I3 = input[(r  )*width + (c-1)];  // mid-left
            uint8_t I4 = input[(r  )*width + (c  )];  // center
            uint8_t I5 = input[(r  )*width + (c+1)];  // mid-right
            uint8_t I6 = input[(r+1)*width + (c-1)];  // bot-left
            uint8_t I7 = input[(r+1)*width + (c  )];  // bot-center
            uint8_t I8 = input[(r+1)*width + (c+1)];  // bot-right

            // Compute all 9 weighted contributions to output[r][c].
            // This is one row of the outer product result matrix —
            // each kernel weight applied to its corresponding input pixel.
            // All 9 inputs are live simultaneously so no input is reloaded.
            // Worst case: 256 * 255 = 65280, fits uint16 — use uint32 for clarity.
            uint32_t sum = 0;
            sum += (uint32_t)kernel[0] * I0;  // top-left tap
            sum += (uint32_t)kernel[1] * I1;  // top-center tap
            sum += (uint32_t)kernel[2] * I2;  // top-right tap
            sum += (uint32_t)kernel[3] * I3;  // mid-left tap
            sum += (uint32_t)kernel[4] * I4;  // center tap (weight=64, strongest)
            sum += (uint32_t)kernel[5] * I5;  // mid-right tap
            sum += (uint32_t)kernel[6] * I6;  // bot-left tap
            sum += (uint32_t)kernel[7] * I7;  // bot-center tap
            sum += (uint32_t)kernel[8] * I8;  // bot-right tap

            // Normalize: shift right by 8 to undo the x256 fixed-point scale.
            // Write directly to output — no separate acc[] array needed.
            output[r * width + c] = (uint8_t)(sum >> 8);
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        fprintf(stderr, "Usage: %s <width> <height> [num_runs]\n", argv[0]);
        return 1;
    }

    int width    = atoi(argv[1]);
    int height   = atoi(argv[2]);
    int num_runs = (argc >= 4) ? atoi(argv[3]) : 100;

    int num_pixels   = width * height;
    int num_channels = 3;

    /* Read the full interleaved BGR image (3 bytes per pixel) */
    unsigned char *input_bgr = (unsigned char *)malloc(num_pixels * num_channels);
    size_t bytes_read = fread(input_bgr, 1, num_pixels * num_channels, stdin);
    if ((int)bytes_read != num_pixels * num_channels) {
        fprintf(stderr, "Expected %d bytes, got %zu\n",
                num_pixels * num_channels, bytes_read);
        return 1;
    }

    /* De-interleave: split packed BGR into 3 separate flat channel arrays.
     * input_bgr layout: B0 G0 R0  B1 G1 R1 ...
     * After split: ch[0] = B0 B1 ..., ch[1] = G0 G1 ..., ch[2] = R0 R1 ... */
    uint8_t *input_ch[3], *output_ch[3];
    for (int ch = 0; ch < num_channels; ch++) {
        input_ch[ch]  = (uint8_t *)malloc(num_pixels);
        output_ch[ch] = (uint8_t *)malloc(num_pixels);
    }
    for (int i = 0; i < num_pixels; i++) {
        input_ch[0][i] = input_bgr[i * 3 + 0];  /* B */
        input_ch[1][i] = input_bgr[i * 3 + 1];  /* G */
        input_ch[2][i] = input_bgr[i * 3 + 2];  /* R */
    }

    uint16_t kernel[9];
    make_3x3_kernel(kernel);

    /* Border pixels: copy from input — outside the timed region.
     * The 1-pixel border has no full 3×3 neighborhood so is left unblurred. */
    for (int ch = 0; ch < 3; ch++) {
        memcpy(output_ch[ch], input_ch[ch], width);                               /* top row    */
        memcpy(output_ch[ch] + (height - 1) * width,
               input_ch[ch]  + (height - 1) * width, width);                     /* bottom row */
        for (int r = 1; r < height - 1; r++) {
            output_ch[ch][r * width]           = input_ch[ch][r * width];         /* left col   */
            output_ch[ch][r * width + width-1] = input_ch[ch][r * width + width-1]; /* right col */
        }
    }

    /* Warmup run — brings code and data into cache before timing starts.
     * No acc[] to allocate: blur_scatter_ch accumulates entirely in
     * registers/locals per pixel, so there is no shared buffer to
     * pre-allocate the way the reference pre-allocates acc[]. */
    for (int ch = 0; ch < 3; ch++)
        blur_scatter_ch(input_ch[ch], output_ch[ch], width, height, kernel);

    /* Timed loop — only blur_scatter_ch is inside the clock calls */
    struct timespec t0, t1;
    double total_ns = 0.0;
    for (int run = 0; run < num_runs; run++) {
        clock_gettime(CLOCK_MONOTONIC, &t0);
        for (int ch = 0; ch < 3; ch++)
            blur_scatter_ch(input_ch[ch], output_ch[ch], width, height, kernel);
        clock_gettime(CLOCK_MONOTONIC, &t1);
        total_ns += (double)(t1.tv_sec - t0.tv_sec) * 1e9
                  + (double)(t1.tv_nsec - t0.tv_nsec);
    }
    /* Print average time per run in milliseconds to stderr */
    fprintf(stderr, "%.4f\n", total_ns / num_runs / 1e6);

    /* Re-interleave output channels into BGR and write to stdout */
    unsigned char *output_bgr = (unsigned char *)malloc(num_pixels * num_channels);
    for (int i = 0; i < num_pixels; i++) {
        output_bgr[i * 3 + 0] = output_ch[0][i];
        output_bgr[i * 3 + 1] = output_ch[1][i];
        output_bgr[i * 3 + 2] = output_ch[2][i];
    }
    fwrite(output_bgr, 1, num_pixels * num_channels, stdout);

    free(output_bgr);
    free(input_bgr);
    for (int ch = 0; ch < num_channels; ch++) { free(input_ch[ch]); free(output_ch[ch]); }
    return 0;
}
