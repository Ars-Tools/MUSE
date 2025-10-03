//
//  Solver+Multiply.swift
//  MUSE
//
//  Created by Kota on 9/29/25.
//
import Testing
import Dense
@testable import Sparse
@Suite
struct SolverMultiply {
    @Test
    func sd() throws {
        let A = CRS<Float64>(rows: [
            [1,2],
            [4,5],
            [3,6]
        ])
        print(A[0..<0, 0...].rowStart, A[0..<0, 0...].colIndex, A[0..<0, 0...].valArray)
        print(Array(A[0..<0, 0...].lil(for: .columnMajor).1))
        let x = [
            [1.0, 2.0, 5.0],
            [3.0, 4.0, 6.0],
        ] as NDArray<Float64>
        let y = A • x
        print(y)
        try print(NDArray(y))
        print(y[[0]])
        try print(NDArray(y[[0]]))
    }
    @Test
    func ds() throws {
        let x = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0]
        ] as NDArray<Float64>
        let A = CCS<Float64>(cols: [
            [7,8,9],
            [0,1,2],
        ])
        let y = Sparse.Solver.DS(order: .default, x: x, y: A)
        try print(NDArray(y))
        print(y[[0]])
        let z = try NDArray(y[[0]])
        print(z)
    }
}
