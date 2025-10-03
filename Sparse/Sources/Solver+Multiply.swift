//
//  Solver+Multiply.swift
//  MUSE
//
//  Created by Kota on 9/28/25.
//
import protocol Dense.Tensor
import protocol Dense.InstantTensor
import func Layout.capacity
import func Layout.contraction
extension Solver {
    public struct SD<X: SparseMatrix<Element>, Y: Dense.Tensor<Element>> {
        public typealias S = SD<X.S, Y.S>
        public typealias T = DS<Y.T, X.T>
        public typealias U = SD<X.S, Y.S>
        public typealias V = SD<X.S, Y.S>
        @usableFromInline let order: MemoryStrategy
        @usableFromInline let x: X
        @usableFromInline let y: Y
    }
    public struct DS<X: Dense.Tensor<Element>, Y: SparseMatrix<Element>> {
        public typealias S = DS<X.S, Y.S>
        public typealias T = SD<Y.T, X.T>
        public typealias U = DS<X.S, Y.S>
        public typealias V = DS<X.S, Y.S>
        @usableFromInline let order: MemoryStrategy
        @usableFromInline let x: X
        @usableFromInline let y: Y
    }
}
extension Solver.SD: Tensor {
    public typealias Storage = Array<Element>
    public typealias Element = Element
    @inlinable@_transparent
    public var shape: Array<Int> {
        contraction(x: x.shape, y: y.shape, count: 1)
    }
    public var transpose: T {
        .init(order: order.transpose, x: y.transpose, y: x.transpose)
    }
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        self[position.map { $0..<$0 }]
    }
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        switch order {
        case.rowMajor:
            let row = bounds.first.map { $0.relative(to: 0..<x.rows) } ?? 0..<0
            let col = [0..<x.cols] + zip(bounds.dropFirst(), y.shape.dropFirst()).map { $0.relative(to: 0..<$1) }
            return.init(order: order, x: x[row, 0...], y: y[col + y.shape.dropFirst(col.count).map { 0..<$0 }])
        case.columnMajor:
            let bounds = zip(bounds, shape.suffix(bounds.count)).map { $0.relative(to: 0..<$1) }
            let tail = bounds.suffix(max(0, y.shape.count - 1))
            let head = bounds.dropLast(tail.count)
            assert(head.count <= 1)
            return.init(order: order, x: x[head.first ?? 0..<x.rows, 0..<x.cols], y: y[[0..<x.cols] + tail])
        }
    }
    @inlinable@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        let yk = y.shape
        let zk = shape
        let (ys, ym) = try y.evaluation(for: .columnMajor)
        let m = max(1, x.rows)
        let ((n, k), ldb, ldc, zs, offset) = MemoryStrategy.columnMajor.contraction(m: m, y: (yk, ys))
        let zm = capacity(alloc: zk, stride: zs)
        switch x.lil(for: .columnMajor) {
        case (.rowMajor, let lil):
            let crs = CRS(shape: (x.rows, x.cols), lil: lil)
            switch (ldb, ldc) {
            case ((1, let ldb), (1, let ldc)):
                let ldx = max(k, ldb)
                let ldy = max(m, ldc)
                return (zs, {
                    await ym().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: m, n: n, k: k,
                                                     colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .N,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldb, 1), (1, let ldc)):
                let ldx = max(k, ldb)
                let ldy = max(m, ldc)
                return (zs, {
                    await ym().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: m, n: n, k: k,
                                                     colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .T,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldb, 1), (1, let ldc)):
                let ldx = max(k, ldb)
                let ldy = max(m, ldc)
                return (zs, {
                    await ym().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: m, n: n, k: k,
                                                     colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .T,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldb, 1), (let ldc, 1)):
                let ldx = max(k, ldb)
                let ldy = max(m, ldc)
                return (zs, {
                    await ym().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: m, n: n, k: k,
                                                     colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .T,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .T)
                                }
                                $1 = $0.count
                            }
                    }
                })
            default:
                fatalError("not implemented")
            }
        case (.columnMajor, let lil):
            let ccs = CCS(shape: (x.rows, x.cols), lil: lil)
            switch (ldb, ldc) {
            case ((1, let ldb), (1, let ldc)):
                let ldx = max(k, ldb)
                let ldy = max(m, ldc)
                return (zs, {
                    await ym().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: m, n: n, k: k,
                                                     colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .N,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldb, 1), (1, let ldc)):
                let ldx = max(k, ldb)
                let ldy = max(m, ldc)
                return (zs, {
                    await ym().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: m, n: n, k: k,
                                                     colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .T,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldb, 1), (1, let ldc)):
                let ldx = max(k, ldb)
                let ldy = max(m, ldc)
                return (zs, {
                    await ym().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: m, n: n, k: k,
                                                     colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .T,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldb, 1), (let ldc, 1)):
                let ldx = max(k, ldb)
                let ldy = max(m, ldc)
                return (zs, {
                    await ym().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: m, n: n, k: k,
                                                     colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .T,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .T)
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
extension Solver.SD: InstantTensor where Y: InstantTensor {
    @inlinable@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let zk = shape
        let yk = y.shape
        let (ys, ym) = try y.evaluation(for: .columnMajor)
        let m = max(1, x.rows)
        let ((n, k), ldb, ldc, zs, offset) = MemoryStrategy.columnMajor.contraction(m: m, y: (yk, ys))
        let zm = capacity(alloc: zk, stride: zs)
        switch x.lil(for: .columnMajor) {
        case (.rowMajor, let lil):
            let crs = CRS(shape: (x.rows, x.cols), lil: lil)
            switch (ldb, ldc) {
            case ((1, let ldb), (1, let ldc)):
                let ldx = max(k, ldb)
                let ldy = max(m, ldc)
                return (zs, {
                    ym().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: m, n: n, k: k,
                                                     colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .N,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldb, 1), (1, let ldc)):
                let ldx = max(k, ldb)
                let ldy = max(m, ldc)
                return (zs, {
                    ym().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: m, n: n, k: k,
                                                     colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .T,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldb, 1), (1, let ldc)):
                let ldx = max(k, ldb)
                let ldy = max(m, ldc)
                return (zs, {
                    ym().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: m, n: n, k: k,
                                                     colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .T,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldb, 1), (let ldc, 1)):
                let ldx = max(k, ldb)
                let ldy = max(m, ldc)
                return (zs, {
                    ym().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: m, n: n, k: k,
                                                     colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .T,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .T)
                                }
                                $1 = $0.count
                            }
                    }
                })
            default:
                fatalError("not implemented")
            }
        case (.columnMajor, let lil):
            let ccs = CCS(shape: (x.rows, x.cols), lil: lil)
            switch (ldb, ldc) {
            case ((1, let ldb), (1, let ldc)):
                let ldx = max(k, ldb)
                let ldy = max(m, ldc)
                return (zs, {
                    ym().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: m, n: n, k: k,
                                                     colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .N,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldb, 1), (1, let ldc)):
                let ldx = max(k, ldb)
                let ldy = max(m, ldc)
                return (zs, {
                    ym().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: m, n: n, k: k,
                                                     colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .T,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldb, 1), (1, let ldc)):
                let ldx = max(k, ldb)
                let ldy = max(m, ldc)
                return (zs, {
                    ym().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: m, n: n, k: k,
                                                     colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .T,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let ldb, 1), (let ldc, 1)):
                let ldx = max(k, ldb)
                let ldy = max(m, ldc)
                return (zs, {
                    ym().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: m, n: n, k: k,
                                                     colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .T,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .T)
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
extension Solver.DS: Tensor {
    public typealias Storage = Array<Element>
    public typealias Element = Element
    public var shape: Array<Int> {
        contraction(x: x.shape, y: y.shape, count: 1)
    }
    public var transpose: T {
        .init(order: order.transpose, x: y.transpose, y: x.transpose)
    }
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        self[position.map { $0..<$0 }]
    }
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        switch order {
        case.rowMajor:
            let bounds = zip(bounds, shape.prefix(bounds.count)).map { $0.relative(to: 0..<$1) }
            let head = bounds.prefix(max(0, x.shape.count - 1))
            let tail = bounds.dropFirst(head.count)
            assert(tail.count <= 1)
            return.init(order: order, x: x[head + [0..<y.rows]], y: y[0..., tail.last ?? 0..<y.cols])
        case.columnMajor:
            let shape = shape
            let bounds = shape.dropLast(bounds.count).map { 0..<$0 } + zip(bounds, shape.suffix(bounds.count)).map { $0.relative(to: 0..<$1) }
            let tail = bounds.last.map { $0.relative(to: 0..<y.cols) } ?? 0..<0
            let head = bounds.dropLast()
            return.init(order: order, x: x[head + [0..<y.rows]], y: y[0..., tail])
        }
    }
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        fatalError()
    }
}
extension Solver.DS: InstantTensor where X: InstantTensor {
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let zk = shape
        let xk = x.shape
        let (xs, xm) = try x.evaluation(for: .rowMajor)
        let n = max(1, y.cols)
        let ((m, k), lda, ldc, zs, offset) = MemoryStrategy.rowMajor.contraction(x: (xk, xs), n: n)
        let zm = capacity(alloc: zk, stride: zs)
        switch y.lil(for: .columnMajor) {
        case (.rowMajor, let lil):
            let crs = CRS(shape: (y.rows, y.cols), lil: lil)
            switch (lda, ldc) {
            case ((1, let lda), (1, let ldc)):
                let ldx = max(k, lda)
                let ldy = max(n, ldc)
                return (zs, {
                    xm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: n, n: m, k: k,
                                                     colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .N,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .T,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .T)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let lda, 1), (1, let ldc)):
                let ldx = max(k, lda)
                let ldy = max(n, ldc)
                return (zs, {
                    xm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: n, n: m, k: k,
                                                     colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .N,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .N,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .T)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((1, let lda), (let ldc, 1)):
                let ldx = max(k, lda)
                let ldy = max(n, ldc)
                return (zs, {
                    xm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: n, n: m, k: k,
                                                     colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .N,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .T,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let lda, 1), (let ldc, 1)):
                let ldx = max(k, lda)
                let ldy = max(n, ldc)
                return (zs, {
                    xm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: n, n: m, k: k,
                                                     colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .N,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .N,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            default:
                fatalError("not implemented")
            }
        case (.columnMajor, let lil):
            let ccs = CCS(shape: (y.rows, y.cols), lil: lil)
            switch (lda, ldc) {
            case ((1, let lda), (1, let ldc)):
                let ldx = max(k, lda)
                let ldy = max(n, ldc)
                return (zs, {
                    xm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: n, n: m, k: k,
                                                     colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .T,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .T,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .T)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let lda, 1), (1, let ldc)):
                let ldx = max(k, lda)
                let ldy = max(n, ldc)
                return (zs, {
                    xm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: n, n: m, k: k,
                                                     colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .T,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .N,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .T)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((1, let lda), (let ldc, 1)):
                let ldx = max(k, lda)
                let ldy = max(n, ldc)
                return (zs, {
                    xm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: n, n: m, k: k,
                                                     colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .T,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .T,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .N)
                                }
                                $1 = $0.count
                            }
                    }
                })
            case ((let lda, 1), (let ldc, 1)):
                let ldx = max(k, lda)
                let ldy = max(n, ldc)
                return (zs, {
                    xm().withUnsafePointerWithFallback { x in
                            .init(unsafeUninitializedCapacity: zm) {
                                let y = $0.baseAddress.unsafelyUnwrapped
                                for offset in offset {
                                    Element.Multiply(m: n, n: m, k: k,
                                                     colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .T,
                                                     X: x.advanced(by: offset.x), ldX: ldx, opX: .N,
                                                     Y: y.advanced(by: offset.y), ldY: ldy, opY: .N)
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
public func •<Element, X, Y>(_ lhs: X, _ rhs: Y) -> Solver<Element>.SD<X, Y> {
    .init(order: .default, x: lhs, y: rhs)
}
