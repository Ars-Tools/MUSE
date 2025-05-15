//
//  Complex+.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
import Testing
import simd
@testable import Numerics
@Suite
struct ComplexTests {
	@Test(arguments: [
		(Complex64(real: 3, imag: 4), Complex64(real: 4, imag: 3))
	])
	func add(lhs: Complex64, rhs: Complex64) {
		let result = lhs + rhs
		#expect(lhs.real + rhs.real == result.real)
		#expect(lhs.imag + rhs.imag == result.imag)
	}
	@Test(arguments: [
		(Complex64(real: 3, imag: 4), Complex64(real: 4, imag: 3))
	])
	func sub(lhs: Complex64, rhs: Complex64) {
		let result = lhs - rhs
		#expect(lhs.real - rhs.real == result.real)
		#expect(lhs.imag - rhs.imag == result.imag)
	}
	@Test(arguments: [
		(Complex64(real: 3, imag: 4), Complex64(real: 4, imag: 3))
	])
	func mul(lhs: Complex64, rhs: Complex64) {
		let result = lhs * rhs
		let real = dot(unsafeBitCast(lhs, to: SIMD2<Complex64.FloatLiteralType>.self), unsafeBitCast(rhs.conjugate, to: SIMD2<Complex64.FloatLiteralType>.self))
		let imag = dot(SIMD2(lhs.real, rhs.real), SIMD2(rhs.imag, lhs.imag))
		#expect(result.real == real)
		#expect(result.imag == imag)
	}
	@Test(arguments: [
		(Complex64(real: 3, imag: 4), Complex64(real: 4, imag: 3))
	])
	func div(lhs: Complex64, rhs: Complex64) {
		let result = lhs / rhs
		let factor = length_squared(unsafeBitCast(rhs, to: SIMD2<Complex64.FloatLiteralType>.self))
		let real = dot(unsafeBitCast(lhs, to: SIMD2<Complex64.FloatLiteralType>.self), unsafeBitCast(rhs, to: SIMD2<Complex64.FloatLiteralType>.self)) / factor
		let imag = dot(SIMD2(lhs.real, rhs.real), SIMD2(-rhs.imag, lhs.imag)) / factor
		#expect(result.real == real)
		#expect(result.imag == imag)
	}
}
