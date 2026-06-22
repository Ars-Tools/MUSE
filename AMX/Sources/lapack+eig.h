//
//  lapack+eig.h
//  MUSE
//
//  Created by Kota on 6/18/26.
//
#include"module.h"
// MARK: GEEV
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const geev(__LAPACK_int const n,
                        float32_t*__nonnull const A, __LAPACK_int const ldA,
                        float32_t*__nonnull const r,
                        float32_t*__nonnull const i,
                        float32_t*__nullable const vl, __LAPACK_int const ldvl,
                        float32_t*__nullable const vr, __LAPACK_int const ldvr,
                        float32_t*__nullable const work, __LAPACK_int const lwork) {
    char const jobvl = vl ? 'V' : 'N';
    char const jobvr = vr ? 'V' : 'N';
    if ( work ) {
        __LAPACK_int info;
        sgeev_(&jobvl, &jobvr,
               &n,
               A, &ldA,
               r,
               i,
               vl, &ldvl,
               vr, &ldvr,
               work, &lwork, &info);
        return info;
    } else {
        __LAPACK_int info;
        float32_t size;
        sgeev_(&jobvl, &jobvr,
               &n,
               A, &ldA,
               r,
               i,
               vl, &ldvl,
               vr, &ldvr,
               &size, (__LAPACK_int const[]){-1}, &info);
        return info ? info : size;
    }
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const geev(__LAPACK_int const n,
                        float64_t*__nonnull const A, __LAPACK_int const ldA,
                        float64_t*__nonnull const r,
                        float64_t*__nonnull const i,
                        float64_t*__nullable const vl, __LAPACK_int const ldvl,
                        float64_t*__nullable const vr, __LAPACK_int const ldvr,
                        float64_t*__nullable const work, __LAPACK_int const lwork) {
    char const jobvl = vl ? 'V' : 'N';
    char const jobvr = vr ? 'V' : 'N';
    if ( work ) {
        __LAPACK_int info;
        dgeev_(&jobvl,
               &jobvr,
               &n,
               A, &ldA,
               r,
               i,
               vl, &ldvl,
               vr, &ldvr,
               work, &lwork, &info);
        return info;
    } else {
        __LAPACK_int info;
        float64_t size;
        dgeev_(&jobvl, &jobvr,
               &n,
               A, &ldA,
               r,
               i,
               vl, &ldvl,
               vr, &ldvr,
               &size, (__LAPACK_int const[]){-1}, &info);
        return info ? info : size;
    }
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const geev(__LAPACK_int const n,
                        complex64_t*__nonnull const A, __LAPACK_int const ldA,
                        complex64_t*__nonnull const w,
                        complex64_t*__nullable const vl, __LAPACK_int const ldvl,
                        complex64_t*__nullable const vr, __LAPACK_int const ldvr,
                        complex64_t*__nullable const work, __LAPACK_int const lwork,
                        float32_t*__nonnull const rwork /* require 2N elements space */) {
    char const jobvl = vl ? 'V' : 'N';
    char const jobvr = vr ? 'V' : 'N';
    if ( work ) {
        __LAPACK_int info;
        cgeev_(&jobvl, &jobvr,
               &n,
               A, &ldA,
               w,
               vl, &ldvl,
               vr, &ldvr,
               work, &lwork, rwork,
               &info);
        return info;
    } else {
        __LAPACK_int info;
        __complex float size;
        cgeev_(&jobvl, &jobvr,
               &n,
               A, &ldA,
               w,
               vl, &ldvl,
               vr, &ldvr,
               &size, (__LAPACK_int const[]){-1}, rwork,
               &info);
        return info ? info : size;
    }
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const geev(__LAPACK_int const n,
                        complex128_t*__nonnull const A, __LAPACK_int const ldA,
                        complex128_t*__nonnull const w,
                        complex128_t*__nullable const vl, __LAPACK_int const ldvl,
                        complex128_t*__nullable const vr, __LAPACK_int const ldvr,
                        complex128_t*__nullable const work, __LAPACK_int const lwork,
                        float64_t*__nonnull const rwork /* require 2N elements space */) {
    char const jobvl = vl ? 'V' : 'N';
    char const jobvr = vr ? 'V' : 'N';
    if ( work ) {
        __LAPACK_int info;
        zgeev_(&jobvl, &jobvr,
               &n,
               A, &ldA,
               w,
               vl, &ldvl,
               vr, &ldvr,
               work, &lwork, rwork,
               &info);
        return info;
    } else {
        __LAPACK_int info;
        __complex double size;
        zgeev_(&jobvl, &jobvr,
               &n,
               A, &ldA,
               w,
               vl, &ldvl,
               vr, &ldvr,
               &size, (__LAPACK_int const[]){-1}, rwork,
               &info);
        return info ? info : size;
    }
}
