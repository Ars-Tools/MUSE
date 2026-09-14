//
//  lapack+ls.h
//  MUSE
//
//  Created by Kota on 6/18/26.
//
#include"module.h"
// MARK: gels
__attribute__((always_inline, __overloadable__)) inline static
__LAPACK_int const gels(__LAPACK_int const m, __LAPACK_int const n, __LAPACK_int const nrhs,
                        float32_t      *__nullable const A, __LAPACK_int const ldA, op_t const opA,
                        float32_t      *__nullable const B, __LAPACK_int const ldB,
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
__attribute__((always_inline, __overloadable__)) inline static
__LAPACK_int const gels(__LAPACK_int const m, __LAPACK_int const n, __LAPACK_int const nrhs,
                        float64_t      *__nullable const A, __LAPACK_int const ldA, op_t const opA,
                        float64_t      *__nullable const B, __LAPACK_int const ldB,
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
                        complex64_t      *__nullable const A, __LAPACK_int const ldA, op_t const opA,
                        complex64_t      *__nullable const B, __LAPACK_int const ldB,
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
__attribute__((always_inline, __overloadable__)) inline static
__LAPACK_int const gels(__LAPACK_int const m, __LAPACK_int const n, __LAPACK_int const nrhs,
                        complex128_t      *__nullable const A, __LAPACK_int const ldA, op_t const opA,
                        complex128_t      *__nullable const B, __LAPACK_int const ldB,
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
// MARK: gglse
__attribute__((always_inline, __overloadable__)) inline static
__LAPACK_int const gglse(__LAPACK_int const m, __LAPACK_int const n, __LAPACK_int const p,
                         float      *_Nullable const A, __LAPACK_int const ldA,
                         float      *_Nullable const B, __LAPACK_int const ldB,
                         float      *_Nullable const c,
                         float      *_Nullable const d,
                         float      *_Nullable const x,
                         float      *_Nullable const work, __LAPACK_int const lwork) {
    __LAPACK_int info;
    float size;
    sgglse_(&m, &n, &p,
            A, &ldA,
            B, &ldB,
            c, d,
            x,
            work ? work : &size, work ? &lwork : (__LAPACK_int const[]) {-1},
            &info);
    return work ? info : info ? info : size;
}
__attribute__((always_inline, __overloadable__)) inline static
__LAPACK_int const gglse(__LAPACK_int const m, __LAPACK_int const n, __LAPACK_int const p,
                         double      *_Nullable const A, __LAPACK_int const ldA,
                         double      *_Nullable const B, __LAPACK_int const ldB,
                         double      *_Nullable const c,
                         double      *_Nullable const d,
                         double      *_Nullable const x,
                         double      *_Nullable const work, __LAPACK_int const lwork) {
    __LAPACK_int info;
    double size;
    dgglse_(&m, &n, &p,
            A, &ldA,
            B, &ldB,
            c, d,
            x,
            work ? work : &size, work ? &lwork : (__LAPACK_int const[]) {-1},
            &info);
    return work ? info : info ? info : size;
}
__attribute__((always_inline, __overloadable__)) inline static
__LAPACK_int const gglse(__LAPACK_int const m, __LAPACK_int const n, __LAPACK_int const p,
                         complex64_t      *_Nullable const A, __LAPACK_int const ldA,
                         complex64_t      *_Nullable const B, __LAPACK_int const ldB,
                         complex64_t      *_Nullable const c,
                         complex64_t      *_Nullable const d,
                         complex64_t      *_Nullable const x,
                         complex64_t      *_Nullable const work, __LAPACK_int const lwork) {
    __LAPACK_int info;
    __complex float size;
    cgglse_(&m, &n, &p,
            &A->lapack, &ldA,
            &B->lapack, &ldB,
            &c->lapack, &d->lapack,
            x,
            work ? work : &size, work ? &lwork : (__LAPACK_int const[]) {-1},
            &info);
    return work ? info : info ? info : size;
}
__attribute__((always_inline, __overloadable__)) inline static
__LAPACK_int const gglse(__LAPACK_int const m, __LAPACK_int const n, __LAPACK_int const p,
                         complex128_t      *_Nullable const A, __LAPACK_int const ldA,
                         complex128_t      *_Nullable const B, __LAPACK_int const ldB,
                         complex128_t      *_Nullable const c,
                         complex128_t      *_Nullable const d,
                         complex128_t      *_Nullable const x,
                         complex128_t      *_Nullable const work, __LAPACK_int const lwork) {
    __LAPACK_int info;
    __complex double size;
    zgglse_(&m, &n, &p,
            &A->lapack, &ldA,
            &B->lapack, &ldB,
            &c->lapack, &d->lapack,
            x,
            work ? work : &size, work ? &lwork : (__LAPACK_int const[]) {-1},
            &info);
    return work ? info : info ? info : size;
}
