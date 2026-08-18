//
//  mkl+gen.h
//  MUSE
//
//  Created by Kota on 6/18/26.
//
#include"module.h"
__attribute__((always_inline, overloadable)) static inline // for each (0<=k<length), A[k*iA] = 0
void vDSP_clr(float32_t * __nonnull const A, intptr_t const iA, intptr_t const length) {
    vDSP_vclr(A, iA, length);
}
__attribute__((always_inline, overloadable)) static inline // for each (0<=k<length), A[k*iA] = 0
void vDSP_clr(float64_t * __nonnull const A, intptr_t const iA, intptr_t const length) {
    vDSP_vclrD(A, iA, length);
}
__attribute__((always_inline, overloadable)) static inline // for each (0<=k<length), B[k*iB] = A
void vDSP_fill(float32_t const A, float32_t * __nonnull const B, intptr_t const iB, intptr_t const length) {
    vDSP_vfill(&A, B, iB, length);
}
__attribute__((always_inline, overloadable)) static inline // for each (0<=k<length), B[k*iB] = A
void vDSP_fill(float64_t const A, float64_t * __nonnull const B, intptr_t const iB, intptr_t const length) {
    vDSP_vfillD(&A, B, iB, length);
}
