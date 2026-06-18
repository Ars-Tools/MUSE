//
//  vFORCE.swift
//  MUSE
//
//  Created by Kota on 6/18/26.
//
import Testing
import simd
@testable import vFORCE
@Suite
struct vFORCETestCases {
    @Test
    func sinπ() {
        let x = repeatElement(0.0 ... 2.0, count: 4).map(Float32.random(in:))
        let z = x.map(__tg_sinpi)
        let w = Array<Float32>(unsafeUninitializedCapacity: x.count) {
            vFORCE.vvsinpi(x, $0.baseAddress.unsafelyUnwrapped, $0.count)
            $1 = $0.count
        }
        #expect(zip(z, w).lazy.map(-).map(\.magnitude).allSatisfy { $0 < .ulpOfOne.squareRoot() })
    }
    @Test
    func cosπ() {
        let x = repeatElement(0.0 ... 2.0, count: 4).map(Float32.random(in:))
        let z = x.map(__tg_cospi)
        let w = Array<Float32>(unsafeUninitializedCapacity: x.count) {
            vFORCE.vvcospi(x, $0.baseAddress.unsafelyUnwrapped, $0.count)
            $1 = $0.count
        }
        #expect(zip(z, w).lazy.map(-).map(\.magnitude).allSatisfy { $0 < .ulpOfOne.squareRoot() })
    }
    @Test
    func pow() {
        let x = repeatElement(0.0 ... 2.0, count: 4).map(Float32.random(in:))
        let z = zip(x, x).map(*)
        let w = Array<Float32>(unsafeUninitializedCapacity: x.count) {
            vFORCE.vvpow(x, 2, $0.baseAddress.unsafelyUnwrapped, $0.count)
            $1 = $0.count
        }
        #expect(zip(z, w).lazy.map(-).map(\.magnitude).allSatisfy { $0 < .ulpOfOne.squareRoot() })
    }
    @Test
    func fmod() {
        let x = repeatElement(0.0 ... 2.0, count: 4).map(Float32.random(in:))
        let y = Array<Float32>(repeating: 1, count: x.count)
        let z = zip(x, y).map(fmodf)
        let w = Array<Float32>(unsafeUninitializedCapacity: x.count) {
            vFORCE.vvfmod(x, y, $0.baseAddress.unsafelyUnwrapped, $0.count)
            $1 = $0.count
        }
        #expect(zip(z, w).allSatisfy(==))
    }
}
