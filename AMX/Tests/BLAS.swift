//
//  BLAS.swift
//  MUSE
//
//  Created by Kota on 6/18/26.
//
import Testing
@testable import BLAS
@Suite
struct BLASTestCases {
    @Test
    func dgemm() {
        let x = [1,2,3,4].map(Float32.init)
        let y = [1,2,3,4].map(Float32.init)
        var z = [1,2,3,4].map(Float32.init)
        gemm(2, 2, 2,
             1.0,
             x, 2, .N,
             y, 2, .N,
             0.0,
             &z, 2)
//        print(x.map(\.r))
//        print(y.map(\.r))
//        print(z.map(\.r))
        
    }
}
