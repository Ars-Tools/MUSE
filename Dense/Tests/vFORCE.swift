//
//  vFORCE.swift
//  MUSE
//
//  Created by Kota on 9/23/25.
//
import Testing
import Numerics
@testable import Dense
@Suite
struct vFORCEComplex64 {
    @Test
    func log() {
        let x = [-1, -2, -3, -4, -5, -6, -7, -8, -9] as Array<Complex64>
        var y = [1, 2, 3, 4, 5, 6, 7, 8, 9] as Array<Complex64>
        var z = Array<Complex64>.init(repeating: .zero, count: 9)
        Complex64.log(x, 2, &y, 2, 4)
        Complex64.exp(y, 2, &z, 2, 4)
        print(x, y, z, "<-")
    }
    @Test
    func exp() {
        let x = [1, 2, 3, 4, 5, 6, 7, 8] as Array<Complex64>
        var y = [1, 2, 3, 4, 5, 6, 7, 8] as Array<Complex64>
        Complex64.exp(x, 2, &y, 2, 4)
        print(y)
    }
    @Test
    func sin_() throws {
        let x = [1.1 + .i, 2.2 + .i, 3.6 + .i, 4.4 + .i] as VecBuf<Complex128>
        try print(VecBuf(cos(x)), "cos")
        try print(VecBuf(sin(x)), "sin")
        try print(VecBuf(cosh(x)), "cosh")
        try print(VecBuf(sinh(x)), "sinh")
        try print(VecBuf(acos(x)), "acos")
        try print(VecBuf(asin(x)), "asin")
        try print(VecBuf(acosh(x)), "acosh")
        try print(VecBuf(asinh(x)), "asinh")
        try print(VecBuf(Dense.exp(x)), "exp")
        try print(VecBuf(Dense.log(x)), "log")
    }
}
