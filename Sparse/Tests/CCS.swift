//
//  CCS.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import Testing
import Dense
@testable import Sparse
@Suite
struct CCSTestCases {
    @Test
    func alt() {
        var eye = CCS<Int>(identity: 4)
        eye[0, 0] = 5
        eye[2, 2] = 0
        eye[2, 3] = 4
        #expect(eye[0, 0] == 5)
        #expect(eye[1, 1] == 1)
        #expect(eye[2, 2] == 0)
        #expect(eye[2, 3] == 4)
    }
    @Test
    func pp() {
        var eye = DOK<Int>(diagonal: 1, 2, 3)
        #expect(eye[2, 0] == 0)
        eye[2, 0] = 10
        let test = CCS(eye)
        #expect(test[2, 0] == 10)
        #expect(test[0, 0] == 1)
        #expect(test[1, 1] == 2)
        #expect(test[2, 2] == 3)
    }
    @Test
    func pb() {
        var eye = DOK<Int>(diagonal: 1, 2, 3)
        eye[2, 0...] = .init(arrayLiteral: 3, 2, 1)
        let test = CCS(eye)
        #expect(test[0, 0] == 1)
        #expect(test[1, 1] == 2)
        #expect(test[2, 2] == 1)
        #expect(test[2, 1] == 2)
        #expect(test[2, 0] == 3)
    }
    @Test
    func bp() {
        var eye = DOK<Int>(diagonal: 1, 2, 3)
        eye[0..., 2] = .init(arrayLiteral: 3, 2, 1)
        let test = CCS(eye)
        #expect(test[0, 0] == 1)
        #expect(test[1, 1] == 2)
        #expect(test[2, 2] == 1)
        #expect(test[1, 2] == 2)
        #expect(test[0, 2] == 3)
    }
    @Test
    func bb() {
        var eye = DOK<Int>(diagonal: 1, 2, 3)
        #expect(eye[0, 0] == 1)
        #expect(eye[1, 1] == 2)
        #expect(eye[2, 2] == 3)
        eye[0..<2, 0..<2] = .init(diagonal: 4, 5)
        let test = CCS(eye)
        #expect(test[0, 0] == 4)
        #expect(test[1, 1] == 5)
        #expect(test[2, 2] == 3)
    }
}
