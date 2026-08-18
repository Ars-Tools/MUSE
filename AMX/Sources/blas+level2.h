//
//  blas+level2.h
//  MUSE
//
//  Created by Kota on 6/18/26.
//
#include"module.h"
// MARK: gemv
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
void gemv(__LAPACK_int const m, __LAPACK_int const n,
          float32_t const alpha,
          float32_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
          float32_t const*__nonnull const x, __LAPACK_int const incx,
          float32_t const beta,
          float32_t      *__nonnull const y, __LAPACK_int const incy) {
    sgemv_(&opA,
           &m, &n,
           &alpha,
           A, &ldA,
           x, &incx,
           &beta,
           y, &incy);
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
void gemv(__LAPACK_int const m, __LAPACK_int const n,
          float64_t const alpha,
          float64_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
          float64_t const*__nonnull const x, __LAPACK_int const incx,
          float64_t const beta,
          float64_t      *__nonnull const y, __LAPACK_int const incy) {
    dgemv_(&opA,
           &m, &n,
           &alpha,
           A, &ldA,
           x, &incx,
           &beta,
           y, &incy);
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
void gemv(__LAPACK_int const m, __LAPACK_int const n,
          complex64_t const alpha,
          complex64_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
          complex64_t const*__nonnull const x, __LAPACK_int const incx,
          complex64_t const beta,
          complex64_t      *__nonnull const y, __LAPACK_int const incy) {
    cgemv_(&opA,
           &m, &n,
           &alpha,
           A, &ldA,
           x, &incx,
           &beta,
           y, &incy);
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
void gemv(__LAPACK_int const m, __LAPACK_int const n,
          complex128_t const alpha,
          complex128_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
          complex128_t const*__nonnull const x, __LAPACK_int const incx,
          complex128_t const beta,
          complex128_t      *__nonnull const y, __LAPACK_int const incy) {
    zgemv_(&opA,
           &m, &n,
           &alpha,
           A, &ldA,
           x, &incx,
           &beta,
           y, &incy);
}
// MARK: symv
__attribute__((always_inline, overloadable)) static inline
void symv(__LAPACK_int const N,
           float32_t const alpha,
           float32_t const*__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA,
           float32_t const*__nonnull const x, __LAPACK_int const incx,
           float32_t const beta,
           float32_t      *__nonnull const y, __LAPACK_int const incy) {
    ssymv_(&uploA,
           &N,
           &alpha,
           A, &ldA,
           x, &incx,
           &beta,
           y, &incy);
}
__attribute__((always_inline, overloadable)) static inline
void symv(__LAPACK_int const N,
          float64_t const alpha,
          float64_t const*__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA,
          float64_t const*__nonnull const x, __LAPACK_int const incx,
          float64_t const beta,
          float64_t      *__nonnull const y, __LAPACK_int const incy) {
    dsymv_(&uploA,
           &N,
           &alpha,
           A, &ldA,
           x, &incx,
           &beta,
           y, &incy);
}
__attribute__((always_inline, overloadable)) static inline
void symv(__LAPACK_int const N,
          complex64_t const alpha,
          complex64_t const*__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA,
          complex64_t const*__nonnull const x, __LAPACK_int const incx,
          complex64_t const beta,
          complex64_t     *__nonnull const y, __LAPACK_int const incy) {
    csymv_(&uploA,
           &N,
           &alpha,
           A, &ldA,
           x, &incx,
           &beta,
           y, &incy);
}
__attribute__((always_inline, overloadable)) static inline
void symv(__LAPACK_int const N,
          complex128_t const alpha,
          complex128_t const*__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA,
          complex128_t const*__nonnull const x, __LAPACK_int const incx,
          complex128_t const beta,
          complex128_t     *__nonnull const y, __LAPACK_int const incy) {
    zsymv_(&uploA,
           &N,
           &alpha,
           A, &ldA,
           x, &incx,
           &beta,
           y, &incy);
}
// MARK: trmv
__attribute__((always_inline, overloadable)) static inline
void trmv(__LAPACK_int const N,
          float32_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA, uplo_t const uploA, diag_t const diagA,
          float32_t      *__nonnull const x, __LAPACK_int const incx) {
    strmv_(&uploA, &opA, &diagA,
           &N,
           A, &ldA,
           x, &incx);
}
__attribute__((always_inline, overloadable)) static inline
void trmv(__LAPACK_int const N,
          float64_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA, uplo_t const uploA, diag_t const diagA,
          float64_t      *__nonnull const x, __LAPACK_int const incx) {
    dtrmv_(&uploA, &opA, &diagA,
           &N,
           A, &ldA,
           x, &incx);
}
__attribute__((always_inline, overloadable)) static inline
void trmv(__LAPACK_int const N,
          complex64_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA, uplo_t const uploA, diag_t const diagA,
          complex64_t      *__nonnull const x, __LAPACK_int const incx) {
    ctrmv_(&uploA, &opA, &diagA,
           &N,
           A, &ldA,
           x, &incx);
}
__attribute__((always_inline, overloadable)) static inline
void trmv(__LAPACK_int const N,
          complex128_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA, uplo_t const uploA, diag_t const diagA,
          complex128_t      *__nonnull const x, __LAPACK_int const incx) {
    ztrmv_(&uploA, &opA, &diagA,
           &N,
           A, &ldA,
           x, &incx);
}
// MARK: ger
__attribute__((always_inline, overloadable)) static inline
void ger(__LAPACK_int const M, __LAPACK_int const N,
         float32_t const alpha,
         float32_t const*__nonnull const x, __LAPACK_int const incx,
         float32_t const*__nonnull const y, __LAPACK_int const incy,
         float32_t      *__nonnull const A, __LAPACK_int const ldA) {
    sger_(&M, &N,
          &alpha,
          x, &incx,
          y, &incy,
          A, &ldA);
}
__attribute__((always_inline, overloadable)) static inline
void ger(__LAPACK_int const M, __LAPACK_int const N,
         float64_t const alpha,
         float64_t const*__nonnull const x, __LAPACK_int const incx,
         float64_t const*__nonnull const y, __LAPACK_int const incy,
         float64_t      *__nonnull const A, __LAPACK_int const ldA) {
    dger_(&M, &N,
          &alpha,
          x, &incx,
          y, &incy,
          A, &ldA);
}
__attribute__((always_inline, overloadable)) static inline
void ger(__LAPACK_int const M, __LAPACK_int const N,
         complex64_t const alpha,
         complex64_t const*__nonnull const x, __LAPACK_int const incx,
         complex64_t const*__nonnull const y, __LAPACK_int const incy,
         complex64_t      *__nonnull const A, __LAPACK_int const ldA) {
    cgeru_(&M, &N,
           &alpha,
           x, &incx,
           y, &incy,
           A, &ldA);
}
__attribute__((always_inline, overloadable)) static inline
void ger(__LAPACK_int const M, __LAPACK_int const N,
         complex128_t const alpha,
         complex128_t const*__nonnull const x, __LAPACK_int const incx,
         complex128_t const*__nonnull const y, __LAPACK_int const incy,
         complex128_t      *__nonnull const A, __LAPACK_int const ldA) {
    zgeru_(&M, &N,
          &alpha,
          x, &incx,
          y, &incy,
          A, &ldA);
}
__attribute__((always_inline, overloadable)) static inline
void gerc(__LAPACK_int const M, __LAPACK_int const N,
          complex64_t const alpha,
          complex64_t const*__nonnull const x, __LAPACK_int const incx,
          complex64_t const*__nonnull const y, __LAPACK_int const incy,
          complex64_t      *__nonnull const A, __LAPACK_int const ldA) {
    cgerc_(&M, &N,
           &alpha,
           x, &incx,
           y, &incy,
           A, &ldA);
}
__attribute__((always_inline, overloadable)) static inline
void gerc(__LAPACK_int const M, __LAPACK_int const N,
          complex128_t const alpha,
          complex128_t const*__nonnull const x, __LAPACK_int const incx,
          complex128_t const*__nonnull const y, __LAPACK_int const incy,
          complex128_t      *__nonnull const A, __LAPACK_int const ldA) {
    zgerc_(&M, &N,
          &alpha,
          x, &incx,
          y, &incy,
          A, &ldA);
}
// MARK: syr
__attribute__((always_inline, overloadable)) static inline
void syr(__LAPACK_int const N,
         float32_t const alpha,
         float32_t const*__nonnull const x, __LAPACK_int const incx,
         float32_t      *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA) {
    ssyr_(&uploA,
          &N,
          &alpha,
          x, &incx,
          A, &ldA);
}
__attribute__((always_inline, overloadable)) static inline
void syr(__LAPACK_int const N,
         float64_t const alpha,
         float64_t const*__nonnull const x, __LAPACK_int const incx,
         float64_t      *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA) {
    dsyr_(&uploA,
          &N,
          &alpha,
          x, &incx,
          A, &ldA);
}
__attribute__((always_inline, overloadable)) static inline
void syr(__LAPACK_int const N,
         complex64_t const alpha,
         complex64_t const*__nonnull const x, __LAPACK_int const incx,
         complex64_t      *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA) {
    csyr_(&uploA,
          &N,
          &alpha,
          x, &incx,
          A, &ldA);
}
__attribute__((always_inline, overloadable)) static inline
void syr(__LAPACK_int const N,
         complex128_t const alpha,
         complex128_t const*__nonnull const x, __LAPACK_int const incx,
         complex128_t      *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA) {
    zsyr_(&uploA,
          &N,
          &alpha,
          x, &incx,
          A, &ldA);
}
// MARK: her
__attribute__((always_inline, overloadable)) static inline
void her(__LAPACK_int const N,
         complex64_t const alpha,
         complex64_t const*__nonnull const x, __LAPACK_int const incx,
         complex64_t      *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA) {
    cher_(&uploA,
          &N,
          &alpha,
          x, &incx,
          A, &ldA);
}
__attribute__((always_inline, overloadable)) static inline
void her(__LAPACK_int const N,
         complex128_t const alpha,
         complex128_t const*__nonnull const x, __LAPACK_int const incx,
         complex128_t      *__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA) {
    zher_(&uploA,
          &N,
          &alpha,
          x, &incx,
          A, &ldA);
}
// MARK: gbmv
__attribute__((always_inline, overloadable)) static inline
void gbmv(__LAPACK_int const M, __LAPACK_int const N,
          __LAPACK_int const KL, __LAPACK_int const KU,
          float32_t const alpha,
          float32_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
          float32_t const*__nonnull const x, __LAPACK_int const incx,
          float32_t const beta,
          float32_t      *__nonnull const y, __LAPACK_int const incy) {
    sgbmv_(&opA,
           &M, &N,
           &KL, &KU,
           &alpha,
           A, &ldA,
           x, &incx,
           &beta,
           y, &incy);
}
__attribute__((always_inline, overloadable)) static inline
void gbmv(__LAPACK_int const M, __LAPACK_int const N,
          __LAPACK_int const KL, __LAPACK_int const KU,
          float64_t const alpha,
          float64_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
          float64_t const*__nonnull const x, __LAPACK_int const incx,
          float64_t const beta,
          float64_t      *__nonnull const y, __LAPACK_int const incy) {
    dgbmv_(&opA,
           &M, &N,
           &KL, &KU,
           &alpha,
           A, &ldA,
           x, &incx,
           &beta,
           y, &incy);
}
__attribute__((always_inline, overloadable)) static inline
void gbmv(__LAPACK_int const M, __LAPACK_int const N,
          __LAPACK_int const KL, __LAPACK_int const KU,
          complex64_t const alpha,
          complex64_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
          complex64_t const*__nonnull const x, __LAPACK_int const incx,
          complex64_t const beta,
          complex64_t      *__nonnull const y, __LAPACK_int const incy) {
    cgbmv_(&opA,
           &M, &N,
           &KL, &KU,
           &alpha,
           A, &ldA,
           x, &incx,
           &beta,
           y, &incy);
}
__attribute__((always_inline, overloadable)) static inline
void gbmv(__LAPACK_int const M, __LAPACK_int const N,
          __LAPACK_int const KL, __LAPACK_int const KU,
          complex128_t const alpha,
          complex128_t const*__nonnull const A, __LAPACK_int const ldA, op_t const opA,
          complex128_t const*__nonnull const x, __LAPACK_int const incx,
          complex128_t const beta,
          complex128_t      *__nonnull const y, __LAPACK_int const incy) {
    zgbmv_(&opA,
           &M, &N,
           &KL, &KU,
           &alpha,
           A, &ldA,
           x, &incx,
           &beta,
           y, &incy);
}
// MARK: sbmv
__attribute__((always_inline, overloadable)) static inline
void sbmv(__LAPACK_int const N,
          __LAPACK_int const K,
          float32_t const alpha,
          float32_t const*__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA,
          float32_t const*__nonnull const x, __LAPACK_int const incx,
          float32_t const beta,
          float32_t      *__nonnull const y, __LAPACK_int const incy) {
    ssbmv_(&uploA,
           &N, &K,
           &alpha,
           A, &ldA,
           x, &incx,
           &beta,
           y, &incy);
}
__attribute__((always_inline, overloadable)) static inline
void sbmv(__LAPACK_int const N,
          __LAPACK_int const K,
          float64_t const alpha,
          float64_t const*__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA,
          float64_t const*__nonnull const x, __LAPACK_int const incx,
          float64_t const beta,
          float64_t      *__nonnull const y, __LAPACK_int const incy) {
    dsbmv_(&uploA,
           &N, &K,
           &alpha,
           A, &ldA,
           x, &incx,
           &beta,
           y, &incy);
}
// MARK: hbmv
__attribute__((always_inline, overloadable)) static inline
void hbmv(__LAPACK_int const N,
          __LAPACK_int const K,
          complex64_t const alpha,
          complex64_t const*__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA,
          complex64_t const*__nonnull const x, __LAPACK_int const incx,
          complex64_t const beta,
          complex64_t      *__nonnull const y, __LAPACK_int const incy) {
    chbmv_(&uploA,
           &N, &K,
           &alpha,
           A, &ldA,
           x, &incx,
           &beta,
           y, &incy);
}
__attribute__((always_inline, overloadable)) static inline
void hbmv(__LAPACK_int const N,
          __LAPACK_int const K,
          complex128_t const alpha,
          complex128_t const*__nonnull const A, __LAPACK_int const ldA, uplo_t const uploA,
          complex128_t const*__nonnull const x, __LAPACK_int const incx,
          complex128_t const beta,
          complex128_t      *__nonnull const y, __LAPACK_int const incy) {
    zhbmv_(&uploA,
           &N, &K,
           &alpha,
           A, &ldA,
           x, &incx,
           &beta,
           y, &incy);
}
