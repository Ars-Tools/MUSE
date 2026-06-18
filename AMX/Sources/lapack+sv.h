//
//  lapack+sv.h
//  MUSE
//
//  Created by Kota on 6/18/26.
//
#include"module.h"
// MARK: gesv
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const gesv(__LAPACK_int const n, __LAPACK_int const nrhs,
                        float32_t      *__nonnull const A, __LAPACK_int const ldA, op_t const opA,
                        __LAPACK_int      *__nonnull ipiv,
                        float32_t      *__nonnull const B, __LAPACK_int const ldB) {
    __LAPACK_int info;
    sgesv_(&n, &nrhs,
           A, &ldA,
           ipiv,
           B, &ldB,
           &info);
    return info;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const gesv(__LAPACK_int const n, __LAPACK_int const nrhs,
                        float64_t      *__nonnull const A, __LAPACK_int const ldA, op_t const opA,
                        __LAPACK_int      *__nonnull ipiv,
                        float64_t      *__nonnull const B, __LAPACK_int const ldB) {
    __LAPACK_int info;
    dgesv_(&n, &nrhs,
           A, &ldA,
           ipiv,
           B, &ldB,
           &info);
    return info;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const gesv(__LAPACK_int const n, __LAPACK_int const nrhs,
                        complex64_t      *__nonnull const A, __LAPACK_int const ldA, op_t const opA,
                        __LAPACK_int      *__nonnull ipiv,
                        complex64_t      *__nonnull const B, __LAPACK_int const ldB) {
    __LAPACK_int info;
    cgesv_(&n, &nrhs,
           A, &ldA,
           ipiv,
           B, &ldB,
           &info);
    return info;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const gesv(__LAPACK_int const n, __LAPACK_int const nrhs,
                        complex128_t      *__nonnull const A, __LAPACK_int const ldA, op_t const opA,
                        __LAPACK_int      *__nonnull ipiv,
                        complex128_t      *__nonnull const B, __LAPACK_int const ldB) {
    __LAPACK_int info;
    zgesv_(&n, &nrhs,
           A, &ldA,
           ipiv,
           B, &ldB,
           &info);
    return info;
}
