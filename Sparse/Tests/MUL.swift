//
//  Mul.swift
//  MUSE
//
//  Created by Kota on 9/10/R7.
//
import Testing
import func Layout.product
@testable import Sparse
@Suite
struct MulTestCases {
	@Test(arguments: [
		([0, 1, 2], [1, -1, 0]),
		([0, 3, 5], [0, 0, 11]),
	])
	func vv(lhs: Array<Int>, rhs: Array<Int>) {
		let x = SPV(lhs)
		let y = SPV(rhs)
		let z = x * y
		let w = SPV(z)
		#expect(w.store.count == 1)
		for idx in 0..<3 {
			#expect(z[idx] == x[idx] * y[idx])
			#expect(w[idx] == x[idx] * y[idx])
		}
	}
	@Test(arguments: [
		([[2, 1], [0, 3]], [[-2, 5], [6, 0]]),
		([[2, 4], [0, 8]], [[3, 9], [0, 11]]),
	])
	func mm(lhs: Array<Array<Int>>, rhs: Array<Array<Int>>) {
		let x = CCS(cols: lhs)
		let y = CRS(rows: rhs)
		let z = x * y
		let w = DOK(z)
		#expect(w.store.count == 2)
		for (row, col) in product(0..<2, 0..<2) {
			#expect(z[row, col] == x[row, col] * y[row, col])
			#expect(w[row, col] == x[row, col] * y[row, col])
		}
	}
	@Test(arguments: [
		(repeatElement(-12...12, count: 6).map(Int.random(in:)), repeatElement(-12...12, count: 6).map(Int.random(in:)))
	])
	func CCC(x: Array<Int>, y: Array<Int>) {
		let x = DOK(rows: [x])
		let y = DOK(cols: [y])
		let z = CCS(x) * CCS(y)
		#expect(z.rows == 6)
		#expect(z.cols == 6)
		let w = CCS(z)
		#expect(w.rows == 6)
		#expect(w.cols == 6)
		for (row, col) in product(0..<z.rows, 0..<z.cols) {
			#expect(z[row, col] == x[0, col] * y[row, 0])
			#expect(w[row, col] == x[0, col] * y[row, 0])
		}
	}
	@Test(arguments: [
		(repeatElement(-12...12, count: 6).map(Int.random(in:)), repeatElement(-12...12, count: 6).map(Int.random(in:)))
	])
	func RCC(x: Array<Int>, y: Array<Int>) {
		let x = DOK(rows: [x])
		let y = DOK(cols: [y])
		let z = CRS(x) * CCS(y)
		#expect(z.rows == 6)
		#expect(z.cols == 6)
		let w = CCS(z)
		#expect(w.rows == 6)
		#expect(w.cols == 6)
		for (row, col) in product(0..<z.rows, 0..<z.cols) {
			#expect(z[row, col] == x[0, col] * y[row, 0])
			#expect(w[row, col] == x[0, col] * y[row, 0])
		}
	}
	@Test(arguments: [
		(repeatElement(-12...12, count: 6).map(Int.random(in:)), repeatElement(-12...12, count: 6).map(Int.random(in:)))
	])
	func CRC(x: Array<Int>, y: Array<Int>) {
		let x = DOK(rows: [x])
		let y = DOK(cols: [y])
		let z = CCS(x) * CRS(y)
		#expect(z.rows == 6)
		#expect(z.cols == 6)
		let w = CCS(z)
		#expect(w.rows == 6)
		#expect(w.cols == 6)
		for (row, col) in product(0..<z.rows, 0..<z.cols) {
			#expect(z[row, col] == x[0, col] * y[row, 0])
			#expect(w[row, col] == x[0, col] * y[row, 0])
		}
	}
	@Test(arguments: [
		(repeatElement(-12...12, count: 6).map(Int.random(in:)), repeatElement(-12...12, count: 6).map(Int.random(in:)))
	])
	func RRC(x: Array<Int>, y: Array<Int>) {
		let x = DOK(rows: [x])
		let y = DOK(cols: [y])
		let z = CRS(x) * CRS(y)
		#expect(z.rows == 6)
		#expect(z.cols == 6)
		let w = CRS(z)
		#expect(w.rows == 6)
		#expect(w.cols == 6)
		for (row, col) in product(0..<z.rows, 0..<z.cols) {
			#expect(z[row, col] == x[0, col] * y[row, 0])
			#expect(w[row, col] == x[0, col] * y[row, 0])
		}
	}
	@Test(arguments: [
		(repeatElement(-12...12, count: 6).map(Int.random(in:)), repeatElement(-12...12, count: 6).map(Int.random(in:)))
	])
	func CCR(x: Array<Int>, y: Array<Int>) {
		let x = DOK(rows: [x])
		let y = DOK(cols: [y])
		let z = CCS(x) * CCS(y)
		#expect(z.rows == 6)
		#expect(z.cols == 6)
		let w = CRS(z)
		#expect(w.rows == 6)
		#expect(w.cols == 6)
		for (row, col) in product(0..<z.rows, 0..<z.cols) {
			#expect(z[row, col] == x[0, col] * y[row, 0])
			#expect(w[row, col] == x[0, col] * y[row, 0])
		}
	}
	@Test(arguments: [
		(repeatElement(-12...12, count: 6).map(Int.random(in:)), repeatElement(-12...12, count: 6).map(Int.random(in:)))
	])
	func RCR(x: Array<Int>, y: Array<Int>) {
		let x = DOK(rows: [x])
		let y = DOK(cols: [y])
		let z = CRS(x) * CCS(y)
		#expect(z.rows == 6)
		#expect(z.cols == 6)
		let w = CRS(z)
		#expect(w.rows == 6)
		#expect(w.cols == 6)
		for (row, col) in product(0..<z.rows, 0..<z.cols) {
			#expect(z[row, col] == x[0, col] * y[row, 0])
			#expect(w[row, col] == x[0, col] * y[row, 0])
		}
	}
	@Test(arguments: [
		(repeatElement(-12...12, count: 6).map(Int.random(in:)), repeatElement(-12...12, count: 6).map(Int.random(in:)))
	])
	func CRR(x: Array<Int>, y: Array<Int>) {
		let x = DOK(rows: [x])
		let y = DOK(cols: [y])
		let z = CCS(x) * CRS(y)
		#expect(z.rows == 6)
		#expect(z.cols == 6)
		let w = CRS(z)
		#expect(w.rows == 6)
		#expect(w.cols == 6)
		for (row, col) in product(0..<z.rows, 0..<z.cols) {
			#expect(z[row, col] == x[0, col] * y[row, 0])
			#expect(w[row, col] == x[0, col] * y[row, 0])
		}
	}
	@Test(arguments: [
		(repeatElement(-12...12, count: 6).map(Int.random(in:)), repeatElement(-12...12, count: 6).map(Int.random(in:)))
	])
	func RRR(x: Array<Int>, y: Array<Int>) {
		let x = DOK(rows: [x])
		let y = DOK(cols: [y])
		let z = CRS(x) * CRS(y)
		#expect(z.rows == 6)
		#expect(z.cols == 6)
		let w = CRS(z)
		#expect(w.rows == 6)
		#expect(w.cols == 6)
		for (row, col) in product(0..<z.rows, 0..<z.cols) {
			#expect(z[row, col] == x[0, col] * y[row, 0])
			#expect(w[row, col] == x[0, col] * y[row, 0])
		}
	}
}
