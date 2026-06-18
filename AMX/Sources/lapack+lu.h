//
//  lapack.h
//  MUSE
//
//  Created by Kota on 6/18/26.
//
#include"module.h"
// MARK: getrf
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const getrf(__LAPACK_int const m, __LAPACK_int const n,
                         float32_t*__nonnull const A, __LAPACK_int const ldA,
                         __LAPACK_int*__nonnull const ipiv) {
    __LAPACK_int info;
    sgetrf_(&m, &n,
            A, &ldA,
            ipiv,
            &info);
    return info;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const getrf(__LAPACK_int const m, __LAPACK_int const n,
                         float64_t*__nonnull const A, __LAPACK_int const ldA,
                         __LAPACK_int*__nonnull const ipiv) {
    __LAPACK_int info;
    dgetrf_(&m, &n,
            A, &ldA,
            ipiv,
            &info);
    return info;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const getrf(__LAPACK_int const m, __LAPACK_int const n,
                         complex64_t*__nonnull const A, __LAPACK_int const ldA,
                         __LAPACK_int*__nonnull const ipiv) {
    __LAPACK_int info;
    sgetrf_(&m, &n,
            A, &ldA,
            ipiv,
            &info);
    return info;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const getrf(__LAPACK_int const m, __LAPACK_int const n,
                         complex128_t*__nonnull const A, __LAPACK_int const ldA,
                         __LAPACK_int*__nonnull const ipiv) {
    __LAPACK_int info;
    zgetrf_(&m, &n,
            A, &ldA,
            ipiv,
            &info);
    return info;
}
// MARK: getrs
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const getrs(__LAPACK_int const n, __LAPACK_int const nrhs,
                         float32_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
                         __LAPACK_int const*__nonnull const ipiv,
                         float32_t      *__nonnull const B, __LAPACK_int const ldB) {
    __LAPACK_int info;
    sgetrs_(&opA,
            &n, &nrhs,
            A, &ldA,
            ipiv,
            B, &ldB,
            &info);
    return info;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const getrs(__LAPACK_int const n, __LAPACK_int const nrhs,
                         float64_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
                         __LAPACK_int const*__nonnull const ipiv,
                         float64_t      *__nonnull const B, __LAPACK_int const ldB) {
    __LAPACK_int info;
    dgetrs_(&opA,
            &n, &nrhs,
            A, &ldA,
            ipiv,
            B, &ldB,
            &info);
    return info;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const getrs(__LAPACK_int const n, __LAPACK_int const nrhs,
                         complex64_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
                         __LAPACK_int const*__nonnull const ipiv,
                         complex64_t      *__nonnull const B, __LAPACK_int const ldB) {
    __LAPACK_int info;
    cgetrs_(&opA,
            &n, &nrhs,
            A, &ldA,
            ipiv,
            B, &ldB,
            &info);
    return info;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const getrs(__LAPACK_int const n, __LAPACK_int const nrhs,
                         complex128_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
                         __LAPACK_int const*__nonnull const ipiv,
                         complex128_t      *__nonnull const B, __LAPACK_int const ldB) {
    __LAPACK_int info;
    zgetrs_(&opA,
            &n, &nrhs,
            A, &ldA,
            ipiv,
            B, &ldB,
            &info);
    return info;
}
// MARK: getri, not return lwork
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const getri(__LAPACK_int const n,
                         float32_t const*__nonnull const A, __LAPACK_int const ldA,
                         __LAPACK_int const*__nonnull const ipiv,
                         float32_t      *__nonnull const work, __LAPACK_int const lwork) {
    __LAPACK_int info;
    sgetri_(&n,
            A, &ldA,
            ipiv,
            work, &lwork,
            &info);
    return info;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const getri(__LAPACK_int const n,
                         float64_t const*__nonnull const A, __LAPACK_int const ldA,
                         __LAPACK_int const*__nonnull const ipiv,
                         float64_t      *__nonnull const work, __LAPACK_int const lwork) {
    __LAPACK_int info;
    dgetri_(&n,
            A, &ldA,
            ipiv,
            work, &lwork,
            &info);
    return info;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const getri(__LAPACK_int const n,
                         complex64_t const*__nonnull const A, __LAPACK_int const ldA,
                         __LAPACK_int const*__nonnull const ipiv,
                         complex64_t      *__nonnull const work, __LAPACK_int const lwork) {
    __LAPACK_int info;
    cgetri_(&n,
            A, &ldA,
            ipiv,
            work, &lwork,
            &info);
    return info;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const getri(__LAPACK_int const n,
                         complex128_t const*__nonnull const A, __LAPACK_int const ldA,
                         __LAPACK_int const*__nonnull const ipiv,
                         complex128_t      *__nonnull const work, __LAPACK_int const lwork) {
    __LAPACK_int info;
    zgetri_(&n,
            A, &ldA,
            ipiv,
            work, &lwork,
            &info);
    return info;
}
// MARK: laswp
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
void const laswp(__LAPACK_int const n,
                 float32_t      *__nonnull const A, __LAPACK_int const ldA,
                 __LAPACK_int const k1, __LAPACK_int const k2,
                 __LAPACK_int const*__nonnull const ipiv, __LAPACK_int const inc) {
    slaswp_(&n, A, &ldA, &k1, &k2, ipiv, &inc);
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
void const laswp(__LAPACK_int const n,
                 float64_t      *__nonnull const A, __LAPACK_int const ldA,
                 __LAPACK_int const k1, __LAPACK_int const k2,
                 __LAPACK_int const*__nonnull const ipiv, __LAPACK_int const inc) {
    dlaswp_(&n, A, &ldA, &k1, &k2, ipiv, &inc);
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
void const laswp(__LAPACK_int const n,
                 complex64_t      *__nonnull const A, __LAPACK_int const ldA,
                 __LAPACK_int const k1, __LAPACK_int const k2,
                 __LAPACK_int const*__nonnull const ipiv, __LAPACK_int const inc) {
    claswp_(&n, A, &ldA, &k1, &k2, ipiv, &inc);
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
void const laswp(__LAPACK_int const n,
                 complex128_t      *__nonnull const A, __LAPACK_int const ldA,
                 __LAPACK_int const k1, __LAPACK_int const k2,
                 __LAPACK_int const*__nonnull const ipiv, __LAPACK_int const inc) {
    zlaswp_(&n, A, &ldA, &k1, &k2, ipiv, &inc);
}
