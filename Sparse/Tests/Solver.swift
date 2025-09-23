//
//  Solver.swift
//  MUSE
//
//  Created by Kota on 9/22/25.
//
import Accelerate
import Testing
import Dense
import Numerics
import Layout
@testable import Sparse
@Suite
struct SolverTestCases {
    typealias Element = Float32
    func random(in range: some RangeExpression<Int>) -> Element {
        .init(Int.random(in: range.relative(to: Int.min..<Int.max)))
    }
    // MARK: SD
    @Test(arguments: [
        (1, 1),
        (1, 2),
        (9, 1),
        (9, 2),
    ])
    func sdi(n: Int, s: Int) throws {
        var x = SPV<Element>(count: n, store: .init())
        var y = VecBuf<Element>(shape: n, stride: s, data: .init(repeating: .zero, count: s * n))
        var r = 0 as Element
        for k in 0..<n {
            x[k] = random(in: -12...12)
            y[k] = random(in: -12...12)
            r += x[k] * y[k]
        }
        let z = Solver.SDI(x: x, y: y)
        let w = try z[]
        #expect(w == r)
    }
    @Test(arguments: [
        (4, 7, 1),
        (4, 7, 2),
        (7, 5, 1),
        (7, 5, 2),
    ])
    func sdmv(m: Int, k: Int, s: Int) throws {
        do { // CCS
            var x = CCS<Element>(shape: (m, k))
            var y = VecBuf<Element>(shape: k, stride: s, data: .init(repeating: .zero, count: s * k))
            for i in 0..<k {
                for j in 0..<m {
                    x[j, i] = random(in: -12...12)
                }
                y[i] = random(in: -12...12)
            }
            let z = Solver.SDMV(x: x, y: y)
            let w = try VecBuf(z)
            #expect(w.count == m)
            for i in 0..<m {
                let u = (0..<k).reduce(0 as Element) {
                    $0 + x[i, $1] * y[$1]
                }
                let v = try z[i][]
                #expect(u == v)
                #expect(u == w[i])
            }
        }
        do { // CRS
            var x = CRS<Element>(shape: (m, k))
            var y = VecBuf<Element>(shape: k, stride: s, data: .init(repeating: .zero, count: s * k))
            for i in 0..<k {
                for j in 0..<m {
                    x[j, i] = random(in: -12...12)
                }
                y[i] = random(in: -12...12)
            }
            let z = Solver.SDMV(x: x, y: y)
            let w = try VecBuf(z)
            #expect(w.count == m)
            for i in 0..<m {
                let u = (0..<k).reduce(0 as Element) {
                    $0 + x[i, $1] * y[$1]
                }
                let v = try z[i][]
                #expect(u == v)
                #expect(u == w[i])
            }
        }
    }
    @Test(arguments: [
        (4, 7, MemoryStrategy.rowMajor),
        (4, 7, MemoryStrategy.columnMajor),
        (7, 5, MemoryStrategy.rowMajor),
        (7, 5, MemoryStrategy.columnMajor),
    ])
    func sdvm(n: Int, k: Int, s: MemoryStrategy) throws {
        var x = SPV<Element>(count: k, store: .init())
        var y = MatBuf<Element>(shape: (k, n), for: s, with: .zero)
        for i in 0..<k {
            for j in 0..<n {
                y[i, j] = random(in: -12...12)
            }
            x[i] = random(in: -12...12)
        }
        let z = Solver.SDVM(x: x, y: y)
        let w = try VecBuf(z)
        #expect(w.count == n)
        for i in 0..<n {
            let u = (0..<k).reduce(0 as Element) {
                $0 + x[$1] * y[$1, i]
            }
            let v = try z[i][]
            #expect(u == v)
            #expect(u == w[i])
        }
    }
    @Test(arguments: [
        (3, 7, 5, MemoryStrategy.rowMajor, MemoryStrategy.rowMajor),
        (3, 7, 5, MemoryStrategy.columnMajor, MemoryStrategy.rowMajor),
        (3, 7, 5, MemoryStrategy.rowMajor, MemoryStrategy.columnMajor),
        (3, 7, 5, MemoryStrategy.columnMajor, MemoryStrategy.columnMajor),
    ])
    func sdmm(m: Int, n: Int, k: Int, s: MemoryStrategy, t:  MemoryStrategy) throws {
        do { // CCS
            var x = CCS<Element>(shape: (m, k))
            var y = MatBuf<Element>(shape: (k, n), for: s, with: .zero)
            for k in 0..<k {
                for m in 0..<m {
                    x[m, k] = random(in: -12...12)
                }
                for n in 0..<n {
                    y[k, n] = random(in: -12...12)
                }
            }
            let z = Solver.SDMM(x: x, y: y)
            let w = try MatBuf(z, for: t)
            #expect(w.rows == m)
            #expect(w.cols == n)
            for (m, n) in product(0..<m, 0..<n) {
                let u = (0..<k).reduce(0 as Element) {
                    $0 + x[m, $1] * y[$1, n]
                }
                let v = try z[m, n][]
                let r = try z[m, 0...][n][]
                let c = try z[0..., n][m][]
                #expect(u == v)
                #expect(u == r)
                #expect(u == c)
                #expect(u == w[m, n])
            }
        }
        do { // CRS
            var x = CRS<Element>(shape: (m, k))
            var y = MatBuf<Element>(shape: (k, n), for: s, with: .zero)
            for k in 0..<k {
                for m in 0..<m {
                    x[m, k] = random(in: -12...12)
                }
                for n in 0..<n {
                    y[k, n] = random(in: -12...12)
                }
            }
            let z = Solver.SDMM(x: x, y: y)
            let w = try MatBuf(z, for: t)
            #expect(w.rows == m)
            #expect(w.cols == n)
            for (m, n) in product(0..<m, 0..<n) {
                let u = (0..<k).reduce(0 as Element) {
                    $0 + x[m, $1] * y[$1, n]
                }
                let v = try z[m, n][]
                let r = try z[m, 0...][n][]
                let c = try z[0..., n][m][]
                #expect(u == v)
                #expect(u == r)
                #expect(u == c)
                #expect(u == w[m, n])
            }
        }
    }
    // MARK: DS
    @Test(arguments: [
        (1, 1),
        (1, 2),
        (9, 1),
        (9, 2),
    ])
    func dsi(n: Int, s: Int) throws {
        var x = VecBuf<Element>(shape: n, stride: s, data: .init(repeating: .zero, count: s * n))
        var y = SPV<Element>(count: n, store: .init())
        var r = 0 as Element
        for k in 0..<n {
            x[k] = random(in: -12...12)
            y[k] = random(in: -12...12)
            r += x[k] * y[k]
        }
        let z = Solver.DSI(x: x, y: y)
        let w = try z[]
        #expect(w == r)
    }
    @Test(arguments: [
        (4, 7, MemoryStrategy.rowMajor),
        (4, 7, MemoryStrategy.columnMajor),
        (7, 5, MemoryStrategy.rowMajor),
        (7, 5, MemoryStrategy.columnMajor),
    ])
    func dsmv(m: Int, k: Int, s: MemoryStrategy) throws {
        var x = MatBuf<Element>(shape: (m, k), for: s, with: .zero)
        var y = SPV<Element>(count: k, store: .init())
        for i in 0..<k {
            for j in 0..<m {
                x[j, i] = random(in: -12...12)
            }
            y[i] = random(in: -12...12)
        }
        let z = Solver.DSMV(x: x, y: y)
        let w = try VecBuf(z)
        #expect(w.count == m)
        for i in 0..<m {
            let u = (0..<k).reduce(0 as Element) {
                $0 + x[i, $1] * y[$1]
            }
            let v = try z[i][]
            #expect(u == v)
            #expect(u == w[i])
        }
    }
    @Test(arguments: [
        (4, 7, 1),
        (4, 7, 2),
        (7, 5, 1),
        (7, 5, 2),
    ])
    func dsvm(n: Int, k: Int, s: Int) throws {
        var x = VecBuf<Element>(shape: k, stride: s, data: .init(repeating: .zero, count: k * s))
        var y = CCS<Element>(shape: (k, n))
        for i in 0..<k {
            for j in 0..<n {
                y[i, j] = random(in: -12...12)
            }
            x[i] = random(in: -12...12)
        }
        let z = Solver.DSVM(x: x, y: y)
        let w = try VecBuf(z)
        #expect(w.count == n)
        for i in 0..<n {
            let u = (0..<k).reduce(0 as Element) {
                $0 + x[$1] * y[$1, i]
            }
            let v = try z[i][]
            #expect(u == v)
            #expect(u == w[i])
        }
    }
    @Test(arguments: [
        (3, 7, 5, MemoryStrategy.rowMajor, MemoryStrategy.rowMajor),
        (3, 7, 5, MemoryStrategy.columnMajor, MemoryStrategy.rowMajor),
        (3, 7, 5, MemoryStrategy.rowMajor, MemoryStrategy.columnMajor),
        (3, 7, 5, MemoryStrategy.columnMajor, MemoryStrategy.columnMajor),
    ])
    func dsmm(m: Int, n: Int, k: Int, s: MemoryStrategy, t:  MemoryStrategy) throws {
        do { // CCS
            var x = MatBuf<Element>(shape: (m, k), for: s, with: .zero)
            var y = CCS<Element>(shape: (k, n))
            for k in 0..<k {
                for m in 0..<m {
                    x[m, k] = random(in: -12...12)
                }
                for n in 0..<n {
                    y[k, n] = random(in: -12...12)
                }
            }
            let z = Solver.DSMM(x: x, y: y)
            let w = try MatBuf(z, for: t)
            #expect(w.rows == m)
            #expect(w.cols == n)
            for (m, n) in product(0..<m, 0..<n) {
                let u = (0..<k).reduce(0 as Element) {
                    $0 + x[m, $1] * y[$1, n]
                }
                let v = try z[m, n][]
                let r = try z[m, 0...][n][]
                let c = try z[0..., n][m][]
                #expect(u == v)
                #expect(u == r)
                #expect(u == c)
                #expect(u == w[m, n])
            }
        }
        do { // CRS
            var x = MatBuf<Element>(shape: (m, k), for: s, with: .zero)
            var y = CRS<Element>(shape: (k, n))
            for k in 0..<k {
                for m in 0..<m {
                    x[m, k] = random(in: -12...12)
                }
                for n in 0..<n {
                    y[k, n] = random(in: -12...12)
                }
            }
            let z = Solver.DSMM(x: x, y: y)
            let w = try MatBuf(z, for: t)
            #expect(w.rows == m)
            #expect(w.cols == n)
            for (m, n) in product(0..<m, 0..<n) {
                let u = (0..<k).reduce(0 as Element) {
                    $0 + x[m, $1] * y[$1, n]
                }
                let v = try z[m, n][]
                let r = try z[m, 0...][n][]
                let c = try z[0..., n][m][]
                #expect(u == v)
                #expect(u == r)
                #expect(u == c)
                #expect(u == w[m, n])
            }
        }
    }
}
