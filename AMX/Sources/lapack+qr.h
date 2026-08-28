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
#endif
