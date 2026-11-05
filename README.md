# LLM-Generated, Hardware-Optimized Computer Vision Kernels

Undergraduate research in the ECE Department at Carnegie Mellon University, advised by Prof. Tze Meng Low.

## The question

Can an LLM, used one step at a time, write architecture-specific C that competes with a hand-tuned library like OpenCV?

The LLM (Claude) writes the code. I pick what to try next, benchmark every round myself, and decide whether the change stays. A curated log of that back-and-forth is in [`gaussian_blur_implementation_chatlog_curated.txt`](gaussian_blur_implementation_chatlog_curated.txt).

## Setup

| | |
|---|---|
| Kernel | Gaussian blur (separable convolution) |
| Baseline | `cv2.GaussianBlur()` (OpenCV's optimized separable path) |
| Input | 3840×2160 (4K), 3-channel BGR, uint8 |
| Method | 100-run average per kernel size, 11 kernel sizes from 1×1 to 101×101 |
| Hardware | 2025 MacBook Pro, Apple M4 Pro (10 P-cores + 4 E-cores), 24 GB unified memory |
| Toolchain | Clang, OpenMP, ARM NEON |

## Results

After 12 rounds, the C version beats OpenCV at 9 of the 11 kernel sizes. It's still slower at 9×9 and 15×15.

| Kernel | OpenCV (ms) | C, round 12 (ms) | C speedup vs. OpenCV |
|---:|---:|---:|---:|
| 1×1 | 0.376 | 0.312 | 1.21x |
| 5×5 | 3.325 | 2.641 | 1.26x |
| 7×7 | 3.135 | 3.043 | 1.03x |
| 9×9 | 3.289 | 4.875 | 0.67x |
| 15×15 | 2.844 | 5.817 | 0.49x |
| 29×29 | 10.652 | 9.596 | 1.11x |
| 43×43 | 16.428 | 13.608 | 1.21x |
| 57×57 | 22.228 | 18.476 | 1.20x |
| 71×71 | 26.873 | 21.056 | 1.28x |
| 85×85 | 33.765 | 25.688 | 1.31x |
| 101×101 | 44.729 | 30.363 | 1.47x |

The first, unoptimized version was 29–62x slower than OpenCV. Every round is recorded in [`Results_OpenCV_Vs_CImplementation.xlsx`](Results_OpenCV_Vs_CImplementation.xlsx).

### The 12 rounds

1. Cache-friendly loop order for the vertical pass
2. Compiler flags (`-O3 -march=native -ffast-math`, NEON auto-vectorization)
3. Fixed-point integer arithmetic
4. Skip the 1×1 kernel
5. Loop swap for SIMD
6. Register tiling (16-pixel groups)
7. `malloc` and skip zero-init
8. uint16 intermediate buffer
9. OpenMP multithreading
10. L1-cache row accumulator
11. Symmetric kernel folding
12. All 3 channels processed together

## What I learned

- **One change did most of the work.** Round 10 replaced a 33 MB full-frame accumulator in DRAM with a ~15 KB per-row accumulator that stays in L1. That round alone produced about 75% of the total speedup.
- **Roofline model.** I measured 228 GB/s of memory bandwidth with a STREAM Triad benchmark (`stream_bench.c`) and a ~450 GIOPS int32 multiply-accumulate ceiling (`int32_mac_bench.c`), against a ~1,440 GIOPS theoretical peak. With the L1 accumulator, every kernel size of 5 or larger sits on the compute-bound side of the roofline. The roofline sheet is in [`ResultsCImplementation.xlsx`](ResultsCImplementation.xlsx).
- **Data width matters.** The kernel weights sum to 256, so the worst-case accumulator value is 256 × 255 = 65,280. That fits in 16 bits instead of 32, which doubles the pixels per NEON instruction. That's the basis for the next round.

## Repo layout

```
Code/
  c_implementations/     C versions of the blur, plus the STREAM and int32 MAC benchmarks
  benchmarks/            Python harness that runs the C binary against cv2.GaussianBlur()
  metal_implementation/  OpenCV's own dispatch sources, kept for reference (OpenCV license)
Photos/                  Test images (1080p, 4K, 8K)
*.xlsx                   Benchmark spreadsheets for every round, plus roofline analysis
Research Notes June 9th.pdf, gaussian_blur_implementation_chatlog_curated.txt
                         Research notes and the curated LLM chat log
```

The C blur binary takes `<width> <height> <kernel_size> <num_runs>`. The Python harness runs it over each kernel size and compares timing and output against OpenCV.

## Next steps

- Explicit NEON intrinsics using the uint16 widening multiply-accumulate
- A scatter-based convolution (`gaussian_blur_scatter.c`) that reads each input once and keeps k output accumulators in flight
- A Halide autoscheduler comparison
- Explain the 9×9 and 15×15 gap

## References

- P. Getreuer, [A Survey of Gaussian Convolution Algorithms](https://www.ipol.im/pub/art/2013/87/), *Image Processing On Line*, 2013
