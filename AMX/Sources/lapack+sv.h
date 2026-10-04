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
// MARK: posv
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const posv(__LAPACK_int const n, __LAPACK_int const nrhs,
                        float32_t      *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA,
                        float32_t      *__nonnull const B, __LAPACK_int const ldB) {
    __LAPACK_int info;
    sposv_(&uploA,
           &n, &nrhs,
           A, &ldA,
           B, &ldB,
           &info);
    return info;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const posv(__LAPACK_int const n, __LAPACK_int const nrhs,
                        float64_t      *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA,
                        float64_t      *__nonnull const B, __LAPACK_int const ldB) {
    __LAPACK_int info;
    dposv_(&uploA,
           &n, &nrhs,
           A, &ldA,
           B, &ldB,
           &info);
    return info;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const posv(__LAPACK_int const n, __LAPACK_int const nrhs,
                        complex64_t      *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA,
                        complex64_t      *__nonnull const B, __LAPACK_int const ldB) {
    __LAPACK_int info;
    cposv_(&uploA,
           &n, &nrhs,
           A, &ldA,
           B, &ldB,
           &info);
    return info;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const posv(__LAPACK_int const n, __LAPACK_int const nrhs,
                        complex128_t      *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA,
                        complex128_t      *__nonnull const B, __LAPACK_int const ldB) {
    __LAPACK_int info;
    zposv_(&uploA,
           &n, &nrhs,
           A, &ldA,
           B, &ldB,
           &info);
    return info;
}
// MARK: POTRF & POTRS
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const potrf(__LAPACK_int const n, float32_t    *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA) {
    __LAPACK_int info;
    spotrf_(&uploA, &n, A, &ldA, &info);
    return info;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const potrf(__LAPACK_int const n, float64_t    *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA) {
    __LAPACK_int info;
    dpotrf_(&uploA, &n, A, &ldA, &info);
    return info;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const potrf(__LAPACK_int const n, complex64_t  *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA) {
    __LAPACK_int info;
    cpotrf_(&uploA, &n, A, &ldA, &info);
    return info;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const potrf(__LAPACK_int const n, complex128_t *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA) {
    __LAPACK_int info;
    zpotrf_(&uploA, &n, A, &ldA, &info);
    return info;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const potrs(__LAPACK_int const n, __LAPACK_int const nrhs,
                         float32_t      *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA,
                         float32_t      *__nonnull const B, __LAPACK_int const ldB) {
    __LAPACK_int info;
    spotrs_(&uploA,
            &n, &nrhs,
            A, &ldA,
            B, &ldB,
            &info);
    return info;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const potrs(__LAPACK_int const n, __LAPACK_int const nrhs,
                         float64_t      *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA,
                         float64_t      *__nonnull const B, __LAPACK_int const ldB) {
    __LAPACK_int info;
    dpotrs_(&uploA,
            &n, &nrhs,
            A, &ldA,
            B, &ldB,
            &info);
    return info;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const potrs(__LAPACK_int const n, __LAPACK_int const nrhs,
                         complex64_t      *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA,
                         complex64_t      *__nonnull const B, __LAPACK_int const ldB) {
    __LAPACK_int info;
    cpotrs_(&uploA,
            &n, &nrhs,
            A, &ldA,
            B, &ldB,
            &info);
    return info;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const potrs(__LAPACK_int const n, __LAPACK_int const nrhs,
                         complex128_t      *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA,
                         complex128_t      *__nonnull const B, __LAPACK_int const ldB) {
    __LAPACK_int info;
    zpotrs_(&uploA,
            &n, &nrhs,
            A, &ldA,
            B, &ldB,
            &info);
    return info;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const potri(__LAPACK_int const n,
                         float32_t * __nonnull const A, __LAPACK_int const ldA, uplo_t const uploA) {
    __LAPACK_int info;
    spotri_(&uploA, &n,
            A, &ldA, &info);
    return info;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const potri(__LAPACK_int const n,
                         float64_t * __nonnull const A, __LAPACK_int const ldA, uplo_t const uploA) {
    __LAPACK_int info;
    dpotri_(&uploA, &n,
            A, &ldA, &info);
    return info;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const potri(__LAPACK_int const n,
                         complex64_t * __nonnull const A, __LAPACK_int const ldA, uplo_t const uploA) {
    __LAPACK_int info;
    cpotri_(&uploA, &n,
            A, &ldA, &info);
    return info;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const potri(__LAPACK_int const n,
                         complex128_t * __nonnull const A, __LAPACK_int const ldA, uplo_t const uploA) {
    __LAPACK_int info;
    zpotri_(&uploA, &n,
            A, &ldA, &info);
    return info;
}
