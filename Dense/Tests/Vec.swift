//
//  Vec.swift
//  MUSE
//
//  Created by Kota on 9/8/R7.
//
import Testing
@testable import Dense
@Suite
struct VectorTestCases {
	@Test
	func arrayLiteral() {
		let x = [1, 2, 3, 4] as VecBuf
		print(x[0..<3][1...])
	}
}
