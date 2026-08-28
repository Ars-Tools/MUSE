//
//  LAPACK.swift
//  MUSE
//
//  Created by Kota on 6/18/26.
//
import Testing
@testable import LAPACK
@Suite
struct LAPACKTestCases {
    @Test
    func eig() {
        var A = [
            1.2, 0,
            0, 3.4
        ] as Array<Float64>
        var r = [0, 0] as Array<Float64>
        var i = [0, 0] as Array<Float64>
        var vl = [0, 0, 0, 0] as Array<Float64>
        var vr = [0, 0, 0, 0] as Array<Float64>
        let size = geev(2,
                        .none, 2,
                        &r, &i,
                        .none, 2,
                        .none, 2,
                        .none, 0)
        print(size)
        let info = geev(2,
                        &A, 2,
                        &r, &i,
                        .none, 2,
                        .none, 2,
                        .allocate(capacity: size), size)
        print(info)
        print(r, i)
        
    }
}
