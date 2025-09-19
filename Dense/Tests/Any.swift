//
//  Any.swift
//  MUSE
//
//  Created by Kota on 9/18/R7.
//
import Testing
import Numerics
@testable import Dense
@Suite
struct AnyTestCases {
	@Test
	func rm2v() async throws {
		let m = MatBuf(rows: [
			[0],
			[1],
			[2],
		])
		let s = vector(m)
		let t = try await VecBuf(s)
		for k in 0..<3 {
			#expect(m[k, 0] == t[k])
		}
	}
	@Test
	func cm2v() async throws {
		let m = MatBuf(rows: [
			[0, 1, 2],
		])
		let s = vector(m)
		let t = try await VecBuf(s)
		for k in 0..<3 {
			#expect(m[0, k] == t[k])
		}
	}
	@Test
	func rv2m() async throws {
		let m = VecBuf([0, 1, 2])
		let s = matrix(rows: m)
		let t = try await MatBuf(s)
		for k in 0..<3 {
			let v = try await s[0, k][]
			#expect(m[k] == t[0, k])
			#expect(m[k] == v)
		}
	}
	@Test
	func cv2m() async throws {
		let m = VecBuf([0, 1, 2])
		let s = matrix(cols: m)
		let t = try await MatBuf(s)
		for k in 0..<3 {
			let v = try await s[k, 0][]
			#expect(m[k] == t[k, 0])
			#expect(m[k] == v)
		}
	}
	@Test
	func v2m() async throws {
		let x = VecBuf([
			1.0, 2.0, 3.0, 4.0
		])
		let y = MatBuf(rows: [
			[1.0, 2.0],
			[3.0, 4.0],
			[5.0, 6.0]
		])
		let s = outer(x, y)//[[3..<4, 0..<3, 0..<2]]
		print(s.shape)
		let t = matrix(rows: typecast(s, as: Int8.self))
		print(t.shape)
//		try await print(MatBuf(t))
//		try await print(TensorBuffer(s)[[0...]])
//		try await print(TensorBuffer(s[[0...]]))
	}
}
