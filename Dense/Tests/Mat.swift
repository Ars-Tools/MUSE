//
//  Mat.swift
//  MUSE
//
//  Created by Kota on 9/9/R7.
//
import Testing
@testable import Dense
@Suite
struct MatrixTestCases {
	@Test
	func new() {
		let m = MatBuf(rows: 4, cols: 4, ldr: 4, ldc: 1, data: .init(0..<16))
		#expect(m[0, 0] ==  0)
		#expect(m[0, 3] ==  3)
		#expect(m[3, 0] == 12)
		#expect(m[3, 3] == 15)
	}
	@Test
	func arrayLiteral() {
		let m = MatBuf(cols: [
			[0, 1, 2],
			[3, 4, 5, 6],
			[7, 8, 9]
		])
		print(m)
	}
}
