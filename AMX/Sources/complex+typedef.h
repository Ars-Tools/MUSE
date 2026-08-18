//
//  complex+typedef.h
//  MUSE
//
//  Created by Kota on 8/18/26.
//
#ifndef ACCELERATE_NEW_LAPACK
#define ACCELERATE_NEW_LAPACK
#endif
#ifndef ACCELERATE_LAPACK_ILP64
#define ACCELERATE_LAPACK_ILP64
#endif
#include<Accelerate/Accelerate.h>
#include<simd/simd.h>
#ifndef __COMPLEX_TYPEDEF__
#define __COMPLEX_TYPEDEF__
__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
typedef union {
    __complex float const scalar;
    __LAPACK_float_complex const lapack;
    simd_float2 const vector;
    DSPComplex const DSPComplex;
    struct {
        float32_t const r;
        float32_t const i;
    };
} complex64_t;
__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
typedef union {
    __complex double const scalar;
    __LAPACK_double_complex const lapack;
    simd_double2 const vector;
    DSPDoubleComplex const DSPComplex;
    struct {
        float64_t const r;
        float64_t const i;
    };
} complex128_t;
#endif
