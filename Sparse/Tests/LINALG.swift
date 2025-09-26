//
//  LINALG.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import Testing
import Dense
@testable import Sparse
@Suite
struct ALG {
    @Test(arguments: [
        ([
            [ 4,  0,  1,  0],
            [ 0,  1,  0,  5],
            [ 1,  0,  4,  0],
            [ 2,  3,  0, -1]
        ], -240.0)
    ])
    func detR(query: Array<Array<Float64>>, expect: Float64.Magnitude) {
        let A = CRS<Float64>(rows: query)
        #expect((Sparse.LINALG.det(A) - expect).magnitude < 1e-6)
    }
    @Test
    func hessC() {
        let A = CCS<Float64>(cols: [
            [ 4,  0,  1,  2],
            [ 0,  1,  0,  3],
            [ 1,  0,  4,  0],
            [ 0,  5,  0, -1]
        ])
        print(Sparse.LINALG.hessenberg(A))
    }
    @Test
    func qrC() {
        let A = CCS<Float64>(cols: [
            [0, 0, 1],
            [-2, 0, 0],
            [7, -2, 1]
        ])
        let (q, r) = Sparse.LINALG.QR(A)
        print("A=", A)
        print("q=", q)
        print("r=", r)
        print("qr=", CCS(q • r))
    }
    @Test
    func qrR() {
        let A = CRS<Float64>(rows: [
            [-1, 5, 7],
            [-2, -1, 0],
            [7, 0, 1]
        ])
        let (q, r) = Sparse.LINALG.QR(A)
        print("A=", A)
        print("q=", q)
        print("r=", r)
        print("qr=", CRS(q • r))
    }
}
