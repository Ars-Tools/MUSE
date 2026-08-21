//
//  mkl+arithmetic.h
//  MUSE
//
//  Created by Kota on 6/19/26.
//
#include"module.h"
// MARK: neg
__attribute__((always_inline, overloadable)) static inline
void vDSP_neg(float32_t const*__nonnull const x, intptr_t const incx,
              float32_t      *__nonnull const y, intptr_t const incy,
              intptr_t const length) {
    vDSP_vneg(x, incx, y, incy, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_neg(float64_t const*__nonnull const x, intptr_t const incx,
              float64_t      *__nonnull const y, intptr_t const incy,
              intptr_t const length) {
    vDSP_vnegD(x, incx, y, incy, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_neg(complex64_t const*__nonnull const x, intptr_t const incx,
              complex64_t      *__nonnull const y, intptr_t const incy,
              intptr_t const length) {
    vDSP_zvneg(&(DSPSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i
    }, 2 * incx, &(DSPSplitComplex const) {
        .realp = &y->r,
        .imagp = &y->i
    }, 2 * incy, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_neg(complex128_t const*__nonnull const x, intptr_t const incx,
              complex128_t      *__nonnull const y, intptr_t const incy,
              intptr_t const length) {
    vDSP_zvnegD(&(DSPDoubleSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i
    }, 2 * incx, &(DSPDoubleSplitComplex const) {
        .realp = &y->r,
        .imagp = &y->i
    }, 2 * incy, length);
}
// MARK: add - vv
__attribute__((always_inline, overloadable)) static inline
void vDSP_add(float32_t const*__nonnull const x, intptr_t const incx,
              float32_t const*__nonnull const y, intptr_t const incy,
              float32_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_vadd(x, incx, y, incy, z, incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_add(float64_t const*__nonnull const x, intptr_t const incx,
              float64_t const*__nonnull const y, intptr_t const incy,
              float64_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_vaddD(x, incx, y, incy, z, incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_add(complex64_t const*__nonnull const x, intptr_t const incx,
              complex64_t const*__nonnull const y, intptr_t const incy,
              complex64_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_zvadd(&(DSPSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPSplitComplex const) {
        .realp = &y->r,
        .imagp = &y->i,
    }, 2 * incy, &(DSPSplitComplex const) {
        .realp = &z->r,
        .imagp = &z->i,
    }, 2 * incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_add(complex128_t const*__nonnull const x, intptr_t const incx,
         complex128_t const*__nonnull const y, intptr_t const incy,
         complex128_t      *__nonnull const z, intptr_t const incz,
         intptr_t const length) {
    vDSP_zvaddD(&(DSPDoubleSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPDoubleSplitComplex const) {
        .realp = &y->r,
        .imagp = &y->i,
    }, 2 * incy, &(DSPDoubleSplitComplex const) {
        .realp = &z->r,
        .imagp = &z->i,
    }, 2 * incz, length);
}
// MARK: add - vs
__attribute__((always_inline, overloadable)) static inline
void vDSP_add(float32_t const*__nonnull const x, intptr_t const incx,
              float32_t const y,
              float32_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_vsadd(x, incx, &y, z, incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_add(float64_t const*__nonnull const x, intptr_t const incx,
              float64_t const y,
              float64_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_vsaddD(x, incx, &y, z, incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_add(complex64_t const*__nonnull const x, intptr_t const incx,
              complex64_t const y,
              complex64_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_vsadd(&x->r, 2 * incx, &y.r, &z->r, 2 * incz, length);
    vDSP_vsadd(&x->i, 2 * incx, &y.i, &z->i, 2 * incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_add(complex128_t const*__nonnull const x, intptr_t const incx,
              complex128_t const y,
              complex128_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_vsaddD(&x->r, 2 * incx, &y.r, &z->r, 2 * incz, length);
    vDSP_vsaddD(&x->i, 2 * incx, &y.i, &z->i, 2 * incz, length);
}
// MARK: sub
__attribute__((always_inline, overloadable)) static inline
void vDSP_sub(float32_t const*__nonnull const x, intptr_t const incx,
              float32_t const*__nonnull const y, intptr_t const incy,
              float32_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_vsub(y, incy, x, incx, z, incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_sub(float64_t const*__nonnull const x, intptr_t const incx,
              float64_t const*__nonnull const y, intptr_t const incy,
              float64_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_vsubD(y, incy, x, incx, z, incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_sub(complex64_t const*__nonnull const x, intptr_t const incx,
              complex64_t const*__nonnull const y, intptr_t const incy,
              complex64_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_zvsub(&(DSPSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPSplitComplex const) {
        .realp = &y->r,
        .imagp = &y->i,
    }, 2 * incy, &(DSPSplitComplex const) {
        .realp = &z->r,
        .imagp = &z->i,
    }, 2 * incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_sub(complex128_t const*__nonnull const x, intptr_t const incx,
              complex128_t const*__nonnull const y, intptr_t const incy,
              complex128_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_zvsubD(&(DSPDoubleSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPDoubleSplitComplex const) {
        .realp = &y->r,
        .imagp = &y->i,
    }, 2 * incy, &(DSPDoubleSplitComplex const) {
        .realp = &z->r,
        .imagp = &z->i,
    }, 2 * incz, length);
}
// MARK: addsub
__attribute__((always_inline, overloadable)) static inline
void vDSP_addsub(float32_t const*__nonnull const x, intptr_t const incx,
                 float32_t const*__nonnull const y, intptr_t const incy,
                 float32_t      *__nonnull const a, intptr_t const inca,
                 float32_t      *__nonnull const s, intptr_t const incs,
                 intptr_t const length) {
    vDSP_vaddsub(y, incy, x, incx, a, inca, s, incs, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_addsub(float64_t const*__nonnull const x, intptr_t const incx,
                 float64_t const*__nonnull const y, intptr_t const incy,
                 float64_t      *__nonnull const a, intptr_t const inca,
                 float64_t      *__nonnull const s, intptr_t const incs,
                 intptr_t const length) {
    vDSP_vaddsubD(y, incy, x, incx, a, inca, s, incs, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_addsub(complex64_t const*__nonnull const x, intptr_t const incx,
                 complex64_t const*__nonnull const y, intptr_t const incy,
                 complex64_t      *__nonnull const a, intptr_t const inca,
                 complex64_t      *__nonnull const s, intptr_t const incs,
                 intptr_t const length) {
    vDSP_vaddsub(&y->r, 2 * incy, &x->r, 2 * incx, &a->r, 2 * inca, &s->r, 2 * incs, length);
    vDSP_vaddsub(&y->i, 2 * incy, &x->i, 2 * incx, &a->i, 2 * inca, &s->i, 2 * incs, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_addsub(complex128_t const*__nonnull const x, intptr_t const incx,
                 complex128_t const*__nonnull const y, intptr_t const incy,
                 complex128_t      *__nonnull const a, intptr_t const inca,
                 complex128_t      *__nonnull const s, intptr_t const incs,
                 intptr_t const length) {
    vDSP_vaddsubD(&y->r, 2 * incy, &x->r, 2 * incx, &a->r, 2 * inca, &s->r, 2 * incs, length);
    vDSP_vaddsubD(&y->i, 2 * incy, &x->i, 2 * incx, &a->i, 2 * inca, &s->i, 2 * incs, length);
}
// MARK: mul - vv
__attribute__((always_inline, overloadable)) static inline
void vDSP_mul(float32_t const*__nonnull const x, intptr_t const incx,
              float32_t const*__nonnull const y, intptr_t const incy,
              float32_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_vmul(x, incx, y, incy, z, incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_mul(float64_t const*__nonnull const x, intptr_t const incx,
              float64_t const*__nonnull const y, intptr_t const incy,
              float64_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_vmulD(x, incx, y, incy, z, incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_mul(__complex float const*__nonnull const x, intptr_t const incx,
              __complex float const*__nonnull const y, intptr_t const incy,
              __complex float      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_zvmul(&(DSPSplitComplex const) {
        .realp = &__real(*x),
        .imagp = &__imag(*x),
    }, 2 * incx, &(DSPSplitComplex const) {
        .realp = &__real(*y),
        .imagp = &__imag(*y),
    }, 2 * incy, &(DSPSplitComplex const) {
        .realp = &__real(*z),
        .imagp = &__imag(*z),
    }, 2 * incz, length, 1);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_mul(__complex double const*__nonnull const x, intptr_t const incx,
              __complex double const*__nonnull const y, intptr_t const incy,
              __complex double      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_zvmulD(&(DSPDoubleSplitComplex const) {
        .realp = &__real(*x),
        .imagp = &__imag(*x),
    }, 2 * incx, &(DSPDoubleSplitComplex const) {
        .realp = &__real(*y),
        .imagp = &__imag(*y),
    }, 2 * incy, &(DSPDoubleSplitComplex const) {
        .realp = &__real(*z),
        .imagp = &__imag(*z),
    }, 2 * incz, length, 1);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_mul(complex64_t const*__nonnull const x, intptr_t const incx,
              complex64_t const*__nonnull const y, intptr_t const incy,
              complex64_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_zvmul(&(DSPSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPSplitComplex const) {
        .realp = &y->r,
        .imagp = &y->i,
    }, 2 * incy, &(DSPSplitComplex const) {
        .realp = &z->r,
        .imagp = &z->i,
    }, 2 * incz, length, 1);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_mul(complex128_t const*__nonnull const x, intptr_t const incx,
              complex128_t const*__nonnull const y, intptr_t const incy,
              complex128_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_zvmulD(&(DSPDoubleSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPDoubleSplitComplex const) {
        .realp = &y->r,
        .imagp = &y->i,
    }, 2 * incy, &(DSPDoubleSplitComplex const) {
        .realp = &z->r,
        .imagp = &z->i,
    }, 2 * incz, length, 1);
}
// MARK: mul - vs
__attribute__((always_inline, overloadable)) static inline
void vDSP_mul(float32_t const*__nonnull const x, intptr_t const incx,
              float32_t const y,
              float32_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_vsmul(x, incx, &y, z, incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_mul(float64_t const*__nonnull const x, intptr_t const incx,
              float64_t const y,
              float64_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_vsmulD(x, incx, &y, z, incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_mul(__complex float const*__nonnull const x, intptr_t const incx,
              __complex float const y,
              __complex float      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_zvzsml(&(DSPSplitComplex const) {
        .realp = &__real(*x),
        .imagp = &__imag(*x),
    }, 2 * incx, &(DSPSplitComplex const) {
        .realp = &__real(y),
        .imagp = &__imag(y),
    }, &(DSPSplitComplex const) {
        .realp = &__real(*z),
        .imagp = &__imag(*z),
    }, 2 * incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_mul(__complex double const*__nonnull const x, intptr_t const incx,
              __complex double const y,
              __complex double      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_zvzsmlD(&(DSPDoubleSplitComplex const) {
        .realp = &__real(*x),
        .imagp = &__imag(*x),
    }, 2 * incx, &(DSPDoubleSplitComplex const) {
        .realp = &__real(y),
        .imagp = &__imag(y),
    }, &(DSPDoubleSplitComplex const) {
        .realp = &__real(*z),
        .imagp = &__imag(*z),
    }, 2 * incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_mul(complex64_t const*__nonnull const x, intptr_t const incx,
              complex64_t const y,
              complex64_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_zvzsml(&(DSPSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPSplitComplex const) {
        .realp = &y.r,
        .imagp = &y.i,
    }, &(DSPSplitComplex const) {
        .realp = &z->r,
        .imagp = &z->i,
    }, 2 * incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_mul(complex128_t const*__nonnull const x, intptr_t const incx,
              complex128_t const y,
              complex128_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_zvzsmlD(&(DSPDoubleSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPDoubleSplitComplex const) {
        .realp = &y.r,
        .imagp = &y.i,
    }, &(DSPDoubleSplitComplex const) {
        .realp = &z->r,
        .imagp = &z->i,
    }, 2 * incz, length);
}
// MARK: div - vv
__attribute__((always_inline, overloadable)) static inline
void vDSP_div(float32_t const*__nonnull const x, intptr_t const incx,
              float32_t const*__nonnull const y, intptr_t const incy,
              float32_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_vdiv(y, incy, x, incx, z, incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_div(float64_t const*__nonnull const x, intptr_t const incx,
              float64_t const*__nonnull const y, intptr_t const incy,
              float64_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_vdivD(y, incy, x, incx, z, incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_div(complex64_t const*__nonnull const x, intptr_t const incx,
              complex64_t const*__nonnull const y, intptr_t const incy,
              complex64_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_zvdiv(&(DSPSplitComplex const) {
        .realp = &y->r,
        .imagp = &y->i,
    }, 2 * incy, &(DSPSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPSplitComplex const) {
        .realp = &z->r,
        .imagp = &z->i,
    }, 2 * incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_div(complex128_t const*__nonnull const x, intptr_t const incx,
              complex128_t const*__nonnull const y, intptr_t const incy,
              complex128_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_zvdivD(&(DSPDoubleSplitComplex const) {
        .realp = &y->r,
        .imagp = &y->i,
    }, 2 * incy, &(DSPDoubleSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i,
    }, 2 * incx, &(DSPDoubleSplitComplex const) {
        .realp = &z->r,
        .imagp = &z->i,
    }, 2 * incz, length);
}
// MARK: div - vs
__attribute__((always_inline, overloadable)) static inline
void vDSP_div(float32_t const*__nonnull const x, intptr_t const incx,
              float32_t const y,
              float32_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_vsdiv(x, incx, &y, z, incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_div(float64_t const*__nonnull const x, intptr_t const incx,
              float64_t const y,
              float64_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_vsdivD(x, incx, &y, z, incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_div(complex64_t const*__nonnull const x, intptr_t const incx,
              complex64_t const y,
              complex64_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_mul(x, incx, libcconj(y), z, incz, length);
    vDSP_div(&x->r, 2 * incx, length_squared(y), &z->r, incz, length);
    vDSP_div(&x->i, 2 * incx, length_squared(y), &z->i, incz, length);
}
__attribute__((always_inline, overloadable)) static inline
void vDSP_div(complex128_t const*__nonnull const x, intptr_t const incx,
              complex128_t const y,
              complex128_t      *__nonnull const z, intptr_t const incz,
              intptr_t const length) {
    vDSP_mul(x, incx, libcconj(y), z, incz, length);
    vDSP_div(&x->r, 2 * incx, length_squared(y), &z->r, incz, length);
    vDSP_div(&x->i, 2 * incx, length_squared(y), &z->i, incz, length);
}
// MARK: complex-related
// MARK: conj
__attribute__((always_inline, __overloadable__)) inline static
void vDSP_conj(complex64_t const*__nonnull const x, intptr_t const incx,
               complex64_t      *__nonnull const y, intptr_t const incy,
               intptr_t const length) {
    vDSP_zvconj(&(DSPSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i
    }, 2 * incx, &(DSPSplitComplex const) {
        .realp = &y->r,
        .imagp = &y->i
    }, 2 * incy, length);
}
__attribute__((always_inline, __overloadable__)) inline static
void vDSP_conj(complex128_t const*__nonnull const x, intptr_t const incx,
               complex128_t      *__nonnull const y, intptr_t const incy,
               intptr_t const length) {
    vDSP_zvconjD(&(DSPSplitComplex const) {
        .realp = &x->r,
        .imagp = &x->i
    }, 2 * incx, &(DSPSplitComplex const) {
        .realp = &y->r,
        .imagp = &y->i
    }, 2 * incy, length);
}
// MARK: phas
__attribute__((always_inline, __overloadable__)) inline static
void vDSP_phas(complex64_t const*__nonnull const z, intptr_t const incc,
               float32_t      *__nonnull const p, intptr_t const incp,
               intptr_t const length) {
    vDSP_zvphas(&(DSPDoubleSplitComplex const) {
        .realp = &z->r,
        .imagp = &z->i
    }, 2 * incc, p, incp, length);
}
__attribute__((always_inline, __overloadable__)) inline static
void vDSP_phas(complex128_t const*__nonnull const z, intptr_t const incc,
               float64_t      *__nonnull const p, intptr_t const incp,
               intptr_t const length) {
    vDSP_zvphasD(&(DSPDoubleSplitComplex const) {
        .realp = &z->r,
        .imagp = &z->i
    }, 2 * incc, p, incp, length);
}
// MARK: ctoz
__attribute__((always_inline, __overloadable__)) inline static
void vDSP_ctoz(complex64_t const*__nonnull const z, intptr_t const incc,
               float32_t const*__nonnull const r,
               float32_t const*__nonnull const i,
               intptr_t const incz,
               intptr_t const length) {
    vDSP_ctoz(&z->DSPComplex, 2 * incc, &(DSPSplitComplex const) {
        .realp = r,
        .imagp = i
    }, incz, length);
}
__attribute__((always_inline, __overloadable__)) inline static
void vDSP_ctoz(complex128_t const*__nonnull const z, intptr_t const incc,
               float64_t const*__nonnull const r,
               float64_t const*__nonnull const i,
               intptr_t const incz,
               intptr_t const length) {
    vDSP_ctozD(&z->DSPComplex, 2 * incc, &(DSPDoubleSplitComplex const) {
        .realp = r,
        .imagp = i
    }, incz, length);
}
// MARK: ztoc
__attribute__((always_inline, __overloadable__)) inline static
void vDSP_ztoc(float32_t const*__nonnull const r,
               float32_t const*__nonnull const i,
               intptr_t const incz,
               complex64_t      *__nonnull const z, intptr_t const incc,
               intptr_t const length) {
    vDSP_ztoc(&(DSPSplitComplex const) {
        .realp = r,
        .imagp = i
    }, incz, &z->DSPComplex, 2 * incc, length);
}
__attribute__((always_inline, __overloadable__)) inline static
void vDSP_ztoc(float64_t const*__nonnull const r,
               float64_t const*__nonnull const i,
               intptr_t const incz,
               complex128_t      *__nonnull const z, intptr_t const incc,
               intptr_t const length) {
    vDSP_ztocD(&(DSPDoubleSplitComplex const) {
        .realp = r,
        .imagp = i
    }, incz, &z->DSPComplex, 2 * incc, length);
}
// MARK: rect
__attribute__((always_inline, __overloadable__)) inline static
void vDSP_rect(complex64_t const*__nonnull const x, intptr_t const incx,
               complex64_t      *__nonnull const y, intptr_t const incy,
               intptr_t const length) {
    vDSP_rect((float32_t const*__nonnull const)x, 2 * incx,
              (float32_t      *__nonnull const)y, 2 * incy,
              length);
}
__attribute__((always_inline, __overloadable__)) inline static
void vDSP_rect(complex128_t const*__nonnull const x, intptr_t const incx,
               complex128_t      *__nonnull const y, intptr_t const incy,
               intptr_t const length) {
    vDSP_rectD((float64_t const*__nonnull const)x, 2 * incx,
               (float64_t      *__nonnull const)y, 2 * incy,
               length);
}
// MARK: polar
__attribute__((always_inline, __overloadable__)) inline static
void vDSP_polar(complex64_t const*__nonnull const x, intptr_t const incx,
                complex64_t      *__nonnull const y, intptr_t const incy,
                intptr_t const length) {
    vDSP_polar((float32_t const*__nonnull const)x, 2 * incx,
               (float32_t      *__nonnull const)y, 2 * incy,
               length);
}
__attribute__((always_inline, __overloadable__)) inline static
void vDSP_polar(complex128_t const*__nonnull const x, intptr_t const incx,
                complex128_t      *__nonnull const y, intptr_t const incy,
                intptr_t const length) {
    vDSP_polarD((float64_t const*__nonnull const)x, 2 * incx,
                (float64_t      *__nonnull const)y, 2 * incy,
                length);
}
