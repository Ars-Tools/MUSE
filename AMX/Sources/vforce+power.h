//
//  vforce+power.h
//  MUSE
//
//  Created by Kota on 6/18/26.
//
#include"module.h"
// MARK: pow
__attribute__((always_inline, __overloadable__)) inline static
void vvpow(float32_t const*__nonnull const x,
           float32_t const*__nonnull const y,
           float32_t      *__nonnull const z,
           intptr_t const length) {
    vvpowf(z, y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvpow(float64_t const*__nonnull const x,
           float64_t const*__nonnull const y,
           float64_t      *__nonnull const z,
           intptr_t const length) {
    vvpow(z, y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvpow(float32_t const*__nonnull const x,
           float32_t const y,
           float32_t      *__nonnull const z,
           intptr_t const length) {
    vvpowsf(z, &y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvpow(float64_t const*__nonnull const x,
           float32_t const y,
           float64_t      *__nonnull const z,
           intptr_t const length) {
    vvpows(z, &y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: exp
__attribute__((always_inline, __overloadable__)) inline static
void vvexp(float32_t const*__nonnull const x,
           float32_t      *__nonnull const y,
           intptr_t const length) {
    vvexpf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvexp(float64_t const*__nonnull const x,
           float64_t      *__nonnull const y,
           intptr_t const length) {
    vvexp(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: log
__attribute__((always_inline, __overloadable__)) inline static
void vvlog(float32_t const*__nonnull const x,
           float32_t      *__nonnull const y,
           intptr_t const length) {
    vvlogf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvlog(float64_t const*__nonnull const x,
           float64_t      *__nonnull const y,
           intptr_t const length) {
    vvlog(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: exp2
__attribute__((always_inline, __overloadable__)) inline static
void vvexp2(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvexp2f(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvexp2(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvexp2(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: log2
__attribute__((always_inline, __overloadable__)) inline static
void vvlog2(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvlog2f(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvlog2(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvlog2(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: expm1
__attribute__((always_inline, __overloadable__)) inline static
void vvexpm1(float32_t const*__nonnull const x,
             float32_t      *__nonnull const y,
             intptr_t const length) {
    vvexpm1f(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvexpm1(float64_t const*__nonnull const x,
             float64_t      *__nonnull const y,
             intptr_t const length) {
    vvexpm1(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: log1p
__attribute__((always_inline, __overloadable__)) inline static
void vvlog1p(float32_t const*__nonnull const x,
             float32_t      *__nonnull const y,
             intptr_t const length) {
    vvlog1pf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvlog1p(float64_t const*__nonnull const x,
             float64_t      *__nonnull const y,
             intptr_t const length) {
    vvlog1p(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: logb
__attribute__((always_inline, __overloadable__)) inline static
void vvlogb(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvlogbf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvlogb(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvlogb(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: log10
__attribute__((always_inline, __overloadable__)) inline static
void vvlog10(float32_t const*__nonnull const x,
             float32_t      *__nonnull const y,
             intptr_t const length) {
    vvlog10f(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvlog10(float64_t const*__nonnull const x,
             float64_t      *__nonnull const y,
             intptr_t const length) {
    vvlog10(y, x, (int32_t const[]){(int32_t const)length});
}
