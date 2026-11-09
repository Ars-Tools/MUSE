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
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const trcon(trcon_norm_t const f,
                         __LAPACK_int const n,
                         float32_t const*_Nullable const A, __LAPACK_int const ldA, uplo_t const uploA, diag_t const diagA,
                         float32_t      *_Nullable const rcond,
                         float32_t      *_Nullable       work, __LAPACK_int const lwork) {
    static __LAPACK_int const query = -1;
    __LAPACK_int info;
    float32_t size;
    strcon_(&f,
            &uploA, &diagA,
            &n,
            A, &ldA,
            &rcond,
            work ? work : &size, work ? &lwork : &query, &info);
    return info ? info : work ? info : size;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const trcon(trcon_norm_t const f,
                         __LAPACK_int const n,
                         float64_t const*_Nullable const A, __LAPACK_int const ldA, uplo_t const uploA, diag_t const diagA,
                         float64_t      *_Nullable const rcond,
                         float64_t      *_Nullable       work, __LAPACK_int const lwork) {
    static __LAPACK_int const query = -1;
    __LAPACK_int info;
    float64_t size;
    dtrcon_(&f,
            &uploA, &diagA,
            &n,
            A, &ldA,
            &rcond,
            work ? work : &size, work ? &lwork : &query, &info);
    return info ? info : work ? info : size;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const trcon(trcon_norm_t const f,
                         __LAPACK_int const n,
                         complex64_t const*_Nullable const A, __LAPACK_int const ldA, uplo_t const uploA, diag_t const diagA,
                         complex64_t      *_Nullable const rcond,
                         complex64_t      *_Nullable       work, __LAPACK_int const lwork) {
    static __LAPACK_int const query = -1;
    __LAPACK_int info;
    __complex float size;
    ctrcon_(&f,
            &uploA, &diagA,
            &n,
            A, &ldA,
            &rcond,
            work ? work : &size, work ? &lwork : &query, &info);
    return info ? info : work ? info : __real(size);
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const trcon(trcon_norm_t const f,
                         __LAPACK_int const n,
                         complex128_t const*_Nullable const A, __LAPACK_int const ldA, uplo_t const uploA, diag_t const diagA,
                         complex128_t      *_Nullable const rcond,
                         complex128_t      *_Nullable       work, __LAPACK_int const lwork) {
    static __LAPACK_int const query = -1;
    __LAPACK_int info;
    __complex double size;
    dtrcon_(&f,
            &uploA, &diagA,
            &n,
            A, &ldA,
            &rcond,
            work ? work : &size, work ? &lwork : &query, &info);
    return info ? info : work ? info : __real(size);
}
#endif
