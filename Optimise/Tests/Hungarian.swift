//
//  Hungarian.swift
//  MUSE
//
//  Created by Kota on 9/3/R7.
//
import Testing
@testable import Optimise
@Suite
struct HungarianTestCases {
	@Test
	func matching() {
		let u: [Int] = [1, 2, 3, 4, 5]
		let v: [Int] = [101, 102, 103, 104, 105]
		let cost: Dictionary<SIMD2<Int>, Int> = [
			SIMD2(1, 101): 9, SIMD2(1, 102): 2, SIMD2(1, 103): 7, SIMD2(1, 104): 8, SIMD2(1, 105): 6,
			SIMD2(2, 101): 6, SIMD2(2, 102): 4, SIMD2(2, 103): 3, SIMD2(2, 104): 7, SIMD2(2, 105): 5,
			SIMD2(3, 101): 5, SIMD2(3, 102): 8, SIMD2(3, 103): 1, SIMD2(3, 104): 8, SIMD2(3, 105): 3,
			SIMD2(4, 101): 7, SIMD2(4, 102): 6, SIMD2(4, 103): 9, SIMD2(4, 104): 4, SIMD2(4, 105): 2,
			SIMD2(5, 101): 8, SIMD2(5, 102): 7, SIMD2(5, 103): 4, SIMD2(5, 104): 2, SIMD2(5, 105): 3,
		]
		#expect(hungarian(u: u, v: v, cost: cost) == [SIMD2<Int>(2, 101), SIMD2<Int>(4, 105), SIMD2<Int>(3, 103), SIMD2<Int>(5, 104), SIMD2<Int>(1, 102)])
	}
}
