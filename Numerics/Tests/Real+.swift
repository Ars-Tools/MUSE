//
//  Real+.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
import Testing
@testable import Numerics
@Suite
struct RealTests {
	@Test
	func continuedFractionExpansion() {
		let x = 2.0.squareRoot()
		let s = x.continuedFractionSequence(as: Int.self)
		#expect(Array(s.prefix(12)) == [1] + Array(repeating: 2, count: 11))
	}
}
