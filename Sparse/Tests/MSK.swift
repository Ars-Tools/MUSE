//
//  MSK.swift
//  MUSE
//
//  Created by Kota on 9/10/R7.
//
import Testing
@testable import Sparse
@Suite
struct MSKTestCases {
	@Test
	func create() {
		var m = MSK(shape: (3, 3))
		#expect(m.isEmpty)
		m[0, 0] = true
		m[0, 1] = true
		#expect(m.state.count == 2)
		m[0, 0] = false
		m[0, 1] = true
		#expect(m.state.count == 1)
	}
	@Test
	func convert() {
		let ccs = CCS(cols: [
			[0.0, .ulpOfOne],
			[0.0, .nan]
		])
		#expect(ccs[1, 1] == .zero)
		#expect(ccs[1, 0] != .zero)
		let msk = MSK(ccs)
		print(msk.state)
		print(msk)
	}
}

