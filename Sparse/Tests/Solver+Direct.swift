//
//  Solver+Direct.swift
//  MUSE
//
//  Created by Kota on 10/2/25.
//
import Testing
import Dense
@testable import Sparse
@Suite
struct SolverDirect {
    @Test
    func qr() throws {
        let A = CRS<Float64>(rows: [
            [2,0],
            [0,3],
        ])
//        let A = CCS<Float64>(cols: [
//            [2,0],
//            [0,3],
//        ])
        let b = [
            [1.0, 3.0, 5.0, 7.0],
            [2.0, 4.0, 6.0, 8.0],
        ] as NDArray<Float64>
        print(b,A,separator: "\r\n")
        let x = solve(qr: A, b: b)
        try print(NDArray(x, for: .rowMajor))
        try print(NDArray(A • x))
    }
}
