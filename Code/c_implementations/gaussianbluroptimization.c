#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <stdint.h>
#include <omp.h>

#define HBLK 16  // horizontal block size — change to 8, 16, or 32 to benchmark

void make_gaussian_kernel(int *kernel, int k, float sigma) {
    int half = k / 2;
    float sum = 0.0f;
    float *tmp_float = (float *)malloc(k * sizeof(float));
    for (int i = 0; i < k; i++) {
        float x = (float)(i - half);
        tmp_float[i] = expf(-(x * x) / (2.0f * sigma * sigma));
        sum += tmp_float[i];
    }
    for (int i = 0; i < k; i++)
        kernel[i] = (int)roundf(tmp_float[i] / sum * 256.0f);
    free(tmp_float);
    // Rounding can make the sum 257 (or rarely 255). Force it to exactly 256
    // so the two-pass >> 16 normalization never overflows unsigned char.
    int ksum = 0;
    for (int i = 0; i < k; i++) ksum += kernel[i];
    kernel[half] += 256 - ksum;
}

// Processes all 3 channels in a single set of OMP parallel regions.
// One tmp allocation (49.5MB) instead of three separate 16.5MB mallocs.
// OMP launches: 4 per frame instead of 12.
// acc_B/G/R combined = 45KB per thread, fits in P-core L1D (128KB).
void gaussian_blur_3ch(
    unsigned char **input_ch,
    unsigned char **output_ch,
    int width, int height,
    const int *kernel, int k
) {
    if (k == 1) {
        for (int ch = 0; ch < 3; ch++)
            memcpy(output_ch[ch], input_ch[ch], width * height);
        return;
    }

    int half = k / 2;
    int num_pixels = width * height;
    uint16_t *tmp = (uint16_t *)malloc(3 * num_pixels * sizeof(uint16_t));
    uint16_t *tmp_ch[3] = { tmp, tmp + num_pixels, tmp + 2 * num_pixels };

    // ── PASS 1: Horizontal ──────────────────────────────────────────
    #pragma omp parallel for schedule(static)
    for (int r = 0; r < height; r++) {
        int base = r * width;
        for (int ch = 0; ch < 3; ch++) {
            const unsigned char *inp = input_ch[ch];
            uint16_t *tmp_c = tmp_ch[ch];

            // BORDER LEFT
            for (int c = 0; c < half; c++) {
                int acc = 0;
                for (int ki = 0; ki < k; ki++) {
                    int col = c + ki - half;
                    if (col < 0) col = 0;
                    acc += kernel[ki] * inp[base + col];
                }
                tmp_c[base + c] = (uint16_t)acc;
            }

            // INTERIOR: symmetric pairs, HBLK-wide blocks
            {
                int c = half;
                for (; c + HBLK <= width - half; c += HBLK) {
                    int acc[HBLK];
                    {
                        int w = kernel[half];
                        const unsigned char *src_c = &inp[base + c];
                        for (int b = 0; b < HBLK; b++)
                            acc[b] = w * (int)src_c[b];
                    }
                    for (int ki = 0; ki < half; ki++) {
                        int w = kernel[ki];
                        const unsigned char *src_lo = &inp[base + c + ki - half];
                        const unsigned char *src_hi = &inp[base + c + half - ki];
                        for (int b = 0; b < HBLK; b++)
                            acc[b] += w * ((int)src_lo[b] + (int)src_hi[b]);
                    }
                    for (int b = 0; b < HBLK; b++)
                        tmp_c[base + c + b] = (uint16_t)acc[b];
                }
                for (; c < width - half; c++) {
                    int acc = kernel[half] * (int)inp[base + c];
                    for (int ki = 0; ki < half; ki++)
                        acc += kernel[ki] * ((int)inp[base + c + ki - half] + (int)inp[base + c + half - ki]);
                    tmp_c[base + c] = (uint16_t)acc;
                }
            }

            // BORDER RIGHT
            for (int c = width - half; c < width; c++) {
                int acc = 0;
                for (int ki = 0; ki < k; ki++) {
                    int col = c + ki - half;
                    if (col >= width) col = width - 1;
                    acc += kernel[ki] * inp[base + col];
                }
                tmp_c[base + c] = (uint16_t)acc;
            }
        }
    }

    // ── PASS 2: Vertical ────────────────────────────────────────────
    // Three separate acc arrays per thread; separate c-loops per channel
    // so the compiler can vectorize each independently.

    // BORDER TOP
    #pragma omp parallel for schedule(static)
    for (int r = 0; r < half; r++) {
        int acc_B[width], acc_G[width], acc_R[width];
        int row_out = r * width;
        {
            int w = kernel[half];
            for (int c = 0; c < width; c++) acc_B[c] = w * tmp_ch[0][row_out + c];
            for (int c = 0; c < width; c++) acc_G[c] = w * tmp_ch[1][row_out + c];
            for (int c = 0; c < width; c++) acc_R[c] = w * tmp_ch[2][row_out + c];
        }
        for (int ki = 0; ki < half; ki++) {
            int w = kernel[ki];
            int row_lo = r + ki - half; if (row_lo < 0) row_lo = 0;
            int row_hi = r + half - ki;
            int rlo = row_lo * width, rhi = row_hi * width;
            for (int c = 0; c < width; c++) acc_B[c] += w * ((int)tmp_ch[0][rlo+c] + (int)tmp_ch[0][rhi+c]);
            for (int c = 0; c < width; c++) acc_G[c] += w * ((int)tmp_ch[1][rlo+c] + (int)tmp_ch[1][rhi+c]);
            for (int c = 0; c < width; c++) acc_R[c] += w * ((int)tmp_ch[2][rlo+c] + (int)tmp_ch[2][rhi+c]);
        }
        for (int c = 0; c < width; c++) output_ch[0][row_out+c] = (unsigned char)(acc_B[c] >> 16);
        for (int c = 0; c < width; c++) output_ch[1][row_out+c] = (unsigned char)(acc_G[c] >> 16);
        for (int c = 0; c < width; c++) output_ch[2][row_out+c] = (unsigned char)(acc_R[c] >> 16);
    }

    // INTERIOR
    #pragma omp parallel for schedule(static)
    for (int r = half; r < height - half; r++) {
        int acc_B[width], acc_G[width], acc_R[width];
        int row_out = r * width;
        {
            int w = kernel[half];
            for (int c = 0; c < width; c++) acc_B[c] = w * tmp_ch[0][row_out + c];
            for (int c = 0; c < width; c++) acc_G[c] = w * tmp_ch[1][row_out + c];
            for (int c = 0; c < width; c++) acc_R[c] = w * tmp_ch[2][row_out + c];
        }
        for (int ki = 0; ki < half; ki++) {
            int w = kernel[ki];
            int rlo = (r + ki - half) * width;
            int rhi = (r + half - ki) * width;
            for (int c = 0; c < width; c++) acc_B[c] += w * ((int)tmp_ch[0][rlo+c] + (int)tmp_ch[0][rhi+c]);
            for (int c = 0; c < width; c++) acc_G[c] += w * ((int)tmp_ch[1][rlo+c] + (int)tmp_ch[1][rhi+c]);
            for (int c = 0; c < width; c++) acc_R[c] += w * ((int)tmp_ch[2][rlo+c] + (int)tmp_ch[2][rhi+c]);
        }
        for (int c = 0; c < width; c++) output_ch[0][row_out+c] = (unsigned char)(acc_B[c] >> 16);
        for (int c = 0; c < width; c++) output_ch[1][row_out+c] = (unsigned char)(acc_G[c] >> 16);
        for (int c = 0; c < width; c++) output_ch[2][row_out+c] = (unsigned char)(acc_R[c] >> 16);
    }

    // BORDER BOTTOM
    #pragma omp parallel for schedule(static)
    for (int r = height - half; r < height; r++) {
        int acc_B[width], acc_G[width], acc_R[width];
        int row_out = r * width;
        {
            int w = kernel[half];
            for (int c = 0; c < width; c++) acc_B[c] = w * tmp_ch[0][row_out + c];
            for (int c = 0; c < width; c++) acc_G[c] = w * tmp_ch[1][row_out + c];
            for (int c = 0; c < width; c++) acc_R[c] = w * tmp_ch[2][row_out + c];
        }
        for (int ki = 0; ki < half; ki++) {
            int w = kernel[ki];
            int row_lo = r + ki - half;
            int row_hi = r + half - ki; if (row_hi >= height) row_hi = height - 1;
            int rlo = row_lo * width, rhi = row_hi * width;
            for (int c = 0; c < width; c++) acc_B[c] += w * ((int)tmp_ch[0][rlo+c] + (int)tmp_ch[0][rhi+c]);
            for (int c = 0; c < width; c++) acc_G[c] += w * ((int)tmp_ch[1][rlo+c] + (int)tmp_ch[1][rhi+c]);
            for (int c = 0; c < width; c++) acc_R[c] += w * ((int)tmp_ch[2][rlo+c] + (int)tmp_ch[2][rhi+c]);
        }
        for (int c = 0; c < width; c++) output_ch[0][row_out+c] = (unsigned char)(acc_B[c] >> 16);
        for (int c = 0; c < width; c++) output_ch[1][row_out+c] = (unsigned char)(acc_G[c] >> 16);
        for (int c = 0; c < width; c++) output_ch[2][row_out+c] = (unsigned char)(acc_R[c] >> 16);
    }

    free(tmp);
}

