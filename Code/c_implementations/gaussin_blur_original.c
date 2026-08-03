#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>

void make_gaussian_kernel(float *kernel, int k, float sigma) {
    int half = k / 2;
    float sum = 0.0f; // used for normalization
    for (int pos = 0; pos < k; pos++) {
        float x = (float)(pos - half); // figure out distance from center
        kernel[pos] = expf(-(x * x) / (2.0f * sigma * sigma)); // gaussian formula, gaussian weight for position pos
        sum += kernel[pos];
    }
    // After this loop, all weights sum to exactly 1.0.
    // This means we never need to divide by a weight sum later.
    for (int pos = 0; pos < k; pos++) kernel[pos] /= sum;


void gaussian_blur_separable(
    const unsigned char *input,
    unsigned char *output,
    int width, int height,
    const float *kernel, int k
) {
    int half = k / 2;
    float *tmp = (float *)malloc(width * height * sizeof(float));

    // ── PASS 1: Horizontal ──────────────────────────────────────────
    for (int r = 0; r < height; r++) {

        // BORDER LEFT: columns too close to the left edge
        // (kernel would reach past column 0)
        for (int c = 0; c < half; c++) {
            float acc = 0.0f;
            for (int ki = 0; ki < k; ki++) {
                int col = c + ki - half;
                if (col < 0) col = 0;          // only needed here, near the edge
                acc += kernel[ki] * input[r * width + col];
            }
            tmp[r * width + c] = acc;          // no division needed — weights sum to 1
        }

        // INTERIOR: columns where the kernel fits completely inside the image.
        // No boundary checks at all — this is the fast path and covers
        // the vast majority of pixels in a large image.
        for (int c = half; c < width - half; c++) {
            float acc = 0.0f;
            for (int ki = 0; ki < k; ki++) {
                // c + ki - half is guaranteed to be inside [0, width-1]
                // so no if-statements needed here at all
                acc += kernel[ki] * input[r * width + c + ki - half];
            }
            tmp[r * width + c] = acc;
        }

        // BORDER RIGHT: columns too close to the right edge
        for (int c = width - half; c < width; c++) {
            float acc = 0.0f;
            for (int ki = 0; ki < k; ki++) {
                int col = c + ki - half;
                if (col >= width) col = width - 1;  // only needed here, near the edge
                acc += kernel[ki] * input[r * width + col];
            }
            tmp[r * width + c] = acc;
        }
    }

    // ── PASS 2: Vertical ────────────────────────────────────────────
    // Same idea — split into border top, interior, border bottom.

    // BORDER TOP
    for (int r = 0; r < half; r++) {
        for (int c = 0; c < width; c++) {
            float acc = 0.0f;
            for (int ki = 0; ki < k; ki++) {
                int row = r + ki - half;
                if (row < 0) row = 0;
                acc += kernel[ki] * tmp[row * width + c];
            }
            output[r * width + c] = (unsigned char)(acc);
        }
    }

    // INTERIOR (no branches)
    for (int r = half; r < height - half; r++) {
        for (int c = 0; c < width; c++) {
            float acc = 0.0f;
            for (int ki = 0; ki < k; ki++) {
                acc += kernel[ki] * tmp[(r + ki - half) * width + c];
            }
            output[r * width + c] = (unsigned char)(acc);
        }
    }

    // BORDER BOTTOM
    for (int r = height - half; r < height; r++) {
        for (int c = 0; c < width; c++) {
            float acc = 0.0f;
            for (int ki = 0; ki < k; ki++) {
                int row = r + ki - half;
                if (row >= height) row = height - 1;
                acc += kernel[ki] * tmp[row * width + c];
            }
            output[r * width + c] = (unsigned char)(acc);
        }
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
    float *kernel = (float *)malloc(k * sizeof(float));

    // Warmup run (kernel built here just to warm up, discarded)
    make_gaussian_kernel(kernel, k, sigma);
    for (int ch = 0; ch < num_channels; ch++)
        gaussian_blur_separable(input_ch[ch], output_ch[ch], width, height, kernel, k);

    // Timed runs — kernel rebuilt every iteration to match OpenCV which
    // calls createGaussianKernels() on every GaussianBlur() call
    struct timespec t0, t1;
    clock_gettime(CLOCK_MONOTONIC, &t0);
    for (int i = 0; i < num_runs; i++) {
        make_gaussian_kernel(kernel, k, sigma);
        for (int ch = 0; ch < num_channels; ch++)
            gaussian_blur_separable(input_ch[ch], output_ch[ch], width, height, kernel, k);
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