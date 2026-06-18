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
        let x = [1,2,3,4].map { complex128_t(.init(real: .init($0), imag: 0)) }
        let y = [1,2,3,4].map { complex128_t(.init(real: .init($0), imag: 0)) }
        var z = [1,2,3,4].map { complex128_t(.init(real: .init($0), imag: 0)) }
        
        let info = gemm(2, 2, 2,
                        complex128_t(.init(real: 1, imag: 0)),
                        x, 2, .N,
                        y, 2, .N,
                        complex128_t(.init(real: 0, imag: 0)),
                        &z, 2)
        print(info)
        print(x.map(\.vector))
        print(y.map(\.vector))
        print(z.map(\.vector))
    }
}
