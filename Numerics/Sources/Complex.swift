//
//  Complex.swift
//  MUSE
//
//  Created by Kota on 5/15/R7.
//
public protocol ComplexNumber<FloatLiteralType>: Numeric & Comparable & Hashable & CustomStringConvertible & Sendable & Copyable & ExpressibleByIntegerLiteral & ExpressibleByFloatLiteral where IntegerLiteralType == FloatLiteralType.IntegerLiteralType, Magnitude == FloatLiteralType, FloatLiteralType: SignedNumeric & Comparable & Hashable & Copyable {
	var real: FloatLiteralType { get }
	var imag: FloatLiteralType { get }
	var magnitude: FloatLiteralType.Magnitude { get }
//	var argument: FloatLiteralType { get }
	init(real: FloatLiteralType, imag: FloatLiteralType)
	static var i: Self { get }
}
extension ComplexNumber {
	@inlinable@inline(__always)
	public static var i: Self {
		.init(real: 0, imag: 1)
	}
}
extension ComplexNumber {
	@inlinable@inline(__always)
	public var conjugate: Self {
		.init(real: real, imag: -imag)
	}
}
extension ComplexNumber {
	@inlinable@inline(__always)
	public init?<T>(exactly source: T) where T : BinaryInteger {
		guard let real = FloatLiteralType(exactly: source) else { return nil }
		self.init(real: real, imag: 0)
	}
	@inlinable@inline(__always)
	public init(integerLiteral value: FloatLiteralType.IntegerLiteralType) {
		self.init(real: .init(integerLiteral: value), imag: 0)
	}
	@inlinable@inline(__always)
	public init(floatLiteral value: FloatLiteralType) {
		self.init(real: value, imag: 0)
	}
	@inlinable@inline(__always)
	public init(_ value: some ComplexNumber<FloatLiteralType>) {
		self.init(real: value.real, imag: value.imag)
	}
}
extension ComplexNumber where FloatLiteralType: BinaryInteger {
	@inlinable@inline(__always)
	public init(_ other: some ComplexNumber<some BinaryFloatingPoint>) {
		self.init(real: .init(other.real), imag: .init(other.imag))
	}
}
extension ComplexNumber where FloatLiteralType: BinaryFloatingPoint {
	@inlinable@inline(__always)
	public init(_ other: some ComplexNumber<some BinaryInteger>) {
		self.init(real: .init(other.real), imag: .init(other.imag))
	}
}
extension ComplexNumber {
	@inlinable@inline(__always)
	public static func<(lhs: Self, rhs: Self) -> Bool {
		lhs.magnitude < rhs.magnitude
	}
	@inlinable@inline(__always)
	public static func>(lhs: Self, rhs: Self) -> Bool {
		lhs.magnitude > rhs.magnitude
	}
	@inlinable@inline(__always)
	public static func<=(lhs: Self, rhs: Self) -> Bool {
		lhs.magnitude <= rhs.magnitude
	}
	@inlinable@inline(__always)
	public static func>=(lhs: Self, rhs: Self) -> Bool {
		lhs.magnitude >= rhs.magnitude
	}
}
extension ComplexNumber where FloatLiteralType: ComplexNumber {
	@inlinable@inline(__always)
	public var simplified: FloatLiteralType {
		real + imag * .i
	}
}
