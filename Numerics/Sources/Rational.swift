//
//  Rational.swift
//  MUSE
//
//  Created by Kota on 5/15/R7.
//
public protocol RationalNumber<IntegerLiteralType>: SignedNumeric & Comparable & CustomStringConvertible & Hashable & Sendable & Copyable where IntegerLiteralType: BinaryInteger {
	var numerator: IntegerLiteralType { get }
	var denominator: IntegerLiteralType { get }
	init(numerator: IntegerLiteralType, denominator: IntegerLiteralType)
}
// Basics
extension RationalNumber {
	@inlinable @inline(__always)
	public init?<T>(exactly source: T) where T : BinaryInteger {
		guard let value = IntegerLiteralType(exactly: source) else { return nil }
		self.init(numerator: value, denominator: 1)
	}
	@inlinable @inline(__always)
	public init(integerLiteral value: IntegerLiteralType) {
		self.init(numerator: value, denominator: 1)
	}
	@inlinable @inline(__always)
	public init(_ numerator: IntegerLiteralType, _ denominator: IntegerLiteralType = 1) {
		self.init(numerator: numerator, denominator: denominator)
	}
	@inlinable @inline(__always)
	public init(_ value: some RationalNumber<IntegerLiteralType>) {
		let (numerator, denominator) = value.factor
		self.init(numerator: numerator, denominator: denominator)
	}
}
// Foundations
extension RationalNumber {
	@inlinable @inline(__always)
	public var inverse: Self {
		.init(numerator: denominator, denominator: numerator)
	}
}
extension RationalNumber {
	@inlinable @inline(__always)
	var factor: (IntegerLiteralType, IntegerLiteralType) {
		denominator == .zero ?
			(numerator, denominator) :
			(numerator / abs(gcd(numerator, denominator)), denominator / abs(gcd(numerator, denominator)))
	}
	@inlinable @inline(__always)
	static func comparison(lhs: Self, rhs: Self, comparator: (IntegerLiteralType, IntegerLiteralType) -> Bool) -> Bool {
		switch (lhs.factor, rhs.factor) {
		case ((0, 0), (0, 0)), ((0, 0), _), (_, (0, 0)): // NaN comparison
			return false
		case ((let ln, 0), (let rn, 0)): // Infinites
			return comparator(ln.signum(), rn.signum())
		case let ((ln, ld), (rn, rd)):
			let n = gcd(ln, rd)
			let d = gcd(rn, ld)
			return comparator(div(ln, n) * div(rd, n) * n, div(rn, d) * div(ld, d) * d)
		}
	}
}
// Equatable
extension RationalNumber {
	@inlinable @inline(__always)
	public static func==(lhs: Self, rhs: Self) -> Bool {
		comparison(lhs: lhs, rhs: rhs, comparator: ==)
	}
}
// Comparable
extension RationalNumber {
	@inlinable @inline(__always)
	public static func<(lhs: Self, rhs: Self) -> Bool {
		comparison(lhs: lhs, rhs: rhs, comparator: <)
	}
	@inlinable @inline(__always)
	public static func>(lhs: Self, rhs: Self) -> Bool {
		comparison(lhs: lhs, rhs: rhs, comparator: >)
	}
	@inlinable @inline(__always)
	public static func<=(lhs: Self, rhs: Self) -> Bool {
		comparison(lhs: lhs, rhs: rhs, comparator: <=)
	}
	@inlinable @inline(__always)
	public static func>=(lhs: Self, rhs: Self) -> Bool {
		comparison(lhs: lhs, rhs: rhs, comparator: >=)
	}
}
extension RationalNumber {
	@inlinable @inline(__always)
	public var isInfinite: Bool {
		denominator == .zero && numerator != .zero
	}
	@inlinable @inline(__always)
	public var isNaN: Bool {
		denominator == .zero && numerator == .zero
	}
	@inlinable @inline(__always)
	public var isFinite: Bool {
		denominator != .zero
	}
	@inlinable @inline(__always)
	public var isNormal: Bool {
		denominator != .zero && numerator != .zero
	}
	@inlinable @inline(__always)
	public var isZero: Bool {
		denominator != .zero && numerator == .zero
	}
}
