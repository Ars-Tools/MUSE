//
//  Rational+Arithmetic.swift
//  MUSE
//
//  Created by Kota on 5/15/R7.
//
extension RationalNumber {
	@inline(__always)
	@inlinable
	public static func+(lhs: Self, rhs: Self) -> Self {
		let (ln, ld) = lhs.factor
		let (rn, rd) = rhs.factor
		let g = gcd(ld, rd)
		let n = ln * div(rd, g) + rn * div(ld, g)
		let d = div(ld, g) * div(rd, g) * g
		let f = abs(gcd(n, d))
		return.init(numerator: div(n, f), denominator: div(d, f))
	}
	@inline(__always)
	@inlinable
	public static func-(lhs: Self, rhs: Self) -> Self {
		let (ln, ld) = lhs.factor
		let (rn, rd) = rhs.factor
		let g = gcd(ld, rd)
		let n = ln * div(rd, g) - rn * div(ld, g)
		let d = div(ld, g) * div(rd, g) * g
		let f = abs(gcd(n, d))
		return.init(numerator: div(n, f), denominator: div(d, f))
	}
	@inline(__always)
	@inlinable
	public static func*(lhs: Self, rhs: Self) -> Self {
		let (ln, ld) = lhs.factor
		let (rn, rd) = rhs.factor
		let n = abs(gcd(ln, rd))
		let d = abs(gcd(ld, rn))
		return.init(numerator: div(ln, n) * div(rn, d), denominator: div(ld, d) * div(rd, n))
	}
	@inline(__always)
	@inlinable
	public static func/(lhs: Self, rhs: Self) -> Self {
		let (ln, ld) = lhs.factor
		let (rn, rd) = rhs.factor
		let n = abs(gcd(ln, rn))
		let d = abs(gcd(ld, rd))
		return.init(numerator: div(ln, n) * div(rd, d), denominator: div(ld, d) * div(rn, n))
	}
}
extension RationalNumber {
	@inline(__always)
	@inlinable
	public static func+=(lhs: inout Self, rhs: Self) {
		lhs = lhs + rhs
	}
	@inline(__always)
	@inlinable
	public static func-=(lhs: inout Self, rhs: Self) {
		lhs = lhs - rhs
	}
	@inline(__always)
	@inlinable
	public static func*=(lhs: inout Self, rhs: Self) {
		lhs = lhs * rhs
	}
	@inline(__always)
	@inlinable
	public static func/=(lhs: inout Self, rhs: Self) {
		lhs = lhs / rhs
	}
}
extension RationalNumber {
	@inline(__always)
	@inlinable
	public static func%(lhs: Self, rhs: Self) -> Self {
		let (ln, ld) = lhs.factor
		switch rhs.factor {
		case (let rn, 0): // we need specialize for nan and infinite
			return.init(numerator: div(ln, rn), denominator: div(ld, rn))
		case (0, let rd): // and modulo by zero, lim_{ε→∞}{\frac{a}{b}\mod\frac{1}{ε} = 0}
			return.init(numerator: 0, denominator: lcm(ld, rd))
		case let(rn, rd):
			let g = gcd(ld, rd)
			let d = div(ld, g) * div(rd, g) * g
			let n = (ln * div(rd, g)) % (rn * div(ld, g))
			let f = abs(gcd(n, d))
			return.init(numerator: div(n, f), denominator: div(d, f))
		}
	}
}
extension RationalNumber where IntegerLiteralType: SignedInteger {
	@inline(__always)
	@inlinable
	public static prefix func-(_ χ: Self) -> Self {
		switch χ.factor {
		case let (numerator, denominator) where denominator < 0:
			.init(numerator: numerator, denominator: -denominator)
		case let (numerator, denominator):
			.init(numerator: -numerator, denominator: denominator)
		}
	}
}
