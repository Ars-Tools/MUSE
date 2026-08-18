//
//  type.h
//  MUSE
//
//  Created by Kota on 6/18/26.
//
#ifndef ACCELERATE_NEW_LAPACK
#define ACCELERATE_NEW_LAPACK
#endif
#ifndef ACCELERATE_LAPACK_ILP64
#define ACCELERATE_LAPACK_ILP64
#endif
#include<Accelerate/Accelerate.h>
#include<simd/simd.h>
#ifndef __LINEAR_ALGEBRA_TYPEDEF__
#define __LINEAR_ALGEBRA_TYPEDEF__
//__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
typedef CF_ENUM(char) {
    op_t_N = 'N',
    op_t_T = 'T',
    op_t_H = 'H'
} op_t;
//__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
typedef CF_ENUM(char) {
    uplo_t_U = 'U', // upper
    uplo_t_L = 'L'  // lower
} uplo_t;
//__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
typedef CF_ENUM(char) {
    side_t_L = 'L', // left
    side_t_R = 'R'  // right
} side_t;
//__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
typedef CF_ENUM(char) {
    diag_t_U = 'U', // assumed to be unit triangular
    diag_t_N = 'N'  // nnot assumed to be unit triangler
} diag_t;
//__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
typedef CF_ENUM(char) {
    job_t_A = 'A',
    job_t_S = 'S',
    job_t_O = 'O',
    job_t_N = 'N'
} svd_job_t;
//__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
typedef CF_ENUM(char) {
    eig_job_t_N = 'N',
    eig_job_t_V = 'V'
} eig_job_t;
//__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
typedef CF_ENUM(char) {
    eig_sort_t_N = 'N',
    eig_sort_t_S = 'S'
} eig_sort_t;
//__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
typedef CF_ENUM(char) {
    eig_range_t_A = 'A',
    eig_range_t_V = 'V',
    eig_range_t_I = 'I'
} eig_range_t;
#endif
#include"complex+typedef.h"
