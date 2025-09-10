//
//  Add.swift
//  MUSE
//
//  Created by Kota on 9/10/R7.
//
import Testing
import func Layout.product
@testable import Sparse
@Suite
struct AddTestCases {
	@Test(arguments: [
		([0, 1, 2], [1, -1, 5]),
		([0, 3, 5], [0, 9, 11]),
	])
	func vv(lhs: Array<Int>, rhs: Array<Int>) {
		let x = SPV(lhs)
		let y = SPV(rhs)
		let z = x + y
		let w = SPV(z)
		#expect(w.store.count == 2)
		for idx in 0..<3 {
			#expect(z[idx] == x[idx] + y[idx])
			#expect(w[idx] == x[idx] + y[idx])
		}
	}
	@Test(arguments: [
		([[2, 1], [2, 3]], [[-2, 5], [6, 7]]),
		([[2, 4], [0, 8]], [[3, 0], [9, 11]]),
	])
	func mm(lhs: Array<Array<Int>>, rhs: Array<Array<Int>>) {
		let x = CCS(cols: lhs)
		let y = CRS(rows: rhs)
		let z = x + y
		let w = DOK(z)
		#expect(w.store.count == 3)
		for (row, col) in product(0..<2, 0..<2) {
			#expect(z[row, col] == x[row, col] + y[row, col])
			#expect(w[row, col] == x[row, col] + y[row, col])
		}
	}
	@Test(arguments: [
		([[2, 1]], [[6, 7]]),
		([[2, 4]], [[3, 0]]),
	])
	func bc(lhs: Array<Array<Int>>, rhs: Array<Array<Int>>) {
		let x = CCS(cols: lhs)
		let y = CRS(rows: rhs)
		let z = x + y
		#expect(z.rows == 2)
		#expect(z.cols == 2)
		for (row, col) in product(0..<2, 0..<2) {
//			print(z[row, col])
			#expect(z[row, col] == x[row, 0] + y[0, col])
		}
		
	}
}
