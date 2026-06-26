//
//  lapack+misc.h
//  MUSE
//
//  Created by Kota on 6/26/26.
//
#include"module.h"
void lacgv(__LAPACK_int const length,
           complex64_t*__nonnull const x, __LAPACK_int const incx) {
    clacgv_(&length, x, &incx);
}
void lacgv(__LAPACK_int const length,
           complex128_t*__nonnull const x, __LAPACK_int const incx) {
    zlacgv_(&length, x, &incx);
}
