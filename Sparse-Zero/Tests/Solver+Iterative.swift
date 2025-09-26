//
//  Solver+Iterative.swift
//  MUSE
//
//  Created by Kota on 9/25/25.
//

import Accelerate
import Testing
import Dense
import Numerics
import Layout
@testable import Sparse
@Suite
struct SolverIterativeTestCases {
    @Test
    func lsmr() {
        let A = CRS<Float32>(rows: [
            [3, 2, 1],
            [0, 9, 2],
            [8, 0, 6],
            [0, 0, 3],
        ])
        let solver = Solver.Iterative(A)
        let y = MatBuf<Float32>(rows: [
    [2, 4],
    [1, 3],
    [5, 9],
    [4, 2],
        ])
        print(A)
        print(y)
        let x = solver.solve(y: y)
        print(x)
    }
}
