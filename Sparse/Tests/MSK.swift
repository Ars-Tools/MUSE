//
//  MSK.swift
//  MUSE
//
//  Created by Kota on 9/28/25.
//
import Testing
import Dense
@testable import Sparse
@Suite
struct MSKTestCases {
    @Test
    func create() {
        var m = MSK(shape: (3, 3))
        #expect(m.isEmpty)
        m[0, 0] = true
        m[0, 1] = true
        #expect(m.entry.count == 2)
        m[0, 0] = false
        m[0, 1] = true
        #expect(m.entry.count == 1)
    }
    @Test
    func convert() {
        let ccs = CCS<Float64>(cols: [
            [0.0, .ulpOfOne],
            [0.0, .nan]
        ])
        #expect(ccs[1, 1] == .zero)
        #expect(ccs[1, 0] != .zero)
    }
}

