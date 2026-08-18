//
//  mkl+geometry.h
//  MUSE
//
//  Created by Kota on 6/19/26.
//
#include"module.h"
__attribute__((always_inline, overloadable)) static inline
void vDSP_abs(float32_t const*__nonnull const x, intptr_t const incx,
              float32_t      *__nonnull const y, intptr_t const incy,
              intptr_t const length) {
    vDSP_vabs(x, incx, y, incy, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_abs(float64_t const*__nonnull const x, intptr_t const incx,
              float64_t      *__nonnull const y, intptr_t const incy,
              intptr_t const length) {
    vDSP_vabsD(x, incx, y, incy, length);
}
// MARK: zabs
__attribute__((always_inline, overloadable)) static inline
void vDSP_abs(complex64_t const*__nonnull const x, intptr_t const incx,
              float32_t      *__nonnull const y, intptr_t const incy,
              intptr_t const length) {
    vDSP_zvabs(&(DSPSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i
    }, 2 * incx, y, incy, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_abs(complex128_t const*__nonnull const x, intptr_t const incx,
              float64_t      *__nonnull const y, intptr_t const incy,
              intptr_t const length) {
    vDSP_zvabsD(&(DSPDoubleSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i
    }, 2 * incx, y, incy, length);
}
// MARK: zmags
__attribute__((always_inline, overloadable)) static inline
void vDSP_mags(complex64_t const*__nonnull const x, intptr_t const incx,
               float32_t      *__nonnull const y, intptr_t const incy,
               intptr_t const length) {
    vDSP_zvmags(&(DSPSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i
    }, 2 * incx, y, incy, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_mags(complex128_t const*__nonnull const x, intptr_t const incx,
               float64_t      *__nonnull const y, intptr_t const incy,
               intptr_t const length) {
    vDSP_zvmagsD(&(DSPDoubleSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i
    }, 2 * incx, y, incy, length);
}
// MARK: hypot
__attribute__((always_inline, overloadable)) static inline
void vDSP_hypot(float32_t const*__nonnull const x, intptr_t const incx,
                float32_t const*__nonnull const y, intptr_t const incy,
                float32_t      *__nonnull const z, intptr_t const incz,
                intptr_t const length) {
    vDSP_vdist(x, incx, y, incy, z, incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_hypot(float64_t const*__nonnull const x, intptr_t const incx,
                float64_t const*__nonnull const y, intptr_t const incy,
                float64_t      *__nonnull const z, intptr_t const incz,
                intptr_t const length) {
    vDSP_vdistD(x, incx, y, incy, z, incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_hypot_zsq(float32_t const*__nonnull const x,
                    float32_t const*__nonnull const y,
                    intptr_t const incz,
                    float32_t      *__nonnull const w, intptr_t const incw,
                    intptr_t const length) {
    vDSP_zvmags(&(DSPSplitComplex const) {
        .realp = x,
        .imagp = y
    }, incz, w, incw, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_hypot_zsq(float64_t const*__nonnull const x,
                    float64_t const*__nonnull const y,
                    intptr_t const incz,
                    float64_t      *__nonnull const w, intptr_t const incw,
                    intptr_t const length) {
    vDSP_zvmagsD(&(DSPDoubleSplitComplex const) {
        .realp = x,
        .imagp = y
    }, incz, w, incw, length);
}
