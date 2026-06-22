//
//  vDSP.swift
//  MUSE
//
//  Created by Kota on 6/18/26.
//
import Testing
import simd
//import Accelerate
@testable import AltVec
@Suite
struct vDSPTestCases {
    @Test
    func fill() {
        let x = Array<Float32>(unsafeUninitializedCapacity: 32) {
            AltVec.vDSP_fill(.pi, $0.baseAddress.unsafelyUnwrapped, 1, $0.count)
            $1 = $0.count
        }
        #expect(x.allSatisfy { $0 == .pi })
    }
}
