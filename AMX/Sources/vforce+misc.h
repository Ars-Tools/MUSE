//
//  vforce+misc.h
//  MUSE
//
//  Created by Kota on 6/18/26.
//
#include"module.h"
// MARK: fabs
__attribute__((always_inline, __overloadable__)) inline static
void vvfabs(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvfabsf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvfabs(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvfabs(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: fmod
__attribute__((always_inline, __overloadable__)) inline static
void vvfmod(float32_t const*__nonnull const x,
            float32_t const*__nonnull const y,
            float32_t      *__nonnull const z,
            intptr_t const length) {
    vvfmodf(z, x, y, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvfmod(float64_t const*__nonnull const x,
            float64_t const*__nonnull const y,
            float64_t      *__nonnull const z,
            intptr_t const length) {
    vvfmod(z, x, y, (int32_t const[]){(int32_t const)length});
}
// MARK: int
__attribute__((always_inline, __overloadable__)) inline static
void vvint(float32_t const*__nonnull const x,
           float32_t      *__nonnull const y,
           intptr_t const length) {
    vvintf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvint(float64_t const*__nonnull const x,
           float64_t      *__nonnull const y,
           intptr_t const length) {
    vvint(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: nint
__attribute__((always_inline, __overloadable__)) inline static
void vvnint(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvnintf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvnint(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvnint(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: floor
__attribute__((always_inline, __overloadable__)) inline static
void vvfloor(float32_t const*__nonnull const x,
             float32_t      *__nonnull const y,
             intptr_t const length) {
    vvfloorf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvfloor(float64_t const*__nonnull const x,
             float64_t      *__nonnull const y,
             intptr_t const length) {
    vvfloor(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: ceil
__attribute__((always_inline, __overloadable__)) inline static
void vvceil(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvceilf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvceil(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvceil(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: sqrt
__attribute__((always_inline, __overloadable__)) inline static
void vvsqrt(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvsqrtf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvsqrt(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvsqrt(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: cbrt
__attribute__((always_inline, __overloadable__)) inline static
void vvcbrt(float32_t const*__nonnull const x,
            float32_t      *__nonnull const y,
            intptr_t const length) {
    vvcbrtf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvcbrt(float64_t const*__nonnull const x,
            float64_t      *__nonnull const y,
            intptr_t const length) {
    vvcbrt(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: rec
__attribute__((always_inline, __overloadable__)) inline static
void vvrec(float32_t const*__nonnull const x,
           float32_t      *__nonnull const y,
           intptr_t const length) {
    vvrecf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvrec(float64_t const*__nonnull const x,
           float64_t      *__nonnull const y,
           intptr_t const length) {
    vvrec(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: div
__attribute__((always_inline, __overloadable__)) inline static
void vvdiv(float32_t const*__nonnull const x,
           float32_t const*__nonnull const y,
           float32_t      *__nonnull const z,
           intptr_t const length) {
    vvdivf(z, x, y, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvdiv(float64_t const*__nonnull const x,
           float64_t const*__nonnull const y,
           float64_t      *__nonnull const z,
           intptr_t const length) {
    vvdiv(z, x, y, (int32_t const[]){(int32_t const)length});
}
// MARK: rsqrt
__attribute__((always_inline, __overloadable__)) inline static
void vvrsqrt(float32_t const*__nonnull const x,
             float32_t      *__nonnull const y,
             intptr_t const length) {
    vvrsqrtf(y, x, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvrsqrt(float64_t const*__nonnull const x,
             float64_t      *__nonnull const y,
             intptr_t const length) {
    vvrsqrt(y, x, (int32_t const[]){(int32_t const)length});
}
// MARK: copysign
__attribute__((always_inline, __overloadable__)) inline static
void vvcopysign(float32_t const*__nonnull const x,
                float32_t const*__nonnull const y,
                float32_t      *__nonnull const z,
                intptr_t const length) {
    vvcopysignf(z, x, y, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvcopysign(float64_t const*__nonnull const x,
                float64_t const*__nonnull const y,
                float64_t      *__nonnull const z,
                intptr_t const length) {
    vvcopysign(z, x, y, (int32_t const[]){(int32_t const)length});
}
// MARK: nextafter
__attribute__((always_inline, __overloadable__)) inline static
void vvnextafter(float32_t const*__nonnull const x,
                 float32_t const*__nonnull const y,
                 float32_t      *__nonnull const z,
                 intptr_t const length) {
    vvnextafterf(z, x, y, (int32_t const[]){(int32_t const)length});
}
__attribute__((always_inline, __overloadable__)) inline static
void vvnextafter(float64_t const*__nonnull const x,
                 float64_t const*__nonnull const y,
                 float64_t      *__nonnull const z,
                 intptr_t const length) {
    vvnextafter(z, x, y, (int32_t const[]){(int32_t const)length});
}
