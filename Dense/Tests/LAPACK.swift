//
//  LAPACK.swift
//  MUSE
//
//  Created by Kota on 10/1/25.
//
import Numerics
import Testing
import Layout
@testable import Dense
@Suite
struct LAPACKTestCases {
    @Test
    func LUSolve() throws {
        let A = MatBuf<Float64>(rows: [
            [1, 1, 1],
            [0, 2, 2],
            [0, 0, 3],
        ])
        let solver = try LAPACK<Float64>.LU(factorize: A)
        print(solver.inv)
        let b = [
            [1.0, 2.0, 6.0],
            [2.0, 3.0, 4.0],
            [2.0, 5.0, 8.0],
        ] as NDArray<Float64>
        let x = try solver.solve(b: .init(b))
        print(x)
    }
}
