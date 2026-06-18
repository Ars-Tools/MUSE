//
//  blas+level3.h
//  MUSE
//
//  Created by Kota on 6/18/26.
//
#include"module.h"
// MARK: gemm
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const gemm(__LAPACK_int const m, __LAPACK_int const n, __LAPACK_int const k,
                        float32_t const alpha,
                        float32_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
                        float32_t const*__nonnull const B, __LAPACK_int const ldB, op_t const opB,
                        float32_t const beta,
                        float32_t      *__nonnull const C, __LAPACK_int const ldC) {
    __LAPACK_int info;
    sgemm_(&opA, &opB,
           &m, &n, &k,
           &alpha,
           A, &ldA,
           B, &ldB,
           &beta,
           C, &ldC);
    return info;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const gemm(__LAPACK_int const m, __LAPACK_int const n, __LAPACK_int const k,
                        float64_t const alpha,
                        float64_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
                        float64_t const*__nonnull const B, __LAPACK_int const ldB, op_t const opB,
                        float64_t const beta,
                        float64_t      *__nonnull const C, __LAPACK_int const ldC) {
    __LAPACK_int info;
    dgemm_(&opA, &opB,
           &m, &n, &k,
           &alpha,
           A, &ldA,
           B, &ldB,
           &beta,
           C, &ldC);
    return info;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const gemm(__LAPACK_int const m, __LAPACK_int const n, __LAPACK_int const k,
                        complex64_t const alpha,
                        complex64_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
                        complex64_t const*__nonnull const B, __LAPACK_int const ldB, op_t const opB,
                        complex64_t const beta,
                        complex64_t      *__nonnull const C, __LAPACK_int const ldC) {
    __LAPACK_int info;
    cgemm_(&opA, &opB,
           &m, &n, &k,
           &alpha,
           A, &ldA,
           B, &ldB,
           &beta,
           C, &ldC);
    return info;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const gemm(__LAPACK_int const m, __LAPACK_int const n, __LAPACK_int const k,
                        complex128_t const alpha,
                        complex128_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
                        complex128_t const*__nonnull const B, __LAPACK_int const ldB, op_t const opB,
                        complex128_t const beta,
                        complex128_t      *__nonnull const C, __LAPACK_int const ldC) {
    __LAPACK_int info;
    zgemm_(&opA, &opB,
           &m, &n, &k,
           &alpha,
           A, &ldA,
           B, &ldB,
           &beta,
           C, &ldC);
    return info;
}
// MARK: symm
__attribute__((always_inline, __overloadable__)) inline static
void symm(__LAPACK_int const M, __LAPACK_int const N,
          float32_t const alpha,
          float32_t const*__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA, side_t const sideA,
          float32_t const*__nonnull const B, __LAPACK_int const ldB,
          float32_t const beta,
          float32_t      *__nonnull const C, __LAPACK_int const ldC) {
    ssymm_(&sideA, &uploA,
           &M, &N,
           &alpha,
           A, &ldA,
           B, &ldB,
           &beta,
           C, &ldC);
}
__attribute__((always_inline, __overloadable__)) inline static
void symm(__LAPACK_int const M, __LAPACK_int const N,
          float64_t const alpha,
          float64_t const*__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA, side_t const sideA,
          float64_t const*__nonnull const B, __LAPACK_int const ldB,
          float64_t const beta,
          float64_t      *__nonnull const C, __LAPACK_int const ldC) {
    dsymm_(&sideA, &uploA,
           &M, &N,
           &alpha,
           A, &ldA,
           B, &ldB,
           &beta,
           C, &ldC);
}
__attribute__((always_inline, __overloadable__)) inline static
void symm(__LAPACK_int const M, __LAPACK_int const N,
          complex64_t const alpha,
          complex64_t const*__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA, side_t const sideA,
          complex64_t const*__nonnull const B, __LAPACK_int const ldB,
          complex64_t const beta,
          complex64_t      *__nonnull const C, __LAPACK_int const ldC) {
    csymm_(&sideA, &uploA,
           &M, &N,
           &alpha,
           A, &ldA,
           B, &ldB,
           &beta,
           C, &ldC);
}
__attribute__((always_inline, __overloadable__)) inline static
void symm(__LAPACK_int const M, __LAPACK_int const N,
          complex128_t const alpha,
          complex128_t const*__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA, side_t const sideA,
          complex128_t const*__nonnull const B, __LAPACK_int const ldB,
          complex128_t const beta,
          complex128_t      *__nonnull const C, __LAPACK_int const ldC) {
    zsymm_(&sideA, &uploA,
           &M, &N,
           &alpha,
           A, &ldA,
           B, &ldB,
           &beta,
           C, &ldC);
}
__attribute__((always_inline, __overloadable__)) inline static
void hemm(__LAPACK_int const M, __LAPACK_int const N,
          complex64_t const alpha,
          complex64_t const*__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA, side_t const sideA,
          complex64_t const*__nonnull const B, __LAPACK_int const ldB,
          complex64_t const beta,
          complex64_t      *__nonnull const C, __LAPACK_int const ldC) {
    chemm_(&sideA, &uploA,
           &M, &N,
           &alpha,
           A, &ldA,
           B, &ldB,
           &beta,
           C, &ldC);
}
__attribute__((always_inline, __overloadable__)) inline static
void hemm(__LAPACK_int const M, __LAPACK_int const N,
          complex128_t const alpha,
          complex128_t const*__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA, side_t const sideA,
          complex128_t const*__nonnull const B, __LAPACK_int const ldB,
          complex128_t const beta,
          complex128_t      *__nonnull const C, __LAPACK_int const ldC) {
    zhemm_(&sideA, &uploA,
           &M, &N,
           &alpha,
           A, &ldA,
           B, &ldB,
           &beta,
           C, &ldC);
}
// MARK: trmm
__attribute__((always_inline, __overloadable__)) inline static
void trmm(__LAPACK_int const M, __LAPACK_int const N,
          float32_t const alpha,
          float32_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA, uplo_t const uploA, diag_t const diagA, side_t const sideA,
          float32_t      *__nonnull const B, __LAPACK_int const ldB) {
    strmm_(&sideA,
           &uploA, &opA, &diagA,
           &M, &N,
           &alpha,
           A, &ldA,
           B, &ldB);
}
__attribute__((always_inline, __overloadable__)) inline static
void trmm(__LAPACK_int const M, __LAPACK_int const N,
          float64_t const alpha,
          float64_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA, uplo_t const uploA, diag_t const diagA, side_t const sideA,
          float64_t      *__nonnull const B, __LAPACK_int const ldB) {
    dtrmm_(&sideA,
           &uploA, &opA, &diagA,
           &M, &N,
           &alpha,
           A, &ldA,
           B, &ldB);
}
__attribute__((always_inline, __overloadable__)) inline static
void trmm(__LAPACK_int const M, __LAPACK_int const N,
          complex64_t const alpha,
          complex64_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA, uplo_t const uploA, diag_t const diagA, side_t const sideA,
          complex64_t      *__nonnull const B, __LAPACK_int const ldB) {
    ctrmm_(&sideA,
           &uploA, &opA, &diagA,
           &M, &N,
           &alpha,
           A, &ldA,
           B, &ldB);
}
__attribute__((always_inline, __overloadable__)) inline static
void trmm(__LAPACK_int const M, __LAPACK_int const N,
          complex128_t const alpha,
          complex128_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA, uplo_t const uploA, diag_t const diagA, side_t const sideA,
          complex128_t      *__nonnull const B, __LAPACK_int const ldB) {
    ztrmm_(&sideA,
           &uploA, &opA, &diagA,
           &M, &N,
           &alpha,
           A, &ldA,
           B, &ldB);
}
// MARK: syrk
__attribute__((always_inline, __overloadable__)) inline static
void syrk(__LAPACK_int const N, __LAPACK_int const K,
          float32_t const alpha,
          float32_t const*__nonnull const x, __LAPACK_int const incx,
          float32_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
          float32_t const beta,
          float32_t      *__nonnull const C, __LAPACK_int const ldC, uplo_t const uploC) {
    ssyrk_(&uploC,
           &opA,
           &N, &K,
           &alpha,
           A, &ldA,
           &beta,
           C, &ldC);
}
__attribute__((always_inline, __overloadable__)) inline static
void syrk(__LAPACK_int const N, __LAPACK_int const K,
          float64_t const alpha,
          float64_t const*__nonnull const x, __LAPACK_int const incx,
          float64_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
          float64_t const beta,
          float64_t      *__nonnull const C, __LAPACK_int const ldC, uplo_t const uploC) {
    dsyrk_(&uploC,
           &opA,
           &N, &K,
           &alpha,
           A, &ldA,
           &beta,
           C, &ldC);
}
__attribute__((always_inline, __overloadable__)) inline static
void syrk(__LAPACK_int const N, __LAPACK_int const K,
          complex64_t const alpha,
          complex64_t const*__nonnull const x, __LAPACK_int const incx,
          complex64_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
          complex64_t const beta,
          complex64_t      *__nonnull const C, __LAPACK_int const ldC, uplo_t const uploC) {
    csyrk_(&uploC,
           &opA,
           &N, &K,
           &alpha,
           A, &ldA,
           &beta,
           C, &ldC);
}
__attribute__((always_inline, __overloadable__)) inline static
void syrk(__LAPACK_int const N, __LAPACK_int const K,
          complex128_t const alpha,
          complex128_t const*__nonnull const x, __LAPACK_int const incx,
          complex128_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
          complex128_t const beta,
          complex128_t      *__nonnull const C, __LAPACK_int const ldC, uplo_t const uploC) {
    zsyrk_(&uploC,
           &opA,
           &N, &K,
           &alpha,
           A, &ldA,
           &beta,
           C, &ldC);
}
__attribute__((always_inline, __overloadable__)) inline static
void herk(__LAPACK_int const N, __LAPACK_int const K,
          complex64_t const alpha,
          complex64_t const*__nonnull const x, __LAPACK_int const incx,
          complex64_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
          complex64_t const beta,
          complex64_t      *__nonnull const C, __LAPACK_int const ldC, uplo_t const uploC) {
    cherk_(&uploC,
           &opA,
           &N, &K,
           &alpha,
           A, &ldA,
           &beta,
           C, &ldC);
}
__attribute__((always_inline, __overloadable__)) inline static
void herk(__LAPACK_int const N, __LAPACK_int const K,
          complex128_t const alpha,
          complex128_t const*__nonnull const x, __LAPACK_int const incx,
          complex128_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
          complex128_t const beta,
          complex128_t      *__nonnull const C, __LAPACK_int const ldC, uplo_t const uploC) {
    zherk_(&uploC,
           &opA,
           &N, &K,
           &alpha,
           A, &ldA,
           &beta,
           C, &ldC);
}

