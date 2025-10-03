//
//  Solver+Direct.swift
//  MUSE
//
//  Created by Kota on 10/1/25.
//
import Accelerate.vecLib
import protocol Dense.Tensor
import protocol Dense.InstantTensor
import typealias Dense.Basic
import func Layout.capacity
extension Solver {
    @usableFromInline
    struct Direct<System: SparseMatrix<Element>, Source: Tensor<Element>> {
        @usableFromInline typealias S = Self
        @usableFromInline typealias T = Self
        @usableFromInline typealias U = Self
        @usableFromInline typealias V = Self
        @usableFromInline let method: SparseFactorization_t
        @usableFromInline let system: System
        @usableFromInline let source: Source
    }
    @usableFromInline
    final class Factorization: Sendable {
        @usableFromInline let rawValue: Element.SparseOpaqueFactorization
        @inlinable init(rawValue factorization: Element.SparseOpaqueFactorization) {
            rawValue = factorization
        }
        @inlinable deinit {
            Element.Cleanup(factorization: rawValue)
        }
    }
}
extension Solver.Direct: Tensor {
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
extension Solver.Direct: InstantTensor where Source: InstantTensor {
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
            let factorization = Solver.Factorization(rawValue: Element.Factorization(type: method,
                                                                                     m: n, n: m,
                                                                                     colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T))
            return switch (ldb, ldc) {
            case ((1, let ldx), (1, let ldy)):
                (stride, {
                    bm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Solve(factorization: factorization.rawValue,
                                                  m: n, n: k, nrhs: nrhs,
                                                  Y: x.advanced(by: offset.x), ldY: ldx, opY: .N,
                                                  X: y.advanced(by: offset.y), ldX: ldy, opX: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldx, 1), (1, let ldy)):
                (stride, {
                    bm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Solve(factorization: factorization.rawValue,
                                                  m: n, n: k, nrhs: nrhs,
                                                  Y: x.advanced(by: offset.x), ldY: ldx, opY: .T,
                                                  X: y.advanced(by: offset.y), ldX: ldy, opX: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((1, let ldx), (let ldy, 1)):
                (stride, {
                    bm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Solve(factorization: factorization.rawValue,
                                                  m: n, n: k, nrhs: nrhs,
                                                  Y: x.advanced(by: offset.x), ldY: ldx, opY: .N,
                                                  X: y.advanced(by: offset.y), ldX: ldy, opX: .T)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldx, 1), (let ldy, 1)):
                (stride, {
                    bm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Solve(factorization: factorization.rawValue,
                                                  m: n, n: k, nrhs: nrhs,
                                                  Y: x.advanced(by: offset.x), ldY: ldx, opY: .T,
                                                  X: y.advanced(by: offset.y), ldX: ldy, opX: .T)
                                }
                                $1 = $0.count
                            }
                    }
                })
            default:
                fatalError()
            }
        case (.columnMajor, let lil):
            let ccs = CCS(shape: (m, n), lil: lil)
            let factorization = Solver.Factorization(rawValue: Element.Factorization(type: method,
                                                                                     m: m, n: n,
                                                                                     colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N))
            return switch (ldb, ldc) {
            case ((1, let ldx), (1, let ldy)):
                (stride, {
                    bm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Solve(factorization: factorization.rawValue,
                                                  m: n, n: k, nrhs: nrhs,
                                                  Y: x.advanced(by: offset.x), ldY: ldx, opY: .N,
                                                  X: y.advanced(by: offset.y), ldX: ldy, opX: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldx, 1), (1, let ldy)):
                (stride, {
                    bm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Solve(factorization: factorization.rawValue,
                                                  m: n, n: k, nrhs: nrhs,
                                                  Y: x.advanced(by: offset.x), ldY: ldx, opY: .T,
                                                  X: y.advanced(by: offset.y), ldX: ldy, opX: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((1, let ldx), (let ldy, 1)):
                (stride, {
                    bm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Solve(factorization: factorization.rawValue,
                                                  m: n, n: k, nrhs: nrhs,
                                                  Y: x.advanced(by: offset.x), ldY: ldx, opY: .N,
                                                  X: y.advanced(by: offset.y), ldX: ldy, opX: .T)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldx, 1), (let ldy, 1)):
                (stride, {
                    bm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Solve(factorization: factorization.rawValue,
                                                  m: n, n: k, nrhs: nrhs,
                                                  Y: x.advanced(by: offset.x), ldY: ldx, opY: .T,
                                                  X: y.advanced(by: offset.y), ldX: ldy, opX: .T)
                                }
                                $1 = $0.count
                            }
                    }
                })
            default:
                fatalError()
            }
        }
    }
}
public func solve<Element: SolverElement>(qr A: some SparseMatrix<Element>, b: some InstantTensor<Element>) -> some InstantTensor<Element> {
    Solver<Element>.Direct(method: SparseFactorizationQR, system: A, source: b)
}
//extension Solver.Direct {
//    @inlinable
//    public convenience init(lu system: some SparseMatrix<Element>) {
//        self.init(type: SparseFactorizationLU, system: system)
//    }
//    @inlinable
//    public convenience init(qr system: some SparseMatrix<Element>) {
//        self.init(type: SparseFactorizationQR, system: system)
//    }
//    @inlinable
//    public convenience init(cholesky system: some SparseMatrix<Element>) {
//        self.init(type: SparseFactorizationCholesky, system: system)
//    }
//}
//extension Solver.Direct {
//    @usableFromInline
//    struct Tensor<Source: Dense.Tensor<Element>> {
//        @usableFromInline typealias S = Self
//        @usableFromInline typealias T = Self
//        @usableFromInline typealias U = Self
//        @usableFromInline typealias V = Self
//        @usableFromInline let solver: Solver.Direct
//        @usableFromInline let source: Source
//    }
//    public func solve(y: some Dense.Tensor<Element>) -> some Dense.Tensor<Element> {
//        Tensor(solver: self, source: y)
//    }
//    public func solve(y: some Dense.InstantTensor<Element>) -> some Dense.InstantTensor<Element> {
//        Tensor(solver: self, source: y)
//    }
//}
//extension Solver.Direct.Tensor: Dense.Tensor {
//    @usableFromInline typealias Element = Element
//    @usableFromInline
//    var shape: Array<Int> {
//        let symbolic = Element.SymbolicFactorization(factorization: solver.factorization)
//        return [Int(symbolic.attributes.transpose ? symbolic.rowCount : symbolic.columnCount)] + source.shape.dropFirst()
//    }
//    @usableFromInline
//    var transpose: Self {
//        fatalError()
//    }
//    @usableFromInline
//    subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
//        fatalError()
//    }
//    @usableFromInline
//    subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
//        fatalError()
//    }
//    @inlinable
//    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
//        let symbolic = Element.SymbolicFactorization(factorization: solver.factorization)
//        let m = Int(symbolic.attributes.transpose ? symbolic.rowCount : symbolic.columnCount)
//        let bk = source.shape
//        let (bs, bm) = try source.evaluation(for: .columnMajor)
//        let ((nrhs, n), ldb, ldc, layout, chunks) = MemoryStrategy.columnMajor.contraction(m: m, y: (bk, bs))
//        let zk = [m] + source.shape.dropFirst()
//        let zm = capacity(alloc: zk, stride: layout)
//        assert(ldc.0 == 1)
//        switch (ldb, ldc) {
//        case ((1, let ldb), (1, let ldc)):
//            return (layout, {
//                await bm().withUnsafePointerWithFallback { x in
//                        .init(unsafeUninitializedCapacity: zm) {
//                            let y = $0.baseAddress.unsafelyUnwrapped
//                            for chunks in chunks {
//                                Element.Solve(factorization: solver.factorization,
//                                              m: n, n: m, nrhs: nrhs,
//                                              Y: x.advanced(by: chunks.x), ldY: ldb, opY: .N,
//                                              X: y.advanced(by: chunks.y), ldX: ldc, opX: .N)
//                            }
//                            $1 = $0.count
//                        }
//                }
//            })
//        case ((let ldb, 1), (1, let ldc)):
//            return (layout, {
//                await bm().withUnsafePointerWithFallback { x in
//                        .init(unsafeUninitializedCapacity: zm) {
//                            let y = $0.baseAddress.unsafelyUnwrapped
//                            for chunks in chunks {
//                                Element.Solve(factorization: solver.factorization,
//                                              m: n, n: m, nrhs: nrhs,
//                                              Y: x.advanced(by: chunks.x), ldY: ldb, opY: .T,
//                                              X: y.advanced(by: chunks.y), ldX: ldc, opX: .N)
//                            }
//                            $1 = $0.count
//                        }
//                }
//            })
//        case ((1, let ldb), (let ldc, 1)):
//            return (layout, {
//                await bm().withUnsafePointerWithFallback { x in
//                        .init(unsafeUninitializedCapacity: zm) {
//                            let y = $0.baseAddress.unsafelyUnwrapped
//                            for chunks in chunks {
//                                Element.Solve(factorization: solver.factorization,
//                                              m: m, n: n, nrhs: nrhs,
//                                              Y: x.advanced(by: chunks.x), ldY: ldb, opY: .N,
//                                              X: y.advanced(by: chunks.y), ldX: ldc, opX: .T)
//                            }
//                            $1 = $0.count
//                        }
//                }
//            })
//        case ((let ldb, 1), (let ldc, 1)):
//            return (layout, {
//                await bm().withUnsafePointerWithFallback { x in
//                        .init(unsafeUninitializedCapacity: zm) {
//                            let y = $0.baseAddress.unsafelyUnwrapped
//                            for chunks in chunks {
//                                Element.Solve(factorization: solver.factorization,
//                                              m: n, n: m, nrhs: nrhs,
//                                              Y: x.advanced(by: chunks.x), ldY: ldb, opY: .T,
//                                              X: y.advanced(by: chunks.y), ldX: ldc, opX: .T)
//                            }
//                            $1 = $0.count
//                        }
//                }
//            })
//        default:
//            fatalError("not implemented")
//        }
//    }
//}
//extension Solver.Direct.Tensor: InstantTensor where Source: InstantTensor {
//    @inlinable
//    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
//        let symbolic = Element.SymbolicFactorization(factorization: solver.factorization)
//        let m = Int(symbolic.attributes.transpose ? symbolic.rowCount : symbolic.columnCount)
//        let bk = source.shape
//        let (bs, bm) = try source.evaluation(for: .columnMajor)
//        let ((nrhs, n), ldb, ldc, layout, chunks) = MemoryStrategy.columnMajor.contraction(m: m, y: (bk, bs))
//        let zk = [m] + source.shape.dropFirst()
//        let zm = capacity(alloc: zk, stride: layout)
//        assert(ldc.0 == 1)
//        switch (ldb, ldc) {
//        case ((1, let ldb), (1, let ldc)):
//            return (layout, {
//                bm().withUnsafePointerWithFallback { x in
//                        .init(unsafeUninitializedCapacity: zm) {
//                            let y = $0.baseAddress.unsafelyUnwrapped
//                            for chunks in chunks {
//                                Element.Solve(factorization: solver.factorization,
//                                              m: n, n: m, nrhs: nrhs,
//                                              Y: x.advanced(by: chunks.x), ldY: ldb, opY: .N,
//                                              X: y.advanced(by: chunks.y), ldX: ldc, opX: .N)
//                            }
//                            $1 = $0.count
//                        }
//                }
//            })
//        case ((let ldb, 1), (1, let ldc)):
//            return (layout, {
//                bm().withUnsafePointerWithFallback { x in
//                        .init(unsafeUninitializedCapacity: zm) {
//                            let y = $0.baseAddress.unsafelyUnwrapped
//                            for chunks in chunks {
//                                Element.Solve(factorization: solver.factorization,
//                                              m: n, n: m, nrhs: nrhs,
//                                              Y: x.advanced(by: chunks.x), ldY: ldb, opY: .T,
//                                              X: y.advanced(by: chunks.y), ldX: ldc, opX: .N)
//                            }
//                            $1 = $0.count
//                        }
//                }
//            })
//        case ((1, let ldb), (let ldc, 1)):
//            return (layout, {
//                bm().withUnsafePointerWithFallback { x in
//                        .init(unsafeUninitializedCapacity: zm) {
//                            let y = $0.baseAddress.unsafelyUnwrapped
//                            for chunks in chunks {
//                                Element.Solve(factorization: solver.factorization,
//                                              m: m, n: n, nrhs: nrhs,
//                                              Y: x.advanced(by: chunks.x), ldY: ldb, opY: .N,
//                                              X: y.advanced(by: chunks.y), ldX: ldc, opX: .T)
//                            }
//                            $1 = $0.count
//                        }
//                }
//            })
//        case ((let ldb, 1), (let ldc, 1)):
//            return (layout, {
//                bm().withUnsafePointerWithFallback { x in
//                        .init(unsafeUninitializedCapacity: zm) {
//                            let y = $0.baseAddress.unsafelyUnwrapped
//                            for chunks in chunks {
//                                Element.Solve(factorization: solver.factorization,
//                                              m: n, n: m, nrhs: nrhs,
//                                              Y: x.advanced(by: chunks.x), ldY: ldb, opY: .T,
//                                              X: y.advanced(by: chunks.y), ldX: ldc, opX: .T)
//                            }
//                            $1 = $0.count
//                        }
//                }
//            })
//        default:
//            fatalError("not implemented")
//        }
//    }
//}
