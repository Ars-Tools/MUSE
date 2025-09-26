//
//  BLAS.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import Numerics
import Testing
import Layout
@testable import Dense
@Suite
struct BLASTestCases {
    @Test
    func inner() throws {
        let X = [0.0, 1.0, 2.0, 3.0]
        let Y = [0.0, 1.0, 2.0, 3.0]
        let x = VecBuf(X)
        let y = VecBuf(Y)
        let z = x • y
        let w = try z[]
        #expect(w == zip(X, Y).lazy.map(*).reduce(0, +))
    }
    @Test
    func outer() throws {
        let X = [1.0, 1.0, 2.0, 3.0]
        let Y = [2.0, 3.0, 5.0, 7.0]
        let x = VecBuf(X)
        let y = VecBuf(Y)
        let z = Dense.outer(x, y)
        let w = try MatBuf(z)
        for (row, col) in product(0..<4, 0..<4) {
            let v = try z[row, col][]
            #expect(x[row] * y[col] == v)
            #expect(x[row] * y[col] == w[row, col])
        }
    }
    @Test
    func mvr() throws {
        let rows = [
            [1, 2, 3, 4],
            [5, 6, 7, 8],
        ] as Array<Array<Float64>>
        let vec = [
            1, 2, 3, 4
        ] as Array<Float64>
        let x = MatBuf(rows: rows)
        let y = VecBuf(vec)
        let z = x • y
        #expect(z.count == 2)
        let w = try VecBuf(z)
        for (k, v) in w.enumerated() {
            let u = try z[k][]
            let w = zip(rows[k], vec).map(*).reduce(0, +)
            #expect(u == w)
            #expect(v == w)
        }
    }
    @Test
    func mvc() throws {
        let cols = [
            [1, 2, 3, 4],
            [5, 6, 7, 8],
        ] as Array<Array<Float64>>
        let vec = [
            1, 2
        ] as Array<Float64>
        let x = MatBuf(cols: cols)
        let y = VecBuf(vec)
        let z = x • y
        #expect(z.count == 4)
        let w = try VecBuf(z)
        for (k, v) in w.enumerated() {
            let u = try z[k][]
            let w = vec.enumerated().map { (cols[$0][k], $1) }.map(*).reduce(0, +)
            #expect(v == w)
            #expect(u == w)
        }
    }
    @Test
    func vmr() throws {
        let vec = [
            1, 2
        ] as Array<Float64>
        let rows = [
            [1, 2, 3, 4],
            [5, 6, 7, 8],
        ] as Array<Array<Float64>>
        let x = VecBuf(vec)
        let y = MatBuf(rows: rows)
        let z = x • y
        #expect(z.count == 4)
        let w = try VecBuf(z)
        for (k, v) in w.enumerated() {
            let u = try z[k][]
            let w = vec.enumerated().map { (rows[$0][k], $1) }.map(*).reduce(0, +)
            #expect(v == w)
            #expect(u == w)
        }
    }
    @Test
    func vmc() throws {
        let vec = [
            1, 2, 3, 4
        ] as Array<Float64>
        let cols = [
            [1, 2, 3, 4],
            [5, 6, 7, 8],
        ] as Array<Array<Float64>>
        let x = VecBuf(vec)
        let y = MatBuf(cols: cols)
        let z = x • y
        #expect(z.count == 2)
        let w = try VecBuf(z)
        for (k, v) in w.enumerated() {
            let u = try z[k][]
            let w = zip(cols[k], vec).map(*).reduce(0, +)
            #expect(u == w)
            #expect(v == w)
        }
    }
    @Test(arguments: [
        (4, 3, 7)
    ])
    func mmrr(shape: (Int, Int, Int)) throws {
        var x = MatBuf<Float64>(shape: (shape.0, shape.1), for: .rowMajor, with: .zero)
        var y = MatBuf<Float64>(shape: (shape.1, shape.2), for: .rowMajor, with: .zero)
        let r = (-12..<12).map(Float64.init) as Array<Float64>
        for (row, col) in product(0..<x.rows, 0..<x.cols) {
            x[row, col] = r.randomElement() ?? .zero
        }
        for (row, col) in product(0..<y.rows, 0..<y.cols) {
            y[row, col] = r.randomElement() ?? .zero
        }
        let z = x • y
        #expect(z.rows == shape.0)
        #expect(z.cols == shape.2)
        let w = try MatBuf(z)
        for (row, col) in product(0..<w.rows, 0..<w.cols) {
            let u = try z[row, col][]
            let v = try (x[row, 0...] • y[0..., col])[]
            #expect(w[row, col] == u)
            #expect(w[row, col] == v)
        }
        for row in 0..<w.rows {
            let u = try z[0..., 0][row][]
            #expect(w[row, 0] == u)
        }
        for col in 0..<w.cols {
            let u = try z[0, 0...][col][]
            #expect(w[0, col] == u)
        }
//        for idx in 0..<min(w.rows, w.cols) {
//            let u = try z.diagonal[idx][]
//            #expect(w[idx, idx] == u)
//        }
    }
    @Test(arguments: [
        (4, 3, 7)
    ])
    func mmrc(shape: (Int, Int, Int)) throws {
        var x = MatBuf<Float64>(shape: (shape.0, shape.1), for: .rowMajor, with: .zero)
        var y = MatBuf<Float64>(shape: (shape.1, shape.2), for: .columnMajor, with: .zero)
        let r = (-12..<12).map(Float64.init) as Array<Float64>
        for (row, col) in product(0..<x.rows, 0..<x.cols) {
            x[row, col] = r.randomElement() ?? .zero
        }
        for (row, col) in product(0..<y.rows, 0..<y.cols) {
            y[row, col] = r.randomElement() ?? .zero
        }
        let z = x • y
        #expect(z.rows == shape.0)
        #expect(z.cols == shape.2)
        let w = try MatBuf(z)
        for (row, col) in product(0..<w.rows, 0..<w.cols) {
            let u = try z[row, col][]
            let v = try (x[row, 0...] • y[0..., col])[]
            #expect(w[row, col] == u)
            #expect(w[row, col] == v)
        }
        for row in 0..<w.rows {
            let u = try z[0..., 0][row][]
            #expect(w[row, 0] == u)
        }
        for col in 0..<w.cols {
            let u = try z[0, 0...][col][]
            #expect(w[0, col] == u)
        }
//        for idx in 0..<min(w.rows, w.cols) {
//            let u = try z.diagonal[idx][]
//            #expect(w[idx, idx] == u)
//        }
    }
    @Test(arguments: [
        (4, 3, 7)
    ])
    func mmcr(shape: (Int, Int, Int)) throws {
        var x = MatBuf<Float64>(shape: (shape.0, shape.1), for: .columnMajor, with: .zero)
        var y = MatBuf<Float64>(shape: (shape.1, shape.2), for: .rowMajor, with: .zero)
        let r = (-12..<12).map(Float64.init) as Array<Float64>
        for (row, col) in product(0..<x.rows, 0..<x.cols) {
            x[row, col] = r.randomElement() ?? .zero
        }
        for (row, col) in product(0..<y.rows, 0..<y.cols) {
            y[row, col] = r.randomElement() ?? .zero
        }
        let z = x • y
        #expect(z.rows == shape.0)
        #expect(z.cols == shape.2)
        let w = try MatBuf(z)
        for (row, col) in product(0..<w.rows, 0..<w.cols) {
            let u = try z[row, col][]
            let v = try (x[row, 0...] • y[0..., col])[]
            #expect(w[row, col] == u)
            #expect(w[row, col] == v)
        }
        for row in 0..<w.rows {
            let u = try z[0..., 0][row][]
            #expect(w[row, 0] == u)
        }
        for col in 0..<w.cols {
            let u = try z[0, 0...][col][]
            #expect(w[0, col] == u)
        }
//        for idx in 0..<min(w.rows, w.cols) {
//            let u = try z.diagonal[idx][]
//            #expect(w[idx, idx] == u)
//        }
    }
    @Test(arguments: [
        (4, 3, 7)
    ])
    func mmcc(shape: (Int, Int, Int)) throws {
        var x = MatBuf<Float64>(shape: (shape.0, shape.1), for: .columnMajor, with: .zero)
        var y = MatBuf<Float64>(shape: (shape.1, shape.2), for: .columnMajor, with: .zero)
        let r = (-12..<12).map(Float64.init) as Array<Float64>
        for (row, col) in product(0..<x.rows, 0..<x.cols) {
            x[row, col] = r.randomElement() ?? .zero
        }
        for (row, col) in product(0..<y.rows, 0..<y.cols) {
            y[row, col] = r.randomElement() ?? .zero
        }
        let z = x • y
        #expect(z.rows == shape.0)
        #expect(z.cols == shape.2)
        let w = try MatBuf(z)
        for (row, col) in product(0..<w.rows, 0..<w.cols) {
            let u = try z[row, col][]
            let v = try (x[row, 0...] • y[0..., col])[]
            #expect(w[row, col] == u)
            #expect(w[row, col] == v)
        }
        for row in 0..<w.rows {
            let u = try z[0..., 0][row][]
            #expect(w[row, 0] == u)
        }
        for col in 0..<w.cols {
            let u = try z[0, 0...][col][]
            #expect(w[0, col] == u)
        }
//        for idx in 0..<min(w.rows, w.cols) {
//            let u = try z.diagonal[idx][]
//            #expect(w[idx, idx] == u)
//        }
    }
    @Test
    func tt() throws {
        let x = [
            [1.0, 1.0, 1.0],
            [4.0, 5.0, 6.0],
        ] as NDArray
        let y = [
            [2.0, 9.0, 9.0],
            [5.0, 9.0, 7.0],
        ] as NDArray
        
        let z = x • y
        let w = try NDArray(z)
        print(w)
        try print(NDArray(z[[0, 2]], for: .rowMajor))
        
    }
}
