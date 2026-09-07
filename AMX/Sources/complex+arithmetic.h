//
//  complex+arithmetic.h
//  MUSE
//
//  Created by Kota on 8/18/26.
//
#include"module.h"
#include"complex.h"
// MARK: new
__attribute__((always_inline, overloadable)) inline static
complex64_t const complex_new(float32_t const r) {
    return (complex64_t const) {
        .scalar = r
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const complex_new(float64_t const r) {
    return (complex128_t const) {
        .scalar = r
    };
}
// MARK: neg
__attribute__((always_inline, overloadable)) inline static
complex64_t const neg(complex64_t const x) {
    return (complex64_t const) {
        .vector = -x.vector
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const neg(complex128_t const x) {
    return (complex128_t const) {
        .vector = -x.vector
    };
}
// MARK: add
__attribute__((always_inline, overloadable)) inline static
complex64_t const add(complex64_t const x, complex64_t const y) {
    return (complex64_t const) {
        .vector = x.vector + y.vector
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const add(complex128_t const x, complex128_t const y) {
    return (complex128_t const) {
        .vector = x.vector + y.vector
    };
}
__attribute__((always_inline, overloadable)) inline static
complex64_t const add(complex64_t const x, float32_t const y) {
    return (complex64_t const) {
        .scalar = x.scalar + y
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const add(complex128_t const x, float64_t const y) {
    return (complex128_t const) {
        .scalar = x.scalar + y
    };
}
__attribute__((always_inline, overloadable)) inline static
complex64_t const add(float32_t const x, complex64_t const y) {
    return (complex64_t const) {
        .vector = x + y.vector
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const add(float64_t const x, complex128_t const y) {
    return (complex128_t const) {
        .vector = x + y.vector
    };
}
// MARK: sub
__attribute__((always_inline, overloadable)) inline static
complex64_t const sub(complex64_t const x, complex64_t const y) {
    return (complex64_t const) {
        .vector = x.vector - y.vector
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const sub(complex128_t const x, complex128_t const y) {
    return (complex128_t const) {
        .vector = x.vector - y.vector
    };
}
__attribute__((always_inline, overloadable)) inline static
complex64_t const sub(complex64_t const x, float32_t const y) {
    return (complex64_t const) {
        .scalar = x.scalar - y
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const sub(complex128_t const x, float64_t const y) {
    return (complex128_t const) {
        .scalar = x.scalar - y
    };
}
__attribute__((always_inline, overloadable)) inline static
complex64_t const sub(float32_t const x, complex64_t const y) {
    return (complex64_t const) {
        .vector = x - y.vector
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const sub(float64_t const x, complex128_t const y) {
    return (complex128_t const) {
        .vector = x - y.vector
    };
}
// MARK: mul
__attribute__((always_inline, overloadable)) inline static
complex64_t const mul(complex64_t const x, complex64_t const y) {
    return (complex64_t const) {
        .scalar = x.scalar * y.scalar
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const mul(complex128_t const x, complex128_t const y) {
    return (complex128_t const) {
        .scalar = x.scalar * y.scalar
    };
}
__attribute__((always_inline, overloadable)) inline static
complex64_t const mul(complex64_t const x, float32_t const y) {
    return (complex64_t const) {
        .scalar = x.scalar * y
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const mul(complex128_t const x, float64_t const y) {
    return (complex128_t const) {
        .scalar = x.scalar * y
    };
}
__attribute__((always_inline, overloadable)) inline static
complex64_t const mul(float32_t const x, complex64_t const y) {
    return (complex64_t const) {
        .scalar = x * y.scalar
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const mul(float64_t const x, complex128_t const y) {
    return (complex128_t const) {
        .scalar = x * y.scalar
    };
}
// MARK: div
__attribute__((always_inline, overloadable)) inline static
complex64_t const div(complex64_t const x, complex64_t const y) {
    return (complex64_t const) {
        .scalar = x.scalar / y.scalar
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const div(complex128_t const x, complex128_t const y) {
    return (complex128_t const) {
        .scalar = x.scalar / y.scalar
    };
}
__attribute__((always_inline, overloadable)) inline static
complex64_t const div(complex64_t const x, float32_t const y) {
    return (complex64_t const) {
        .scalar = x.scalar / y
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const div(complex128_t const x, float64_t const y) {
    return (complex128_t const) {
        .scalar = x.scalar / y
    };
}
__attribute__((always_inline, overloadable)) inline static
complex64_t const div(float32_t const x, complex64_t const y) {
    return (complex64_t const) {
        .scalar = x / y.scalar
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const div(float64_t const x, complex128_t const y) {
    return (complex128_t const) {
        .scalar = x / y.scalar
    };
}
// MARK: mag
__attribute__((always_inline, overloadable)) inline static
float32_t const length(complex64_t const x) {
    return simd_length(x.vector);
}
__attribute__((always_inline, overloadable)) inline static
float64_t const length(complex128_t const x) {
    return simd_length(x.vector);
}
// MARK: mag2
__attribute__((always_inline, overloadable)) inline static
float32_t const length_squared(complex64_t const x) {
    return simd_length_squared(x.vector);
}
__attribute__((always_inline, overloadable)) inline static
float64_t const length_squared(complex128_t const x) {
    return simd_length_squared(x.vector);
}
// MARK: arg
__attribute__((always_inline, overloadable)) inline static
float32_t const arg(complex64_t const x) {
    return cargf(x.scalar);
}
__attribute__((always_inline, overloadable)) inline static
float64_t const arg(complex128_t const x) {
    return carg(x.scalar);
}
// MARK: rad
__attribute__((always_inline, overloadable)) inline static
complex64_t const complex_new_rt(float32_t const r, float32_t const t) {
    return (complex64_t const) {
        .scalar = r * cexpf(t * I)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const complex_new_rt(float64_t const r, float64_t const t) {
    return (complex128_t const) {
        .scalar = r * cexp(t * I)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex64_t const complex_new_rp(float32_t const r, float32_t const p) {
    register struct __float2 const e = __sincospif_stret(2 * p);
    return (complex64_t const) {
        .vector = r * simd_make_float2(e.__cosval, e.__sinval)
    };
}
__attribute__((always_inline, overloadable)) inline static
complex128_t const complex_new_rp(float64_t const r, float64_t const p) {
    register struct __double2 const e = __sincospi_stret(2 * p);
    return (complex128_t const) {
        .vector = r * simd_make_double2(e.__cosval, e.__sinval)
    };
}
