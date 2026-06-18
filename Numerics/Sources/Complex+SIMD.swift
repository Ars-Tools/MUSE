//
//  Complex+SIMD.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
import func simd.dot
import func simd.length
import func simd.length_squared
import func simd.__sincos_stret
import func simd.__sincosf_stret
import func simd.atan2f
import func simd.atan2l
import AltVec
extension ComplexNumber where FloatLiteralType: SIMDScalar & BinaryFloatingPoint {
    @inlinable@inline(__always)@_transparent
	public static func+(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self) + unsafeBitCast(rhs, to: SIMD2<FloatLiteralType>.self), to: Self.self)
	}
    @inlinable@inline(__always)@_transparent
	public static func-(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self) - unsafeBitCast(rhs, to: SIMD2<FloatLiteralType>.self), to: Self.self)
	}
}
extension ComplexNumber where FloatLiteralType == Float32 {
    @inlinable@inline(__always)@_transparent
	public init(r: FloatLiteralType, θ: FloatLiteralType) {
		let e = r * unsafeBitCast(__sincosf_stret(θ), to: SIMD2<FloatLiteralType>.self)
		self.init(real: e.y, imag: e.x)
	}
    @inlinable@inline(__always)@_transparent
    public static func+(lhs: Self, rhs: Self) -> Self {
        unsafeBitCast(complex_add(
            unsafeBitCast(lhs, to: complex64_t.self),
            unsafeBitCast(rhs, to: complex64_t.self)
        ), to: Self.self)
    }
    @inlinable@inline(__always)@_transparent
    public static func-(lhs: Self, rhs: Self) -> Self {
        unsafeBitCast(complex_sub(
            unsafeBitCast(lhs, to: complex64_t.self),
            unsafeBitCast(rhs, to: complex64_t.self)
        ), to: Self.self)
    }
    @inlinable@inline(__always)@_transparent
	public static func*(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(complex_mul(
            unsafeBitCast(lhs, to: complex64_t.self),
            unsafeBitCast(rhs, to: complex64_t.self)
        ), to: Self.self)
	}
    @inlinable@inline(__always)@_transparent
	public static func/(lhs: Self, rhs: Self) -> Self {
        unsafeBitCast(complex_div(
            unsafeBitCast(lhs, to: complex64_t.self),
            unsafeBitCast(rhs, to: complex64_t.self)
        ), to: Self.self)
	}
}
extension ComplexNumber where FloatLiteralType == Float64 {
    @inlinable@inline(__always)@_transparent
	public init(r: FloatLiteralType, θ: FloatLiteralType) {
		let e = r * unsafeBitCast(__sincos_stret(θ), to: SIMD2<FloatLiteralType>.self)
		self.init(real: e.y, imag: e.x)
	}
    @inlinable@inline(__always)@_transparent
    public static func+(lhs: Self, rhs: Self) -> Self {
        unsafeBitCast(complex_add(
            unsafeBitCast(lhs, to: complex128_t.self),
            unsafeBitCast(rhs, to: complex128_t.self)
        ), to: Self.self)
    }
    @inlinable@inline(__always)@_transparent
    public static func-(lhs: Self, rhs: Self) -> Self {
        unsafeBitCast(complex_sub(
            unsafeBitCast(lhs, to: complex128_t.self),
            unsafeBitCast(rhs, to: complex128_t.self)
        ), to: Self.self)
    }
    @inlinable@inline(__always)@_transparent
	public static func*(lhs: Self, rhs: Self) -> Self {
        unsafeBitCast(complex_mul(
            unsafeBitCast(lhs, to: complex128_t.self),
            unsafeBitCast(rhs, to: complex128_t.self)
        ), to: Self.self)
	}
    @inlinable@inline(__always)@_transparent
	public static func/(lhs: Self, rhs: Self) -> Self {
        unsafeBitCast(complex_div(
            unsafeBitCast(lhs, to: complex128_t.self),
            unsafeBitCast(rhs, to: complex128_t.self)
        ), to: Self.self)
	}
}
