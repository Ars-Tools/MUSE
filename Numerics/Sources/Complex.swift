//
//  Complex.swift
//  MUSE
//
//  Created by Kota on 5/15/R7.
//
import simd
public protocol ComplexNumber<FloatLiteralType>: Numeric & Comparable & Hashable & CustomStringConvertible & Sendable & Copyable where IntegerLiteralType == FloatLiteralType.IntegerLiteralType, Magnitude == FloatLiteralType {
	associatedtype FloatLiteralType: SignedNumeric & Comparable & Hashable
	var real: FloatLiteralType { get }
	var imag: FloatLiteralType { get }
	init(real: FloatLiteralType, imag: FloatLiteralType)
	static var i: Self { get }
}
extension ComplexNumber {
	public static var i: Self {
		.init(real: 0, imag: 1)
	}
}
extension ComplexNumber {
	@inline(__always)
	@inlinable
	public var conjugate: Self {
		.init(real: real, imag: -imag)
	}
}
extension ComplexNumber {
	@inline(__always)
	@inlinable
	public init?<T>(exactly source: T) where T : BinaryInteger {
		guard let real = FloatLiteralType(exactly: source) else { return nil }
		self.init(real: real, imag: 0)
	}
	@inline(__always)
	@inlinable
	public init(integerLiteral value: FloatLiteralType.IntegerLiteralType) {
		self.init(real: .init(integerLiteral: value), imag: 0)
	}
	@inline(__always)
	@inlinable
	public init(floatLiteral value: FloatLiteralType) {
		self.init(real: value, imag: 0)
	}
	@inline(__always)
	@inlinable
	public init(_ value: some ComplexNumber<FloatLiteralType>) {
		self.init(real: value.real, imag: value.imag)
	}
}
extension ComplexNumber where FloatLiteralType: BinaryInteger {
	public init(_ other: some ComplexNumber<some BinaryFloatingPoint>) {
		self.init(real: .init(other.real), imag: .init(other.imag))
	}
}
extension ComplexNumber where FloatLiteralType: BinaryFloatingPoint {
	public init(_ other: some ComplexNumber<some BinaryInteger>) {
		self.init(real: .init(other.real), imag: .init(other.imag))
	}
}
extension ComplexNumber {
	public static func<(lhs: Self, rhs: Self) -> Bool {
		lhs.magnitude < rhs.magnitude
	}
	public static func>(lhs: Self, rhs: Self) -> Bool {
		lhs.magnitude > rhs.magnitude
	}
	public static func<=(lhs: Self, rhs: Self) -> Bool {
		lhs.magnitude <= rhs.magnitude
	}
	public static func>=(lhs: Self, rhs: Self) -> Bool {
		lhs.magnitude >= rhs.magnitude
	}
}
extension ComplexNumber where FloatLiteralType: ComplexNumber {
	public var simplified: FloatLiteralType {
		real + imag * .i
	}
}
extension ComplexNumber where FloatLiteralType: SIMDScalar & BinaryFloatingPoint {
	public static func+(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self) + unsafeBitCast(rhs, to: SIMD2<FloatLiteralType>.self), to: Self.self)
	}
	public static func-(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self) - unsafeBitCast(rhs, to: SIMD2<FloatLiteralType>.self), to: Self.self)
	}
}
extension ComplexNumber where FloatLiteralType == Float32 {
	public init(r: FloatLiteralType, θ: FloatLiteralType) {
		let θ = r * unsafeBitCast(__sincosf_stret(θ), to: SIMD2<FloatLiteralType>.self)
		self.init(real: θ.y, imag: θ.x)
	}
	public static func*(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(SIMD2(
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(rhs.real, -rhs.imag)),
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(rhs.imag,  rhs.real))
		), to: Self.self)
	}
	public static func/(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(SIMD2(
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2( rhs.real, rhs.imag)),
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(-rhs.imag, rhs.real))
		) / length_squared(unsafeBitCast(rhs, to: SIMD2<FloatLiteralType>.self)), to: Self.self)
	}
	public var magnitude: FloatLiteralType {
		length(unsafeBitCast(self, to: SIMD2<FloatLiteralType>.self))
	}
}
extension ComplexNumber where FloatLiteralType == Float64 {
	public init(r: FloatLiteralType, θ: FloatLiteralType) {
		let θ = r * unsafeBitCast(__sincos_stret(θ), to: SIMD2<FloatLiteralType>.self)
		self.init(real: θ.y, imag: θ.x)
	}
	public static func*(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(SIMD2(
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(rhs.real, -rhs.imag)),
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(rhs.imag,  rhs.real))
		), to: Self.self)
	}
	public static func/(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(SIMD2(
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2( rhs.real, rhs.imag)),
			dot(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), SIMD2(-rhs.imag, rhs.real))
		) / rhs.magnitude, to: Self.self)
	}
	public var magnitude: FloatLiteralType {
		length(unsafeBitCast(self, to: SIMD2<FloatLiteralType>.self))
	}
}
