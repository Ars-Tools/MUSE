//
//  Complex+Arithmetic.swift
//  MUSE
//
//  Created by Kota on 5/15/R7.
//
extension ComplexNumber {
    @inlinable@inline(__always)@_transparent
	public static func+(lhs: Self, rhs: Self) -> Self {
		let real = lhs.real + rhs.real
		let imag = lhs.imag + rhs.imag
		return.init(real: real, imag: imag)
	}
    @inlinable@inline(__always)@_transparent
	public static func-(lhs: Self, rhs: Self) -> Self {
		let real = lhs.real - rhs.real
		let imag = lhs.imag - rhs.imag
		return.init(real: real, imag: imag)
	}
    @inlinable@inline(__always)@_transparent
	public static func*(lhs: Self, rhs: Self) -> Self {
		let real = lhs.real * rhs.real - lhs.imag * rhs.imag
		let imag = lhs.imag * rhs.real + lhs.real * rhs.imag
		return.init(real: real, imag: imag)
	}
}
extension ComplexNumber {
    @inlinable@inline(__always)@_transparent
	public static func+=(lhs: inout Self, rhs: Self) {
		lhs = lhs + rhs
	}
    @inlinable@inline(__always)@_transparent
	public static func-=(lhs: inout Self, rhs: Self) {
		lhs = lhs - rhs
	}
    @inlinable@inline(__always)@_transparent
	public static func*=(lhs: inout Self, rhs: Self) {
		lhs = lhs * rhs
	}
}
extension ComplexNumber where FloatLiteralType: BinaryInteger {
    @inlinable@inline(__always)@_transparent
	public static func/(lhs: Self, rhs: Self) -> Self {
		let norm = rhs.real * rhs.real + rhs.imag * rhs.imag
		let real = lhs.real * rhs.real + lhs.imag * rhs.imag
		let imag = lhs.real * rhs.imag - lhs.imag * rhs.real
		return.init(real: real / norm, imag: imag / norm)
	}
    @inlinable@inline(__always)@_transparent
	public static func/=(lhs: inout Self, rhs: Self) {
		lhs = lhs / rhs
	}
}
extension ComplexNumber where FloatLiteralType: BinaryFloatingPoint {
    @inlinable@inline(__always)@_transparent
	public static func/(lhs: Self, rhs: Self) -> Self {
		let norm = rhs.real * rhs.real + rhs.imag * rhs.imag
		let real = lhs.real * rhs.real + lhs.imag * rhs.imag
		let imag = lhs.real * rhs.imag - lhs.imag * rhs.real
		return.init(real: real / norm, imag: imag / norm)
	}
    @inlinable@inline(__always)@_transparent
	public static func/=(lhs: inout Self, rhs: Self) {
		lhs = lhs / rhs
	}
}
extension ComplexNumber {
    @inlinable@inline(__always)@_transparent
	public static prefix func-(_ χ: Self) -> Self {
		.init(real: -χ.real, imag: -χ.imag)
	}
}
extension ComplexNumber {
    @inlinable@inline(__always)@_transparent
	public static func==(lhs: Self, rhs: Self) -> Bool {
		(lhs.real, lhs.imag) == (rhs.real, rhs.imag)
	}
}
