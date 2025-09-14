//
//  LIL.swift
//  MUSE
//
//  Created by Kota on 9/13/R7.
//
import Testing
@testable import Sparse
@Suite
struct LILTestCases {
	@Test
	func alt() {
		var eye = LIL<Int>(identity: 4)
		eye[0, 0] = 5
		eye[2, 2] = 0
		eye[2, 3] = 4
		#expect(eye[0, 0] == 5)
		#expect(eye[1, 1] == 1)
		#expect(eye[2, 2] == 0)
		#expect(eye[2, 3] == 4)
	}
	@Test
	func pp() {
		var eye = DOK<Int>(diagonal: 1, 2, 3)
		#expect(eye[2, 0] == 0)
		eye[2, 0] = 10
		let test = LIL(eye)
		#expect(test[2, 0] == 10)
		#expect(test[0, 0] == 1)
		#expect(test[1, 1] == 2)
		#expect(test[2, 2] == 3)
	}
	@Test
	func pb() {
		var eye = DOK<Int>(diagonal: 1, 2, 3)
		eye[2, 0...] = .init(arrayLiteral: 3, 2, 1)
		let test = LIL(eye)
		#expect(test[0, 0] == 1)
		#expect(test[1, 1] == 2)
		#expect(test[2, 2] == 1)
		#expect(test[2, 1] == 2)
		#expect(test[2, 0] == 3)
	}
	@Test
	func bp() {
		var eye = DOK<Int>(diagonal: 1, 2, 3)
		eye[0..., 2] = .init(arrayLiteral: 3, 2, 1)
		let test = LIL(eye)
		#expect(test[0, 0] == 1)
		#expect(test[1, 1] == 2)
		#expect(test[2, 2] == 1)
		#expect(test[1, 2] == 2)
		#expect(test[0, 2] == 3)
	}
	@Test
	func bb() {
		var eye = DOK<Int>(diagonal: 1, 2, 3)
		#expect(eye[0, 0] == 1)
		#expect(eye[1, 1] == 2)
		#expect(eye[2, 2] == 3)
		eye[0..<2, 0..<2] = .init(diagonal: 4, 5)
		let test = LIL(eye)
		#expect(test[0, 0] == 4)
		#expect(test[1, 1] == 5)
		#expect(test[2, 2] == 3)
		print(test)
	}
	@Test
	func modVR() {
		var eye = LIL(CRS<Int>(identity: 4))
		eye[3, 0] = 10
		#expect(eye.major == .rowMajor)
		eye[1..., 0] = .init(arrayLiteral: 2, 4, 8)
		#expect(eye[0..., 0].store == [
			0:1,
			1:2,
			2:4,
			3:8
		])
	}
	@Test
	func modVC() {
		var eye = LIL(CCS<Int>(identity: 4))
		eye[3, 0] = 10
		#expect(eye.major == .columnMajor)
		eye[1..., 0] = .init(arrayLiteral: 2, 4, 8)
		#expect(eye[0..., 0].store == [
			0:1,
			1:2,
			2:4,
			3:8
		])
	}
	@Test
	func modHR() {
		var eye = LIL(CRS<Int>(identity: 4))
		eye[3, 0] = 10
		#expect(eye.major == .rowMajor)
		eye[0, 1...] = .init(arrayLiteral: 2, 4, 8)
		#expect(eye[0, 0...].store == [
			0:1,
			1:2,
			2:4,
			3:8
		])
	}
	@Test
	func modHC() {
		var eye = LIL(CCS<Int>(identity: 4))
		eye[3, 0] = 10
		#expect(eye.major == .columnMajor)
		eye[0, 1...] = .init(arrayLiteral: 2, 4, 8)
		#expect(eye[0, 0...].store == [
			0:1,
			1:2,
			2:4,
			3:8
		])
	}
}
