//
//  Rational+.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
import Testing
import func Darwin.fmod
@testable import Numerics
@Suite
struct RationalTests {
	@Test
	func eq() {
		#expect(Rational(numerator: 1, denominator: 2) == Rational(numerator:  4, denominator: 8))
		#expect(Rational(numerator: 1, denominator: 0) == Rational(numerator:  9, denominator: 0), "should be same, as infinites")
		#expect(Rational(numerator: 1, denominator: 0) != Rational(numerator: -1, denominator: 0), "should be not same, as infinites")
		#expect(Rational(numerator: 0, denominator: 0) != Rational(numerator:  0, denominator: 0), "nan never match")
	}
	@Test
	func gt() {
		#expect(Rational(numerator: 1, denominator: 2) > Rational(numerator: 1, denominator: 3))
		#expect(Rational(numerator: 3, denominator: 2) > Rational(numerator: 1, denominator: 2))
		#expect(Rational(numerator: 3, denominator: 2) >= Rational(numerator: 1, denominator: 2))
		#expect(Rational(numerator:  1, denominator: 0) > Rational(numerator: .max, denominator: 1))
	}
	@Test
	func lt() {
		#expect(Rational(numerator: 3, denominator: 8) < Rational(numerator: 1, denominator: 2))
		#expect(Rational(numerator: 1, denominator: 2) < Rational(numerator: 3, denominator: 2))
		#expect(Rational(numerator: 1, denominator: 2) <= Rational(numerator: 3, denominator: 2))
		#expect(Rational(numerator: -1, denominator: 0) < Rational(numerator: .min, denominator: 1))
	}
	@Test
	func add() {
		let x = Rational<Int>(Float32.random(in: -3...3))
		let y = Rational<Int>(Float32.random(in: -3...3))
		#expect(x.isNormal)
		#expect(y.isNormal)
		#expect((Float64(x) + Float64(y) - Float64(x + y)).magnitude < 1e-5)
	}
	@Test
	func sub() {
		let x = Rational<Int>(Float32.random(in: -3...3))
		let y = Rational<Int>(Float32.random(in: -3...3))
		#expect(x.isNormal)
		#expect(y.isNormal)
		#expect((Float64(x) - Float64(y) - Float64(x - y)).magnitude < 1e-5)
	}
	@Test
	func mul() {
		let x = Rational<Int>(Float32.random(in: -3...3))
		let y = Rational<Int>(Float32.random(in: -3...3))
		#expect(x.isNormal)
		#expect(y.isNormal)
		#expect((Float64(x) * Float64(y) - Float64(x * y)).magnitude < 1e-5)
	}
	@Test
	func div() {
		let x = Rational<Int>(Float32.random(in: -1...1))
		let y = Rational<Int>(Float32.random(in: 1...10))
		#expect(x.isNormal)
		#expect(y.isNormal)
		#expect((Float64(x) / Float64(y) - Float64(x / y)).magnitude < 1e-5)
	}
	@Test
	func mod() {
		let x = Rational<Int>(Float32.random(in: -1...1))
		let y = Rational<Int>(Float32.random(in: 1...10))
		#expect((fmod(Float64(x), Float64(y)) - Float64(x % y)).magnitude < 1e-5)
		#expect(Rational<Int>(3, 1) % Rational<Int>(numerator: 1, denominator: 0) == .init(numerator: 3, denominator: 1), "should be lhs")
		#expect(Rational<Int>(3, 1) % Rational<Int>(numerator: 0, denominator: 1) == 0, "should be zer0")
		#expect((Rational<Int>(3, 1) % Rational<Int>(numerator: 0, denominator: 0)).factor == (0, 0), "should be nan")
	}
	@Test
		func testContinuedFractionSqrt2() {
		let x = (2.0).squareRoot()
		let s = x.continuedFractionSequence(as: Int.self)
		#expect(Array(s.prefix(12)) == [1] + Array(repeating: 2, count: 11))
	}
	@Test
	func testContinuedFractionπ() {
		let q = Rational<Int>(continuedFraction: [3, 7, 15, 1, 292])
		#expect((Float64(q) - .pi).magnitude < 1e-6)
	}
	@Test
	func fromBinaryFloatingPoint() {
		let x = 355.0 / 113.0
		let y = Rational<Int>(x)
		#expect(y == .init(numerator: 355, denominator: 113))
		#expect(.init(numerator: 977, denominator: 997) == Rational<Int>(977.0/997.0))
	}
	@Test
	func fromContinuedFraction() {
		let x = 355.0 / 113.0
		let y = Rational<Int>(continuedFraction: x.continuedFractionSequence())
		#expect(y == .init(numerator: 355, denominator: 113))
		#expect(.init(numerator: 977, denominator: 997) == Rational<Int>(continuedFraction: (977.0/997.0).continuedFractionSequence()))
	}
	@Test
	func fromContinuedFractionBinary() {
		let x = (1...).lazy.map{(2 * $0 - 1, $0 * $0)}
		let π = Rational(continuedFraction: x.prefix(12))
		#expect((4 / Float64(π) - .pi).magnitude < 1e-6)
	}
	@Test(arguments: -31...31)
	func round(n: Int) {
		let x = Rational(numerator: n, denominator: 19)
		#expect((Float64(x.rounding(denominator: 4, toward: .positive)) - (Float64(x)*4).rounded(.up)/4).magnitude < 1e-5)
		#expect((Float64(x.rounding(denominator: 4, toward: .negative)) - (Float64(x)*4).rounded(.down)/4).magnitude < 1e-5)
		#expect((Float64(x.rounding(denominator: 4, toward: .zero)) - (Float64(x)*4).rounded(.towardZero)/4).magnitude < 1e-5)
		#expect((Float64(x.rounding(denominator: 4, toward: .infinite)) - (Float64(x)*4).rounded(.awayFromZero)/4).magnitude < 1e-5)
		#expect((Float64(x.rounding(denominator: 4, toward: .nearest)) - (Float64(x)*4).rounded(.toNearestOrEven)/4).magnitude < 1e-5)
	}
}
