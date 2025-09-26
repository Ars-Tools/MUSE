//
//  Solver+Multiply.swift
//  MUSE
//
//  Created by Kota on 9/22/25.
//
import typealias Foundation.KeyPathComparator
import protocol Accelerate.AccelerateBuffer
import protocol Accelerate.AccelerateMutableBuffer
import protocol Dense.Scalar
import protocol Dense.Vector
import protocol Dense.Matrix
import protocol Dense.Tensor
import protocol Dense.InstantScalar
import protocol Dense.InstantVector
import protocol Dense.InstantMatrix
import protocol Dense.InstantTensor
import protocol Dense.ArithmeticElement
import typealias Dense.Basic
import typealias Layout.MemoryStrategy
import func Layout.broadcast
import func Layout.capacity
extension Solver {
    // MARK: Hadamard
    @usableFromInline
    struct HV<X: SparseVector<Element>, Y: Dense.Vector<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = HV<X.S, Y.S>
        @usableFromInline let x: X
        @usableFromInline let y: Y
    }
    @usableFromInline
    struct HM<X: SparseMatrix<Element>, Y: Dense.Matrix<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Array<Element>
        @usableFromInline typealias T = Array<Element>
        @usableFromInline typealias U = Array<Element>
        @usableFromInline typealias V = Array<Element>
        @usableFromInline let x: X
        @usableFromInline let y: Y
    }
    // MARK: SD-Inner
    @usableFromInline
    struct SDI<X: SparseVector<Element>, Y: Dense.Vector<Element>> {
        @usableFromInline typealias R = CollectionOfOne<Element>
        @usableFromInline let x: X
        @usableFromInline let y: Y
    }
    // MARK: DS-Inner
    @usableFromInline
    struct DSI<X: Dense.Vector<Element>, Y: SparseVector<Element>> {
        @usableFromInline typealias R = CollectionOfOne<Element>
        @usableFromInline let x: X
        @usableFromInline let y: Y
    }
    // MARK: SD
    @usableFromInline
    struct SDMV<X: SparseMatrix<Element>, Y: Dense.Vector<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = SDMV<X.S, Y>
        @usableFromInline typealias U = SDI<X.V, Y>
        @usableFromInline let x: X
        @usableFromInline let y: Y
    }
    @usableFromInline
    struct SDVM<X: SparseVector<Element>, Y: Dense.Matrix<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = SDVM<X, Y.S>
        @usableFromInline typealias U = SDI<X, Y.V>
        @usableFromInline let x: X
        @usableFromInline let y: Y
    }
    @usableFromInline
    struct SDMM<X: SparseMatrix<Element>, Y: Dense.Matrix<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = SDMM<X.S, Y.S>
        @usableFromInline typealias T = DSMM<Y.T, X.T>
        @usableFromInline typealias U = SDI<X.V, Y.V>
        @usableFromInline typealias V = Basic<Element>.AB<SDMV<X.S, Y.V>, SDVM<X.V, Y.S>>
        @usableFromInline let x: X
        @usableFromInline let y: Y
    }
    // MARK: DS
    @usableFromInline
    struct DSMV<X: Dense.Matrix<Element>, Y: SparseVector<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = DSMV<X.S, Y>
        @usableFromInline typealias U = DSI<X.V, Y>
        @usableFromInline let x: X
        @usableFromInline let y: Y
    }
    @usableFromInline
    struct DSVM<X: Dense.Vector<Element>, Y: SparseMatrix<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = DSVM<X, Y.S>
        @usableFromInline typealias U = DSI<X, Y.V>
        @usableFromInline let x: X
        @usableFromInline let y: Y
    }
    @usableFromInline
    struct DSMM<X: Dense.Matrix<Element>, Y: SparseMatrix<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = DSMM<X.S, Y.S>
        @usableFromInline typealias T = SDMM<Y.T, X.T>
        @usableFromInline typealias U = DSI<X.V, Y.V>
        @usableFromInline typealias V = Basic<Element>.AB<DSMV<X.S, Y.V>, DSVM<X.V, Y.S>>
        @usableFromInline let x: X
        @usableFromInline let y: Y
    }
    @usableFromInline
    struct SDMT<X: SparseMatrix<Element>, Y: Dense.Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = SDMT<X.S, Y.S>
        @usableFromInline typealias T = DSTM<Y.T, X.T>
        @usableFromInline typealias U = SDMT<X.S, Y.U>
        @usableFromInline typealias V = SDMT<X.S, Y.V>
        @usableFromInline let x: X
        @usableFromInline let y: Y
        @usableFromInline let w: Int
    }
    @usableFromInline
    struct DSTM<X: Dense.Tensor<Element>, Y: SparseMatrix<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = DSTM<X.S, Y.S>
        @usableFromInline typealias T = SDMT<Y.T, X.T>
        @usableFromInline typealias U = DSTM<X.U, Y.S>
        @usableFromInline typealias V = DSTM<X.V, Y.S>
        @usableFromInline let x: X
        @usableFromInline let y: Y
        @usableFromInline let w: Int
    }
}
// MARK: Hadamard
extension Solver.HV: SparseVector {
    @inlinable
    var count: Int {
        broadcast(x: x.count, y: y.count)
    }
    @usableFromInline
    subscript(position: Int) -> Element {
        fatalError("WIP")
    }
    @usableFromInline
    subscript(bounds: some RangeExpression<Int>) -> S {
        .init(x: x[bounds], y: y[bounds])
    }
    @usableFromInline
    var coo: some Sequence<(Int, Element)> {
        return x.coo
    }
}
// MARK: SDI
extension Solver.SDI: Scalar {
    @usableFromInline
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> CollectionOfOne<Element>) {
        let (xm, xi) = x.coo.sorted(using: KeyPathComparator(\.0)).reduce(into: (Array<Element>(), Array<Int64>())) {
            $0.0.append($1.1)
            $0.1.append(.init($1.0))
        }
        return switch strategy {
        case.rowMajor:
            switch try y.evaluation(for: strategy) {
            case (let ys, let yk):
                ([], {
                    await yk().withUnsafeBufferPointer {
                        .init(Element.Inner(nz: xm.count, xm: xm, xi: xi, ym: $0.baseAddress.unsafelyUnwrapped, ys: ys.last ?? .zero))
                    }
                })
            }
        case.columnMajor:
            switch try y.evaluation(for: strategy) {
            case (let ys, let yk):
                ([], {
                    await yk().withUnsafeBufferPointer {
                        .init(Element.Inner(nz: xm.count, xm: xm, xi: xi, ym: $0.baseAddress.unsafelyUnwrapped, ys: ys.first ?? .zero))
                    }
                })
            }
        }
    }
}
extension Solver.SDI: InstantTensor & InstantMatrix & InstantVector & InstantScalar where Y: InstantVector {
    @usableFromInline
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> CollectionOfOne<Element>) {
        let (xm, xi) = x.coo.sorted(using: KeyPathComparator(\.0)).reduce(into: (Array<Element>(), Array<Int64>())) {
            $0.0.append($1.1)
            $0.1.append(.init($1.0))
        }
        return switch strategy {
        case.rowMajor:
            switch try y.evaluation(for: strategy) {
            case (let ys, let yk):
                ([], {
                    yk().withUnsafeBufferPointer {
                        .init(Element.Inner(nz: xm.count, xm: xm, xi: xi, ym: $0.baseAddress.unsafelyUnwrapped, ys: ys.last ?? .zero))
                    }
                })
            }
        case.columnMajor:
            switch try y.evaluation(for: strategy) {
            case (let ys, let yk):
                ([], {
                    yk().withUnsafeBufferPointer {
                        .init(Element.Inner(nz: xm.count, xm: xm, xi: xi, ym: $0.baseAddress.unsafelyUnwrapped, ys: ys.first ?? .zero))
                    }
                })
            }
        }
    }
}
// MARK: SDMV
extension Solver.SDMV: Vector {
    @usableFromInline
    var count: Int {
        x.rows
    }
    @usableFromInline
    subscript(position: Int) -> U {
        .init(x: x[position, 0...], y: y)
    }
    @usableFromInline
    subscript(bounds: some RangeExpression<Int>) -> S {
        .init(x: x[bounds, 0...], y: y)
    }
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        let (xs, xm) = try y.evaluation(for: .columnMajor)
        switch x.lil(for: .columnMajor) {
        case(.rowMajor, let lil):
            let crs = CRS(lil: lil, count: x.cols)
            return ([1], {
                await xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: crs.rows) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: crs.rows, n: 1, k: crs.cols,
                                     colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                     X: x, ldX: xs.first ?? .zero, opX: .T,
                                     Y: y, ldY: 1, opY: .T)
                        $1 = $0.count
                    }
                }
            })
        case(.columnMajor, let lil):
            let ccs = CCS(lil: lil, count: x.rows)
            return ([1], {
                await xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: ccs.rows) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: ccs.rows, n: 1, k: ccs.cols,
                                     colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                     X: x, ldX: xs.first ?? .zero, opX: .T,
                                     Y: y, ldY: 1, opY: .T)
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
extension Solver.SDMV: InstantTensor & InstantVector where Y: InstantVector {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let (xs, xm) = try y.evaluation(for: .columnMajor)
        switch x.lil(for: .columnMajor) {
        case(.rowMajor, let lil):
            let crs = CRS(lil: lil, count: x.cols)
            return ([1], {
                xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: crs.rows) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: crs.rows, n: 1, k: crs.cols,
                                     colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                     X: x, ldX: xs.first ?? .zero, opX: .T,
                                     Y: y, ldY: 1, opY: .T)
                        $1 = $0.count
                    }
                }
            })
        case(.columnMajor, let lil):
            let ccs = CCS(lil: lil, count: x.rows)
            return ([1], {
                xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: ccs.rows) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: ccs.rows, n: 1, k: ccs.cols,
                                     colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                     X: x, ldX: xs.first ?? .zero, opX: .T,
                                     Y: y, ldY: 1, opY: .T)
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
// MARK: SDVM
extension Solver.SDVM: Vector {
    @inlinable
    var count: Int {
        y.cols
    }
    @usableFromInline
    subscript(position: Int) -> U {
        .init(x: x, y: y[0..., position])
    }
    @usableFromInline
    subscript(bounds: some RangeExpression<Int>) -> S {
        .init(x: x, y: y[0..., bounds])
    }
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        let (xs, xm) = try y.evaluation(for: .columnMajor)
        let (rowIndex, valArray) = x.coo.sorted(using: KeyPathComparator(\.0)).reduce(into: (Array<Int32>(), Array<Element>())) {
            $0.0.append(.init($1.0))
            $0.1.append($1.1)
        }
        let ((n, k), ldb, ldc, stride, offset) = strategy.contraction(m: 1, y: (y.shape, xs))
        assert(stride.count == 2)
        assert(offset == [.zero])
        switch (ldb, ldc) {
        case ((1, let ldb), (1, let ldc)):
            return ([ldc], {
                await xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: n * ldc) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: 1, n: n, k: k,
                                     colStart: [0, valArray.count], rowIndex: rowIndex, valArray: valArray, opA: .T,
                                     X: x, ldX: ldb, opX: .N,
                                     Y: y, ldY: ldc, opY: .N)
                        $1 = $0.count
                    }
                }
            })
        case ((let ldb, 1), (1, let ldc)):
            return ([ldc], {
                await xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: n * ldc) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: 1, n: n, k: k,
                                     colStart: [0, valArray.count], rowIndex: rowIndex, valArray: valArray, opA: .T,
                                     X: x, ldX: ldb, opX: .T,
                                     Y: y, ldY: ldc, opY: .N)
                        $1 = $0.count
                    }
                }
            })
        case ((1, let ldb), (let ldc, 1)):
            return ([ldc], {
                await xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: n * ldc) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: 1, n: n, k: k,
                                     colStart: [0, valArray.count], rowIndex: rowIndex, valArray: valArray, opA: .T,
                                     X: x, ldX: ldb, opX: .N,
                                     Y: y, ldY: ldc, opY: .T)
                        $1 = $0.count
                    }
                }
            })
        case ((let ldb, 1), (let ldc, 1)):
            return ([ldc], {
                await xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: n * ldc) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: 1, n: n, k: k,
                                     colStart: [0, valArray.count], rowIndex: rowIndex, valArray: valArray, opA: .T,
                                     X: x, ldX: ldb, opX: .T,
                                     Y: y, ldY: ldc, opY: .T)
                        $1 = $0.count
                    }
                }
            })
        default:
            fatalError("not implemented")
        }
    }
}
extension Solver.SDVM: InstantTensor & InstantVector where Y: InstantMatrix {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let (xs, xm) = try y.evaluation(for: .columnMajor)
        let (rowIndex, valArray) = x.coo.sorted(using: KeyPathComparator(\.0)).reduce(into: (Array<Int32>(), Array<Element>())) {
            $0.0.append(.init($1.0))
            $0.1.append($1.1)
        }
        let ((n, k), ldb, ldc, stride, offset) = strategy.contraction(m: 1, y: (y.shape, xs))
        assert(stride.count == 2)
        assert(offset == [.zero])
        switch (ldb, ldc) {
        case ((1, let ldb), (1, let ldc)):
            return ([ldc], {
                xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: n * ldc) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: 1, n: n, k: k,
                                     colStart: [0, valArray.count], rowIndex: rowIndex, valArray: valArray, opA: .T,
                                     X: x, ldX: ldb, opX: .N,
                                     Y: y, ldY: ldc, opY: .T)
                        $1 = $0.count
                    }
                }
            })
        case ((let ldb, 1), (1, let ldc)):
            return ([ldc], {
                xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: n * ldc) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: 1, n: n, k: k,
                                     colStart: [0, valArray.count], rowIndex: rowIndex, valArray: valArray, opA: .T,
                                     X: x, ldX: ldb, opX: .T,
                                     Y: y, ldY: ldc, opY: .T)
                        $1 = $0.count
                    }
                }
            })
        case ((1, let ldb), (let ldc, 1)):
            return ([ldc], {
                xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: n * ldc) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: 1, n: n, k: k,
                                     colStart: [0, valArray.count], rowIndex: rowIndex, valArray: valArray, opA: .T,
                                     X: x, ldX: ldb, opX: .N,
                                     Y: y, ldY: ldc, opY: .N)
                        $1 = $0.count
                    }
                }
            })
        case ((let ldb, 1), (let ldc, 1)):
            return ([ldc], {
                xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: n * ldc) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: 1, n: n, k: k,
                                     colStart: [0, valArray.count], rowIndex: rowIndex, valArray: valArray, opA: .T,
                                     X: x, ldX: ldb, opX: .T,
                                     Y: y, ldY: ldc, opY: .N)
                        $1 = $0.count
                    }
                }
            })
        default:
            fatalError("not implemented")
        }
    }
}
// MARK: DSVM
extension Solver.DSVM: Vector {
    @usableFromInline
    var count: Int {
        y.cols
    }
    @usableFromInline
    subscript(position: Int) -> U {
        .init(x: x, y: y[0..., position])
    }
    @usableFromInline
    subscript(bounds: some RangeExpression<Int>) -> S {
        .init(x: x, y: y[0..., bounds])
    }
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        let (xs, xk) = try x.evaluation(for: .rowMajor)
        switch y.lil(for: .rowMajor) {
        case(.rowMajor, let lil):
            let crs = CRS(lil: lil, count: y.cols)
            return ([1], {
                await xk().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: crs.cols) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: crs.cols, n: 1, k: crs.rows,
                                     colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .N,
                                     X: x, ldX: xs.first ?? .zero, opX: .T,
                                     Y: y, ldY: 1, opY: .T)
                        $1 = $0.count
                    }
                }
            })
        case(.columnMajor, let lil):
            let ccs = CCS(lil: lil, count: y.rows)
            return ([1], {
                await xk().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: ccs.cols) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: ccs.cols, n: 1, k: ccs.rows,
                                     colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .T,
                                     X: x, ldX: xs.first ?? .zero, opX: .T,
                                     Y: y, ldY: 1, opY: .T)
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
extension Solver.DSVM: InstantTensor & InstantVector where X: InstantVector {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let (xs, xk) = try x.evaluation(for: .rowMajor)
        switch y.lil(for: .rowMajor) {
        case(.rowMajor, let lil):
            let crs = CRS(lil: lil, count: y.cols)
            return ([1], {
                xk().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: crs.cols) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: crs.cols, n: 1, k: crs.rows,
                                     colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .N,
                                     X: x, ldX: xs.first ?? .zero, opX: .T,
                                     Y: y, ldY: 1, opY: .T)
                        $1 = $0.count
                    }
                }
            })
        case(.columnMajor, let lil):
            let ccs = CCS(lil: lil, count: y.rows)
            return ([1], {
                xk().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: ccs.cols) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: ccs.cols, n: 1, k: ccs.rows,
                                     colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .T,
                                     X: x, ldX: xs.first ?? .zero, opX: .T,
                                     Y: y, ldY: 1, opY: .T)
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
// MARK: SDMM
extension Solver.SDMM: Matrix {
    @inlinable
    var rows: Int {
        x.rows
    }
    @inlinable
    var cols: Int {
        y.cols
    }
    @usableFromInline
    var transpose: T {
        .init(x: y.transpose, y: x.transpose)
    }
    @usableFromInline
    var diagonal: V {
        fatalError()
    }
    @usableFromInline
    subscript(row: Int, col: Int) -> U {
        .init(x: x[row, 0...], y: y[0..., col])
    }
    @usableFromInline
    subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .B(.init(x: x[row, 0...], y: y[0..., col]))
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .A(.init(x: x[row, 0...], y: y[0..., col]))
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        .init(x: x[row, 0...], y: y[0..., col])
    }
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        let m = x.rows
        let (ys, yk) = try y.evaluation(for: .columnMajor)
        switch x.lil(for: .columnMajor) {
        case (.rowMajor, let lil):
            let crs = CRS(lil: lil, count: x.cols)
            let ((n, k), ldb, ldc, stride, offset) = strategy.contraction(m: m, y: (y.shape, ys))
            assert(stride.count == 2)
            assert(offset == [.zero])
            let capacity = capacity(alloc: [m, n], stride: stride)
            switch (ldb, ldc) {
            case ((1, let ldb), (1, let ldc)):
                return (stride, {
                    await yk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: m, n: n, k: k,
                                         colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                         X: x, ldX: ldb, opX: .N,
                                         Y: y, ldY: ldc, opY: .N)
                            $1 = $0.count
                        }
                    }
                })
            case ((let ldb, 1), (1, let ldc)):
                return (stride, {
                    await yk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: m, n: n, k: k,
                                         colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                         X: x, ldX: ldb, opX: .T,
                                         Y: y, ldY: ldc, opY: .N)
                            $1 = $0.count
                        }
                    }
                })
            case ((1, let ldb), (let ldc, 1)):
                return (stride, {
                    await yk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: m, n: n, k: k,
                                         colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                         X: x, ldX: ldb, opX: .N,
                                         Y: y, ldY: ldc, opY: .T)
                            $1 = $0.count
                        }
                    }
                })
            case ((let ldb, 1), (let ldc, 1)):
                return (stride, {
                    await yk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: m, n: n, k: k,
                                         colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                         X: x, ldX: ldb, opX: .T,
                                         Y: y, ldY: ldc, opY: .T)
                            $1 = $0.count
                        }
                    }
                })
            default:
                fatalError("not implemented")
            }
        case (.columnMajor, let lil):
            let ccs = CCS(lil: lil, count: x.rows)
            let ((n, k), ldb, ldc, stride, offset) = strategy.contraction(m: m, y: (y.shape, ys))
            assert(stride.count == 2)
            assert(offset == [.zero])
            let capacity = capacity(alloc: [m, n], stride: stride)
            switch (ldb, ldc) {
            case ((1, let ldb), (1, let ldc)):
                return (stride, {
                    await yk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: m, n: n, k: k,
                                         colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                         X: x, ldX: ldb, opX: .N,
                                         Y: y, ldY: ldc, opY: .N)
                            $1 = $0.count
                        }
                    }
                })
            case ((let ldb, 1), (1, let ldc)):
                return (stride, {
                    await yk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: m, n: n, k: k,
                                         colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                         X: x, ldX: ldb, opX: .T,
                                         Y: y, ldY: ldc, opY: .N)
                            $1 = $0.count
                        }
                    }
                })
            case ((1, let ldb), (let ldc, 1)):
                return (stride, {
                    await yk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: m, n: n, k: k,
                                         colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                         X: x, ldX: ldb, opX: .N,
                                         Y: y, ldY: ldc, opY: .T)
                            $1 = $0.count
                        }
                    }
                })
            case ((let ldb, 1), (let ldc, 1)):
                return (stride, {
                    await yk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: m, n: n, k: k,
                                         colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                         X: x, ldX: ldb, opX: .T,
                                         Y: y, ldY: ldc, opY: .T)
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
extension Solver.SDMM: InstantTensor & InstantMatrix where Y: InstantMatrix {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let m = x.rows
        let (ys, yk) = try y.evaluation(for: .columnMajor)
        switch x.lil(for: .columnMajor) {
        case (.rowMajor, let lil):
            let crs = CRS(lil: lil, count: x.cols)
            let ((n, k), ldb, ldc, stride, offset) = strategy.contraction(m: m, y: (y.shape, ys))
            assert(stride.count == 2)
            assert(offset == [.zero])
            let capacity = capacity(alloc: [m, n], stride: stride)
            switch (ldb, ldc) {
            case ((1, let ldb), (1, let ldc)):
                return (stride, {
                    yk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: m, n: n, k: k,
                                         colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                         X: x, ldX: ldb, opX: .N,
                                         Y: y, ldY: ldc, opY: .N)
                            $1 = $0.count
                        }
                    }
                })
            case ((let ldb, 1), (1, let ldc)):
                return (stride, {
                    yk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: m, n: n, k: k,
                                         colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                         X: x, ldX: ldb, opX: .T,
                                         Y: y, ldY: ldc, opY: .N)
                            $1 = $0.count
                        }
                    }
                })
            case ((1, let ldb), (let ldc, 1)):
                return (stride, {
                    yk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: m, n: n, k: k,
                                         colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                         X: x, ldX: ldb, opX: .N,
                                         Y: y, ldY: ldc, opY: .T)
                            $1 = $0.count
                        }
                    }
                })
            case ((let ldb, 1), (let ldc, 1)):
                return (stride, {
                    yk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: m, n: n, k: k,
                                         colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                         X: x, ldX: ldb, opX: .T,
                                         Y: y, ldY: ldc, opY: .T)
                            $1 = $0.count
                        }
                    }
                })
            default:
                fatalError("not implemented")
            }
        case (.columnMajor, let lil):
            let ccs = CCS(lil: lil, count: x.rows)
            let ((n, k), ldb, ldc, stride, offset) = strategy.contraction(m: m, y: (y.shape, ys))
            assert(stride.count == 2)
            assert(offset == [.zero])
            let capacity = capacity(alloc: [m, n], stride: stride)
            switch (ldb, ldc) {
            case ((1, let ldb), (1, let ldc)):
                return (stride, {
                    yk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: m, n: n, k: k,
                                         colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                         X: x, ldX: ldb, opX: .N,
                                         Y: y, ldY: ldc, opY: .N)
                            $1 = $0.count
                        }
                    }
                })
            case ((let ldb, 1), (1, let ldc)):
                return (stride, {
                    yk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: m, n: n, k: k,
                                         colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                         X: x, ldX: ldb, opX: .T,
                                         Y: y, ldY: ldc, opY: .N)
                            $1 = $0.count
                        }
                    }
                })
            case ((1, let ldb), (let ldc, 1)):
                return (stride, {
                    yk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: m, n: n, k: k,
                                         colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                         X: x, ldX: ldb, opX: .N,
                                         Y: y, ldY: ldc, opY: .T)
                            $1 = $0.count
                        }
                    }
                })
            case ((let ldb, 1), (let ldc, 1)):
                return (stride, {
                    yk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: m, n: n, k: k,
                                         colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                         X: x, ldX: ldb, opX: .T,
                                         Y: y, ldY: ldc, opY: .T)
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
// MARK: DSI
extension Solver.DSI: Scalar {
    @usableFromInline
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> CollectionOfOne<Element>) {
        let (xm, xi) = y.coo.sorted(using: KeyPathComparator(\.0)).reduce(into: (Array<Element>(), Array<Int64>())) {
            $0.0.append($1.1)
            $0.1.append(.init($1.0))
        }
        return switch strategy {
        case.rowMajor:
            switch try x.evaluation(for: strategy) {
            case (let ys, let yk):
                ([], {
                    await yk().withUnsafeBufferPointer {
                        .init(Element.Inner(nz: xm.count, xm: xm, xi: xi, ym: $0.baseAddress.unsafelyUnwrapped, ys: ys.last ?? .zero))
                    }
                })
            }
        case.columnMajor:
            switch try x.evaluation(for: strategy) {
            case (let ys, let yk):
                ([], {
                    await yk().withUnsafeBufferPointer {
                        .init(Element.Inner(nz: xm.count, xm: xm, xi: xi, ym: $0.baseAddress.unsafelyUnwrapped, ys: ys.first ?? .zero))
                    }
                })
            }
        }
    }
}
extension Solver.DSI: InstantTensor & InstantMatrix & InstantVector & InstantScalar where X: InstantVector {
    @usableFromInline
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> CollectionOfOne<Element>) {
        let (xm, xi) = y.coo.sorted(using: KeyPathComparator(\.0)).reduce(into: (Array<Element>(), Array<Int64>())) {
            $0.0.append($1.1)
            $0.1.append(.init($1.0))
        }
        return switch strategy {
        case.rowMajor:
            switch try x.evaluation(for: strategy) {
            case (let ys, let yk):
                ([], {
                    yk().withUnsafeBufferPointer {
                        .init(Element.Inner(nz: xm.count, xm: xm, xi: xi, ym: $0.baseAddress.unsafelyUnwrapped, ys: ys.last ?? .zero))
                    }
                })
            }
        case.columnMajor:
            switch try x.evaluation(for: strategy) {
            case (let ys, let yk):
                ([], {
                    yk().withUnsafeBufferPointer {
                        .init(Element.Inner(nz: xm.count, xm: xm, xi: xi, ym: $0.baseAddress.unsafelyUnwrapped, ys: ys.first ?? .zero))
                    }
                })
            }
        }
    }
}
// MARK: DSMV
extension Solver.DSMV: Vector {
    @usableFromInline
    var count: Int {
        x.rows
    }
    @usableFromInline
    subscript(position: Int) -> U {
        .init(x: x[position, 0...], y: y)
    }
    @usableFromInline
    subscript(bounds: some RangeExpression<Int>) -> S {
        .init(x: x[bounds, 0...], y: y)
    }
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        let (xs, xm) = try x.evaluation(for: .rowMajor)
        let (rowIndex, valArray) = y.coo.sorted(using: KeyPathComparator(\.0)).reduce(into: (Array<Int32>(), Array<Element>())) {
            $0.0.append(.init($1.0))
            $0.1.append($1.1)
        }
        let ((m, k), lda, ldc, stride, offset) = strategy.contraction(x: (x.shape, xs), n: 1)
        assert(stride.count == 2)
        assert(offset == [.zero])
        switch (lda, ldc) {
        case ((1, let lda), (1, let ldc)):
            return ([ldc], {
                await xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: m * ldc) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: 1, n: m, k: k,
                                     colStart: [0, valArray.count], rowIndex: rowIndex, valArray: valArray, opA: .T,
                                     X: x, ldX: lda, opX: .T,
                                     Y: y, ldY: ldc, opY: .N)
                        $1 = $0.count
                    }
                }
            })
        case ((let lda, 1), (1, let ldc)):
            return ([ldc], {
                await xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: m * ldc) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: 1, n: m, k: k,
                                     colStart: [0, valArray.count], rowIndex: rowIndex, valArray: valArray, opA: .T,
                                     X: x, ldX: lda, opX: .N,
                                     Y: y, ldY: ldc, opY: .N)
                        $1 = $0.count
                    }
                }
            })
        case ((1, let lda), (let ldc, 1)):
            return ([ldc], {
                await xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: m * ldc) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: 1, n: m, k: k,
                                     colStart: [0, valArray.count], rowIndex: rowIndex, valArray: valArray, opA: .T,
                                     X: x, ldX: lda, opX: .T,
                                     Y: y, ldY: ldc, opY: .T)
                        $1 = $0.count
                    }
                }
            })
        case ((let lda, 1), (let ldc, 1)):
            return ([ldc], {
                await xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: m * ldc) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: 1, n: m, k: k,
                                     colStart: [0, valArray.count], rowIndex: rowIndex, valArray: valArray, opA: .T,
                                     X: x, ldX: lda, opX: .N,
                                     Y: y, ldY: ldc, opY: .T)
                        $1 = $0.count
                    }
                }
            })
        default:
            fatalError("not implemented")
        }
    }
}
extension Solver.DSMV: InstantTensor & InstantVector where X: InstantMatrix {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let (xs, xm) = try x.evaluation(for: .rowMajor)
        let (rowIndex, valArray) = y.coo.sorted(using: KeyPathComparator(\.0)).reduce(into: (Array<Int32>(), Array<Element>())) {
            $0.0.append(.init($1.0))
            $0.1.append($1.1)
        }
        let ((m, k), lda, ldc, stride, offset) = strategy.contraction(x: (x.shape, xs), n: 1)
        assert(stride.count == 2)
        assert(offset == [.zero])
        switch (lda, ldc) {
        case ((1, let lda), (1, let ldc)):
            return ([ldc], {
                xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: m * ldc) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: 1, n: m, k: k,
                                     colStart: [0, valArray.count], rowIndex: rowIndex, valArray: valArray, opA: .T,
                                     X: x, ldX: lda, opX: .T,
                                     Y: y, ldY: ldc, opY: .N)
                        $1 = $0.count
                    }
                }
            })
        case ((let lda, 1), (1, let ldc)):
            return ([ldc], {
                xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: m * ldc) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: 1, n: m, k: k,
                                     colStart: [0, valArray.count], rowIndex: rowIndex, valArray: valArray, opA: .T,
                                     X: x, ldX: lda, opX: .N,
                                     Y: y, ldY: ldc, opY: .N)
                        $1 = $0.count
                    }
                }
            })
        case ((1, let lda), (let ldc, 1)):
            return ([ldc], {
                xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: m * ldc) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: 1, n: m, k: k,
                                     colStart: [0, valArray.count], rowIndex: rowIndex, valArray: valArray, opA: .T,
                                     X: x, ldX: lda, opX: .T,
                                     Y: y, ldY: ldc, opY: .T)
                        $1 = $0.count
                    }
                }
            })
        case ((let lda, 1), (let ldc, 1)):
            return ([ldc], {
                xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: m * ldc) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        Element.SPMM(m: 1, n: m, k: k,
                                     colStart: [0, valArray.count], rowIndex: rowIndex, valArray: valArray, opA: .T,
                                     X: x, ldX: lda, opX: .N,
                                     Y: y, ldY: ldc, opY: .T)
                        $1 = $0.count
                    }
                }
            })
        default:
            fatalError("not implemented")
        }
    }
}

