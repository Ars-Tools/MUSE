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
        var x = [
            [[1, 2],
             [3, 4]],
            [[5, 6],
             [7, 8]],
        ] as TensorBuffer<Array<Int>>
        print(x)
        print(x[0].transpose)
        print(x.transpose)
        print(x.transpose[0])
//        x[0] = x[1]
//        print(x)
//        print(x.diagonal)
//        print(x)
//        print(x[0])
//        print(x[[0]])
//        print(x)
//        print(x[[0]])
    }
}
