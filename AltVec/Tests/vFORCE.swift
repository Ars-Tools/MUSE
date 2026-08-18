//
//  vFORCE.swift
//  MUSE
//
//  Created by Kota on 8/18/26.
//
import Testing
import MKL
import Complex
import Numerics
@testable import AltVec
@Suite
struct vFORCETestCases {
    func eval(query: Array<Float32>, expect: (Float32) -> Float32, result: (UnsafePointer<Float32>, Int, UnsafeMutablePointer<Float32>, Int, Int) -> Void) {
        let expect = query.map(expect)
        let result = Array<Float32>(unsafeUninitializedCapacity: query.count) {
            result(query, 1, $0.baseAddress.unsafelyUnwrapped, 1, $0.count)
            $1 = $0.count
        }
        #expect(expect.count == result.count)
        #expect(zip(expect, result).map(-).map(\.magnitude).allSatisfy { $0.isLess(than: .ulpOfOne.squareRoot()) })
    }
    func eval(query: Array<Float64>, expect: (Float64) -> Float64, result: (UnsafePointer<Float64>, Int, UnsafeMutablePointer<Float64>, Int, Int) -> Void) {
        let expect = query.map(expect)
        let result = Array<Float64>(unsafeUninitializedCapacity: query.count) {
            result(query, 1, $0.baseAddress.unsafelyUnwrapped, 1, $0.count)
            $1 = $0.count
        }
        #expect(expect.count == result.count)
        #expect(zip(expect, result).map(-).map(\.magnitude).allSatisfy { $0.isLess(than: .ulpOfOne.squareRoot()) })
    }
    func eval(query: Array<Complex64>, expect: (complex64_t) -> complex64_t, result: (UnsafePointer<Complex64>, Int, UnsafeMutablePointer<Complex64>, Int, Int) -> Void) {
        let expect = query.map(\.rawValue).map(expect).map(Complex64.init(rawValue:))
        let result = Array<Complex64>(unsafeUninitializedCapacity: query.count) {
            result(query, 1, $0.baseAddress.unsafelyUnwrapped, 1, $0.count)
            $1 = $0.count
        }
        #expect(expect.count == result.count)
        #expect(zip(expect, result).map(-).map(\.magnitudeSquared).allSatisfy { $0.isLess(than: .ulpOfOne.squareRoot()) })
    }
    func eval(query: Array<Complex128>, expect: (complex128_t) -> complex128_t, result: (UnsafePointer<Complex128>, Int, UnsafeMutablePointer<Complex128>, Int, Int) -> Void) {
        let expect = query.map(\.rawValue).map(expect).map(Complex128.init(rawValue:))
        let result = Array<Complex128>(unsafeUninitializedCapacity: query.count) {
            result(query, 1, $0.baseAddress.unsafelyUnwrapped, 1, $0.count)
            $1 = $0.count
        }
        #expect(expect.count == result.count)
        #expect(zip(expect, result).map(-).map(\.magnitudeSquared).allSatisfy { $0.isLess(than: .ulpOfOne.squareRoot()) })
    }
    @Test(
        arguments: [1024]
    )
    func sin(count: Int) {
        do {
            let r = repeatElement(0.0 ... 1.0, count: count).map(Float32.random(in:))
            eval(query: r, expect: Darwin.sinf, result: Float32.sin)
        }
        do {
            let r = repeatElement(0.0 ... 1.0, count: count).map(Float64.random(in:))
            eval(query: r, expect: Darwin.sin, result: Float64.sin)
        }
        do {
            let r = repeatElement(0.0 ... 1.0, count: count).map(Float32.random(in:))
            let i = repeatElement(0.0 ... 1.0, count: count).map(Float32.random(in:))
            let z = zip(r, i).map(Complex64.init(real:imag:))
            eval(query: z, expect: libcsin, result: Complex64.sin)
        }
        do {
            let r = repeatElement(0.0 ... 1.0, count: count).map(Float64.random(in:))
            let i = repeatElement(0.0 ... 1.0, count: count).map(Float64.random(in:))
            let z = zip(r, i).map(Complex128.init(real:imag:))
            eval(query: z, expect: libcsin, result: Complex128.sin)
        }
    }
    @Test(
        arguments: [1024]
    )
    func acos(count: Int) {
        do {
            let r = repeatElement(0.0 ... 1.0, count: count).map(Float32.random(in:))
            eval(query: r, expect: Darwin.acosf, result: Float32.acos)
        }
        do {
            let r = repeatElement(0.0 ... 1.0, count: count).map(Float64.random(in:))
            eval(query: r, expect: Darwin.acos, result: Float64.acos)
        }
        do {
            let r = repeatElement(0.0 ... 1.0, count: count).map(Float32.random(in:))
            let i = repeatElement(0.0 ... 1.0, count: count).map(Float32.random(in:))
            let z = zip(r, i).map(Complex64.init(real:imag:))
            eval(query: z, expect: libcacos, result: Complex64.acos)
        }
        do {
            let r = repeatElement(0.0 ... 1.0, count: count).map(Float64.random(in:))
            let i = repeatElement(0.0 ... 1.0, count: count).map(Float64.random(in:))
            let z = zip(r, i).map(Complex128.init(real:imag:))
            eval(query: z, expect: libcacos, result: Complex128.acos)
        }
    }
}
