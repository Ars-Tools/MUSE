//
//  Arithmetic.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import Numerics
import Testing
import Layout
@testable import Dense
@Suite
struct ArithmeticTestCases {
    @Test
    func mulMat() throws {
        let x = MatBuf(rows: [
            [1.0, 2.0, 3.0],
        ])
        let y = MatBuf(rows: [
            [1.0],
            [2.0],
            [3.0]
        ])
        let z = x * y
        let w = try MatBuf(z)
        for (row, col) in product(0..<3, 0..<3) {
            let u = z[row, col]
            let v = try u[]
            #expect(v == x[0, col] * y[row, 0])
            #expect(w[row, col] == x[0, col] * y[row, 0])
        }
    }
    @Test
    func addMat() throws {
        let x = MatBuf(rows: [
            [1.0, 2.0, 3.0],
        ])
        let y = MatBuf(rows: [
            [1.0],
            [2.0],
            [3.0]
        ])
        let z = x + y
        let w = try MatBuf(z)
        for (row, col) in product(0..<3, 0..<3) {
            let u = z[row, col]
            let v = try u[]
            #expect(v == x[0, col] + y[row, 0])
            #expect(w[row, col] == x[0, col] + y[row, 0])
        }
    }
    @Test
    func divMat() throws {
        let x = MatBuf(rows: [
            [1.0, 2.0, 3.0],
        ])
        let y = MatBuf(rows: [
            [1.0],
            [2.0],
            [4.0]
        ])
        let z = x / y
        let w = try MatBuf(z)
        for (row, col) in product(0..<3, 0..<3) {
            let u = z[row, col]
            let v = try u[]
            #expect(v == x[0, col] / y[row, 0])
            #expect(w[row, col] == x[0, col] / y[row, 0])
        }
    }
    @Test
    func subMat() throws {
        let x = MatBuf(rows: [
            [1.0, 2.0, 3.0],
        ])
        let y = MatBuf(rows: [
            [1.0],
            [2.0],
            [3.0]
        ])
        let z = x - y
        let w = try MatBuf(z)
        for (row, col) in product(0..<3, 0..<3) {
            let u = z[row, col]
            let v = try u[]
            #expect(v == x[0, col] - y[row, 0])
            #expect(w[row, col] == x[0, col] - y[row, 0])
        }
    }
    @Test
    func zmulMat() throws {
        let x = MatBuf(rows: [
            [1.0, 2.0, 3.0],
        ] as [[Complex128]])
        let y = MatBuf(rows: [
            [1.0],
            [2.0],
            [3.0]
        ] as [[Complex128]])
        let z = x * y
        let w = try MatBuf(z)
        for (row, col) in product(0..<3, 0..<3) {
            let u = z[row, col]
            let v = try u[]
            #expect(v == x[0, col] * y[row, 0])
            #expect(w[row, col] == x[0, col] * y[row, 0])
        }
    }
    @Test
    func zaddMat() throws {
        let x = MatBuf(rows: [
            [1.0, 2.0, 3.0],
        ] as [[Complex128]])
        let y = MatBuf(rows: [
            [1.0],
            [2.0],
            [3.0]
        ] as [[Complex128]])
        let z = x + y
        let w = try MatBuf(z)
        for (row, col) in product(0..<3, 0..<3) {
            let u = z[row, col]
            let v = try u[]
            #expect(v == x[0, col] + y[row, 0])
            #expect(w[row, col] == x[0, col] + y[row, 0])
        }
    }
    @Test
    func zdivMat() throws {
        let x = MatBuf(rows: [
            [1.0, 2.0, 3.0],
        ] as [[Complex128]])
        let y = MatBuf(rows: [
            [1.0],
            [2.0],
            [4.0]
        ] as [[Complex128]])
        let z = x / y
        let w = try MatBuf(z)
        print(w)

        for (row, col) in product(0..<3, 0..<3) {
            let u = z[row, col]
            let v = try u[]
            #expect(v == x[0, col] / y[row, 0])
            #expect(w[row, col] == x[0, col] / y[row, 0])
        }
    }
    @Test
    func zsubMat() throws {
        let x = MatBuf(rows: [
            [1.0, 2.0, 3.0],
        ] as [[Complex128]])
        let y = MatBuf(rows: [
            [1.0],
            [2.0],
            [3.0]
        ] as [[Complex128]])
        let z = x - y
        let w = try MatBuf(z)
        for (row, col) in product(0..<3, 0..<3) {
            let u = z[row, col]
            let v = try u[]
            #expect(v == x[0, col] - y[row, 0])
            #expect(w[row, col] == x[0, col] - y[row, 0])
        }
    }
    @Test
    func diviMat() throws {
        let x = MatBuf(rows: [
            [10, 20, 30],
        ] as Array<Array<Int32>>)
        let y = MatBuf(rows: [
            [5],
            [5],
            [5]
        ] as Array<Array<Int32>>)
        let z = x / y
        let w = try MatBuf(z)
        for (row, col) in product(0..<3, 0..<3) {
            let u = z[row, col]
            let v = try u[]
            #expect(v == x[0, col] / y[row, 0])
            #expect(w[row, col] == x[0, col] / y[row, 0])
        }
    }
}
