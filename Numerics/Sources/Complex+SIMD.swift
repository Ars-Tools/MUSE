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
extension ComplexNumber where FloatLiteralType: SIMDScalar & BinaryFloatingPoint {
	@inlinable @inline(__always)
	public static func+(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self) + unsafeBitCast(rhs, to: SIMD2<FloatLiteralType>.self), to: Self.self)
	}
	@inlinable @inline(__always)
	public static func-(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self) - unsafeBitCast(rhs, to: SIMD2<FloatLiteralType>.self), to: Self.self)
	}
}
extension ComplexNumber where FloatLiteralType == Float32 {
	@inlinable @inline(__always)
	public init(r: FloatLiteralType, θ: FloatLiteralType) {
		let θ = r * unsafeBitCast(__sincosf_stret(θ), to: SIMD2<FloatLiteralType>.self)
		self.init(real: θ.y, imag: θ.x)
	}
	@inlinable @inline(__always)
	public static func*(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(SIMD2(
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(rhs.real, -rhs.imag)),
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(rhs.imag,  rhs.real))
		), to: Self.self)
	}
	@inlinable @inline(__always)
	public static func/(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(SIMD2(
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2( rhs.real, rhs.imag)),
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(-rhs.imag, rhs.real))
		) / length_squared(unsafeBitCast(rhs, to: SIMD2<FloatLiteralType>.self)), to: Self.self)
	}
	@inlinable @inline(__always)
	public var magnitude: FloatLiteralType {
		length(unsafeBitCast(self, to: SIMD2<FloatLiteralType>.self))
	}
}
extension ComplexNumber where FloatLiteralType == Float64 {
	@inlinable @inline(__always)
	public init(r: FloatLiteralType, θ: FloatLiteralType) {
		let θ = r * unsafeBitCast(__sincos_stret(θ), to: SIMD2<FloatLiteralType>.self)
		self.init(real: θ.y, imag: θ.x)
	}
	@inlinable @inline(__always)
	public static func*(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(SIMD2(
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(rhs.real, -rhs.imag)),
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(rhs.imag,  rhs.real))
		), to: Self.self)
	}
	@inlinable @inline(__always)
	public static func/(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(SIMD2(
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2( rhs.real, rhs.imag)),
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(-rhs.imag, rhs.real))
		) / rhs.magnitude, to: Self.self)
	}
	@inlinable @inline(__always)
	public var magnitude: FloatLiteralType {
		length(unsafeBitCast(self, to: SIMD2<FloatLiteralType>.self))
	}
}
