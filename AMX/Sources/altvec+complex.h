//
//  complex.h
//  MUSE
//
//  Created by Kota on 6/19/26.
//
#include"module.h"
// MARK: new
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_new(float32_t const r) {
    return (complex64_t const) {
        .r = r,
        .i = 0
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_new(float64_t const r) {
    return (complex128_t const) {
        .r = r,
        .i = 0
    };
}
// MARK: neg
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_neg(complex64_t const x) {
    return (complex64_t const) {
        .vector = -x.vector
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_neg(complex128_t const x) {
    return (complex128_t const) {
        .vector = -x.vector
    };
}
// MARK: add
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_add(complex64_t const x, complex64_t const y) {
    return (complex64_t const) {
        .vector = x.vector + y.vector
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_add(complex128_t const x, complex128_t const y) {
    return (complex128_t const) {
        .vector = x.vector + y.vector
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_add(complex64_t const x, float32_t const y) {
    return (complex64_t const) {
        .vector = x.vector + y
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_add(complex128_t const x, float64_t const y) {
    return (complex128_t const) {
        .vector = x.vector + y
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_add(float32_t const x, complex64_t const y) {
    return (complex64_t const) {
        .vector = x + y.vector
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_add(float64_t const x, complex128_t const y) {
    return (complex128_t const) {
        .vector = x + y.vector
    };
}
// MARK: sub
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_sub(complex64_t const x, complex64_t const y) {
    return (complex64_t const) {
        .vector = x.vector - y.vector
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_sub(complex128_t const x, complex128_t const y) {
    return (complex128_t const) {
        .vector = x.vector - y.vector
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_sub(complex64_t const x, float32_t const y) {
    return (complex64_t const) {
        .vector = x.vector - y
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_sub(complex128_t const x, float64_t const y) {
    return (complex128_t const) {
        .vector = x.vector - y
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_sub(float32_t const x, complex64_t const y) {
    return (complex64_t const) {
        .vector = x - y.vector
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_sub(float64_t const x, complex128_t const y) {
    return (complex128_t const) {
        .vector = x - y.vector
    };
}
// MARK: mul
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_mul(complex64_t const x, complex64_t const y) {
    return (complex64_t const) {
        .scalar = x.scalar * y.scalar
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_mul(complex128_t const x, complex128_t const y) {
    return (complex128_t const) {
        .scalar = x.scalar * y.scalar
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_mul(complex64_t const x, float32_t const y) {
    return (complex64_t const) {
        .scalar = x.scalar * y
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_mul(complex128_t const x, float64_t const y) {
    return (complex128_t const) {
        .scalar = x.scalar * y
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_mul(float32_t const x, complex64_t const y) {
    return (complex64_t const) {
        .scalar = x * y.scalar
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_mul(float64_t const x, complex128_t const y) {
    return (complex128_t const) {
        .scalar = x * y.scalar
    };
}
// MARK: div
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_div(complex64_t const x, complex64_t const y) {
    return (complex64_t const) {
        .scalar = x.scalar / y.scalar
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_div(complex128_t const x, complex128_t const y) {
    return (complex128_t const) {
        .scalar = x.scalar / y.scalar
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_div(complex64_t const x, float32_t const y) {
    return (complex64_t const) {
        .scalar = x.scalar / y
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_div(complex128_t const x, float64_t const y) {
    return (complex128_t const) {
        .scalar = x.scalar / y
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_div(float32_t const x, complex64_t const y) {
    return (complex64_t const) {
        .scalar = x / y.scalar
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_div(float64_t const x, complex128_t const y) {
    return (complex128_t const) {
        .scalar = x / y.scalar
    };
}
// MARK: mag
__attribute__((always_inline, __overloadable__)) inline static
float32_t const length(complex64_t const x) {
    return simd_length(x.vector);
}
__attribute__((always_inline, __overloadable__)) inline static
float64_t const length(complex128_t const x) {
    return simd_length(x.vector);
}
// MARK: arg
__attribute__((always_inline, __overloadable__)) inline static
float32_t const complex_arg(complex64_t const x) {
    return cargf(x.scalar);
}
__attribute__((always_inline, __overloadable__)) inline static
float64_t const complex_arg(complex128_t const x) {
    return carg(x.scalar);
}
// MARK: rad
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_new_rt(float32_t const r, float32_t const t) {
    return (complex64_t const) {
        .scalar = r * cexpf(t)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_new_rt(float64_t const r, float64_t const t) {
    return (complex128_t const) {
        .scalar = r * cexp(t)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_new_rp(float32_t const r, float32_t const p) {
    register struct __float2 const e = __sincospif_stret(p);
    return (complex64_t const) {
        .vector = r * simd_make_float2(e.__cosval, e.__sinval)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_new_rp(float64_t const r, float64_t const p) {
    register struct __double2 const e = __sincospi_stret(p);
    return (complex128_t const) {
        .vector = r * simd_make_double2(e.__cosval, e.__sinval)
    };
}
// MARK: conj
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_conj(complex64_t const x) {
    return (complex64_t const) {
        .scalar = conjf(x.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_conj(complex128_t const x) {
    return (complex128_t const) {
        .scalar = conj(x.scalar)
    };
}
// MARK: proj
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_proj(complex64_t const x) {
    return (complex64_t const) {
        .scalar = cproj(x.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_proj(complex128_t const x) {
    return (complex128_t const) {
        .scalar = cproj(x.scalar)
    };
}
// MARK: exp
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_exp(complex64_t const x) {
    return (complex64_t const) {
        .scalar = cexpf(x.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_exp(complex128_t const x) {
    return (complex128_t const) {
        .scalar = cexp(x.scalar)
    };
}
// MARK: log
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_log(complex64_t const x) {
    return (complex64_t const) {
        .scalar = clogf(x.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_log(complex128_t const x) {
    return (complex128_t const) {
        .scalar = clog(x.scalar)
    };
}
// MARK: cos
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_cos(complex64_t const x) {
    return (complex64_t const) {
        .scalar = ccosf(x.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_cos(complex128_t const x) {
    return (complex128_t const) {
        .scalar = ccos(x.scalar)
    };
}
// MARK: sin
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_sin(complex64_t const x) {
    return (complex64_t const) {
        .scalar = csinf(x.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_sin(complex128_t const x) {
    return (complex128_t const) {
        .scalar = csin(x.scalar)
    };
}
// MARK: tan
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_tan(complex64_t const x) {
    return (complex64_t const) {
        .scalar = ctanf(x.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_tan(complex128_t const x) {
    return (complex128_t const) {
        .scalar = ctan(x.scalar)
    };
}
// MARK: cosh
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_cosh(complex64_t const x) {
    return (complex64_t const) {
        .scalar = ccoshf(x.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_cosh(complex128_t const x) {
    return (complex128_t const) {
        .scalar = ccosh(x.scalar)
    };
}
// MARK: sinh
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_sinh(complex64_t const x) {
    return (complex64_t const) {
        .scalar = csinhf(x.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_sinh(complex128_t const x) {
    return (complex128_t const) {
        .scalar = csinh(x.scalar)
    };
}
// MARK: tan
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_tanh(complex64_t const x) {
    return (complex64_t const) {
        .scalar = ctanhf(x.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_tanh(complex128_t const x) {
    return (complex128_t const) {
        .scalar = ctanh(x.scalar)
    };
}
// MARK: acos
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_acos(complex64_t const x) {
    return (complex64_t const) {
        .scalar = cacosf(x.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_acos(complex128_t const x) {
    return (complex128_t const) {
        .scalar = cacos(x.scalar)
    };
}
// MARK: sin
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_asin(complex64_t const x) {
    return (complex64_t const) {
        .scalar = casinf(x.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_asin(complex128_t const x) {
    return (complex128_t const) {
        .scalar = casin(x.scalar)
    };
}
// MARK: tan
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_atan(complex64_t const x) {
    return (complex64_t const) {
        .scalar = catanf(x.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_atan(complex128_t const x) {
    return (complex128_t const) {
        .scalar = catan(x.scalar)
    };
}
// MARK: cosh
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_acosh(complex64_t const x) {
    return (complex64_t const) {
        .scalar = cacoshf(x.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_acosh(complex128_t const x) {
    return (complex128_t const) {
        .scalar = cacosh(x.scalar)
    };
}
// MARK: sinh
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_asinh(complex64_t const x) {
    return (complex64_t const) {
        .scalar = casinhf(x.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_asinh(complex128_t const x) {
    return (complex128_t const) {
        .scalar = casinh(x.scalar)
    };
}
// MARK: tan
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_atanh(complex64_t const x) {
    return (complex64_t const) {
        .scalar = catanhf(x.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_atanh(complex128_t const x) {
    return (complex128_t const) {
        .scalar = catanh(x.scalar)
    };
}
// MARK: sqrt
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_sqrt(complex64_t const x) {
    return (complex64_t const) {
        .scalar = csqrtf(x.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_sqrt(complex128_t const x) {
    return (complex128_t const) {
        .scalar = csqrt(x.scalar)
    };
}
// MARK: pow
__attribute__((always_inline, __overloadable__)) inline static
complex64_t const complex_pow(complex64_t const x,
                              complex64_t const y) {
    return (complex64_t const) {
        .scalar = cpowf(x.scalar, y.scalar)
    };
}
__attribute__((always_inline, __overloadable__)) inline static
complex128_t const complex_pow(complex128_t const x,
                               complex128_t const y) {
    return (complex128_t const) {
        .scalar = cpow(x.scalar, y.scalar)
    };
}
