//
//  Complex.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import Numerics
import Testing
import Layout
@testable import Dense
@Suite
struct ComplexTestCases {
    @Test
    func mul() throws {
//        let y = [[1.0, 2.0, 3.0]] as MatBuf<Float32>
        let z = complex(r: 1.0 as NDArray<Float64>, θ: [0.0, 0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9] as NDArray<Float64>, as: Complex128.self)
        let w = try VecBuf(z)
        print(w)
    }
}