int main(int argc, char *argv[]) {
    if (argc < 5) {
        fprintf(stderr, "Usage: %s <width> <height> <kernel_size> <num_runs>\n", argv[0]);
        return 1;
    }

    int width    = atoi(argv[1]);
    int height   = atoi(argv[2]);
    int k        = atoi(argv[3]);
    int num_runs = atoi(argv[4]);

    if (k % 2 == 0) { fprintf(stderr, "Kernel size must be odd\n"); return 1; }

    int num_pixels   = width * height;
    int num_channels = 3;

    // Read the full interleaved BGR image (3 bytes per pixel)
    unsigned char *input_bgr = (unsigned char *)malloc(num_pixels * num_channels);
    size_t bytes_read = fread(input_bgr, 1, num_pixels * num_channels, stdin);
    if ((int)bytes_read != num_pixels * num_channels) {
        fprintf(stderr, "Expected %d bytes, got %zu\n", num_pixels * num_channels, bytes_read);
        return 1;
    }

    // De-interleave: split packed BGR into 3 separate flat channel arrays.
    // input_bgr layout: B0 G0 R0  B1 G1 R1  B2 G2 R2 ...
    // After split: ch[0] = B0 B1 B2 ..., ch[1] = G0 G1 G2 ..., ch[2] = R0 R1 R2 ...
    unsigned char *input_ch[3], *output_ch[3];
    for (int ch = 0; ch < num_channels; ch++) {
        input_ch[ch]  = (unsigned char *)malloc(num_pixels);
        output_ch[ch] = (unsigned char *)malloc(num_pixels);
    }
    for (int i = 0; i < num_pixels; i++) {
        input_ch[0][i] = input_bgr[i * 3 + 0];  // B
        input_ch[1][i] = input_bgr[i * 3 + 1];  // G
        input_ch[2][i] = input_bgr[i * 3 + 2];  // R
    }

    float sigma = 0.3f * ((k - 1) * 0.5f - 1) + 0.8f;
    int *kernel = (int *)malloc(k * sizeof(int));

    // Warmup run
    make_gaussian_kernel(kernel, k, sigma);
    gaussian_blur_3ch(input_ch, output_ch, width, height, kernel, k);

    // Timed runs — kernel rebuilt every iteration to match OpenCV which
    // calls createGaussianKernels() on every GaussianBlur() call
    struct timespec t0, t1;
    clock_gettime(CLOCK_MONOTONIC, &t0);
    for (int i = 0; i < num_runs; i++) {
        make_gaussian_kernel(kernel, k, sigma);
        gaussian_blur_3ch(input_ch, output_ch, width, height, kernel, k);
    }
    clock_gettime(CLOCK_MONOTONIC, &t1);

    double elapsed_ms = ((t1.tv_sec - t0.tv_sec) * 1e9 + (t1.tv_nsec - t0.tv_nsec)) / 1e6;
    fprintf(stderr, "%.4f\n", elapsed_ms / num_runs);

    // Re-interleave output channels into BGR and write to stdout for Python to save
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
    free(kernel);
    return 0;
}
