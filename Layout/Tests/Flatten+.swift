//
//  Flatten+.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
import Testing
@testable import Layout
@Suite
struct FlattenTests {
	@Test
	func vector1() {
		#expect(flatten(shape: [], xs: []) == (1, 0, [0]))
	}
	@Test
	func vector2() {
		let (length, stride, offset) = flatten(shape: [4,4,4], xs: [1,4,20], ys: [1,4,16])
		#expect(length == 16)
		#expect(stride == .one)
		#expect(offset == [.init(0, 0), .init(20, 16), .init(40, 32), .init(60, 48)])
	}
	@Test
	func vector3() {
		let (length, stride, offset) = flatten(shape: [4,4,4], xs: [1,4,16], ys: [1,4,16], zs: [1,4,16])
		#expect(length == 64)
		#expect(stride == .one)
		#expect(offset == [.zero])
	}
	@Test
	func testMatrix2() {
		let (length, stride, offset) = flatten(shape: [4,4], xs: [1,4], ys: [4,1])
		#expect(length == 4)
		#expect(stride == .init(4, 1))
		#expect(offset == [.init(0, 0), .init(1, 4), .init(2, 8), .init(3, 12)])
	}
}
