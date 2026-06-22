//
//  vFORCE.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import Testing
import Numerics
import AltVec
@testable import Dense
@Suite
struct vFORCEComplex64 {
    func single(count: Int,
                range: ClosedRange<Float32> = -1.0 ... 1.0,
                tolerance: Complex64.Magnitude = .ulpOfOne.squareRoot(),
                expect: (Complex64.RawValue) -> Complex64.RawValue,
                test: (VecBuf<Complex64>) throws -> some InstantVector<Complex64>) throws {
        let r = repeatElement(range, count: count).map(Float32.random(in:))
        let i = repeatElement(range, count: count).map(Float32.random(in:))
        let x = zip(r, i).map(Complex64.init(real:imag:))
        let y = try VecBuf(test(VecBuf(x)))
        let z = x.lazy.map(\.rawValue).map(expect).map(Complex64.init(rawValue:))
        #expect(y.count == z.count)
        #expect(zip(y, z).lazy.map(-).map(\.magnitude).allSatisfy { $0 < tolerance })
    }
    func double(count: Int,
                range: ClosedRange<Float64> = -1.0 ... 1.0,
                tolerance: Complex128.Magnitude = .ulpOfOne.squareRoot(),
                expect: (Complex128.RawValue) -> Complex128.RawValue,
                test: (VecBuf<Complex128>) throws -> some InstantVector<Complex128>) throws {
        let r = repeatElement(range, count: count).map(Float64.random(in:))
        let i = repeatElement(range, count: count).map(Float64.random(in:))
        let x = zip(r, i).map(Complex128.init(real:imag:))
        let y = try VecBuf(test(VecBuf(x)))
        let z = x.lazy.map(\.rawValue).map(expect).map(Complex128.init(rawValue:))
//        print(x, y, z, separator: "\r\n")
        #expect(y.count == z.count)
        #expect(zip(y, z).lazy.map(-).map(\.magnitude).allSatisfy { $0 < tolerance })
    }
    @Test
    func exp() throws {
        try single(count: 16, expect: complex_exp, test: Dense.exp)
        try double(count: 16, expect: complex_exp, test: Dense.exp)
    }
    @Test
    func log() throws {
        try single(count: 16, expect: complex_log, test: Dense.log)
        try double(count: 16, expect: complex_log, test: Dense.log)
    }
    @Test
    func sqrt() throws {
        try single(count: 16, expect: complex_sqrt, test: Dense.sqrt)
        try double(count: 16, expect: complex_sqrt, test: Dense.sqrt)
    }
    @Test
    func sin() throws {
        try single(count: 16, expect: complex_sin, test: Dense.sin)
        try double(count: 16, expect: complex_sin, test: Dense.sin)
    }
    @Test
    func cos() throws {
        try single(count: 16, expect: complex_cos, test: Dense.cos)
        try double(count: 16, expect: complex_cos, test: Dense.cos)
    }
    @Test
    func tan() throws {
        try single(count: 16, expect: complex_tan, test: Dense.tan)
        try double(count: 16, expect: complex_tan, test: Dense.tan)
    }
    @Test
    func sinh() throws {
        try single(count: 16, expect: complex_sinh, test: Dense.sinh)
        try double(count: 16, expect: complex_sinh, test: Dense.sinh)
    }
    @Test
    func cosh() throws {
        try single(count: 16, expect: complex_cosh, test: Dense.cosh)
        try double(count: 16, expect: complex_cosh, test: Dense.cosh)
    }
    @Test
    func tanh() throws {
        try single(count: 16, expect: complex_tanh, test: Dense.tanh)
        try double(count: 16, expect: complex_tanh, test: Dense.tanh)
    }
    @Test
    func asin() throws {
        try single(count: 16, expect: complex_asin, test: Dense.asin)
        try double(count: 16, expect: complex_asin, test: Dense.asin)
    }
    @Test
    func acos() throws {
        try single(count: 16, expect: complex_acos, test: Dense.acos)
        try double(count: 16, expect: complex_acos, test: Dense.acos)
    }
    @Test
    func atan() throws {
        try single(count: 16, expect: complex_atan, test: Dense.atan)
        try double(count: 16, expect: complex_atan, test: Dense.atan)
    }
    @Test
    func asinh() throws {
        try single(count: 16, expect: complex_acos, test: Dense.acos)
        try double(count: 16, expect: complex_asinh, test: Dense.asinh)
    }
    @Test
    func acosh() throws {
        try single(count: 16, expect: complex_acos, test: Dense.acos)
        try double(count: 16, expect: complex_acosh, test: Dense.acosh)
    }
    @Test
    func atanh() throws {
        try single(count: 16, expect: complex_acos, test: Dense.acos)
        try double(count: 16, expect: complex_atanh, test: Dense.atanh)
    }
}
