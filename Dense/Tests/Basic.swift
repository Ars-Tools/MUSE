//
//  Basic.swift
//  MUSE
//
//  Created by Kota on 10/4/25.
//
import Testing
import func Layout.product
@testable import Dense
@Suite
struct BasicTests {
    @Test
    func transpose() throws {
        let x = [
            [1, 2, 3],
            [4, 5, 6]
        ] as MatBuf<Int>
        let y = Basic<Int>.Transpose(source: x)
        let z = try MatBuf(y)
        #expect((x.rows, x.cols) == (y.cols, y.rows))
        for (row, col) in product(0..<x.rows, 0..<x.cols) {
            #expect(x[row, col] == y[col, row])
            #expect(x[row, col] == z[col, row])
        }
        for row in 0..<x.rows {
            #expect(x[row, 0...][0] == y[0..., row][0])
        }
        for col in 0..<x.cols {
            #expect(x[0..., col][0] == y[col, 0...][0])
        }
    }
    @Test
    func slice() throws {
        let x = [
            [1, 2, 3],
            [4, 5, 6]
        ] as MatBuf<Int>
        let y = Basic<Int>.Slice(source: x, order: .rowMajor, slice: [0..<2, 1..<3])
        let z = try MatBuf(y)
        #expect((y.rows, y.cols) == (2, 2))
        for (row, col) in product(0..<2, 0..<2) {
            #expect(x[row, col+1] == y[row, col])
            #expect(x[row, col+1] == z[row, col])
        }
//        print(x, z)
        let w = y[0..., 0]
//        print(w)
//        print(y.shape, w.shape)
        #expect(w.count == 2)
        #expect(w[0] == 2)
        #expect(w[1] == 5)
    }
}
