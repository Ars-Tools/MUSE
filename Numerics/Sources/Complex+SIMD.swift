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
	public static func*(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(SIMD2(
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(rhs.real, -rhs.imag)),
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(rhs.imag,  rhs.real))
		), to: Self.self)
	}
    @inlinable@inline(__always)@_transparent
	public static func/(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(SIMD2(
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2( rhs.real, rhs.imag)),
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(-rhs.imag, rhs.real))
		) / length_squared(unsafeBitCast(rhs, to: SIMD2<FloatLiteralType>.self)), to: Self.self)
	}
}
extension ComplexNumber where FloatLiteralType == Float64 {
    @inlinable@inline(__always)@_transparent
	public init(r: FloatLiteralType, θ: FloatLiteralType) {
		let e = r * unsafeBitCast(__sincos_stret(θ), to: SIMD2<FloatLiteralType>.self)
		self.init(real: e.y, imag: e.x)
	}
    @inlinable@inline(__always)@_transparent
	public static func*(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(SIMD2(
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(rhs.real, -rhs.imag)),
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(rhs.imag,  rhs.real))
		), to: Self.self)
	}
    @inlinable@inline(__always)@_transparent
	public static func/(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(SIMD2(
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2( rhs.real, rhs.imag)),
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(-rhs.imag, rhs.real))
		) / length_squared(unsafeBitCast(rhs, to: SIMD2<FloatLiteralType>.self)), to: Self.self)
	}
}
