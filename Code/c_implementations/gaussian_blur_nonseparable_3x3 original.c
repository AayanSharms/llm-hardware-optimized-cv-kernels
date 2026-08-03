#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <stdint.h>

/*
 * Build the 3×3 fixed-point Gaussian kernel.
 *
 * The standard 3×3 Gaussian (σ≈0.85) has relative weights 1:2:4.
 * Normalizing so all 9 weights sum to 256 — rather than the usual 1.0 —
 * lets the hot path use pure integer MACs; the true pixel value is
 * recovered with a single >> 8 at the end of each row.
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

static void blur_interior_ch(
    const uint8_t * restrict input, uint8_t * restrict output,
    int width, int height,
    const uint16_t kernel[9]
) {
    int iw = width - 2;  /* number of interior columns */

    for (int r = 1; r < height - 1; r++) {
        uint8_t *dst = output + r * width + 1;

        /* Outer loop: iterate over interior pixels in this row. */
        for (int c = 0; c < iw; c++) {
            uint16_t acc = 0;

            /* Inner loop: accumulate all 9 kernel taps for this single
             * pixel before finalizing it and moving to the next. */
            for (int ki = 0; ki < 9; ki++) {
                int ky = ki / 3 - 1;   /* row offset: −1, 0, +1 */
                int kx = ki % 3 - 1;   /* col offset: −1, 0, +1 */
                uint8_t w = kernel[ki];
                acc += w * input[(r + ky) * width + (1 + c + kx)];
            }

            /* Shift right by 8 to undo the ×256 fixed-point scale factor. */
            dst[c] = (uint8_t)(acc >> 8);
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

    /* Warmup run: bring code and data into cache before timing */
    for (int ch = 0; ch < 3; ch++)
        blur_interior_ch(input_ch[ch], output_ch[ch], width, height, kernel);

    /* Timed runs: clock wraps only the interior blur computation */
    struct timespec t0, t1;
    double total_ns = 0.0;
    for (int run = 0; run < num_runs; run++) {
        clock_gettime(CLOCK_MONOTONIC, &t0);
        for (int ch = 0; ch < 3; ch++)
            blur_interior_ch(input_ch[ch], output_ch[ch], width, height, kernel);
        clock_gettime(CLOCK_MONOTONIC, &t1);
        total_ns += (double)(t1.tv_sec  - t0.tv_sec)  * 1e9
                  + (double)(t1.tv_nsec - t0.tv_nsec);
    }

    /* Average per-run interior blur time in milliseconds → stderr */
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
