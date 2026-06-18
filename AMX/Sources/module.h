//
//  type.h
//  MUSE
//
//  Created by Kota on 6/18/26.
//
#ifndef __LINEAR_ALGEBRA_TYPEDEF__
#define __LINEAR_ALGEBRA_TYPEDEF__
#ifndef ACCELERATE_NEW_LAPACK
#define ACCELERATE_NEW_LAPACK
#endif
#ifndef ACCELERATE_LAPACK_ILP64
#define ACCELERATE_LAPACK_ILP64
#endif
#include<Accelerate/Accelerate.h>
#include<simd/simd.h>
typedef CF_ENUM(char const) {
    op_t_N = 'N',
    op_t_T = 'T',
    op_t_H = 'H'
} op_t;
typedef CF_ENUM(char const) {
    uplo_t_U = 'U', // upper
    uplo_t_L = 'L'  // lower
} uplo_t;
typedef CF_ENUM(char const) {
    side_t_L = 'L', // left
    side_t_R = 'R'  // right
} side_t;
typedef CF_ENUM(char const) {
    diag_t_U = 'U', // assumed to be unit triangular
    diag_t_N = 'N'  // nnot assumed to be unit triangler
} diag_t;
typedef CF_ENUM(char const) {
    job_t_A = 'A',
    job_t_S = 'S',
    job_t_O = 'O',
    job_t_N = 'N'
} svd_job_t;
typedef CF_ENUM(char const) {
    eig_job_t_N = 'N',
    eig_job_t_V = 'V'
} eig_job_t;
typedef CF_ENUM(char const) {
    eig_sort_t_N = 'N',
    eig_sort_t_S = 'S'
} eig_sort_t;
typedef CF_ENUM(char const) {
    eig_range_t_A = 'A',
    eig_range_t_V = 'V',
    eig_range_t_I = 'I'
} eig_range_t;
typedef union {
    __complex float scalar;
    __LAPACK_float_complex lapack;
    simd_float2 vector;
    DSPComplex vDSP;
    struct {
        float32_t real;
        float32_t imag;
    };
} complex64_t;
typedef union {
    __complex double scalar;
    __LAPACK_double_complex lapack;
    simd_double2 vector;
    DSPDoubleComplex vDSP;
    struct {
        float64_t real;
        float64_t imag;
    };
} complex128_t;
#endif
