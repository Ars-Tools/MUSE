//
//  lapack+ls.h
//  MUSE
//
//  Created by Kota on 6/18/26.
//
#include"module.h"
// MARK: gels
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const gels(__LAPACK_int const m, __LAPACK_int const n, __LAPACK_int const nrhs,
                        float32_t      *__nonnull const A, __LAPACK_int const ldA, op_t const opA,
                        float32_t      *__nonnull const B, __LAPACK_int const ldB,
                        float32_t      *__nullable work, __LAPACK_int const lwork) {
    __LAPACK_int info;
    float32_t size;
    sgels_(&opA,
           &m, &n, &nrhs,
           A, &ldA,
           B, &ldB,
           work ? work : &size, work ? &lwork : (__LAPACK_int const[]) {-1},
           &info);
    return work ? info : info ? info : size;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const gels(__LAPACK_int const m, __LAPACK_int const n, __LAPACK_int const nrhs,
                        float64_t      *__nonnull const A, __LAPACK_int const ldA, op_t const opA,
                        float64_t      *__nonnull const B, __LAPACK_int const ldB,
                        float64_t      *__nullable work, __LAPACK_int const lwork) {
    __LAPACK_int info;
    float64_t size;
    dgels_(&opA,
           &m, &n, &nrhs,
           A, &ldA,
           B, &ldB,
           work ? work : &size, work ? &lwork : (__LAPACK_int const[]) {-1},
           &info);
    return work ? info : info ? info : size;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const gels(__LAPACK_int const m, __LAPACK_int const n, __LAPACK_int const nrhs,
                        complex64_t      *__nonnull const A, __LAPACK_int const ldA, op_t const opA,
                        complex64_t      *__nonnull const B, __LAPACK_int const ldB,
                        complex64_t      *__nullable work, __LAPACK_int const lwork) {
    __LAPACK_int info;
    __complex float size;
    cgels_(&opA,
           &m, &n, &nrhs,
           &A->scalar, &ldA,
           &B->scalar, &ldB,
           work ? work : &size, work ? &lwork : (__LAPACK_int const[]) {-1},
           &info);
    return work ? info : info ? info : size;
}
__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
__LAPACK_int const gels(__LAPACK_int const m, __LAPACK_int const n, __LAPACK_int const nrhs,
                        complex128_t      *__nonnull const A, __LAPACK_int const ldA, op_t const opA,
                        complex128_t      *__nonnull const B, __LAPACK_int const ldB,
                        complex128_t      *__nullable work, __LAPACK_int const lwork) {
    __LAPACK_int info;
    __complex double size;
    zgels_(&opA,
           &m, &n, &nrhs,
           &A->scalar, &ldA,
           &B->scalar, &ldB,
           work ? work : &size, work ? &lwork : (__LAPACK_int const[]) {-1},
           &info);
    return work ? info : info ? info : size;
}
