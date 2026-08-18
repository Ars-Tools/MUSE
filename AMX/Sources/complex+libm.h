//
//  complex+libm.h
//  MUSE
//
//  Created by Kota on 8/18/26.
//
#include"complex.h"
// MARK: conj
__attribute__((always_inline, overloadable)) inline static
complex64_t const libcconj(complex64_t const x) {
    return (complex64_t const) {
        .scalar = conjf(x.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libcconj(complex128_t const x) {
    return (complex128_t const) {
        .scalar = conj(x.scalar)
    };
}
// MARK: proj
__attribute__((always_inline, overloadable)) inline static
complex64_t const libcproj(complex64_t const x) {
    return (complex64_t const) {
        .scalar = cproj(x.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libcproj(complex128_t const x) {
    return (complex128_t const) {
        .scalar = cproj(x.scalar)
    };
}
// MARK: exp
__attribute__((always_inline, overloadable)) inline static
complex64_t const libcexp(complex64_t const x) {
    return (complex64_t const) {
        .scalar = cexpf(x.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libcexp(complex128_t const x) {
    return (complex128_t const) {
        .scalar = cexp(x.scalar)
    };
}
// MARK: log
__attribute__((always_inline, overloadable)) inline static
complex64_t const libclog(complex64_t const x) {
    return (complex64_t const) {
        .scalar = clogf(x.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libclog(complex128_t const x) {
    return (complex128_t const) {
        .scalar = clog(x.scalar)
    };
}
// MARK: cos
__attribute__((always_inline, overloadable)) inline static
complex64_t const libccos(complex64_t const x) {
    return (complex64_t const) {
        .scalar = ccosf(x.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libccos(complex128_t const x) {
    return (complex128_t const) {
        .scalar = ccos(x.scalar)
    };
}
// MARK: sin
__attribute__((always_inline, overloadable)) inline static
complex64_t const libcsin(complex64_t const x) {
    return (complex64_t const) {
        .scalar = csinf(x.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libcsin(complex128_t const x) {
    return (complex128_t const) {
        .scalar = csin(x.scalar)
    };
}
// MARK: tan
__attribute__((always_inline, overloadable)) inline static
complex64_t const libctan(complex64_t const x) {
    return (complex64_t const) {
        .scalar = ctanf(x.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libctan(complex128_t const x) {
    return (complex128_t const) {
        .scalar = ctan(x.scalar)
    };
}
// MARK: cosh
__attribute__((always_inline, overloadable)) inline static
complex64_t const libccosh(complex64_t const x) {
    return (complex64_t const) {
        .scalar = ccoshf(x.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libccosh(complex128_t const x) {
    return (complex128_t const) {
        .scalar = ccosh(x.scalar)
    };
}
// MARK: sinh
__attribute__((always_inline, overloadable)) inline static
complex64_t const libcsinh(complex64_t const x) {
    return (complex64_t const) {
        .scalar = csinhf(x.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libcsinh(complex128_t const x) {
    return (complex128_t const) {
        .scalar = csinh(x.scalar)
    };
}
// MARK: tan
__attribute__((always_inline, overloadable)) inline static
complex64_t const libctanh(complex64_t const x) {
    return (complex64_t const) {
        .scalar = ctanhf(x.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libctanh(complex128_t const x) {
    return (complex128_t const) {
        .scalar = ctanh(x.scalar)
    };
}
// MARK: acos
__attribute__((always_inline, overloadable)) inline static
complex64_t const libcacos(complex64_t const x) {
    return (complex64_t const) {
        .scalar = cacosf(x.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libcacos(complex128_t const x) {
    return (complex128_t const) {
        .scalar = cacos(x.scalar)
    };
}
// MARK: sin
__attribute__((always_inline, overloadable)) inline static
complex64_t const libcasin(complex64_t const x) {
    return (complex64_t const) {
        .scalar = casinf(x.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libcasin(complex128_t const x) {
    return (complex128_t const) {
        .scalar = casin(x.scalar)
    };
}
// MARK: tan
__attribute__((always_inline, overloadable)) inline static
complex64_t const libcatan(complex64_t const x) {
    return (complex64_t const) {
        .scalar = catanf(x.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libcatan(complex128_t const x) {
    return (complex128_t const) {
        .scalar = catan(x.scalar)
    };
}
// MARK: cosh
__attribute__((always_inline, overloadable)) inline static
complex64_t const libcacosh(complex64_t const x) {
    return (complex64_t const) {
        .scalar = cacoshf(x.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libcacosh(complex128_t const x) {
    return (complex128_t const) {
        .scalar = cacosh(x.scalar)
    };
}
// MARK: sinh
__attribute__((always_inline, overloadable)) inline static
complex64_t const libcasinh(complex64_t const x) {
    return (complex64_t const) {
        .scalar = casinhf(x.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libcasinh(complex128_t const x) {
    return (complex128_t const) {
        .scalar = casinh(x.scalar)
    };
}
// MARK: tan
__attribute__((always_inline, overloadable)) inline static
complex64_t const libcatanh(complex64_t const x) {
    return (complex64_t const) {
        .scalar = catanhf(x.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libcatanh(complex128_t const x) {
    return (complex128_t const) {
        .scalar = catanh(x.scalar)
    };
}
// MARK: sqrt
__attribute__((always_inline, overloadable)) inline static
complex64_t const libcsqrt(complex64_t const x) {
    return (complex64_t const) {
        .scalar = csqrtf(x.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libcsqrt(complex128_t const x) {
    return (complex128_t const) {
        .scalar = csqrt(x.scalar)
    };
}
// MARK: pow
__attribute__((always_inline, overloadable)) inline static
complex64_t const libcpow(complex64_t const x,
                              complex64_t const y) {
    return (complex64_t const) {
        .scalar = cpowf(x.scalar, y.scalar)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const libcpow(complex128_t const x,
                               complex128_t const y) {
    return (complex128_t const) {
        .scalar = cpow(x.scalar, y.scalar)
    };
}
