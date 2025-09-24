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
    func LUsolveVec() throws {
        let A = MatBuf<Float64>(rows: [
            [3, 2, 1],
            [4, 0, 9],
            [9, 8, 7]
        ])
        let solver = try LAPACK.LU(factorize: A)
        let b = [1, 2, 3] as VecBuf<Float64>
        let x = solver.solve(y: b)
        let Δ = (b - A • x).magnitude
        #expect(Δ.count == b.count)
        for idx in 0..<Δ.count {
            try #expect(Δ[idx][] <= .ulpOfOne.squareRoot())
        }
    }
    @Test
    func LUsolveMat() throws {
        let A = MatBuf<Float64>(rows: [
            [3, 2, 1],
            [4, 0, 9],
            [9, 8, 7]
        ])
        let solver = try LAPACK.LU(factorize: A)
        let b = MatBuf<Float64>(rows: [
            repeatElement(-12.0 ... 12.0, count: 3).map(Float64.random(in:)),
            repeatElement(-12.0 ... 12.0, count: 3).map(Float64.random(in:)),
            repeatElement(-12.0 ... 12.0, count: 3).map(Float64.random(in:))
        ] as Array<Array<Float64>>)
        let x = solver.solve(y: b)
        let Δ = (b - A • x).magnitude
        #expect((Δ.rows, Δ.cols) == (b.rows, b.cols))
        for (row, col) in product(0..<Δ.rows, 0..<Δ.cols) {
            try #expect(Δ[row, col][] <= .ulpOfOne.squareRoot())
        }
    }
}
