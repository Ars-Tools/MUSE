//
//  blas.h
//  MUSE
//
//  Created by Kota on 6/18/26.
//
#include"module.h"
// MARK: axpy
__attribute__((always_inline, __overloadable__)) inline static
void axpy(__LAPACK_int const N,
          float32_t const alpha,
          float32_t const*__nonnull const x, __LAPACK_int const incx,
          float32_t      *__nonnull const y, __LAPACK_int const incy) {
    saxpy_(&N,
           &alpha,
           x, &incx,
           y, &incy);
}
__attribute__((always_inline, __overloadable__)) inline static
void axpy(__LAPACK_int const N,
          float64_t const alpha,
          float64_t const*__nonnull const x, __LAPACK_int const incx,
          float64_t      *__nonnull const y, __LAPACK_int const incy) {
    daxpy_(&N,
           &alpha,
           x, &incx,
           y, &incy);
}
__attribute__((always_inline, __overloadable__)) inline static
void axpy(__LAPACK_int const N,
          complex64_t const alpha,
          complex64_t const*__nonnull const x, __LAPACK_int const incx,
          complex64_t      *__nonnull const y, __LAPACK_int const incy) {
    caxpy_(&N,
           &alpha,
           x, &incx,
           y, &incy);
}
__attribute__((always_inline, __overloadable__)) inline static
void axpy(__LAPACK_int const N,
          complex128_t const alpha,
          complex128_t const*__nonnull const x, __LAPACK_int const incx,
          complex128_t      *__nonnull const y, __LAPACK_int const incy) {
    zaxpy_(&N,
           &alpha,
           x, &incx,
           y, &incy);
}
// MARK: scal
__attribute__((always_inline, __overloadable__)) inline static
void scal(__LAPACK_int const N,
          float32_t const alpha,
          float32_t      *__nonnull const x, __LAPACK_int const inc) {
    sscal_(&N, &alpha, x, &inc);
}
__attribute__((always_inline, __overloadable__)) inline static
void scal(__LAPACK_int const N,
          float64_t const alpha,
          float64_t      *__nonnull const x, __LAPACK_int const inc) {
    dscal_(&N, &alpha, x, &inc);
}
__attribute__((always_inline, __overloadable__)) inline static
void scal(__LAPACK_int const N,
          complex64_t const alpha,
          complex64_t      *__nonnull const x, __LAPACK_int const inc) {
    cscal_(&N, &alpha, x, &inc);
}
__attribute__((always_inline, __overloadable__)) inline static
void scal(__LAPACK_int const N,
          complex128_t const alpha,
          complex128_t      *__nonnull const x, __LAPACK_int const inc) {
    zscal_(&N, &alpha, x, &inc);
}
// MARK: copy
__attribute__((always_inline, __overloadable__)) inline static
void copy(__LAPACK_int const N,
          float32_t const*__nonnull const x, __LAPACK_int const incx,
          float32_t      *__nonnull const y, __LAPACK_int const incy) {
    scopy_(&N, x, &incx, &y, &incy);
}
__attribute__((always_inline, __overloadable__)) inline static
void copy(__LAPACK_int const N,
          float64_t const*__nonnull const x, __LAPACK_int const incx,
          float64_t      *__nonnull const y, __LAPACK_int const incy) {
    dcopy_(&N, x, &incx, &y, &incy);
}
__attribute__((always_inline, __overloadable__)) inline static
void copy(__LAPACK_int const N,
          complex64_t const*__nonnull const x, __LAPACK_int const incx,
          complex64_t      *__nonnull const y, __LAPACK_int const incy) {
    ccopy_(&N, x, &incx, &y, &incy);
}
__attribute__((always_inline, __overloadable__)) inline static
void copy(__LAPACK_int const N,
          complex128_t const*__nonnull const x, __LAPACK_int const incx,
          complex128_t      *__nonnull const y, __LAPACK_int const incy) {
    zcopy_(&N, x, &incx, &y, &incy);
}
// MARK: swap
__attribute__((always_inline, __overloadable__)) inline static
void swap(__LAPACK_int const N,
          float32_t const*__nonnull const x, __LAPACK_int const incx,
          float32_t      *__nonnull const y, __LAPACK_int const incy) {
    sswap_(&N, x, &incx, &y, &incy);
}
__attribute__((always_inline, __overloadable__)) inline static
void swap(__LAPACK_int const N,
          float64_t const*__nonnull const x, __LAPACK_int const incx,
          float64_t      *__nonnull const y, __LAPACK_int const incy) {
    dswap_(&N, x, &incx, &y, &incy);
}
__attribute__((always_inline, __overloadable__)) inline static
void swap(__LAPACK_int const N,
          complex64_t const*__nonnull const x, __LAPACK_int const incx,
          complex64_t      *__nonnull const y, __LAPACK_int const incy) {
    cswap_(&N, x, &incx, &y, &incy);
}
__attribute__((always_inline, __overloadable__)) inline static
void swap(__LAPACK_int const N,
          complex128_t const*__nonnull const x, __LAPACK_int const incx,
          complex128_t      *__nonnull const y, __LAPACK_int const incy) {
    zswap_(&N, x, &incx, &y, &incy);
}
// MARK: dot
__attribute__((always_inline, __overloadable__)) inline static
float32_t const dot(__LAPACK_int const N,
                    float32_t const*__nonnull const x, __LAPACK_int const incx,
                    float32_t const*__nonnull const y, __LAPACK_int const incy) {
    return sdot_(&N, x, &incx, y, &incy);
}
__attribute__((always_inline, __overloadable__)) inline static
float64_t const dot(__LAPACK_int const N,
                    float64_t const*__nonnull const x, __LAPACK_int const incx,
                    float64_t const*__nonnull const y, __LAPACK_int const incy) {
    return sdot_(&N, x, &incx, y, &incy);
}
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const dot(__LAPACK_int const N,
                      complex64_t const*__nonnull const x, __LAPACK_int const incx,
                      complex64_t const*__nonnull const y, __LAPACK_int const incy) {
    complex64_t result;
    cdotu_(&result, &N, x, &incx, y, &incy);
    return result;
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const dot(__LAPACK_int const N,
                       complex128_t const*__nonnull const x, __LAPACK_int const incx,
                       complex128_t const*__nonnull const y, __LAPACK_int const incy) {
    complex128_t result;
    zdotu_(&result, &N, x, &incx, y, &incy);
    return result;
}
// MARK: dotc
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const dotc(__LAPACK_int const N,
                       complex64_t const*__nonnull const x, __LAPACK_int const incx,
                       complex64_t const*__nonnull const y, __LAPACK_int const incy) {
    complex64_t result;
    cdotc_(&result, &N, x, &incx, y, &incy);
    return result;
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const dotc(__LAPACK_int const N,
                        complex128_t const*__nonnull const x, __LAPACK_int const incx,
                        complex128_t const*__nonnull const y, __LAPACK_int const incy) {
    complex128_t result;
    zdotc_(&result, &N, x, &incx, y, &incy);
    return result;
}
// MARK: 2-norm
__attribute__((always_inline, __overloadable__)) inline static
float32_t const nrm2(__LAPACK_int const n,
                     float32_t const*__nonnull const x, __LAPACK_int const incx) {
    return snrm2(&n, x, &incx);
}
__attribute__((always_inline, __overloadable__)) inline static
float64_t const nrm2(__LAPACK_int const n,
                     float64_t const*__nonnull const x, __LAPACK_int const incx) {
    return dnrm2(&n, x, &incx);
}
__attribute__((always_inline, __overloadable__)) inline static
float32_t const nrm2(__LAPACK_int const n,
                     complex64_t const*__nonnull const x, __LAPACK_int const incx) {
    return scnrm2(&n, x, &incx);
}
__attribute__((always_inline, __overloadable__)) inline static
float64_t const nrm2(__LAPACK_int const n,
                     complex128_t const*__nonnull const x, __LAPACK_int const incx) {
    return dznrm2(&n, x, &incx);
}
// MARK: 1-norm
__attribute__((always_inline, __overloadable__)) inline static
float32_t const asum(__LAPACK_int const n,
                     float32_t const*__nonnull const x, __LAPACK_int const incx) {
    return sasum(&n, x, &incx);
}
__attribute__((always_inline, __overloadable__)) inline static
float64_t const asum(__LAPACK_int const n,
                     float64_t const*__nonnull const x, __LAPACK_int const incx) {
    return dasum(&n, x, &incx);
}
__attribute__((always_inline, __overloadable__)) inline static
float32_t const asum(__LAPACK_int const n,
                     complex64_t const*__nonnull const x, __LAPACK_int const incx) {
    return scasum(&n, x, &incx);
}
__attribute__((always_inline, __overloadable__)) inline static
float64_t const asum(__LAPACK_int const n,
                     complex128_t const*__nonnull const x, __LAPACK_int const incx) {
    return dzasum(&n, x, &incx);
}
// MARK: ∞-norm
__attribute__((always_inline, __overloadable__)) inline static
float32_t const i_amax(__LAPACK_int const N,
                       float32_t const*__nonnull const x, __LAPACK_int const incx) {
    return si_amax(&N, x, &incx);
}
__attribute__((always_inline, __overloadable__)) inline static
float64_t const i_amax(__LAPACK_int const N,
                       float64_t const*__nonnull const x, __LAPACK_int const incx) {
    return di_amax(&N, x, &incx);
}
__attribute__((always_inline, __overloadable__)) inline static
float32_t const i_amax(__LAPACK_int const N,
                       complex64_t const*__nonnull const x, __LAPACK_int const incx) {
    return sci_amax(&N, x, &incx);
}
__attribute__((always_inline, __overloadable__)) inline static
float64_t const i_amax(__LAPACK_int const N,
                       complex128_t const*__nonnull const x, __LAPACK_int const incx) {
    return dzi_amax(&N, x, &incx);
}
