//
//  Solver+Iterative.swift
//  MUSE
//
//  Created by Kota on 10/1/25.
//
@preconcurrency import Accelerate.vecLib
import protocol Dense.Tensor
import protocol Dense.InstantTensor
import typealias Dense.Basic
import func Layout.capacity
extension Solver {
    @usableFromInline
    struct Iterative<System: SparseMatrix<Element>, Source: Tensor<Element>> {
        @usableFromInline typealias S = Self
        @usableFromInline typealias T = Self
        @usableFromInline typealias U = Self
        @usableFromInline typealias V = Self
        @usableFromInline let method: SparseIterativeMethod
        @usableFromInline let system: System
        @usableFromInline let source: Source
    }
    @usableFromInline
    final class Preconditioner: Sendable {
        @usableFromInline let conditioner: Element.SparseOpaquePreconditioner
        @inlinable init(rawValue: Element.SparseOpaquePreconditioner) {
            conditioner = rawValue
        }
        @inlinable deinit {
            Element.Cleanup(preconditioner: conditioner)
        }
    }
}
extension Solver.Iterative: Tensor {
    @usableFromInline typealias Element = Element
    @inlinable
    var shape: Array<Int> {
        [system.cols] + source.shape.dropFirst()
    }
    @inlinable
    var transpose: Self {
        fatalError()
    }
    @inlinable
    subscript<P>(position: P) -> Self where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        fatalError()
    }
    @inlinable
    subscript<Q>(bounds: Q) -> Self where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        fatalError()
    }
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        fatalError()
    }
}
extension Solver.Iterative: InstantTensor where Source: InstantTensor {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let m = max(1, system.rows)
        let n = max(1, system.cols)
        let bk = source.shape
        let (bs, bm) = try source.evaluation(for: .columnMajor)
        let ((nrhs, k), ldb, ldc, stride, offset) = MemoryStrategy.columnMajor.contraction(m: n, y: (bk, bs))
        let zk = [n] + source.shape.dropFirst()
        let zm = capacity(alloc: zk, stride: stride)
        assert(ldc.0 == 1)
        switch system.lil(for: .columnMajor) {
        case (.rowMajor, let lil):
            let crs = CRS(shape: (m, n), lil: lil)
            let pre = Solver.Preconditioner(rawValue: Element.Preconditioner(type: SparsePreconditionerDiagonal,
                                                                             m: crs.cols, n: crs.rows, op: .T,
                                                                             colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray))
            return switch (ldb, ldc) {
            case ((1, let ldx), (1, let ldy)):
                (stride, { [method] in
                    bm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Solve(method: method,
                                                  preconditioner: pre.conditioner,
                                                  m: n, n: k, nrhs: nrhs,
                                                  colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                                  Y: x.advanced(by: offset.x), ldY: ldx, opY: .N,
                                                  X: y.advanced(by: offset.y), ldX: ldy, opX: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldx, 1), (1, let ldy)):
                (stride, { [method] in
                    bm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Solve(method: method,
                                                  preconditioner: pre.conditioner,
                                                  m: n, n: k, nrhs: nrhs,
                                                  colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                                  Y: x.advanced(by: offset.x), ldY: ldx, opY: .T,
                                                  X: y.advanced(by: offset.y), ldX: ldy, opX: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((1, let ldx), (let ldy, 1)):
                (stride, { [method] in
                    bm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Solve(method: method,
                                                  preconditioner: pre.conditioner,
                                                  m: n, n: k, nrhs: nrhs,
                                                  colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                                  Y: x.advanced(by: offset.x), ldY: ldx, opY: .N,
                                                  X: y.advanced(by: offset.y), ldX: ldy, opX: .T)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldx, 1), (let ldy, 1)):
                (stride, { [method] in
                    bm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Solve(method: method,
                                                  preconditioner: pre.conditioner,
                                                  m: n, n: k, nrhs: nrhs,
                                                  colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                                  Y: x.advanced(by: offset.x), ldY: ldx, opY: .T,
                                                  X: y.advanced(by: offset.y), ldX: ldy, opX: .T)
                                }
                                $1 = $0.count
                            }
                    }
                })
            default:
                fatalError("not implemented")
            }
        case (.columnMajor, let lil):
            let ccs = CCS(shape: (m, n), lil: lil)
            let pre = Solver.Preconditioner(rawValue: Element.Preconditioner(type: SparsePreconditionerDiagonal,
                                                                             m: ccs.rows, n: ccs.cols, op: .N,
                                                                             colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray))
            return switch (ldb, ldc) {
            case ((1, let ldx), (1, let ldy)):
                (stride, { [method] in
                    bm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Solve(method: method,
                                                  preconditioner: pre.conditioner,
                                                  m: n, n: k, nrhs: nrhs,
                                                  colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                                  Y: x.advanced(by: offset.x), ldY: ldx, opY: .N,
                                                  X: y.advanced(by: offset.y), ldX: ldy, opX: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldx, 1), (1, let ldy)):
                (stride, { [method] in
                    bm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Solve(method: method,
                                                  preconditioner: pre.conditioner,
                                                  m: n, n: k, nrhs: nrhs,
                                                  colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                                  Y: x.advanced(by: offset.x), ldY: ldx, opY: .T,
                                                  X: y.advanced(by: offset.y), ldX: ldy, opX: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((1, let ldx), (let ldy, 1)):
                (stride, { [method] in
                    bm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Solve(method: method,
                                                  preconditioner: pre.conditioner,
                                                  m: n, n: k, nrhs: nrhs,
                                                  colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                                  Y: x.advanced(by: offset.x), ldY: ldx, opY: .N,
                                                  X: y.advanced(by: offset.y), ldX: ldy, opX: .T)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldx, 1), (let ldy, 1)):
                (stride, { [method] in
                    bm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Solve(method: method,
                                                  preconditioner: pre.conditioner,
                                                  m: n, n: k, nrhs: nrhs,
                                                  colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                                  Y: x.advanced(by: offset.x), ldY: ldx, opY: .T,
                                                  X: y.advanced(by: offset.y), ldX: ldy, opX: .T)
                                }
                                $1 = $0.count
                            }
                    }
                })
            default:
                fatalError("not implemented")
            }
        }
    }
}
public func solve<Element: SolverElement>(lsmr A: some SparseMatrix<Element>, b: some InstantTensor<Element>) -> some InstantTensor<Element> {
    Solver<Element>.Iterative(method: SparseLSMR(), system: A, source: b)
}
public func solve<Element: SolverElement>(gmres A: some SparseMatrix<Element>, b: some InstantTensor<Element>) -> some InstantTensor<Element> {
    Solver<Element>.Iterative(method: SparseGMRES(), system: A, source: b)
}
public func solve<Element: SolverElement>(cg A: some SparseMatrix<Element>, b: some InstantTensor<Element>) -> some InstantTensor<Element> {
    Solver<Element>.Iterative(method: SparseConjugateGradient(), system: A, source: b)
}
