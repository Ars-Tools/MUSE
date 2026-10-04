//
//  mkl+gen.h
//  MUSE
//
//  Created by Kota on 6/18/26.
//
#include"module.h"
// MARK: clr
__attribute__((always_inline, overloadable)) static inline // for each (0<=k<length), A[k*iA] = 0
void vDSP_clr(float32_t * __nonnull const A, intptr_t const iA, intptr_t const length) {
    vDSP_vclr(A, iA, length);
}
__attribute__((always_inline, overloadable)) static inline // for each (0<=k<length), A[k*iA] = 0
void vDSP_clr(float64_t * __nonnull const A, intptr_t const iA, intptr_t const length) {
    vDSP_vclrD(A, iA, length);
}
__attribute__((always_inline, overloadable)) static inline // for each (0<=k<length), A[k*iA] = 0
void vDSP_clr(complex64_t * __nonnull const A, intptr_t const iA, intptr_t const length) {
    vDSP_clr(__builtin_bit_cast(float32_t*__nonnull const, &A->r), 2 * iA, length);
    vDSP_clr(__builtin_bit_cast(float32_t*__nonnull const, &A->i), 2 * iA, length);
}
__attribute__((always_inline, overloadable)) static inline // for each (0<=k<length), A[k*iA] = 0
void vDSP_clr(complex128_t * __nonnull const A, intptr_t const iA, intptr_t const length) {
    vDSP_clr(__builtin_bit_cast(float64_t*__nonnull const, &A->r), 2 * iA, length);
    vDSP_clr(__builtin_bit_cast(float64_t*__nonnull const, &A->i), 2 * iA, length);
}
// MARK: fill
__attribute__((always_inline, overloadable)) static inline // for each (0<=k<length), B[k*iB] = A
void vDSP_fill(float32_t const A, float32_t * __nonnull const B, intptr_t const iB, intptr_t const length) {
    vDSP_vfill(&A, B, iB, length);
}
__attribute__((always_inline, overloadable)) static inline // for each (0<=k<length), B[k*iB] = A
void vDSP_fill(float64_t const A, float64_t * __nonnull const B, intptr_t const iB, intptr_t const length) {
    vDSP_vfillD(&A, B, iB, length);
}
__attribute__((always_inline, overloadable)) static inline // for each (0<=k<length), B[k*iB] = A
void vDSP_fill(complex64_t const A, complex64_t * __nonnull const B, intptr_t const iB, intptr_t const length) {
    vDSP_fill(A.r, __builtin_bit_cast(float32_t*__nonnull const, &B->r), 2 * iB, length);
    vDSP_fill(A.i, __builtin_bit_cast(float32_t*__nonnull const, &B->i), 2 * iB, length);
}
__attribute__((always_inline, overloadable)) static inline // for each (0<=k<length), B[k*iB] = A
void vDSP_fill(complex128_t const A, complex128_t * __nonnull const B, intptr_t const iB, intptr_t const length) {
    vDSP_fill(A.r, __builtin_bit_cast(float64_t*__nonnull const, &B->r), 2 * iB, length);
    vDSP_fill(A.i, __builtin_bit_cast(float64_t*__nonnull const, &B->i), 2 * iB, length);
}
// MARK: copy (col-major)
__attribute__((always_inline, overloadable)) static inline
void vDSP_copy(intptr_t const m, intptr_t const n,
               float32_t const * __nonnull const A, intptr_t const ldA,
               float32_t       * __nonnull const B, intptr_t const ldB) {
    vDSP_mmov(A, B, m, n, ldA, ldB);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_copy(intptr_t const m, intptr_t const n,
               float64_t const * __nonnull const A, intptr_t const ldA,
               float64_t       * __nonnull const B, intptr_t const ldB) {
    vDSP_mmovD(A, B, m, n, ldA, ldB);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_copy(intptr_t const m, intptr_t const n,
               complex64_t const * __nonnull const A, intptr_t const ldA,
               complex64_t       * __nonnull const B, intptr_t const ldB) {
    vDSP_mmov(__builtin_bit_cast(float32_t*__nonnull const, A),
              __builtin_bit_cast(float32_t*__nonnull const, B),
              2 * m, n, 2 * ldA, 2 * ldB);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_copy(intptr_t const m, intptr_t const n,
               complex128_t const * __nonnull const A, intptr_t const ldA,
               complex128_t       * __nonnull const B, intptr_t const ldB) {
    vDSP_mmovD(__builtin_bit_cast(float64_t*__nonnull const, A),
               __builtin_bit_cast(float64_t*__nonnull const, B),
               2 * m, n, 2 * ldA, 2 * ldB);
}
// MARK: move (col-major)
__attribute__((always_inline, overloadable)) static inline
void vDSP_move(intptr_t const m, intptr_t const n,
               float32_t const * __nonnull const A, intptr_t const ldA,
               float32_t       * __nonnull const B, intptr_t const ldB) {
    for ( register intptr_t col = 0 ; col < n ; ++ col )
        memmove(B + col * ldB, A + col * ldA, m * sizeof(float32_t const));
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_move(intptr_t const m, intptr_t const n,
               float64_t const * __nonnull const A, intptr_t const ldA,
               float64_t       * __nonnull const B, intptr_t const ldB) {
    for ( register intptr_t col = 0 ; col < n ; ++ col )
        memmove(B + col * ldB, A + col * ldA, m * sizeof(float64_t const));
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_move(intptr_t const m, intptr_t const n,
               complex64_t const * __nonnull const A, intptr_t const ldA,
               complex64_t       * __nonnull const B, intptr_t const ldB) {
    for ( register intptr_t col = 0 ; col < n ; ++ col )
        memmove(B + col * ldB, A + col * ldA, m * sizeof(complex64_t const));
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_move(intptr_t const m, intptr_t const n,
               complex128_t const * __nonnull const A, intptr_t const ldA,
               complex128_t       * __nonnull const B, intptr_t const ldB) {
    for ( register intptr_t col = 0 ; col < n ; ++ col )
        memmove(B + col * ldB, A + col * ldA, m * sizeof(complex128_t const));
}
