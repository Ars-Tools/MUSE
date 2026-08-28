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
                        float32_t*__nullable const A, __LAPACK_int const ldA,
                        float32_t*__nullable const r,
                        float32_t*__nullable const i,
                        float32_t*__nullable const vl, __LAPACK_int const ldvl,
                        float32_t*__nullable const vr, __LAPACK_int const ldvr,
                        float32_t*__nullable const work, __LAPACK_int const lwork) {
    static char const job[] = "VN";
    __LAPACK_int info;
    float32_t size;
    sgeev_(job + !vl, job + !vr,
           &n,
           A, &ldA,
           r, i,
           vl, &ldvl,
           vr, &ldvr,
           work ? work : &size, work ? &lwork : (__LAPACK_int const[]) {-1},
           &info);
    return info ? info : work ? info : size;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const geev(__LAPACK_int const n,
                        float64_t*__nullable const A, __LAPACK_int const ldA,
                        float64_t*__nullable const r,
                        float64_t*__nullable const i,
                        float64_t*__nullable const vl, __LAPACK_int const ldvl,
                        float64_t*__nullable const vr, __LAPACK_int const ldvr,
                        float64_t*__nullable const work, __LAPACK_int const lwork) {
    static char const job[] = "VN";
    __LAPACK_int info;
    float64_t size;
    dgeev_(job + !vl, job + !vr,
           &n,
           A, &ldA,
           r, i,
           vl, &ldvl,
           vr, &ldvr,
           work ? work : &size, work ? &lwork : (__LAPACK_int const[]) {-1},
           &info);
    return info ? info : work ? info : size;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const geev(__LAPACK_int const n,
                        complex64_t*__nullable const A, __LAPACK_int const ldA,
                        complex64_t*__nullable const w,
                        complex64_t*__nullable const vl, __LAPACK_int const ldvl,
                        complex64_t*__nullable const vr, __LAPACK_int const ldvr,
                        complex64_t*__nullable const work, __LAPACK_int const lwork,
                        float32_t*__nonnull const rwork /* require 2N elements space */) {
    static char const job[] = "VN";
    __LAPACK_int info;
    __complex float size;
    cgeev_(job + !vl, job + !vr,
           &n,
           A, &ldA,
           w,
           vl, &ldvl,
           vr, &ldvr,
           work ? work : &size, work ? &lwork : (__LAPACK_int const[]) {-1}, rwork,
           &info);
    return info ? info : work ? info : size;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const geev(__LAPACK_int const n,
                        complex128_t*__nullable const A, __LAPACK_int const ldA,
                        complex128_t*__nullable const w,
                        complex128_t*__nullable const vl, __LAPACK_int const ldvl,
                        complex128_t*__nullable const vr, __LAPACK_int const ldvr,
                        complex128_t*__nullable const work, __LAPACK_int const lwork,
                        float64_t*__nonnull const rwork /* require 2N elements space */) {
    static char const job[] = "VN";
    __LAPACK_int info;
    __complex double size;
    zgeev_(job + !vl, job + !vr,
           &n,
           A, &ldA,
           w,
           vl, &ldvl,
           vr, &ldvr,
           work ? work : &size, work ? &lwork : (__LAPACK_int const[]) {-1}, rwork,
           &info);
    return info ? info : work ? info : size;
}
