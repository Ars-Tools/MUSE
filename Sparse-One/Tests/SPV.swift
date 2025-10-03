//
//  SPV.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import Testing
@testable import Sparse
@Suite
struct SPVTestCases {
    @Test
    func create() {
        let v = [0, 1, 0, 2, 0, 3] as SPV
        #expect(v.store.count == 3)
        #expect(v[0] == 0)
        #expect(v[1] == 1)
        #expect(v[3] == 2)
        #expect(v[5] == 3)
    }
}
