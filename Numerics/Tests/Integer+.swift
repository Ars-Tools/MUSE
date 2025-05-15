//
//  Integer+.swift
//  MUSE
//
//  Created by Kota on 5/15/R7.
//
import Testing
@testable import Numerics
@Suite
struct IntegerTests {
	@Test(arguments: [
		(1, 1),
		(2, 1),
		(3, 1),
		(4, 2),
		(5, 2),
		(6, 2),
		(7, 2),
		(8, 2),
		(9, 3),
	])
	func sqareRoot(query: Int, expected: Int) {
		#expect(query.squareRoot == expected)
	}
	@Test
	func prime() {
		#expect(Array(Int.Prime.prefix(11)) == [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31])
	}
	@Test
	func fibonacci() {
		#expect(Array(Int.Fibonacci.prefix(11)) == [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55])
	}
}
