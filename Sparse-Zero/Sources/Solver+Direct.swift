//
//  Solver+Direct.swift
//  MUSE
//
//  Created by Kota on 9/22/25.
//
import Accelerate.vecLib.Sparse
import Dense
import Layout
import Auxiliary
extension Solver {
    public final class Direct {
        @usableFromInline let factorization: Element.SparseOpaqueFactorization
        public init(_ A: some SparseMatrix<Element>, method: SparseFactorization_t = SparseFactorizationQR) {
            switch A.lil(for: .columnMajor) {
            case (.rowMajor, let lil):
                let crs = CRS(lil: lil, count: A.cols)
                factorization = Element.Factorization(type: method,
                                                      m: crs.rows, n: crs.cols,
                                                      colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T)
            case (.columnMajor, let lil):
                let ccs = CCS(lil: lil, count: A.rows)
                factorization = Element.Factorization(type: method,
                                                      m: ccs.rows, n: ccs.cols,
                                                      colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N)
            }
        }
        deinit {
            Element.Cleanup(factorization: factorization)
        }
    }
}
extension Solver.Direct {
    
}
