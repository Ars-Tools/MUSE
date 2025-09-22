//
//  LinAlg.swift
//  MUSE
//
//  Created by Kota on 9/19/R7.
//
import Numerics
import Testing
import Layout
@testable import Dense
@Suite
struct LAPACKTestCases {
	@Test
	func inv() throws {
		let x = MatBuf<Float64>(rows: [
			[3, 2, 1],
			[6, 5, 4],
			[7, 8, 9]
		])
        let lu = try LAPACK.LU(decompose: x)
        print(lu.l, lu.u, separator: "\r\n")
        print(lu.ipivot.enumerated().reduce(into: [0, 1, 2]) {
            $0.swapAt($1.0, $1.1-1)
        })
	}
}
