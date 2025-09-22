//
//  BLAS+T.swift
//  MUSE
//
//  Created by Kota on 9/18/R7.
//
import typealias Foundation.KeyPathComparator
import typealias Layout.MemoryStrategy
import func Layout.contraction
import func Layout.capacity
import func Layout.flatten
import func Layout.broadcast
import func Layout.narrowcast
extension BLAS {
    @usableFromInline
    @frozen struct TT<X: Tensor<Element>, Y: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = TT<X.S, Y.S>
        @usableFromInline typealias T = TT<Y.T, X.T>
        @usableFromInline typealias U = TT<X.S, Y.S>
        @usableFromInline typealias V = TT<X.S, Y.S>
        @usableFromInline let x: X
        @usableFromInline let y: Y
        @usableFromInline let w: Int
    }
}
extension BLAS.TT: Scalar {
    
}
extension BLAS.TT: Vector {
    @usableFromInline
    var count: Int {
        precondition(shape.count == 1, "shape is not vector")
        return shape.reduce(1, *)
    }
    @usableFromInline
    subscript(position: Int) -> U {
        self[[position..<position]]
    }
    @usableFromInline
    subscript(bounds: some RangeExpression<Int>) -> S {
//        switch (x.shape.count - w, y.shape.count - w) {
//        case (1, 0):
//                .init(x: x[x.shape.prefix(1).map{bounds.relative(to: 0..<$0)} + x.shape.dropFirst().map{0..<$0}],
//                      y: y[repeatElement(0..., count: y.shape.count)],
//                      w: w)
//        case (0, 1):
//                .init(x: x[repeatElement(0..., count: x.shape.count)],
//                      y: y[y.shape.dropLast().map{0..<$0} + y.shape.suffix(1).map{bounds.relative(to: 0..<$0)}],
//                      w: w)
//        default:
//            preconditionFailure("shape is not vector")
//        }
        self[[bounds]]
    }
}
extension BLAS.TT: Matrix {
    @usableFromInline
    var rows: Int {
        precondition(shape.count == 2, "shape is not matrix")
        return shape.first ?? 1
    }
    @usableFromInline
    var cols: Int {
        precondition(shape.count == 2, "shape is not matrix")
        return shape.last ?? 1
    }
    @usableFromInline
    subscript(row: Int, col: Int) -> U {
        self[row..<row, col..<col]
    }
    @usableFromInline
    subscript(row: Int, col: some RangeExpression<Int>) -> V {
        self[row..<row, col]
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: Int) -> V {
        self[row, col..<col]
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
//        switch (x.shape.count - w, y.shape.count - w) {
//        case (2, 0):
//            let r = x.shape.prefix(1).map { row.relative(to: 0..<$0) }
//            let c = x.shape.dropFirst().prefix(1).map { col.relative(to: 0..<$0) }
//            return.init(x: x[r + c + x.shape.dropFirst(2).map{0..<$0}],
//                        y: y[repeatElement(0..., count: y.shape.count)],
//                        w: w)
//        case (0, 2):
//            let r = y.shape.dropLast().suffix(1).map { row.relative(to: 0..<$0) }
//            let c = y.shape.suffix(1).map { col.relative(to: 0..<$0) }
//            return.init(x: x[repeatElement(0..., count: x.shape.count)],
//                        y: y[y.shape.dropLast(2).map{0..<$0} + r + c],
//                        w: w)
//        case (1, 1):
//            let r = x.shape.prefix(1).map { row.relative(to: 0..<$0) }
//            let c = y.shape.suffix(1).map { col.relative(to: 0..<$0) }
//            return.init(x: x[r + x.shape.dropFirst().map{0..<$0}],
//                        y: y[y.shape.dropLast().map{0..<$0} + c],
//                        w: w)
//        default:
//            preconditionFailure("shape is not matrix")
//        }
        self[[row.relative(to: 0..<rows), col.relative(to: 0..<cols)]]
    }
}
extension BLAS.TT: Tensor {
    @usableFromInline
    var shape: Array<Int> {
        contraction(lhs: x.shape, rhs: y.shape, order: w)
    }
    @usableFromInline
    var diagonal: V {
        fatalError("WIP")
    }
    @usableFromInline
    var transpose: T {
        .init(x: y.transpose, y: x.transpose, w: w)
    }
    @usableFromInline
    subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
        self[position.map{ $0..<$0 } + shape.dropFirst(position.count).map{ 0..<$0 }]
    }
    @usableFromInline
    subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
        let slice = zip(bounds, shape).map { $0.relative(to: 0..<$1) } + shape.dropFirst(bounds.count).map { 0..<$0 }
        let xs = slice.dropLast(w) + x.shape.suffix(w).map { 0..<$0 }
        let ys = y.shape.prefix(w).map { 0..<$0 } + slice.dropFirst(w)
        assert(xs.count == x.shape.count)
        assert(ys.count == y.shape.count)
        return.init(x: x[xs],
                    y: y[ys],
                    w: w)
    }
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        let (xs, xm) = try x.evaluation(for: .rowMajor)
        let (ys, ym) = try y.evaluation(for: .columnMajor)
        let ((m, n, k), lda, ldb, ldc, stride, offset) = contraction(lhs: (x.shape, xs),
                                                                     rhs: (y.shape, ys),
                                                                     order: w, strategy: strategy)
        let length = k.1
        // MARK: Inner dot
        switch (m, n, k.0, lda, ldb, ldc) {
        case (1, 1, let N, (0, let incx), (let incy, 0), (1, 1)):
            return (stride, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(arrayLiteral: length.reduce(0 as Element) {
                            $0 + Element.Inner(n: N,
                                               x: x.advanced(by: $1.x), ldx: incx,
                                               y: y.advanced(by: $1.y), ldy: incy)
                        })
                }
            })
            // MARK: Outer dot
        case (let m, let n, 1, (let incx, 0), (0, let incy), (1, let ldc)): // Col-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            $0.initialize(repeating: .zero)
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                for offset in length {
                                    Element.Outer(m: m, n: n,
                                                  α: 1,
                                                  x: x.advanced(by: offset.x), ldx: incx,
                                                  y: y.advanced(by: offset.y), ldy: incy,
                                                  β: 1,
                                                  a: z, lda: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (let m, let n, 1, (let incx, 0), (0, let incy), (let ldc, 1)): // Row-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            $0.initialize(repeating: .zero)
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                for offset in length {
                                    Element.Outer(m: n, n: m,
                                                  α: 1,
                                                  x: y.advanced(by: offset.y), ldx: incy,
                                                  y: x.advanced(by: offset.x), ldy: incx,
                                                  β: 1,
                                                  a: z, lda: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
            // MARK: LHS GEMV routines
        case (let m, 1, let k, (1, let lda), let incx, let incy): // Col-Major Col-Vector
            let capacity = capacity(alloc: shape, stride: stride)
            let incx = incx.0
            let incy = incy.0
            return (stride, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMV(m: m, n: k,
                                             α: 1,
                                             a: x, lda: lda, opa: "N",
                                             x: y, ldx: incx,
                                             β: 0,
                                             y: z, ldy: incy)
                                for offset in length.dropFirst() {
                                    Element.GEMV(m: m, n: k,
                                                 α: 1,
                                                 a: x.advanced(by: offset.x), lda: lda, opa: "N",
                                                 x: y.advanced(by: offset.y), ldx: incx,
                                                 β: 1,
                                                 y: z, ldy: incy)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (let m, 1, let k, (let lda, 1), let incx, let incy): // Row-Major Col-Vector
            let capacity = capacity(alloc: shape, stride: stride)
            let incx = incx.0
            let incy = incy.0
            return (stride, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMV(m: k, n: m,
                                             α: 1,
                                             a: x, lda: lda, opa: "T",
                                             x: y, ldx: incx,
                                             β: 0,
                                             y: z, ldy: incy)
                                for offset in length.dropFirst() {
                                    Element.GEMV(m: k, n: m,
                                                 α: 1,
                                                 a: x.advanced(by: offset.x), lda: lda, opa: "T",
                                                 x: y.advanced(by: offset.y), ldx: incx,
                                                 β: 1,
                                                 y: z, ldy: incy)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
            // MARK: RHS GEMV routines
        case (1, let n, let k, let incx, (1, let ldb), let incy): // Row-Vector Col-Major
            let capacity = capacity(alloc: shape, stride: stride)
            let incx = incx.1
            let incy = incy.1
            return (stride, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMV(m: k, n: n,
                                             α: 1,
                                             a: y, lda: ldb, opa: "T",
                                             x: x, ldx: incx,
                                             β: 0,
                                             y: z, ldy: incy)
                                for offset in length.dropFirst() {
                                    Element.GEMV(m: k, n: n,
                                                 α: 1,
                                                 a: y.advanced(by: offset.y), lda: ldb, opa: "T",
                                                 x: x.advanced(by: offset.x), ldx: incx,
                                                 β: 1,
                                                 y: z, ldy: incy)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (1, let n, let k, let incx, (let ldb, 1), let incy): // Row-Vector Row-Major
            let capacity = capacity(alloc: shape, stride: stride)
            let incx = incx.1
            let incy = incy.1
            return (stride, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMV(m: n, n: k,
                                             α: 1,
                                             a: y, lda: ldb, opa: "N",
                                             x: x, ldx: incx,
                                             β: 0,
                                             y: z, ldy: incy)
                                for offset in length.dropFirst() {
                                    Element.GEMV(m: n, n: k,
                                                 α: 1,
                                                 a: y.advanced(by: offset.y), lda: ldb, opa: "N",
                                                 x: x.advanced(by: offset.x), ldx: incx,
                                                 β: 1,
                                                 y: z, ldy: incy)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
            // MARK: GEMM routines
        case (let m, let n, let k, (1, let lda), (1, let ldb), (1, let ldc)): // Col-Major, Col-Major, Col-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMM(m: m, n: n, k: k,
                                             α: 1,
                                             a: x, lda: lda, opa: "N",
                                             b: y, ldb: ldb, opb: "N",
                                             β: 0,
                                             c: z, ldc: ldc)
                                for offset in length.dropFirst() {
                                    Element.GEMM(m: m, n: n, k: k,
                                                 α: 1,
                                                 a: x.advanced(by: offset.x), lda: lda, opa: "N",
                                                 b: y.advanced(by: offset.y), ldb: ldb, opb: "N",
                                                 β: 1,
                                                 c: z, ldc: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (let m, let n, let k, (1, let lda), (let ldb, 1), (1, let ldc)): // Col-Major, Row-Major, Col-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                await withUnsafePointer(xm(), ym()) { x, y in
                    .init(unsafeUninitializedCapacity: capacity) {
                        let z = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            let x = x.advanced(by: offset.x)
                            let y = y.advanced(by: offset.y)
                            let z = z.advanced(by: offset.z)
                            Element.GEMM(m: m, n: n, k: k,
                                         α: 1,
                                         a: x, lda: lda, opa: "F",
                                         b: y, ldb: ldb, opb: "T",
                                         β: 0,
                                         c: z, ldc: ldc)
                            for offset in length.dropFirst() {
                                Element.GEMM(m: m, n: n, k: k,
                                             α: 1,
                                             a: x.advanced(by: offset.x), lda: lda, opa: "F",
                                             b: y.advanced(by: offset.y), ldb: ldb, opb: "T",
                                             β: 1,
                                             c: z, ldc: ldc)
                            }
                        }
                        $1 = $0.count
                    }
                }
            })
        case (let m, let n, let k, (let lda, 1), (1, let ldb), (1, let ldc)): // Row-Major, Col-Major, Col-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMM(m: m, n: n, k: k,
                                             α: 1,
                                             a: x, lda: lda, opa: "T",
                                             b: y, ldb: ldb, opb: "N",
                                             β: 0,
                                             c: z, ldc: ldc)
                                for offset in length.dropFirst() {
                                    Element.GEMM(m: m, n: n, k: k,
                                                 α: 1,
                                                 a: x.advanced(by: offset.x), lda: lda, opa: "T",
                                                 b: y.advanced(by: offset.y), ldb: ldb, opb: "N",
                                                 β: 1,
                                                 c: z, ldc: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (let m, let n, let k, (let lda, 1), (let ldb, 1), (1, let ldc)): // Row-Major, Row-Major, Col-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMM(m: m, n: n, k: k,
                                             α: 1,
                                             a: x, lda: lda, opa: "T",
                                             b: y, ldb: ldb, opb: "T",
                                             β: 0,
                                             c: z, ldc: ldc)
                                for offset in length.dropFirst() {
                                    Element.GEMM(m: m, n: n, k: k,
                                                 α: 1,
                                                 a: x.advanced(by: offset.x), lda: lda, opa: "T",
                                                 b: y.advanced(by: offset.y), ldb: ldb, opb: "T",
                                                 β: 1,
                                                 c: z, ldc: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (let m, let n, let k, (1, let lda), (1, let ldb), (let ldc, 1)): // Col-Major, Col-Major, Row-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMM(m: n, n: m, k: k,
                                             α: 1,
                                             a: y, lda: ldb, opa: "T",
                                             b: x, ldb: lda, opb: "T",
                                             β: 0,
                                             c: z, ldc: ldc)
                                for offset in length.dropFirst() {
                                    Element.GEMM(m: n, n: m, k: k,
                                                 α: 1,
                                                 a: y.advanced(by: offset.y), lda: ldb, opa: "T",
                                                 b: x.advanced(by: offset.x), ldb: lda, opb: "T",
                                                 β: 1,
                                                 c: z, ldc: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (let m, let n, let k, (1, let lda), (let ldb, 1), (let ldc, 1)): // Col-Major, Row-Major, Row-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMM(m: n, n: m, k: k,
                                             α: 1,
                                             a: y, lda: ldb, opa: "N",
                                             b: x, ldb: lda, opb: "T",
                                             β: 0,
                                             c: z, ldc: ldc)
                                for offset in length.dropFirst() {
                                    Element.GEMM(m: n, n: m, k: k,
                                                 α: 1,
                                                 a: y.advanced(by: offset.y), lda: ldb, opa: "N",
                                                 b: x.advanced(by: offset.x), ldb: lda, opb: "T",
                                                 β: 1,
                                                 c: z, ldc: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (let m, let n, let k, (let lda, 1), (1, let ldb), (let ldc, 1)): // Row-Major, Col-Major, Row-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMM(m: n, n: m, k: k,
                                             α: 1,
                                             a: y, lda: ldb, opa: "T",
                                             b: x, ldb: lda, opb: "N",
                                             β: 0,
                                             c: z, ldc: ldc)
                                for offset in length.dropFirst() {
                                    Element.GEMM(m: n, n: m, k: k,
                                                 α: 1,
                                                 a: y.advanced(by: offset.y), lda: ldb, opa: "T",
                                                 b: x.advanced(by: offset.x), ldb: lda, opb: "N",
                                                 β: 0,
                                                 c: z, ldc: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (let m, let n, let k, (let lda, 1), (let ldb, 1), (let ldc, 1)): // Row-Major, Row-Major, Row-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMM(m: n, n: m, k: k,
                                             α: 1,
                                             a: y, lda: ldb, opa: "N",
                                             b: x, ldb: lda, opb: "N",
                                             β: 0,
                                             c: z, ldc: ldc)
                                for offset in length.dropFirst() {
                                    Element.GEMM(m: n, n: m, k: k,
                                                 α: 1,
                                                 a: y.advanced(by: offset.y), lda: ldb, opa: "N",
                                                 b: x.advanced(by: offset.x), ldb: lda, opb: "N",
                                                 β: 1,
                                                 c: z, ldc: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        default:
            assertionFailure("[TRAP] try to specialize production for m=\(m), n=\(n), k=\(k), lda=\(lda), ldb=\(ldb), ldc=\(ldc)")
            let xk = x.shape
            let yk = y.shape
            let xr = xk.dropLast(w)
            let xc = xk.suffix(w)
            let yr = yk.prefix(w)
            let yc = yk.dropFirst(w)
            let zk = xr + yc
            let xt = MemoryStrategy.rowMajor.stride(for: xk)
            let yt = MemoryStrategy.columnMajor.stride(for: yk)
            let xo = flatten(shape: xk, xs: xs, ys: xt)
            let yo = flatten(shape: yk, xs: ys, ys: yt)
            let xb = capacity(alloc: xk, stride: xt)
            let yb = capacity(alloc: yk, stride: yt)
            let zr = MemoryStrategy.rowMajor.stride(for: xr)
            let zc = MemoryStrategy.columnMajor.stride(for: yc)
            let m = xr.reduce(1, &*)
            let n = yc.reduce(1, &*)
            switch strategy {
            case.columnMajor:
                let k = zip(xc, yr.reversed()).lazy.map(broadcast).reduce(1, &*) as Int
                let zs = capacity(alloc: xr, stride: zr)
                let zt = zr + zc.lazy.map { $0 * zs }
                let zb = capacity(alloc: zk, stride: zt)
                return (zt, {
                    await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: zb + xb + yb) {
                            let c = $0.baseAddress.unsafelyUnwrapped
                            let b = c.advanced(by: zb)
                            let a = b.advanced(by: yb)
                            for offset in xo.2 {
                                Element.Copy(x: x.advanced(by: offset.x), ldx: xo.1.x,
                                             y: a.advanced(by: offset.y), ldy: xo.1.y,
                                             length: xo.0)
                            }
                            for offset in yo.2 {
                                Element.Copy(x: y.advanced(by: offset.x), ldx: yo.1.x,
                                             y: b.advanced(by: offset.y), ldy: yo.1.y,
                                             length: yo.0)
                            }
                            Element.GEMM(m: m, n: n, k: k,
                                         α: 1,
                                         a: a, lda: k, opa: "T",
                                         b: b, ldb: k, opb: "N",
                                         β: 0,
                                         c: c, ldc: m)
                            $1 = zb
                        }
                    }
                })
            case.rowMajor:
                let k = zip(xc.reversed(), yr).lazy.map(broadcast).reduce(1, &*) as Int
                let zs = capacity(alloc: yc, stride: zc)
                let zt = zr.lazy.map { $0 &* zs } + zc
                let zb = capacity(alloc: zk, stride: zt)
                return (zt, {
                    await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: zb + xb + yb) {
                            let c = $0.baseAddress.unsafelyUnwrapped
                            let b = c.advanced(by: zb)
                            let a = b.advanced(by: yb)
                            for offset in xo.2 {
                                Element.Copy(x: x.advanced(by: offset.x), ldx: xo.1.x,
                                             y: a.advanced(by: offset.y), ldy: xo.1.y,
                                             length: xo.0)
                            }
                            for offset in yo.2 {
                                Element.Copy(x: y.advanced(by: offset.x), ldx: yo.1.x,
                                             y: b.advanced(by: offset.y), ldy: yo.1.y,
                                             length: yo.0)
                            }
                            Element.GEMM(m: n, n: m, k: k,
                                         α: 1,
                                         a: b, lda: k, opa: "T",
                                         b: a, ldb: k, opb: "N",
                                         β: 0,
                                         c: c, ldc: n)
                            $1 = zb
                        }
                    }
                })
            }
        }
    }
}
extension BLAS.TT: InstantTensor & InstantMatrix & InstantVector & InstantScalar where X: InstantTensor, Y: InstantTensor {
    @usableFromInline
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let (xs, xm) = try x.evaluation(for: .rowMajor)
        let (ys, ym) = try y.evaluation(for: .columnMajor)
        let ((m, n, k), lda, ldb, ldc, stride, offset) = contraction(lhs: (x.shape, xs),
                                                                     rhs: (y.shape, ys),
                                                                     order: w, strategy: strategy)
        let length = k.1
        // MARK: Inner dot
        switch (m, n, k.0, lda, ldb, ldc) {
        case (1, 1, let N, (0, let incx), (let incy, 0), (1, 1)):
            return (stride, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(arrayLiteral: length.reduce(0 as Element) {
                            $0 + Element.Inner(n: N,
                                               x: x.advanced(by: $1.x), ldx: incx,
                                               y: y.advanced(by: $1.y), ldy: incy)
                        })
                }
            })
            // MARK: Outer dot
        case (let m, let n, 1, (let incx, 0), (0, let incy), (1, let ldc)): // Col-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            $0.initialize(repeating: .zero)
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                for offset in length {
                                    Element.Outer(m: m, n: n,
                                                  α: 1,
                                                  x: x.advanced(by: offset.x), ldx: incx,
                                                  y: y.advanced(by: offset.y), ldy: incy,
                                                  β: 1,
                                                  a: z, lda: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (let m, let n, 1, (let incx, 0), (0, let incy), (let ldc, 1)): // Row-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            $0.initialize(repeating: .zero)
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                for offset in length {
                                    Element.Outer(m: n, n: m,
                                                  α: 1,
                                                  x: y.advanced(by: offset.y), ldx: incy,
                                                  y: x.advanced(by: offset.x), ldy: incx,
                                                  β: 1,
                                                  a: z, lda: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
            // MARK: LHS GEMV routines
        case (let m, 1, let k, (1, let lda), let incx, let incy): // Col-Major Col-Vector
            let capacity = capacity(alloc: shape, stride: stride)
            let incx = incx.0
            let incy = incy.0
            return (stride, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMV(m: m, n: k,
                                             α: 1,
                                             a: x, lda: lda, opa: "N",
                                             x: y, ldx: incx,
                                             β: 0,
                                             y: z, ldy: incy)
                                for offset in length.dropFirst() {
                                    Element.GEMV(m: m, n: k,
                                                 α: 1,
                                                 a: x.advanced(by: offset.x), lda: lda, opa: "N",
                                                 x: y.advanced(by: offset.y), ldx: incx,
                                                 β: 1,
                                                 y: z, ldy: incy)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (let m, 1, let k, (let lda, 1), let incx, let incy): // Row-Major Col-Vector
            let capacity = capacity(alloc: shape, stride: stride)
            let incx = incx.0
            let incy = incy.0
            return (stride, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMV(m: k, n: m,
                                             α: 1,
                                             a: x, lda: lda, opa: "T",
                                             x: y, ldx: incx,
                                             β: 0,
                                             y: z, ldy: incy)
                                for offset in length.dropFirst() {
                                    Element.GEMV(m: k, n: m,
                                                 α: 1,
                                                 a: x.advanced(by: offset.x), lda: lda, opa: "T",
                                                 x: y.advanced(by: offset.y), ldx: incx,
                                                 β: 1,
                                                 y: z, ldy: incy)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
            // MARK: RHS GEMV routines
        case (1, let n, let k, let incx, (1, let ldb), let incy): // Row-Vector Col-Major
            let capacity = capacity(alloc: shape, stride: stride)
            let incx = incx.1
            let incy = incy.1
            return (stride, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMV(m: k, n: n,
                                             α: 1,
                                             a: y, lda: ldb, opa: "T",
                                             x: x, ldx: incx,
                                             β: 0,
                                             y: z, ldy: incy)
                                for offset in length.dropFirst() {
                                    Element.GEMV(m: k, n: n,
                                                 α: 1,
                                                 a: y.advanced(by: offset.y), lda: ldb, opa: "T",
                                                 x: x.advanced(by: offset.x), ldx: incx,
                                                 β: 1,
                                                 y: z, ldy: incy)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (1, let n, let k, let incx, (let ldb, 1), let incy): // Row-Vector Row-Major
            let capacity = capacity(alloc: shape, stride: stride)
            let incx = incx.1
            let incy = incy.1
            return (stride, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMV(m: n, n: k,
                                             α: 1,
                                             a: y, lda: ldb, opa: "N",
                                             x: x, ldx: incx,
                                             β: 0,
                                             y: z, ldy: incy)
                                for offset in length.dropFirst() {
                                    Element.GEMV(m: n, n: k,
                                                 α: 1,
                                                 a: y.advanced(by: offset.y), lda: ldb, opa: "N",
                                                 x: x.advanced(by: offset.x), ldx: incx,
                                                 β: 1,
                                                 y: z, ldy: incy)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
            // MARK: GEMM routines
        case (let m, let n, let k, (1, let lda), (1, let ldb), (1, let ldc)): // Col-Major, Col-Major, Col-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMM(m: m, n: n, k: k,
                                             α: 1,
                                             a: x, lda: lda, opa: "N",
                                             b: y, ldb: ldb, opb: "N",
                                             β: 0,
                                             c: z, ldc: ldc)
                                for offset in length.dropFirst() {
                                    Element.GEMM(m: m, n: n, k: k,
                                                 α: 1,
                                                 a: x.advanced(by: offset.x), lda: lda, opa: "N",
                                                 b: y.advanced(by: offset.y), ldb: ldb, opb: "N",
                                                 β: 1,
                                                 c: z, ldc: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (let m, let n, let k, (1, let lda), (let ldb, 1), (1, let ldc)): // Col-Major, Row-Major, Col-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                withUnsafePointer(xm(), ym()) { x, y in
                    .init(unsafeUninitializedCapacity: capacity) {
                        let z = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            let x = x.advanced(by: offset.x)
                            let y = y.advanced(by: offset.y)
                            let z = z.advanced(by: offset.z)
                            Element.GEMM(m: m, n: n, k: k,
                                         α: 1,
                                         a: x, lda: lda, opa: "F",
                                         b: y, ldb: ldb, opb: "T",
                                         β: 0,
                                         c: z, ldc: ldc)
                            for offset in length.dropFirst() {
                                Element.GEMM(m: m, n: n, k: k,
                                             α: 1,
                                             a: x.advanced(by: offset.x), lda: lda, opa: "F",
                                             b: y.advanced(by: offset.y), ldb: ldb, opb: "T",
                                             β: 1,
                                             c: z, ldc: ldc)
                            }
                        }
                        $1 = $0.count
                    }
                }
            })
        case (let m, let n, let k, (let lda, 1), (1, let ldb), (1, let ldc)): // Row-Major, Col-Major, Col-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMM(m: m, n: n, k: k,
                                             α: 1,
                                             a: x, lda: lda, opa: "T",
                                             b: y, ldb: ldb, opb: "N",
                                             β: 0,
                                             c: z, ldc: ldc)
                                for offset in length.dropFirst() {
                                    Element.GEMM(m: m, n: n, k: k,
                                                 α: 1,
                                                 a: x.advanced(by: offset.x), lda: lda, opa: "T",
                                                 b: y.advanced(by: offset.y), ldb: ldb, opb: "N",
                                                 β: 1,
                                                 c: z, ldc: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (let m, let n, let k, (let lda, 1), (let ldb, 1), (1, let ldc)): // Row-Major, Row-Major, Col-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMM(m: m, n: n, k: k,
                                             α: 1,
                                             a: x, lda: lda, opa: "T",
                                             b: y, ldb: ldb, opb: "T",
                                             β: 0,
                                             c: z, ldc: ldc)
                                for offset in length.dropFirst() {
                                    Element.GEMM(m: m, n: n, k: k,
                                                 α: 1,
                                                 a: x.advanced(by: offset.x), lda: lda, opa: "T",
                                                 b: y.advanced(by: offset.y), ldb: ldb, opb: "T",
                                                 β: 1,
                                                 c: z, ldc: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (let m, let n, let k, (1, let lda), (1, let ldb), (let ldc, 1)): // Col-Major, Col-Major, Row-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMM(m: n, n: m, k: k,
                                             α: 1,
                                             a: y, lda: ldb, opa: "T",
                                             b: x, ldb: lda, opb: "T",
                                             β: 0,
                                             c: z, ldc: ldc)
                                for offset in length.dropFirst() {
                                    Element.GEMM(m: n, n: m, k: k,
                                                 α: 1,
                                                 a: y.advanced(by: offset.y), lda: ldb, opa: "T",
                                                 b: x.advanced(by: offset.x), ldb: lda, opb: "T",
                                                 β: 1,
                                                 c: z, ldc: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (let m, let n, let k, (1, let lda), (let ldb, 1), (let ldc, 1)): // Col-Major, Row-Major, Row-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMM(m: n, n: m, k: k,
                                             α: 1,
                                             a: y, lda: ldb, opa: "N",
                                             b: x, ldb: lda, opb: "T",
                                             β: 0,
                                             c: z, ldc: ldc)
                                for offset in length.dropFirst() {
                                    Element.GEMM(m: n, n: m, k: k,
                                                 α: 1,
                                                 a: y.advanced(by: offset.y), lda: ldb, opa: "N",
                                                 b: x.advanced(by: offset.x), ldb: lda, opb: "T",
                                                 β: 1,
                                                 c: z, ldc: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (let m, let n, let k, (let lda, 1), (1, let ldb), (let ldc, 1)): // Row-Major, Col-Major, Row-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMM(m: n, n: m, k: k,
                                             α: 1,
                                             a: y, lda: ldb, opa: "T",
                                             b: x, ldb: lda, opb: "N",
                                             β: 0,
                                             c: z, ldc: ldc)
                                for offset in length.dropFirst() {
                                    Element.GEMM(m: n, n: m, k: k,
                                                 α: 1,
                                                 a: y.advanced(by: offset.y), lda: ldb, opa: "T",
                                                 b: x.advanced(by: offset.x), ldb: lda, opb: "N",
                                                 β: 0,
                                                 c: z, ldc: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case (let m, let n, let k, (let lda, 1), (let ldb, 1), (let ldc, 1)): // Row-Major, Row-Major, Row-Major
            let capacity = capacity(alloc: shape, stride: stride)
            return (stride, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.GEMM(m: n, n: m, k: k,
                                             α: 1,
                                             a: y, lda: ldb, opa: "N",
                                             b: x, ldb: lda, opb: "N",
                                             β: 0,
                                             c: z, ldc: ldc)
                                for offset in length.dropFirst() {
                                    Element.GEMM(m: n, n: m, k: k,
                                                 α: 1,
                                                 a: y.advanced(by: offset.y), lda: ldb, opa: "N",
                                                 b: x.advanced(by: offset.x), ldb: lda, opb: "N",
                                                 β: 1,
                                                 c: z, ldc: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        default:
            assertionFailure("[TRAP] try to specialize production for m=\(m), n=\(n), k=\(k), lda=\(lda), ldb=\(ldb), ldc=\(ldc)")
            let xk = x.shape
            let yk = y.shape
            let xr = xk.dropLast(w)
            let xc = xk.suffix(w)
            let yr = yk.prefix(w)
            let yc = yk.dropFirst(w)
            let zk = xr + yc
            let xt = MemoryStrategy.rowMajor.stride(for: xk)
            let yt = MemoryStrategy.columnMajor.stride(for: yk)
            let xo = flatten(shape: xk, xs: xs, ys: xt)
            let yo = flatten(shape: yk, xs: ys, ys: yt)
            let xb = capacity(alloc: xk, stride: xt)
            let yb = capacity(alloc: yk, stride: yt)
            let zr = MemoryStrategy.rowMajor.stride(for: xr)
            let zc = MemoryStrategy.columnMajor.stride(for: yc)
            let m = xr.reduce(1, &*)
            let n = yc.reduce(1, &*)
            switch strategy {
            case.columnMajor:
                let k = zip(xc, yr.reversed()).lazy.map(broadcast).reduce(1, &*) as Int
                let zs = capacity(alloc: xr, stride: zr)
                let zt = zr + zc.lazy.map { $0 * zs }
                let zb = capacity(alloc: zk, stride: zt)
                return (zt, {
                    withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: zb + xb + yb) {
                            let c = $0.baseAddress.unsafelyUnwrapped
                            let b = c.advanced(by: zb)
                            let a = b.advanced(by: yb)
                            for offset in xo.2 {
                                Element.Copy(x: x.advanced(by: offset.x), ldx: xo.1.x,
                                             y: a.advanced(by: offset.y), ldy: xo.1.y,
                                             length: xo.0)
                            }
                            for offset in yo.2 {
                                Element.Copy(x: y.advanced(by: offset.x), ldx: yo.1.x,
                                             y: b.advanced(by: offset.y), ldy: yo.1.y,
                                             length: yo.0)
                            }
                            Element.GEMM(m: m, n: n, k: k,
                                         α: 1,
                                         a: a, lda: k, opa: "T",
                                         b: b, ldb: k, opb: "N",
                                         β: 0,
                                         c: c, ldc: m)
                            $1 = zb
                        }
                    }
                })
            case.rowMajor:
                let k = zip(xc.reversed(), yr).lazy.map(broadcast).reduce(1, &*) as Int
                let zs = capacity(alloc: yc, stride: zc)
                let zt = zr.lazy.map { $0 &* zs } + zc
                let zb = capacity(alloc: zk, stride: zt)
                return (zt, {
                    withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: zb + xb + yb) {
                            let c = $0.baseAddress.unsafelyUnwrapped
                            let b = c.advanced(by: zb)
                            let a = b.advanced(by: yb)
                            for offset in xo.2 {
                                Element.Copy(x: x.advanced(by: offset.x), ldx: xo.1.x,
                                             y: a.advanced(by: offset.y), ldy: xo.1.y,
                                             length: xo.0)
                            }
                            for offset in yo.2 {
                                Element.Copy(x: y.advanced(by: offset.x), ldx: yo.1.x,
                                             y: b.advanced(by: offset.y), ldy: yo.1.y,
                                             length: yo.0)
                            }
                            Element.GEMM(m: n, n: m, k: k,
                                         α: 1,
                                         a: b, lda: k, opa: "T",
                                         b: a, ldb: k, opb: "N",
                                         β: 0,
                                         c: c, ldc: n)
                            $1 = zb
                        }
                    }
                })
            }
        }
    }
}
@_disfavoredOverload
public func •<Element: BLASElement & ArithmeticElement>(_ lhs: some Tensor<Element>, _ rhs: some Tensor<Element>) -> some Tensor<Element> {
    BLAS.TT(x: lhs, y: rhs, w: 1)
}
@_disfavoredOverload
public func outer<Element: BLASElement & ArithmeticElement>(_ lhs: some Tensor<Element>, _ rhs: some Tensor<Element>) -> some Tensor<Element> {
    BLAS.TT(x: lhs, y: rhs, w: 0)
}
@_disfavoredOverload
public func •<Element: BLASElement & ArithmeticElement>(_ lhs: some InstantTensor<Element>, _ rhs: some InstantTensor<Element>) -> some InstantTensor<Element> {
    BLAS.TT(x: lhs, y: rhs, w: 1)
}
@_disfavoredOverload
public func outer<Element: BLASElement & ArithmeticElement>(_ lhs: some InstantTensor<Element>, _ rhs: some InstantTensor<Element>) -> some InstantTensor<Element> {
    BLAS.TT(x: lhs, y: rhs, w: 0)
}
