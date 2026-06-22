//
//  vforce+trigonometric.h
//  MUSE
//
//  Created by Kota on 6/18/26.
//
#include"module.h"
// MARK: sin
__attribute__((always_inline, __overloadable__)) inline static
void vvsin(float32_t const*__nonnull const x,
           float32_t      *__nonnull const y,
           intptr_t const length) {
    vvsinf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvsin(float64_t const*__nonnull const x,
           float64_t      *__nonnull const y,
           intptr_t const length) {
    vvsin(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: cos
__attribute__((always_inline, __overloadable__)) inline static
void vvcos(float32_t const*__nonnull const x,
           float32_t      *__nonnull const y,
           intptr_t const length) {
    vvcosf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvcos(float64_t const*__nonnull const x,
           float64_t      *__nonnull const y,
           intptr_t const length) {
    vvcos(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: tan
__attribute__((always_inline, __overloadable__)) inline static
void vvtan(float32_t const*__nonnull const x,
           float32_t      *__nonnull const y,
           intptr_t const length) {
    vvtanf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvtan(float64_t const*__nonnull const x,
           float64_t      *__nonnull const y,
           intptr_t const length) {
    vvtan(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: sinπ
__attribute__((always_inline, __overloadable__)) inline static
void vvsinpi(float32_t const*__nonnull const x,
             float32_t      *__nonnull const y,
             intptr_t const length) {
    vvsinpif(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvsinpi(float64_t const*__nonnull const x,
             float64_t      *__nonnull const y,
             intptr_t const length) {
    vvsinpi(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: cosπ
__attribute__((always_inline, __overloadable__)) inline static
void vvcospi(float32_t const*__nonnull const x,
             float32_t      *__nonnull const y,
             intptr_t const length) {
    vvcospif(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvcospi(float64_t const*__nonnull const x,
             float64_t      *__nonnull const y,
             intptr_t const length) {
    vvcospi(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: cosisin
__attribute__((always_inline, __overloadable__)) inline static
void vvcosisin(float32_t const*__nonnull const x,
               complex64_t*__nonnull const y,
               intptr_t const length) {
    vvcosisinf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvcosisin(float64_t const*__nonnull const x,
               complex128_t*__nonnull const y,
               intptr_t const length) {
    vvcosisin(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: sincos
__attribute__((always_inline, __overloadable__)) inline static
void vvsincos(float32_t const*__nonnull const x,
              float32_t      *__nonnull const s,
              float32_t      *__nonnull const c,
              intptr_t const length) {
    vvsincosf(s, c, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvsincos(float64_t const*__nonnull const x,
              float64_t      *__nonnull const s,
              float64_t      *__nonnull const c,
              intptr_t const length) {
    vvsincos(s, c, x, (int32_t const[]){(int32_t const)length});
}
// MARK: tanπ
__attribute__((always_inline, __overloadable__)) inline static
void vvtanpi(float32_t const*__nonnull const x,
             float32_t      *__nonnull const y,
             intptr_t const length) {
    vvtanpif(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvtanpi(float64_t const*__nonnull const x,
             float64_t      *__nonnull const y,
             intptr_t const length) {
    vvtanpi(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: sinh
__attribute__((always_inline, __overloadable__)) inline static
void vvsinh(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvsinhf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvsinh(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvsinh(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: cosh
__attribute__((always_inline, __overloadable__)) inline static
void vvcosh(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvcoshf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvcosh(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvcosh(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: tanh
__attribute__((always_inline, __overloadable__)) inline static
void vvtanh(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvtanhf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvtanh(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvtanh(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: asin
__attribute__((always_inline, __overloadable__)) inline static
void vvasin(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvasinf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvasin(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvasin(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: acos
__attribute__((always_inline, __overloadable__)) inline static
void vvacos(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvacosf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvacos(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvacos(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: atan
__attribute__((always_inline, __overloadable__)) inline static
void vvatan(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvatanf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvatan(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvatan(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: atan2
__attribute__((always_inline, __overloadable__)) inline static
void vvatan2(float32_t const*__nonnull const x,
             float32_t const*__nonnull const y,
             float32_t      *__nonnull const z,
             intptr_t const length) {
    vvatan2f(z, x, y, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvatan2(float64_t const*__nonnull const x,
             float64_t const*__nonnull const y,
             float64_t      *__nonnull const z,
             intptr_t const length) {
    vvatan2(z, x, y, (int32_t const[]){(int32_t const)length});
}
// MARK: asinh
__attribute__((always_inline, __overloadable__)) inline static
void vvasinh(float32_t const*__nonnull const x,
             float32_t      *__nonnull const y,
             intptr_t const length) {
    vvasinhf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvasinh(float64_t const*__nonnull const x,
             float64_t      *__nonnull const y,
             intptr_t const length) {
    vvasinh(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: acosh
__attribute__((always_inline, __overloadable__)) inline static
void vvacosh(float32_t const*__nonnull const x,
             float32_t      *__nonnull const y,
             intptr_t const length) {
    vvacoshf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvacosh(float64_t const*__nonnull const x,
             float64_t      *__nonnull const y,
             intptr_t const length) {
    vvacosh(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: atanh
__attribute__((always_inline, __overloadable__)) inline static
void vvatanh(float32_t const*__nonnull const x,
             float32_t      *__nonnull const y,
             intptr_t const length) {
    vvatanhf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvatanh(float64_t const*__nonnull const x,
             float64_t      *__nonnull const y,
             intptr_t const length) {
    vvatanh(y, x, (int32_t const[]){(int32_t const)length});
}
