//
//  lapack+qr.h
//  MUSE
//
//  Created by Kota on 8/29/26.
//
#include"module.h"
#ifndef __LAPACK__QR__H
#define __LAPACK__QR__H
//__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
typedef CF_ENUM(char) {
    seqr_job_t_E = 'E',
    seqr_job_t_S = 'S'
} seqr_job_t;
//__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
typedef CF_ENUM(char) {
    seqr_z_t_N = 'N',
    seqr_z_t_I = 'I',
    seqr_z_t_V = 'V'
} seqr_z_t;
// MARK: geqr
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const geqr(__LAPACK_int const m, __LAPACK_int const n,
                        float32_t * _Nullable const A, __LAPACK_int const ldA,
                        float32_t * _Nullable const t, __LAPACK_int const tsize,
                        float32_t * _Nullable const work, __LAPACK_int const lwork) {
    static __LAPACK_int const query = -1;
    __LAPACK_int info;
    float32_t size;
    sgeqr_(&m, &n,
           A, &ldA,
           t, &tsize,
           work ? work : &size, work ? &lwork : &query,
           &info);
    return info ? info : work ? info : size;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const geqr(__LAPACK_int const m, __LAPACK_int const n,
                        float64_t * _Nullable const A, __LAPACK_int const ldA,
                        float64_t * _Nullable const t, __LAPACK_int const tsize,
                        float64_t * _Nullable const work, __LAPACK_int const lwork) {
    static __LAPACK_int const query = -1;
    __LAPACK_int info;
    float64_t size;
    dgeqr_(&m, &n,
           A, &ldA,
           t, &tsize,
           work ? work : &size, work ? &lwork : &query,
           &info);
    return info ? info : work ? info : size;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const geqr(__LAPACK_int const m, __LAPACK_int const n,
                        complex64_t * _Nullable const A, __LAPACK_int const ldA,
                        complex64_t * _Nullable const t, __LAPACK_int const tsize,
                        complex64_t * _Nullable const work, __LAPACK_int const lwork) {
    static __LAPACK_int const query = -1;
    __LAPACK_int info;
    __complex float size;
    cgeqr_(&m, &n,
           A, &ldA,
           t, &tsize,
           work ? work : &size, work ? &lwork : &query,
           &info);
    return info ? info : work ? info : __real(size);
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const geqr(__LAPACK_int const m, __LAPACK_int const n,
                        complex128_t * _Nullable const A, __LAPACK_int const ldA,
                        complex128_t * _Nullable const t, __LAPACK_int const tsize,
                        complex128_t * _Nullable const work, __LAPACK_int const lwork) {
    static __LAPACK_int const query = -1;
    __LAPACK_int info;
    __complex double size;
    zgeqr_(&m, &n,
           A, &ldA,
           t, &tsize,
           work ? work : &size, work ? &lwork : &query,
           &info);
    return info ? info : work ? info : __real(size);
}
// MARK: hseqr
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const hseqr(seqr_job_t const job,
                         seqr_z_t const compz,
                         __LAPACK_int const n,
                         __LAPACK_int const ilo,
                         __LAPACK_int const ihi,
                         float32_t*__nullable const h, __LAPACK_int const ldh,
                         float32_t*__nullable const r,
                         float32_t*__nullable const i,
                         float32_t*__nullable const z, __LAPACK_int const ldz,
                         float32_t*__nullable const work, __LAPACK_int const lwork) {
    __LAPACK_int info;
    float32_t size;
    shseqr_(&job, &compz,
            &n,
            &ilo, &ihi,
            h, &ldh,
            r, i,
            z, &ldz,
            work ? work : &size, work ? &lwork : (__LAPACK_int const[]) {-1},
            &info);
    return info ? info : work ? info : size;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const hseqr(seqr_job_t const job,
                         seqr_z_t const compz,
                         __LAPACK_int const n,
                         __LAPACK_int const ilo,
                         __LAPACK_int const ihi,
                         float64_t*__nullable const h, __LAPACK_int const ldh,
                         float64_t*__nullable const r,
                         float64_t*__nullable const i,
                         float64_t*__nullable const z, __LAPACK_int const ldz,
                         float64_t*__nullable const work, __LAPACK_int const lwork) {
    __LAPACK_int info;
    float64_t size;
    dhseqr_(&job, &compz,
            &n,
            &ilo, &ihi,
            h, &ldh,
            r, i,
            z, &ldz,
            work ? work : &size, work ? &lwork : (__LAPACK_int const[]) {-1},
            &info);
    return info ? info : work ? info : size;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const hseqr(seqr_job_t const job,
                         seqr_z_t const compz,
                         __LAPACK_int const n,
                         __LAPACK_int const ilo,
                         __LAPACK_int const ihi,
                         complex64_t*__nullable const h, __LAPACK_int const ldh,
                         complex64_t*__nullable const v,
                         complex64_t*__nullable const z, __LAPACK_int const ldz,
                         complex64_t*__nullable const work, __LAPACK_int const lwork) {
    __LAPACK_int info;
    __complex float size;
    chseqr_(&job, &compz,
            &n,
            &ilo, &ihi,
            h, &ldh,
            v,
            z, &ldz,
            work ? work : &size, work ? &lwork : (__LAPACK_int const[]) {-1},
            &info);
    return info ? info : work ? info : size;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const hseqr(seqr_job_t const job,
                         seqr_z_t const compz,
                         __LAPACK_int const n,
                         __LAPACK_int const ilo,
                         __LAPACK_int const ihi,
                         complex128_t*__nullable const h, __LAPACK_int const ldh,
                         complex128_t*__nullable const v,
                         complex128_t*__nullable const z, __LAPACK_int const ldz,
                         complex128_t*__nullable const work, __LAPACK_int const lwork) {
    __LAPACK_int info;
    __complex double size;
    zhseqr_(&job, &compz,
            &n,
            &ilo, &ihi,
            h, &ldh,
            v,
            z, &ldz,
            work ? work : &size, work ? &lwork : (__LAPACK_int const[]) {-1},
            &info);
    return info ? info : work ? info : size;
}
// MARK: GEQRF
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const geqrf(__LAPACK_int const m, __LAPACK_int const n,
                         float32_t * _Nullable const A, __LAPACK_int const ldA,
                         float32_t * _Nullable const tau,
                         float32_t * _Nullable const work, __LAPACK_int const lwork) {
    static __LAPACK_int const query = -1;
    __LAPACK_int info;
    float32_t size;
    sgeqrf_(&m, &n,
            A, &ldA,
            tau,
            work ? work : &size, work ? &lwork : &query, &info);
    return info ? info : work ? info : size;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const geqrf(__LAPACK_int const m, __LAPACK_int const n,
                         float64_t * _Nullable const A, __LAPACK_int const ldA,
                         float64_t * _Nullable const tau,
                         float64_t * _Nullable const work, __LAPACK_int const lwork) {
    static __LAPACK_int const query = -1;
    __LAPACK_int info;
    float64_t size;
    dgeqrf_(&m, &n,
            A, &ldA,
            tau,
            work ? work : &size, work ? &lwork : &query, &info);
    return info ? info : work ? info : size;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const geqrf(__LAPACK_int const m, __LAPACK_int const n,
                         complex64_t * _Nullable const A, __LAPACK_int const ldA,
                         complex64_t * _Nullable const tau,
                         complex64_t * _Nullable const work, __LAPACK_int const lwork) {
    static __LAPACK_int const query = -1;
    __LAPACK_int info;
    __complex float size;
    cgeqrf_(&m, &n,
            A, &ldA,
            tau,
            work ? work : &size, work ? &lwork : &query, &info);
    return info ? info : work ? info : __real(size);
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const geqrf(__LAPACK_int const m, __LAPACK_int const n,
                         complex128_t * _Nullable const A, __LAPACK_int const ldA,
                         complex128_t * _Nullable const tau,
                         complex128_t * _Nullable const work, __LAPACK_int const lwork) {
    static __LAPACK_int const query = -1;
    __LAPACK_int info;
    __complex double size;
    zgeqrf_(&m, &n,
            A, &ldA,
            tau,
            work ? work : &size, work ? &lwork : &query, &info);
    return info ? info : work ? info : __real(size);
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
void larf(__LAPACK_int const m, __LAPACK_int const n,
          float32_t * _Nullable v, __LAPACK_int const incv, side_t const sidev,
          float32_t const tau,
          float32_t * _Nullable c, __LAPACK_int const ldc,
          float32_t * _Nullable work) {
    slarf_(&sidev,
           &m, &n,
           v, &incv,
           &tau,
           c, &ldc,
           work);
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
void larf(__LAPACK_int const m, __LAPACK_int const n,
          float64_t * _Nullable v, __LAPACK_int const incv, side_t const sidev,
          float64_t const tau,
          float64_t * _Nullable c, __LAPACK_int const ldc,
          float64_t * _Nullable work) {
    dlarf_(&sidev,
           &m, &n,
           v, &incv,
           &tau,
           c, &ldc,
           work);
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
void larf(__LAPACK_int const m, __LAPACK_int const n,
          complex64_t * _Nullable v, __LAPACK_int const incv, side_t const sidev,
          complex64_t const tau,
          complex64_t * _Nullable c, __LAPACK_int const ldc,
          complex64_t * _Nullable work) {
    clarf_(&sidev,
           &m, &n,
           v, &incv,
           &tau,
           c, &ldc,
           work);
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
void larf(__LAPACK_int const m, __LAPACK_int const n,
          complex128_t * _Nullable v, __LAPACK_int const incv, side_t const sidev,
          complex128_t const tau,
          complex128_t * _Nullable c, __LAPACK_int const ldc,
          complex128_t * _Nullable work) {
    zlarf_(&sidev,
           &m, &n,
           v, &incv,
           &tau,
           c, &ldc,
           work);
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
simd_float2 larfg(__LAPACK_int const n,
                float32_t alpha, float32_t tau,
                float32_t * _Nullable const x, __LAPACK_int const incx) {
    slarfg_(&n, &alpha, x, &incx, &tau);
    return (simd_float2 const) { alpha, tau };
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
simd_double2 larfg(__LAPACK_int const n,
                float64_t alpha, float64_t tau,
                float64_t * _Nullable const x, __LAPACK_int const incx) {
    dlarfg_(&n, &alpha, x, &incx, &tau);
    return (simd_double2 const) { alpha, tau };
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
simd_float4 larfg(__LAPACK_int const n,
                  complex64_t alpha, complex64_t tau,
                  complex64_t * _Nullable const x, __LAPACK_int const incx) {
    clarfg_(&n, &alpha, x, &incx, &tau);
    return (simd_float4 const) { alpha.r, alpha.i, tau.r, alpha.i };
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
simd_double4 larfg(__LAPACK_int const n,
                   complex128_t alpha, complex128_t tau,
                   complex128_t * _Nullable const x, __LAPACK_int const incx) {
    zlarfg_(&n, &alpha, x, &incx, &tau);
    return (simd_double4 const) { alpha.r, alpha.i, tau.r, alpha.i };
}
#endif
