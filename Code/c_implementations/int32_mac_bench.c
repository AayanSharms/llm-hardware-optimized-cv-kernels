/*
 * int32_mac_bench.c — Peak int32 multiply-accumulate throughput benchmark
 *
 * Measures the empirical int32 MAC ceiling of this machine using OpenMP
 * across all available threads and NEON 128-bit auto-vectorization
 * (4 int32 lanes per register, via clang -O3 -march=native).
 *
 * Theoretical peak (M4 Pro, 10 P-cores):
 *   10 cores × 4 NEON MLA pipes × 4 int32 lanes × 2 ops/MLA × 4.5 GHz
 *   = 1,440 GIOPS
 *
 * Build (see Makefile target 'int32_mac_bench'):
 *   make int32_mac_bench          # all available threads
 *   OMP_NUM_THREADS=10 ./int32_mac_bench   # P-cores only (M4 Pro)
 *
 * Vectorization remarks go to stderr at compile time.  Look for the hot loop:
 *   remark: vectorized loop (vectorization width: 4, interleaved count: N)
 *   [-Rpass=loop-vectorize]
 * width=4 confirms 4-lane NEON int32; interleaved≥2 means multiple
 * independent MLA chains are active to hide the 3-cycle MLA latency.
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <omp.h>

/*
 * Array size: 4096 × 4 B = 16 KB per array.
 * Both arrays together = 32 KB, well inside one M4 Pro P-core L1 (192 KB),
 * so the hot loop is entirely compute-bound, not memory-bandwidth-bound.
 * Must be a compile-time constant so the compiler can prove loop bounds
 * and emit an unrolled, vectorised inner loop.
 */
#define N     4096 // defining amount of numbers in each array
#define REPS  800000LL    /* outer repeats; targets ~2 s total wall-clock */

int main(void)

{

    // creating two arrays
    int32_t *a = (int32_t *)aligned_alloc(64, N * sizeof(int32_t)); 
    int32_t *b = (int32_t *)aligned_alloc(64, N * sizeof(int32_t));
    if (!a || !b) { perror("aligned_alloc"); return 1; }

    // fills the arrays
    for (int i = 0; i < N; i++) {
        a[i] = (int32_t)(i + 1);
        b[i] = (int32_t)(i + 2);
    }

    /*
     * volatile prevents the final printf from being DCE'd, which in turn
     * keeps the compiler from eliminating the entire parallel region.
     */
    volatile int32_t global_sink = 0;
    long long        total_ops   = 0;

    double t0 = omp_get_wtime();

    #pragma omp parallel reduction(+:total_ops)
    {
        /*
         * Stride-1 reduction loop — the canonical form that clang -O3
         * auto-vectorises into NEON MLA.
         *
         * clang detects the integer-reduction pattern and internally splits
         * the single accumulator into (vectorization_width × interleave_count)
         * independent partial sums — e.g. width=4 interleaved=4 yields 16
         * independent int32 accumulators packed into 4 NEON v.4S registers.
         * At the end of the inner loop it horizontally reduces them into `acc`.
         *
         * The restrict qualifier confirms to the compiler that a[] and b[]
         * do not alias, removing the only other barrier to vectorisation.
         */
        const int32_t * restrict pa = a; // points to array a, guarantees no overlap between a and b
        const int32_t * restrict pb = b;// points to array b, guarantees no overlap between a and b
        int32_t acc = 1;

        for (long long r = 0; r < REPS; r++) {
            for (int i = 0; i < N; i++) {
                acc += pa[i] * pb[i];
            }
        }

        #pragma omp atomic
        global_sink += acc;

        /* 1 multiply + 1 add = 2 integer ops per element per outer repeat */
        total_ops += REPS * (long long)N * 2LL;
    }

    double elapsed = omp_get_wtime() - t0;
    double giops   = (double)total_ops / elapsed / 1e9;

    /* All output written to stdout for easy capture / redirection */
    printf("sink        : %d\n",        (int)global_sink);
    printf("threads     : %d\n",        omp_get_max_threads());
    printf("N (int32)   : %d  (array pair = %zu KB, fits in L1)\n",
           N, 2 * N * sizeof(int32_t) / 1024);
    printf("REPS        : %lld\n",      REPS);
    printf("elapsed     : %.3f s\n",    elapsed);
    printf("total ops   : %.3e\n",      (double)total_ops);
    printf("throughput  : %.1f GIOPS\n", giops);
    printf("theoretical : 1440.0 GIOPS  "
           "(10 P-cores × 4 pipes × 4 int32 lanes × 2 ops × 4.5 GHz)\n");
    printf("efficiency  : %.1f%%\n",    giops / 1440.0 * 100.0);

    free(a);
    free(b);
    return 0;
}
