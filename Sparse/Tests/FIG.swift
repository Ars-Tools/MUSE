//
//  FIG.swift
//  MUSE
//
//  Created by Kota on 9/11/R7.
//
import Testing
@testable import Sparse
@Suite
struct FigureTests {
	@Test
	func pad() {
		let s = CRS(rows: [
			[1, 2],
			[3, 4]
		])
		let t = padding(s, rows: (1, 3), cols: (2, 4))
		let z: some SparseMatrix<Int> = t[1..<4, 1..<4]
		#expect(t.rows == 6)
		#expect(t.cols == 8)
		print(CRS<Int>(t))
		print(z)
		print(CRS<Int>(z))
	}
	@Test
	func vflp() {
		let s = CCS(diagonal: 1, 2, 3, 4)
		let t = flip(s, axis: .rowMajor)
		let c = CCS(t)
		for (row, val) in [1,2,3,4].enumerated() {
			#expect(t[3 - row, row] == val)
			#expect(c[3 - row, row] == val)
		}
	}
	@Test
	func hflp() {
		let s = CCS(diagonal: 1, 2, 3, 4)
		let t = flip(s, axis: .columnMajor)
		let c = CCS(t)
		for (col, val) in [1,2,3,4].enumerated() {
			#expect(t[col, 3 - col] == val)
			#expect(c[col, 3 - col] == val)
		}
	}
}