// MARK: DSMM
extension Solver.DSMM: Matrix {
    @inlinable
    var rows: Int {
        x.rows
    }
    @inlinable
    var cols: Int {
        y.cols
    }
    @usableFromInline
    var transpose: T {
        .init(x: y.transpose, y: x.transpose)
    }
    @usableFromInline
    var diagonal: V {
        fatalError("WIP")
    }
    @usableFromInline
    subscript(row: Int, col: Int) -> U {
        .init(x: x[row, 0...], y: y[0..., col])
    }
    @usableFromInline
    subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .B(.init(x: x[row, 0...], y: y[0..., col]))
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .A(.init(x: x[row, 0...], y: y[0..., col]))
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        .init(x: x[row, 0...], y: y[0..., col])
    }
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        let n = y.cols
        let (xs, xk) = try x.evaluation(for: .rowMajor)
        switch y.lil(for: .rowMajor) {
        case (.rowMajor, let lil):
            let crs = CRS(lil: lil, count: x.cols)
            let ((m, k), lda, ldc, stride, offset) = strategy.contraction(x: (x.shape, xs), n: n)
            assert(stride.count == 2)
            assert(offset == [.zero])
            let capacity = capacity(alloc: [m, n], stride: stride)
            switch (lda, ldc) {
            case ((let lda, 1), (let ldc, 1)):
                return (stride, {
                    await xk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: n, n: m, k: k,
                                         colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .N,
                                         X: x, ldX: lda, opX: .N,
                                         Y: y, ldY: ldc, opY: .N)
                            $1 = $0.count
                        }
                    }
                })
            case ((let lda, 1), (1, let ldc)):
                return (stride, {
                    await xk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: n, n: m, k: k,
                                         colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .N,
                                         X: x, ldX: lda, opX: .N,
                                         Y: y, ldY: ldc, opY: .T)
                            $1 = $0.count
                        }
                    }
                })
            case ((1, let lda), (let ldc, 1)):
                return (stride, {
                    await xk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: n, n: m, k: k,
                                         colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .N,
                                         X: x, ldX: lda, opX: .T,
                                         Y: y, ldY: ldc, opY: .N)
                            $1 = $0.count
                        }
                    }
                })
            case ((1, let lda), (1, let ldc)):
                return (stride, {
                    await xk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: n, n: m, k: k,
                                         colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .N,
                                         X: x, ldX: lda, opX: .T,
                                         Y: y, ldY: ldc, opY: .T)
                            $1 = $0.count
                        }
                    }
                })
            default:
                fatalError("not implemented")
            }
        case (.columnMajor, let lil):
            let ccs = CCS(lil: lil, count: x.rows)
            let ((m, k), lda, ldc, stride, offset) = strategy.contraction(x: (x.shape, xs), n: n)
            assert(stride.count == 2)
            assert(offset == [.zero])
            let capacity = capacity(alloc: [m, n], stride: stride)
            switch (lda, ldc) {
            case ((let lda, 1), (let ldc, 1)):
                return (stride, {
                    await xk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: n, n: m, k: k,
                                         colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .T,
                                         X: x, ldX: lda, opX: .N,
                                         Y: y, ldY: ldc, opY: .N)
                            $1 = $0.count
                        }
                    }
                })
            case ((let lda, 1), (1, let ldc)):
                return (stride, {
                    await xk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: n, n: m, k: k,
                                         colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .T,
                                         X: x, ldX: lda, opX: .N,
                                         Y: y, ldY: ldc, opY: .T)
                            $1 = $0.count
                        }
                    }
                })
            case ((1, let lda), (let ldc, 1)):
                return (stride, {
                    await xk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: n, n: m, k: k,
                                         colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .T,
                                         X: x, ldX: lda, opX: .T,
                                         Y: y, ldY: ldc, opY: .N)
                            $1 = $0.count
                        }
                    }
                })
            case ((1, let lda), (1, let ldc)):
                return (stride, {
                    await xk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: n, n: m, k: k,
                                         colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .T,
                                         X: x, ldX: lda, opX: .T,
                                         Y: y, ldY: ldc, opY: .T)
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
extension Solver.DSMM: InstantTensor & InstantMatrix where X: InstantMatrix {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let n = y.cols
        let (xs, xk) = try x.evaluation(for: .rowMajor)
        switch y.lil(for: .rowMajor) {
        case (.rowMajor, let lil):
            let crs = CRS(lil: lil, count: x.cols)
            let ((m, k), lda, ldc, stride, offset) = strategy.contraction(x: (x.shape, xs), n: n)
            assert(stride.count == 2)
            assert(offset == [.zero])
            let capacity = capacity(alloc: [m, n], stride: stride)
            switch (lda, ldc) {
            case ((let lda, 1), (let ldc, 1)):
                return (stride, {
                    xk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: n, n: m, k: k,
                                         colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .N,
                                         X: x, ldX: lda, opX: .N,
                                         Y: y, ldY: ldc, opY: .N)
                            $1 = $0.count
                        }
                    }
                })
            case ((let lda, 1), (1, let ldc)):
                return (stride, {
                    xk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: n, n: m, k: k,
                                         colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .N,
                                         X: x, ldX: lda, opX: .N,
                                         Y: y, ldY: ldc, opY: .T)
                            $1 = $0.count
                        }
                    }
                })
            case ((1, let lda), (let ldc, 1)):
                return (stride, {
                    xk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: n, n: m, k: k,
                                         colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .N,
                                         X: x, ldX: lda, opX: .T,
                                         Y: y, ldY: ldc, opY: .N)
                            $1 = $0.count
                        }
                    }
                })
            case ((1, let lda), (1, let ldc)):
                return (stride, {
                    xk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: n, n: m, k: k,
                                         colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .N,
                                         X: x, ldX: lda, opX: .T,
                                         Y: y, ldY: ldc, opY: .T)
                            $1 = $0.count
                        }
                    }
                })
            default:
                fatalError("not implemented")
            }
        case (.columnMajor, let lil):
            let ccs = CCS(lil: lil, count: x.rows)
            let ((m, k), lda, ldc, stride, offset) = strategy.contraction(x: (x.shape, xs), n: n)
            assert(stride.count == 2)
            assert(offset == [.zero])
            let capacity = capacity(alloc: [m, n], stride: stride)
            switch (lda, ldc) {
            case ((let lda, 1), (let ldc, 1)):
                return (stride, {
                    xk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: n, n: m, k: k,
                                         colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .T,
                                         X: x, ldX: lda, opX: .N,
                                         Y: y, ldY: ldc, opY: .N)
                            $1 = $0.count
                        }
                    }
                })
            case ((let lda, 1), (1, let ldc)):
                return (stride, {
                    xk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: n, n: m, k: k,
                                         colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .T,
                                         X: x, ldX: lda, opX: .N,
                                         Y: y, ldY: ldc, opY: .T)
                            $1 = $0.count
                        }
                    }
                })
            case ((1, let lda), (let ldc, 1)):
                return (stride, {
                    xk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: n, n: m, k: k,
                                         colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .T,
                                         X: x, ldX: lda, opX: .T,
                                         Y: y, ldY: ldc, opY: .N)
                            $1 = $0.count
                        }
                    }
                })
            case ((1, let lda), (1, let ldc)):
                return (stride, {
                    xk().withUnsafeBufferPointer {
                        let x = $0.baseAddress.unsafelyUnwrapped
                        return.init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            Element.SPMM(m: n, n: m, k: k,
                                         colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .T,
                                         X: x, ldX: lda, opX: .T,
                                         Y: y, ldY: ldc, opY: .T)
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
// MARK: Sparse-Dense
//extension Solver.SDMT: Scalar {
//    
//}
//extension Solver.SDMT: Vector {
//    @usableFromInline
//    var count: Int {
//        precondition(shape.count == 1, "shape is not vector")
//        return shape.reduce(1, *)
//    }
//    @usableFromInline
//    subscript(position: Int) -> U {
//        self[[position..<position]]
//    }
//    @usableFromInline
//    subscript(bounds: some RangeExpression<Int>) -> S {
//        self[[bounds]]
//    }
//}
//extension Solver.SDMT: Matrix {
//    @usableFromInline
//    var rows: Int {
//        precondition(shape.count == 2, "shape is not matrix")
//        return shape.first ?? 1
//    }
//    @usableFromInline
//    var cols: Int {
//        precondition(shape.count == 2, "shape is not matrix")
//        return shape.last ?? 1
//    }
//    @usableFromInline
//    subscript(row: Int, col: Int) -> U {
//        self[row..<row, col..<col]
//    }
//    @usableFromInline
//    subscript(row: Int, col: some RangeExpression<Int>) -> V {
//        self[row..<row, col]
//    }
//    @usableFromInline
//    subscript(row: some RangeExpression<Int>, col: Int) -> V {
//        self[row, col..<col]
//    }
//    @usableFromInline
//    subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
//        self[[row.relative(to: 0..<rows), col.relative(to: 0..<cols)]]
//    }
//}
//extension Solver.SDMT: Tensor {
//    @usableFromInline
//    var shape: Array<Int> {
//        contraction(lhs: x.shape, rhs: y.shape, order: w)
//    }
//    @usableFromInline
//    var diagonal: V {
//        fatalError("WIP")
//    }
//    @usableFromInline
//    var transpose: T {
//        .init(x: y.transpose, y: x.transpose, w: w)
//    }
//    @usableFromInline
//    subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
//        self[position.map{ $0..<$0 } + shape.dropFirst(position.count).map{ 0..<$0 }]
//    }
//    @usableFromInline
//    subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
//        let slice = zip(bounds, shape).map { $0.relative(to: 0..<$1) } + shape.dropFirst(bounds.count).map { 0..<$0 }
//        let xs = slice.dropLast(w) + x.shape.suffix(w).map { 0..<$0 }
//        let ys = y.shape.prefix(w).map { 0..<$0 } + slice.dropFirst(w)
//        assert(xs.count == x.shape.count)
//        assert(ys.count == y.shape.count)
//        return.init(x: x[xs],
//                    y: y[ys],
//                    w: w)
//    }
//    @inlinable
//    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
//        fatalError()
//    }
//}
//extension Solver.SDMT: InstantScalar where Y: InstantScalar {}
//extension Solver.SDMT: InstantVector where Y: InstantVector {}
//extension Solver.SDMT: InstantMatrix where Y: InstantMatrix {}
//extension Solver.SDMT: InstantTensor where Y: InstantTensor {
//    @inlinable
//    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
//        fatalError()
//    }
//}
// MARK: Dense-Sparse
//extension Solver.DSTM: Scalar {
//    
//}
//extension Solver.DSTM: Vector {
//    @usableFromInline
//    var count: Int {
//        precondition(shape.count == 1, "shape is not vector")
//        return shape.reduce(1, *)
//    }
//    @usableFromInline
//    subscript(position: Int) -> U {
//        self[[position..<position]]
//    }
//    @usableFromInline
//    subscript(bounds: some RangeExpression<Int>) -> S {
//        self[[bounds]]
//    }
//}
//extension Solver.DSTM: Matrix {
//    @usableFromInline
//    var rows: Int {
//        precondition(shape.count == 2, "shape is not matrix")
//        return shape.first ?? 1
//    }
//    @usableFromInline
//    var cols: Int {
//        precondition(shape.count == 2, "shape is not matrix")
//        return shape.last ?? 1
//    }
//    @usableFromInline
//    subscript(row: Int, col: Int) -> U {
//        self[row..<row, col..<col]
//    }
//    @usableFromInline
//    subscript(row: Int, col: some RangeExpression<Int>) -> V {
//        self[row..<row, col]
//    }
//    @usableFromInline
//    subscript(row: some RangeExpression<Int>, col: Int) -> V {
//        self[row, col..<col]
//    }
//    @usableFromInline
//    subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
//        self[[row.relative(to: 0..<rows), col.relative(to: 0..<cols)]]
//    }
//}
//extension Solver.DSTM: Tensor {
//    @usableFromInline
//    var shape: Array<Int> {
//        contraction(lhs: x.shape, rhs: y.shape, order: w)
//    }
//    @usableFromInline
//    var diagonal: V {
//        fatalError("WIP")
//    }
//    @usableFromInline
//    var transpose: T {
//        .init(x: y.transpose, y: x.transpose, w: w)
//    }
//    @usableFromInline
//    subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
//        self[position.map{ $0..<$0 } + shape.dropFirst(position.count).map{ 0..<$0 }]
//    }
//    @usableFromInline
//    subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
//        let slice = zip(bounds, shape).map { $0.relative(to: 0..<$1) } + shape.dropFirst(bounds.count).map { 0..<$0 }
//        let xs = slice.dropLast(w) + x.shape.suffix(w).map { 0..<$0 }
//        let ys = y.shape.prefix(w).map { 0..<$0 } + slice.dropFirst(w)
//        assert(xs.count == x.shape.count)
//        assert(ys.count == y.shape.count)
//        return.init(x: x[xs],
//                    y: y[ys],
//                    w: w)
//    }
//    @inlinable
//    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
//        fatalError()
//    }
//}
//extension Solver.DSTM: InstantScalar where X: InstantScalar {}
//extension Solver.DSTM: InstantVector where X: InstantVector {}
//extension Solver.DSTM: InstantMatrix where X: InstantMatrix {}
//extension Solver.DSTM: InstantTensor where X: InstantTensor {
//    @inlinable
//    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
//        fatalError()
//    }
//}
public func •<Element: SolverElement & ArithmeticElement>(lhs: some SparseVector<Element>, rhs: some Dense.Vector<Element>) -> some Dense.Scalar<Element> {
    Solver.SDI(x: lhs, y: rhs)
}
public func •<Element: SolverElement & ArithmeticElement>(lhs: some Dense.Vector<Element>, rhs: some SparseVector<Element>) -> some Dense.Scalar<Element> {
    Solver.DSI(x: lhs, y: rhs)
}
public func •<Element: SolverElement & ArithmeticElement>(lhs: some SparseMatrix<Element>, rhs: some Dense.Vector<Element>) -> some Dense.Vector<Element> {
    Solver.SDMV(x: lhs, y: rhs)
}
public func •<Element: SolverElement & ArithmeticElement>(lhs: some Dense.Vector<Element>, rhs: some SparseMatrix<Element>) -> some Dense.Vector<Element> {
    Solver.DSVM(x: lhs, y: rhs)
}
public func •<Element: SolverElement & ArithmeticElement>(lhs: some SparseMatrix<Element>, rhs: some Dense.Matrix<Element>) -> some Dense.Matrix<Element> {
    Solver.SDMM(x: lhs, y: rhs)
}
public func •<Element: SolverElement & ArithmeticElement>(lhs: some Dense.Matrix<Element>, rhs: some SparseMatrix<Element>) -> some Dense.Matrix<Element> {
    Solver.DSMM(x: lhs, y: rhs)
}
// Instant
public func •<Element: SolverElement & ArithmeticElement>(lhs: some SparseVector<Element>, rhs: some Dense.InstantVector<Element>) -> some Dense.InstantScalar<Element> {
    Solver.SDI(x: lhs, y: rhs)
}
public func •<Element: SolverElement & ArithmeticElement>(lhs: some Dense.InstantVector<Element>, rhs: some SparseVector<Element>) -> some Dense.InstantScalar<Element> {
    Solver.DSI(x: lhs, y: rhs)
}
public func •<Element: SolverElement & ArithmeticElement>(lhs: some SparseMatrix<Element>, rhs: some Dense.InstantVector<Element>) -> some Dense.InstantVector<Element> {
    Solver.SDMV(x: lhs, y: rhs)
}
public func •<Element: SolverElement & ArithmeticElement>(lhs: some Dense.InstantVector<Element>, rhs: some SparseMatrix<Element>) -> some Dense.InstantVector<Element> {
    Solver.DSVM(x: lhs, y: rhs)
}
public func •<Element: SolverElement & ArithmeticElement>(lhs: some SparseMatrix<Element>, rhs: some Dense.InstantMatrix<Element>) -> some Dense.InstantMatrix<Element> {
    Solver.SDMM(x: lhs, y: rhs)
}
public func •<Element: SolverElement & ArithmeticElement>(lhs: some Dense.InstantMatrix<Element>, rhs: some SparseMatrix<Element>) -> some Dense.InstantMatrix<Element> {
    Solver.DSMM(x: lhs, y: rhs)
}
