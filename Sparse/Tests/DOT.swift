//
//  DOT.swift
//  MUSE
//
//  Created by Kota on 9/10/R7.
//
import Dense
import Testing
import func Layout.product
@testable import Sparse
@Suite
struct DOTTestCases {
	@Test
	func scaleVec() {
		let x = [2, 3, 5] as SPV
		let y = 7 * x
		let z = SPV(y)
		#expect(y[0] == 14)
		#expect(z[1] == 21)
		#expect(z[2] == 35)
	}
	@Test
	func scaleMat() {
		let x = CRS(rows: [[2, 3, 5], [11, 13, 19]])
		let y = 7 * x
		let z = CCS(y)
		#expect(y[0, 0] == 14)
		#expect(z[0, 1] == 21)
		#expect(z[0, 2] == 35)
		#expect(y[1, 0] == 77)
		#expect(z[1, 1] == 91)
	}
	@Test(arguments: [
		([2, 3, 5], [7, 11, 13]),
		([1, 0, 0, 1], [0, 9, 0, 3])
	])
	func innerDot(x: Array<Int>, y: Array<Int>) async throws {
		let z = SPV(x) • SPV(y)
		let w = zip(x, y).map(*).reduce(0, +)
		#expect(z == w)
	}
	@Test(arguments: [
		([2, 3, 5], [7, 11, 13]),
		([1, 0, 0, 1], [0, 9, 0, 3])
	])
	func outerDot(x: Array<Int>, y: Array<Int>) async throws {
		let z = outer(SPV(x), SPV(y))
		let w = CCS(z)
		for (x, y) in product(x.enumerated(), y.enumerated()) {
			#expect(z[x.0, y.0] == x.1 * y.1)
			#expect(w[x.0, y.0] == x.1 * y.1)
		}
	}
	@Test(arguments: [
		([[1, 2], [3, 5]], [[9, 6], [3, 1]])
	])
	func mmCCC(lhs: Array<Array<Int>>, rhs: Array<Array<Int>>) {
		let x = CCS(cols: lhs)
		let y = CCS(cols: rhs)
		let z = x • y
		let w = CCS(z)
		for (row, col) in product(0..<2, 0..<2) {
			let e = x[row, 0...] • y[0..., col]
			#expect(z[row, col] == e)
			#expect(w[row, col] == e)
		}
	}
	@Test(arguments: [
		([[1, 2], [3, 5]], [[9, 6], [3, 1]])
	])
	func mmRRC(lhs: Array<Array<Int>>, rhs: Array<Array<Int>>) {
		let x = CRS(rows: lhs)
		let y = CRS(rows: rhs)
		let z = x • y
		let w = CCS(z)
		for (row, col) in product(0..<2, 0..<2) {
			let e = x[row, 0...] • y[0..., col]
			#expect(z[row, col] == e)
			#expect(w[row, col] == e)
		}
	}
	@Test(arguments: [
		([[1, 2], [3, 5]], [[9, 6], [3, 1]])
	])
	func mmRCC(lhs: Array<Array<Int>>, rhs: Array<Array<Int>>) {
		let x = CRS(rows: lhs)
		let y = CCS(cols: rhs)
		let z = x • y
		let w = CCS(z)
		for (row, col) in product(0..<2, 0..<2) {
			let e = x[row, 0...] • y[0..., col]
			#expect(z[row, col] == e)
			#expect(w[row, col] == e)
		}
	}
	@Test(arguments: [
		([[1, 2], [3, 5]], [[9, 6], [3, 1]])
	])
	func mmCCR(lhs: Array<Array<Int>>, rhs: Array<Array<Int>>) {
		let x = CCS(cols: lhs)
		let y = CCS(cols: rhs)
		let z = x • y
		let w = CRS(z)
		for (row, col) in product(0..<2, 0..<2) {
			let e = x[row, 0...] • y[0..., col]
			#expect(z[row, col] == e)
			#expect(w[row, col] == e)
		}
	}
	@Test(arguments: [
		([[1, 2], [3, 5]], [[9, 6], [3, 1]])
	])
	func mmRRR(lhs: Array<Array<Int>>, rhs: Array<Array<Int>>) {
		let x = CRS(rows: lhs)
		let y = CRS(rows: rhs)
		let z = x • y
		let w = CRS(z)
		for (row, col) in product(0..<2, 0..<2) {
			let e = x[row, 0...] • y[0..., col]
			#expect(z[row, col] == e)
			#expect(w[row, col] == e)
		}
	}
	@Test
	func tt() {
		var x = MSK(shape: (6, 6))
		var y = MSK(shape: (6, 6))
		for (row, col) in product(0..<6, 0..<6) {
			x[row, col] = .random()
			y[row, col] = .random()
		}
		let z = x • y
		#expect(z.rows == 6)
		#expect(z.cols == 6)
		let w = MSK(z)
		#expect(w.rows == 6)
		#expect(w.cols == 6)
		#expect(z.state == w.state)
		#expect(z.diagonal.state == w.diagonal.state)
		#expect(z[0, 0...].state == w[0, 0...].state)
		#expect(z[0..., 0].state == w[0..., 0].state)
		for (row, col) in product(0..<6, 0..<6) {
			let e = (0..<6).reduce(false) { $0 || x[row, $1] && y[$1, col] }
			#expect(z[row, col] == e)
			#expect(w[row, col] == e)
		}
		for idx in 0..<6 {
			#expect(z[idx, 0...].state == w[idx, 0...].state)
			#expect(z[0..., idx].state == w[0..., idx].state)
		}
	}
}
