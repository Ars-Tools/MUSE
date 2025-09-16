//
//  Narrowcast+.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
import Testing
@testable import Layout
@Suite
struct NarrowcastTests {
	@Test
	func range() {
		let x = [8, 1]
		let y = [1, 6]
		let z = broadcast(lhs: x, rhs: y)
		#expect(z == [8, 6])
		#expect(narrowcast(ranges: [..<3, ..<3], target: z, source: [8, 1]) == [0..<3, 0..<1])
		#expect(narrowcast(ranges: [3..., 3...], target: z, source: [1, 6]) == [0..<1, 3..<6])
	}
	@Test
	func slice() {
		let x = [8, 4, 1]
		let y = [1, 6]
		let z = broadcast(lhs: x, rhs: y)
		#expect(z == [8, 4, 6])
		#expect(narrowcast(ranges: [0..<1], target: z, source: [1, 6]) == [0..<1, 0..<6])
		#expect(narrowcast(ranges: [0..<1, 3..<4, 2..<4], target: z, source: [1, 6]) == [0..<1, 2..<4])
	}
}
