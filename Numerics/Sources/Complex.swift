//
//  Complex.swift
//  MUSE
//
//  Created by Kota on 5/15/R7.
//
public protocol ComplexNumber<FloatLiteralType>: Numeric & Comparable & Hashable & CustomStringConvertible & Sendable & Copyable where IntegerLiteralType == FloatLiteralType.IntegerLiteralType, Magnitude == FloatLiteralType {
	associatedtype FloatLiteralType: SignedNumeric & Comparable & Hashable & Copyable
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
