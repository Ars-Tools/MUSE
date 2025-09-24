//
//  Solver+Direct.swift
//  MUSE
//
//  Created by Kota on 9/22/25.
//
import Accelerate.vecLib.Sparse
import Dense
import Auxiliary
extension Solver {
    public struct Direct {
        @usableFromInline let factor: SparseOpaqueFactorization_Double
    }
}
extension Solver.Direct {
    public func solve() {
        
    }
}
