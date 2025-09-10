//
//  COO.swift
//  MUSE
//
//  Created by Kota on 9/9/R7.
//
import Testing
@testable import Sparse
@Suite
struct COOTestCases {
	@Test
	func pp() {
		var eye = COO<Int>(diagonal: 1, 2, 3)
		#expect(eye[2, 0] == 0)
		eye[2, 0] = 10
		#expect(eye[2, 0] == 10)
		#expect(eye[0, 0] == 1)
		#expect(eye[1, 1] == 2)
		#expect(eye[2, 2] == 3)
	}
	@Test
	func pb() {
		var eye = COO<Int>(diagonal: 1, 2, 3)
		eye[2, 0...] = .init(arrayLiteral: 3, 2, 1)
		#expect(eye[0, 0] == 1)
		#expect(eye[1, 1] == 2)
		#expect(eye[2, 2] == 1)
		#expect(eye[2, 1] == 2)
		#expect(eye[2, 0] == 3)
	}
	@Test
	func bp() {
		var eye = COO<Int>(diagonal: 1, 2, 3)
		eye[0..., 2] = .init(arrayLiteral: 3, 2, 1)
		#expect(eye[0, 0] == 1)
		#expect(eye[1, 1] == 2)
		#expect(eye[2, 2] == 1)
		#expect(eye[1, 2] == 2)
		#expect(eye[0, 2] == 3)
	}
	@Test
	func bb() {
		var eye = COO<Int>(diagonal: 1, 2, 3)
		#expect(eye[0, 0] == 1)
		#expect(eye[1, 1] == 2)
		#expect(eye[2, 2] == 3)
		eye[0..<2, 0..<2] = .init(diagonal: 4, 5)
		#expect(eye[0, 0] == 4)
		#expect(eye[1, 1] == 5)
		#expect(eye[2, 2] == 3)
	}
}
