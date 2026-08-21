//
//  vforce+trigonometric.h
//  MUSE
//
//  Created by Kota on 6/18/26.
//
#include"module.h"
#define __MKL_REF32__(x) (int32_t const[]){(int32_t const)(x)}
// MARK: sin
__attribute__((always_inline, overloadable)) static inline
void vvsin(float32_t const*__nonnull const x,
           float32_t      *__nonnull const y,
           intptr_t const length) {
    vvsinf(y, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvsin(float64_t const*__nonnull const x,
           float64_t      *__nonnull const y,
           intptr_t const length) {
    vvsin(y, x, __MKL_REF32__(length));
}
// MARK: cos
__attribute__((always_inline, overloadable)) static inline
void vvcos(float32_t const*__nonnull const x,
           float32_t      *__nonnull const y,
           intptr_t const length) {
    vvcosf(y, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvcos(float64_t const*__nonnull const x,
           float64_t      *__nonnull const y,
           intptr_t const length) {
    vvcos(y, x, __MKL_REF32__(length));
}
// MARK: tan
__attribute__((always_inline, overloadable)) static inline
void vvtan(float32_t const*__nonnull const x,
           float32_t      *__nonnull const y,
           intptr_t const length) {
    vvtanf(y, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvtan(float64_t const*__nonnull const x,
           float64_t      *__nonnull const y,
           intptr_t const length) {
    vvtan(y, x, __MKL_REF32__(length));
}
// MARK: sinπ
__attribute__((always_inline, overloadable)) static inline
void vvsinpi(float32_t const*__nonnull const x,
             float32_t      *__nonnull const y,
             intptr_t const length) {
    vvsinpif(y, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvsinpi(float64_t const*__nonnull const x,
             float64_t      *__nonnull const y,
             intptr_t const length) {
    vvsinpi(y, x, __MKL_REF32__(length));
}
// MARK: cosπ
__attribute__((always_inline, overloadable)) static inline
void vvcospi(float32_t const*__nonnull const x,
             float32_t      *__nonnull const y,
             intptr_t const length) {
    vvcospif(y, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvcospi(float64_t const*__nonnull const x,
             float64_t      *__nonnull const y,
             intptr_t const length) {
    vvcospi(y, x, __MKL_REF32__(length));
}
// MARK: cosisin
__attribute__((always_inline, overloadable)) static inline
void vvcosisin(float32_t const*__nonnull const x,
               complex64_t*__nonnull const y,
               intptr_t const length) {
    vvcosisinf(&y->scalar, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvcosisin(float64_t const*__nonnull const x,
               complex128_t*__nonnull const y,
               intptr_t const length) {
    vvcosisin(&y->scalar, x, __MKL_REF32__(length));
}
// MARK: sincos
__attribute__((always_inline, overloadable)) static inline
void vvsincos(float32_t const*__nonnull const x,
              float32_t      *__nonnull const s,
              float32_t      *__nonnull const c,
              intptr_t const length) {
    vvsincosf(s, c, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvsincos(float64_t const*__nonnull const x,
              float64_t      *__nonnull const s,
              float64_t      *__nonnull const c,
              intptr_t const length) {
    vvsincos(s, c, x, __MKL_REF32__(length));
}
// MARK: tanπ
__attribute__((always_inline, overloadable)) static inline
void vvtanpi(float32_t const*__nonnull const x,
             float32_t      *__nonnull const y,
             intptr_t const length) {
    vvtanpif(y, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvtanpi(float64_t const*__nonnull const x,
             float64_t      *__nonnull const y,
             intptr_t const length) {
    vvtanpi(y, x, __MKL_REF32__(length));
}
// MARK: sinh
__attribute__((always_inline, overloadable)) static inline
void vvsinh(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvsinhf(y, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvsinh(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvsinh(y, x, __MKL_REF32__(length));
}
// MARK: cosh
__attribute__((always_inline, overloadable)) static inline
void vvcosh(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvcoshf(y, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvcosh(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvcosh(y, x, __MKL_REF32__(length));
}
// MARK: tanh
__attribute__((always_inline, overloadable)) static inline
void vvtanh(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvtanhf(y, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvtanh(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvtanh(y, x, __MKL_REF32__(length));
}
// MARK: asin
__attribute__((always_inline, overloadable)) static inline
void vvasin(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvasinf(y, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvasin(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvasin(y, x, __MKL_REF32__(length));
}
// MARK: acos
__attribute__((always_inline, overloadable)) static inline
void vvacos(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvacosf(y, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvacos(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvacos(y, x, __MKL_REF32__(length));
}
// MARK: atan
__attribute__((always_inline, overloadable)) static inline
void vvatan(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvatanf(y, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvatan(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvatan(y, x, __MKL_REF32__(length));
}
// MARK: atan2
__attribute__((always_inline, overloadable)) static inline
void vvatan2(float32_t const*__nonnull const x,
             float32_t const*__nonnull const y,
             float32_t      *__nonnull const z,
             intptr_t const length) {
    vvatan2f(z, x, y, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvatan2(float64_t const*__nonnull const x,
             float64_t const*__nonnull const y,
             float64_t      *__nonnull const z,
             intptr_t const length) {
    vvatan2(z, x, y, __MKL_REF32__(length));
}
// MARK: asinh
__attribute__((always_inline, overloadable)) static inline
void vvasinh(float32_t const*__nonnull const x,
             float32_t      *__nonnull const y,
             intptr_t const length) {
    vvasinhf(y, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvasinh(float64_t const*__nonnull const x,
             float64_t      *__nonnull const y,
             intptr_t const length) {
    vvasinh(y, x, __MKL_REF32__(length));
}
// MARK: acosh
__attribute__((always_inline, overloadable)) static inline
void vvacosh(float32_t const*__nonnull const x,
             float32_t      *__nonnull const y,
             intptr_t const length) {
    vvacoshf(y, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvacosh(float64_t const*__nonnull const x,
             float64_t      *__nonnull const y,
             intptr_t const length) {
    vvacosh(y, x, __MKL_REF32__(length));
}
// MARK: atanh
__attribute__((always_inline, overloadable)) static inline
void vvatanh(float32_t const*__nonnull const x,
             float32_t      *__nonnull const y,
             intptr_t const length) {
    vvatanhf(y, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvatanh(float64_t const*__nonnull const x,
             float64_t      *__nonnull const y,
             intptr_t const length) {
    vvatanh(y, x, __MKL_REF32__(length));
}
// MARK: complex-exp
__attribute__((always_inline, overloadable)) static inline
void vvcosisin(float32_t const*__nonnull const x,
               __complex float*__nonnull const y,
               intptr_t const length) {
    vvcosisinf(y, x, __MKL_REF32__(length));
}
__attribute__((always_inline, overloadable)) static inline
void vvcosisin(float64_t const*__nonnull const x,
               __complex double*__nonnull const y,
               intptr_t const length) {
    vvcosisin(y, x, __MKL_REF32__(length));
}
#undef __MKL_REF32__
