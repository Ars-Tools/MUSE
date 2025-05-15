//
//  Rational+Rounding.swift
//  MUSE
//
//  Created by Kota on 5/15/R7.
//
public enum RoundingToward {
	case zero
	case nearest
	case positive
	case negative
	case infinite
}
extension RationalNumber {
	@inline(__always)
	@inlinable
	public func rounding(denominator: IntegerLiteralType, toward: RoundingToward = .zero) -> Self {
		let (n, d) = factor
		let v = n * denominator
		switch toward {
		case.zero:
			return.init(numerator: div(v, d), denominator: denominator)
		case.nearest:
			let ν = d + v % d + d / 2
			return.init(numerator: div(v - ν % d + d / 2, d), denominator: denominator)
		case.negative:
			let ν = d + v % d
			return.init(numerator: div(v - ν % d, d), denominator: denominator)
		case.positive:
			let ν = d - v % d
			return.init(numerator: div(v + ν % d, d), denominator: denominator)
		case.infinite:
			let ν = v % d
			let p = v - ( d + ν ) % d
			let q = v + ( d - ν ) % d
			return.init(numerator: div(p, d) + div(q, d) - div(v, d), denominator: denominator)
		}
	}
	@inline(__always)
	@inlinable
	public func roundingIfNeeded(denominator limit: IntegerLiteralType, toward: RoundingToward = .zero) -> Self {
		denominator < limit ? self : rounding(denominator: limit, toward: toward)
	}
}
