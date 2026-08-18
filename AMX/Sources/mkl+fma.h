//
//  mkl+fma.h
//  MUSE
//
//  Created by Kota on 6/19/26.
//
#include"module.h"
// MARK: VVV
__attribute__((always_inline, overloadable)) static inline
void vDSP_fma(float32_t const*__nonnull const x, intptr_t const incx,
              float32_t const*__nonnull const y, intptr_t const incy,
              float32_t const*__nonnull const z, intptr_t const incz,
              float32_t      *__nonnull const w, intptr_t const incw,
              intptr_t const length) {
    vDSP_vma(x, incx, y, incy, z, incz, w, incw, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_fma(float64_t const*__nonnull const x, intptr_t const incx,
              float64_t const*__nonnull const y, intptr_t const incy,
              float64_t const*__nonnull const z, intptr_t const incz,
              float64_t      *__nonnull const w, intptr_t const incw,
              intptr_t const length) {
    vDSP_vmaD(x, incx, y, incy, z, incz, w, incw, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_fma(complex64_t const*__nonnull const x, intptr_t const incx,
              complex64_t const*__nonnull const y, intptr_t const incy,
              complex64_t const*__nonnull const z, intptr_t const incz,
              complex64_t      *__nonnull const w, intptr_t const incw,
              intptr_t const length) {
    vDSP_zvmaD(&(DSPSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPSplitComplex const) {
        .realp = &y->r,
        .imagp = &y->i,
    }, 2 * incy, &(DSPSplitComplex const) {
        .realp = &z->r,
        .imagp = &z->i,
    }, 2 * incz, &(DSPSplitComplex const) {
        .realp = &w->r,
        .imagp = &w->i,
    }, 2 * incw, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_fma(complex128_t const*__nonnull const x, intptr_t const incx,
              complex128_t const*__nonnull const y, intptr_t const incy,
              complex128_t const*__nonnull const z, intptr_t const incz,
              complex128_t      *__nonnull const w, intptr_t const incw,
              intptr_t const length) {
    vDSP_zvmaD(&(DSPDoubleSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPDoubleSplitComplex const) {
        .realp = &y->r,
        .imagp = &y->i,
    }, 2 * incy, &(DSPDoubleSplitComplex const) {
        .realp = &z->r,
        .imagp = &z->i,
    }, 2 * incz, &(DSPDoubleSplitComplex const) {
        .realp = &w->r,
        .imagp = &w->i,
    }, 2 * incw, length);
}
// MARK: VVS
__attribute__((always_inline, overloadable)) static inline
void vDSP_fma(float32_t const*__nonnull const x, intptr_t const incx,
              float32_t const*__nonnull const y, intptr_t const incy,
              float32_t const z,
              float32_t      *__nonnull const w, intptr_t const incw,
              intptr_t const length) {
    vDSP_vmsa(x, incx, y, incy, &z, w, incw, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_fma(float64_t const*__nonnull const x, intptr_t const incx,
              float64_t const*__nonnull const y, intptr_t const incy,
              float64_t const z,
              float64_t      *__nonnull const w, intptr_t const incw,
              intptr_t const length) {
    vDSP_vmsaD(x, incx, y, incy, &z, w, incw, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_fma(complex64_t const*__nonnull const x, intptr_t const incx,
              complex64_t const*__nonnull const y, intptr_t const incy,
              complex64_t const z,
              complex64_t      *__nonnull const w, intptr_t const incw,
         intptr_t const length) {
    vDSP_zvma(&(DSPSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPSplitComplex const) {
        .realp = &y->r,
        .imagp = &y->i,
    }, 2 * incy, &(DSPSplitComplex const) {
        .realp = &z.r,
        .imagp = &z.i,
    }, 0, &(DSPSplitComplex const) {
        .realp = &w->r,
        .imagp = &w->i,
    }, 2 * incw, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_fma(complex128_t const*__nonnull const x, intptr_t const incx,
              complex128_t const*__nonnull const y, intptr_t const incy,
              complex128_t const z,
              complex128_t      *__nonnull const w, intptr_t const incw,
              intptr_t const length) {
    vDSP_zvmaD(&(DSPDoubleSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPDoubleSplitComplex const) {
        .realp = &y->r,
        .imagp = &y->i,
    }, 2 * incy, &(DSPDoubleSplitComplex const) {
        .realp = &z.r,
        .imagp = &z.i,
    }, 0, &(DSPDoubleSplitComplex const) {
        .realp = &w->r,
        .imagp = &w->i,
    }, 2 * incw, length);
}
// MARK: VSV
__attribute__((always_inline, overloadable)) static inline
void vDSP_fma(float32_t const*__nonnull const x, intptr_t const incx,
              float32_t const y,
              float32_t const*__nonnull const z, intptr_t const incz,
              float32_t      *__nonnull const w, intptr_t const incw,
              intptr_t const length) {
    vDSP_vsma(x, incx, &y, z, incz, w, incw, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_fma(float64_t const*__nonnull const x, intptr_t const incx,
              float64_t const y,
              float64_t const*__nonnull const z, intptr_t const incz,
              float64_t      *__nonnull const w, intptr_t const incw,
              intptr_t const length) {
    vDSP_vsmaD(x, incx, &y, z, incz, w, incw, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_fma(complex64_t const*__nonnull const x, intptr_t const incx,
              complex64_t const y,
              complex64_t const*__nonnull const z, intptr_t const incz,
              complex64_t      *__nonnull const w, intptr_t const incw,
         intptr_t const length) {
    vDSP_zvsma(&(DSPSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPSplitComplex const) {
        .realp = &y.r,
        .imagp = &y.i,
    }, &(DSPSplitComplex const) {
        .realp = &z->r,
        .imagp = &z->i,
    }, 2 * incz, &(DSPSplitComplex const) {
        .realp = &w->r,
        .imagp = &w->i,
    }, 2 * incw, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_fma(complex128_t const*__nonnull const x, intptr_t const incx,
              complex128_t const y,
              complex128_t const*__nonnull const z, intptr_t const incz,
              complex128_t      *__nonnull const w, intptr_t const incw,
              intptr_t const length) {
    vDSP_zvsmaD(&(DSPDoubleSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPDoubleSplitComplex const) {
        .realp = &y.r,
        .imagp = &y.i,
    }, &(DSPDoubleSplitComplex const) {
        .realp = &z->r,
        .imagp = &z->i,
    }, 2 * incz, &(DSPDoubleSplitComplex const) {
        .realp = &w->r,
        .imagp = &w->i,
    }, 2 * incw, length);
}
// MARK: VSS
__attribute__((always_inline, overloadable)) static inline
void vDSP_fma(float32_t const*__nonnull const x, intptr_t const incx,
              float32_t const y,
              float32_t const z,
              float32_t      *__nonnull const w, intptr_t const incw,
              intptr_t const length) {
    vDSP_vsmsa(x, incx, &y, &z, w, incw, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_fma(float64_t const*__nonnull const x, intptr_t const incx,
              float64_t const y,
              float64_t const z,
              float64_t      *__nonnull const w, intptr_t const incw,
              intptr_t const length) {
    vDSP_vsmsaD(x, incx, &y, &z, w, incw, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_fma(complex64_t const*__nonnull const x, intptr_t const incx,
              complex64_t const y,
              complex64_t const z,
              complex64_t      *__nonnull const w, intptr_t const incw,
         intptr_t const length) {
    vDSP_zvsma(&(DSPSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPSplitComplex const) {
        .realp = &y.r,
        .imagp = &y.i,
    }, &(DSPSplitComplex const) {
        .realp = &z.r,
        .imagp = &z.i,
    }, 0, &(DSPSplitComplex const) {
        .realp = &w->r,
        .imagp = &w->i,
    }, 2 * incw, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_fma(complex128_t const*__nonnull const x, intptr_t const incx,
              complex128_t const y,
              complex128_t const z,
              complex128_t      *__nonnull const w, intptr_t const incw,
              intptr_t const length) {
    vDSP_zvsmaD(&(DSPDoubleSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPDoubleSplitComplex const) {
        .realp = &y.r,
        .imagp = &y.i,
    }, &(DSPDoubleSplitComplex const) {
        .realp = &z.r,
        .imagp = &z.i,
    }, 0, &(DSPDoubleSplitComplex const) {
        .realp = &w->r,
        .imagp = &w->i,
    }, 2 * incw, length);
}
