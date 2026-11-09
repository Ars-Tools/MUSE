//
//  lapack+misc.h
//  MUSE
//
//  Created by Kota on 6/26/26.
//
#include"module.h"
#ifndef __LAPACK_MISC_H
#define __LAPACK_MISC_H
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
void lacgv(__LAPACK_int const length,
           complex64_t*__nonnull const x, __LAPACK_int const incx) {
    clacgv_(&length, x, &incx);
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
void lacgv(__LAPACK_int const length,
           complex128_t*__nonnull const x, __LAPACK_int const incx) {
    zlacgv_(&length, x, &incx);
}
// MARK: TRCON
typedef CF_ENUM(char) {
    trcon_norm_t_O = 'O',
    trcon_norm_t_I = 'I',
} trcon_norm_t;
// WORK: 3*n reals; IWORK: n integers. TRCON has no workspace query.
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const trcon(trcon_norm_t const f,
                         __LAPACK_int const n,
                         float32_t const*_Nullable const A, __LAPACK_int const ldA, uplo_t const uploA, diag_t const diagA,
                         float32_t      *__nonnull const rcond,
                         float32_t      *_Nullable work,
                         __LAPACK_int   *_Nullable iwork) {
    if (!work) work = alloca(3 * n * sizeof(float32_t const));
    if (!iwork) iwork = alloca(n * sizeof(__LAPACK_int const));
    __LAPACK_int info;
    strcon_(&f, &uploA, &diagA, &n, A, &ldA, rcond, work, iwork, &info);
    return info;
}

// WORK: 3*n reals; IWORK: n integers. TRCON has no workspace query.
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const trcon(trcon_norm_t const f,
                         __LAPACK_int const n,
                         float64_t const*_Nullable const A, __LAPACK_int const ldA, uplo_t const uploA, diag_t const diagA,
                         float64_t      *__nonnull const rcond,
                         float64_t      *_Nullable work,
                         __LAPACK_int   *_Nullable iwork) {
    if (!work) work = alloca(3 * n * sizeof(float64_t const));
    if (!iwork) iwork = alloca(n * sizeof(__LAPACK_int const));
    __LAPACK_int info;
    dtrcon_(&f, &uploA, &diagA, &n, A, &ldA, rcond, work, iwork, &info);
    return info;
}

// WORK: 2*n complex values; RWORK: n reals; RCOND is real.
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const trcon(trcon_norm_t const f,
                         __LAPACK_int const n,
                         complex64_t const*_Nullable const A, __LAPACK_int const ldA, uplo_t const uploA, diag_t const diagA,
                         float32_t        *__nonnull const rcond,
                         complex64_t      *_Nullable work,
                         float32_t        *_Nullable rwork) {
    if (!work) work = alloca(2 * n * sizeof(complex64_t const));
    if (!iwork) iwork = alloca(n * sizeof(__LAPACK_int const));
    __LAPACK_int info;
    ctrcon_(&f, &uploA, &diagA, &n,
             (__LAPACK_float_complex const*)A, &ldA, rcond,
             (__LAPACK_float_complex*)work, rwork, &info);
    return info;
}

// WORK: 2*n complex values; RWORK: n reals; RCOND is real.
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const trcon(trcon_norm_t const f,
                         __LAPACK_int const n,
                         complex128_t const*_Nullable const A, __LAPACK_int const ldA, uplo_t const uploA, diag_t const diagA,
                         float64_t         *__nonnull const rcond,
                         complex128_t      *_Nullable work,
                         float64_t         *_Nullable rwork) {
    if (!work) work = alloca(2 * n * sizeof(complex128_t const));
    if (!iwork) iwork = alloca(n * sizeof(__LAPACK_int const));
    __LAPACK_int info;
    ztrcon_(&f, &uploA, &diagA, &n,
             (__LAPACK_double_complex const*)A, &ldA, rcond,
             (__LAPACK_double_complex*)work, rwork, &info);
    return info;
}
#endif
