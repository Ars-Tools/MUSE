//
//  lapack+svd.h
//  MUSE
//
//  Created by Kota on 9/9/26.
//
#include"module.h"
__attribute__((__visibility__("hidden"))) static
__LAPACK_int const query = -1;
__attribute__((__visibility__("hidden"))) static
__LAPACK_int const _[] = {0, 1, 2};
// MARK: gesvd
//__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
typedef CF_ENUM(char) {
    svd_job_t_A = 'A',
    svd_job_t_S = 'S',
    svd_job_t_O = 'O',
    svd_job_t_N = 'N',
} svd_job_t;
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const gesvd(__LAPACK_int const m, __LAPACK_int const n,
                         float32_t      *__nullable A, __LAPACK_int const ldA,
                         float32_t      *__nullable s,
                         float32_t      *__nullable U, __LAPACK_int const ldU,
                         float32_t      *__nullable V, __LAPACK_int const ldV,
                         float32_t      *__nullable work, __LAPACK_int const lwork) {
    static char const jobuv[] = "SN";
    __LAPACK_int info;
    float32_t size;
    sgesvd_(jobuv + !U, jobuv + !V,
            &m, &n,
            A, &ldA,
            s,
            U, &ldU,
            V, &ldV,
            work ? work : &size, work ? &lwork : &query,
            &info);
    return work ? info : info ? info : size;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const gesvd(__LAPACK_int const m, __LAPACK_int const n,
                         float64_t      *__nullable A, __LAPACK_int const ldA,
                         float64_t      *__nullable s,
                         float64_t      *__nullable U, __LAPACK_int const ldU,
                         float64_t      *__nullable V, __LAPACK_int const ldV,
                         float64_t      *__nullable work, __LAPACK_int const lwork) {
    static char const jobuv[] = "SN";
    __LAPACK_int info;
    float64_t size;
    dgesvd_(jobuv + !U, jobuv + !V,
            &m, &n,
            A, &ldA,
            s,
            U, &ldU,
            V, &ldV,
            work ? work : &size, work ? &lwork : &query,
            &info);
    return work ? info : info ? info : size;
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const gesvd(__LAPACK_int const m, __LAPACK_int const n,
                         complex64_t      *__nullable A, __LAPACK_int const ldA,
                         float32_t      *__nullable s,
                         complex64_t      *__nullable U, __LAPACK_int const ldU,
                         complex64_t      *__nullable V, __LAPACK_int const ldV,
                         complex64_t      *__nullable work, __LAPACK_int const lwork,
                         float32_t      * __nullable const rwork /* 5 * min(m, n) */) {
    static char const jobuv[] = "SN";
    __LAPACK_int info;
    __complex float size;
    cgesvd_(jobuv + !U, jobuv + !V,
            &m, &n,
            A, &ldA,
            s,
            U, &ldU,
            V, &ldV,
            work ? work : &size, work ? &lwork : &query,
            rwork ? rwork : alloca(sizeof(float32_t const) * 5 * MIN(m, n)),
            &info);
    return work ? info : info ? info : __real(size);
}
__attribute__((always_inline, overloadable, warn_unused_result)) inline static
__LAPACK_int const gesvd(__LAPACK_int const m, __LAPACK_int const n,
                         complex128_t      *__nullable A, __LAPACK_int const ldA,
                         float64_t      *__nullable s,
                         complex128_t      *__nullable U, __LAPACK_int const ldU,
                         complex128_t      *__nullable V, __LAPACK_int const ldV,
                         complex128_t      *__nullable work, __LAPACK_int const lwork,
                         float64_t      * __nullable const rwork /* 5 * min(m, n) */) {
    static char const jobuv[] = "SN";
    __LAPACK_int info;
    __complex double size;
    zgesvd_(jobuv + !U, jobuv + !V,
            &m, &n,
            A, &ldA,
            s,
            U, &ldU,
            V, &ldV,
            work ? work : &size, work ? &lwork : &query,
            rwork ? rwork : alloca(sizeof(float64_t const) * 5 * MIN(m, n)),
            &info);
    return work ? info : info ? info : __real(size);
}
// MARK: gejsv, not implemented yet
////__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
//typedef CF_ENUM(char) {
//    jsv_joba_C = 'C',
//    jsv_joba_E = 'E',
//    jsv_joba_F = 'F',
//    jsv_joba_G = 'G',
//    jsv_joba_A = 'A',
//    jsv_joba_R = 'R',
//} jsv_joba_t;
////__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
//typedef CF_ENUM(char) {
//    jsv_jobu_U = 'U',
//    jsv_jobu_F = 'F',
//    jsv_jobu_W = 'W',
//    jsv_jobu_N = 'N',
//} jsv_jobu_t;
////__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
//typedef CF_ENUM(char) {
//    jsv_jobv_V = 'V',
//    jsv_jobv_J = 'J',
//    jsv_jobv_W = 'W',
//    jsv_jobv_N = 'N',
//} jsv_jobv_t;
////__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
//typedef CF_ENUM(char) {
//    jsv_jobr_N = 'N',
//    jsv_jobr_R = 'R',
//} jsv_jobr_t;
////__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
//typedef CF_ENUM(char) {
//    jsv_jobt_N = 'N',
//    jsv_jobt_T = 'T',
//} jsv_jobt_t;
////__attribute__((__swift_attr__("BitwiseCopyable"), __swift_attr__("Sendable")))
//typedef CF_ENUM(char) {
//    jsv_jobp_N = 'N',
//    jsv_jobp_P = 'P',
//} jsv_jobp_t;
//__attribute__((always_inline, __overloadable__, warn_unused_result)) inline static
//__LAPACK_int const gejsv(__LAPACK_int const m, __LAPACK_int const n,
//                         float64_t      *__nullable const A, __LAPACK_int const ldA, jsv_joba_t const joba,
//                         float64_t      *__nullable const sva,
//                         float64_t      *__nullable const U, __LAPACK_int const ldU, jsv_jobu_t const jobu,
//                         float64_t      *__nullable const V, __LAPACK_int const ldv, jsv_jobv_t const jobv,
//                         float64_t      *__nullable const work, __LAPACK_int const lwork,
//                         __LAPACK_int   *__nullable const iwork) {
//    __LAPACK_int info;
//    dgejsv_(&joba,
//            &jobu,
//            &jobv,
//            <#const char * _Nonnull jobr#>,
//            <#const char * _Nonnull jobt#>,
//            <#const char * _Nonnull jobp#>,
//            &m, &n,
//            A, &ldA,
//            sva,
//            U, &ldU,
//            V, &ldV,
//            work ? work : &size, work ? &lwork : (__LAPACK_int const[]) {-1},
//            iwork ? iwork : alloca(sizeof(__LAPACK_int const) * MAX(3, m + 3 * n)), &info);
//    return work ? info : info ? info : size;
//    
//}
