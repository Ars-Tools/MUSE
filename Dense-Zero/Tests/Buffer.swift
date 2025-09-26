//
//  Buffer.swift
//  MUSE
//
//  Created by Kota on 9/21/25.
//
import Numerics
import Testing
import Layout
@testable import Dense
@Suite
struct BuuferTestCases {
    @Test
    func tensor() throws {
        let x = [
            [[1, 2],
             [3, 4]],
            [[5, 6],
             [7, 8]],
        ] as TensorBuffer<Array<Int>>
        #expect(x[[0, 0, 1]][] == 2)
        #expect(x[[1, 1, 0]][] == 7)
    }
    @Test
    func slice() throws {
        let x = MatBuf(rows: [
            [1,2,3],
            [4,5,6],
            [7,8,9],
        ])
        let y = Basic.Slice(source: x, order: .rowMajor, slice: [0..<3, 0..<3])[1, 0..<2]
        let z = try VecBuf(y)
        #expect(z[0] == x[1, 0])
        #expect(z[1] == x[1, 1])
    }
}
