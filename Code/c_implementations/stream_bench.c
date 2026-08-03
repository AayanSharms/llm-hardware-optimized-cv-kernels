/*
 * stream_bench.c — Memory bandwidth benchmark (STREAM-style, all four kernels)
 *
 * Measures peak main-memory (DRAM) bandwidth using the four standard kernels:
 *   Copy  : a[i] = b[i]                      (2 arrays × 8 B = 16 B/elem)
 *   Scale : b[i] = scalar * c[i]             (2 arrays × 8 B = 16 B/elem)
 *   Add   : c[i] = a[i] + b[i]              (3 arrays × 8 B = 24 B/elem)
 *   Triad : a[i] = b[i] + scalar * c[i]     (3 arrays × 8 B = 24 B/elem)
 *
 * Arrays are sized to exceed the M4 Pro L3 cache (24 MB) by ~40×, so every
 * access hits main memory (LPDDR5X), not any cache level.
 *
 * Build:
 *   make stream_bench
 *
 * Run:
 *   ./build/stream_bench
 *   OMP_NUM_THREADS=10 ./build/stream_bench   # P-cores only
 *
 * Theoretical peak (M4 Pro, LPDDR5X):
 *   ~273 GB/s (per Apple spec for the 12-core M4 Pro)
 */

#include <stdio.h>
#include <stdlib.h>
#include <float.h>
#include <omp.h>

/*
 * 3 arrays × 40 M × 8 B = 960 MB total — 40× the 24 MB M4 Pro L3 cache.
 * Reducing N will move accesses into cache and inflate the reported bandwidth.
 */
#define N       40000000L
#define NTIMES  20
#define SCALAR  3.0

static double min_time(const double *t, int n)
{
    double m = t[0];
    for (int i = 1; i < n; i++) if (t[i] < m) m = t[i];
    return m;
}

static double avg_time(const double *t, int n)
{
    double s = 0;
    for (int i = 0; i < n; i++) s += t[i];
    return s / n;
}

int main(void)
{
    double *a = (double *)aligned_alloc(64, N * sizeof(double));
    double *b = (double *)aligned_alloc(64, N * sizeof(double));
    double *c = (double *)aligned_alloc(64, N * sizeof(double));
    if (!a || !b || !c) { perror("aligned_alloc"); return 1; }

    /*
     * First-touch initialisation in parallel.  On unified-memory systems like
     * Apple Silicon this ensures OS pages are mapped before timing starts and
     * that threads access locally-initialised data, matching the runtime access
     * pattern used in the timed kernels.
     */
    #pragma omp parallel for schedule(static)
    for (long i = 0; i < N; i++) {
        a[i] = 1.0;
        b[i] = 2.0;
        c[i] = 0.5;
    }

    double t_copy[NTIMES], t_scale[NTIMES], t_add[NTIMES], t_triad[NTIMES];

    for (int k = 0; k < NTIMES; k++) {
        double t0, t1;

        t0 = omp_get_wtime();
        #pragma omp parallel for schedule(static)
        for (long i = 0; i < N; i++)
            a[i] = b[i];
        t1 = omp_get_wtime();
        t_copy[k] = t1 - t0;

        t0 = omp_get_wtime();
        #pragma omp parallel for schedule(static)
        for (long i = 0; i < N; i++)
            b[i] = SCALAR * c[i];
        t1 = omp_get_wtime();
        t_scale[k] = t1 - t0;

        t0 = omp_get_wtime();
        #pragma omp parallel for schedule(static)
        for (long i = 0; i < N; i++)
            c[i] = a[i] + b[i];
        t1 = omp_get_wtime();
        t_add[k] = t1 - t0;

        t0 = omp_get_wtime();
        #pragma omp parallel for schedule(static)
        for (long i = 0; i < N; i++)
            a[i] = b[i] + SCALAR * c[i];
        t1 = omp_get_wtime();
        t_triad[k] = t1 - t0;
    }

    /*
     * Checksum — forces the compiler to materialise array values and prevents
     * the timed loops from being eliminated as dead code.
     */
    volatile double sink = 0.0;
    for (long i = 0; i < N; i += N / 64) sink += a[i] + b[i] + c[i];

    /* Best-rate bandwidth = bytes_accessed / minimum_time */
    double bytes_2arr = 2.0 * N * sizeof(double);
    double bytes_3arr = 3.0 * N * sizeof(double);

    double bw_copy  = bytes_2arr / min_time(t_copy,  NTIMES) / 1e9;
    double bw_scale = bytes_2arr / min_time(t_scale, NTIMES) / 1e9;
    double bw_add   = bytes_3arr / min_time(t_add,   NTIMES) / 1e9;
    double bw_triad = bytes_3arr / min_time(t_triad, NTIMES) / 1e9;

    printf("Array size : %ldM doubles × 8 B = %ld MB each  (3 arrays = %ld MB)\n",
           N / 1000000L,
           N * (long)sizeof(double) / (1024 * 1024),
           3L * N * (long)sizeof(double) / (1024 * 1024));
    printf("Threads    : %d\n", omp_get_max_threads());
    printf("Iterations : %d  (reporting best of %d runs)\n\n", NTIMES, NTIMES);

    printf("%-8s  %12s  %12s  %14s\n",
           "Kernel", "Best (GB/s)", "Avg (GB/s)", "Bytes/elem");
    printf("--------  ------------  ------------  --------------\n");
    printf("%-8s  %12.1f  %12.1f  %14.0f\n",
           "Copy",  bw_copy,  bytes_2arr / avg_time(t_copy,  NTIMES) / 1e9, bytes_2arr / N);
    printf("%-8s  %12.1f  %12.1f  %14.0f\n",
           "Scale", bw_scale, bytes_2arr / avg_time(t_scale, NTIMES) / 1e9, bytes_2arr / N);
    printf("%-8s  %12.1f  %12.1f  %14.0f\n",
           "Add",   bw_add,   bytes_3arr / avg_time(t_add,   NTIMES) / 1e9, bytes_3arr / N);
    printf("%-8s  %12.1f  %12.1f  %14.0f\n",
           "Triad", bw_triad, bytes_3arr / avg_time(t_triad, NTIMES) / 1e9, bytes_3arr / N);

    printf("\nTheoretical: ~273 GB/s  (M4 Pro 12-core, LPDDR5X, per Apple spec)\n");
    printf("Triad efficiency: %.1f%%\n", bw_triad / 273.0 * 100.0);
    printf("checksum   : %g\n", sink);

    free(a); free(b); free(c);
    return 0;
}
