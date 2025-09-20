//
//  DOT+T.swift
//  MUSE
//
//  Created by Kota on 9/18/R7.
//
import typealias Layout.MemoryStrategy
import func Layout.contraction
import func Layout.capacity
import func Layout.flatten
import func Layout.broadcast
import func Layout.narrowcast
@usableFromInline
protocol Contraction<Element> {
    associatedtype Element: BLASElement & ArithmeticElement
    associatedtype X: Tensor<Element>
    associatedtype Y: Tensor<Element>
    @inlinable var x: X { get }
    @inlinable var y: Y { get }
    @inlinable var shape: Array<Int> { get }
    @inlinable var order: Int { get }
}
extension Contraction {
    @inlinable
    func callAsFunction(as strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        let (xs, xm) = try x(as: .rowMajor)
        let (ys, ym) = try y(as: .columnMajor)
        let ((m, n, k), lda, ldb, ldc, stride, offset) = contraction(lhs: (x.shape, xs),
                                                                     rhs: (y.shape, ys),
                                                                     order: order, strategy: strategy)
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
            let xr = xk.dropLast(order)
            let xc = xk.suffix(order)
            let yr = yk.prefix(order)
            let yc = yk.dropFirst(order)
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
extension DOT {
    @usableFromInline
    enum TT<X: Tensor<Element>, Y: Tensor<Element>> {
        @usableFromInline
        typealias R = Array<Element>
        @usableFromInline
        struct U {
            @usableFromInline typealias S = Self
            @usableFromInline typealias T = Self
            @usableFromInline typealias U = Self
            @usableFromInline typealias V = Self
            @usableFromInline let x: X
            @usableFromInline let y: Y
            @usableFromInline let order: Int
        }
    }
}

//extension DOT.TT: Vector {
//    @inlinable
//    var count: Int {
//        let s = x.shape.dropLast(order) + y.shape.dropFirst(order)
//        precondition(s.count == 1, "shape isn't vector")
//        return s.reduce(1, *)
//    }
//    @usableFromInline
//    subscript(position: Int) -> U {
//        fatalError()
//    }
//    @usableFromInline
//    subscript(bounds: some RangeExpression<Int>) -> V {
//        fatalError()
//    }
//}
//extension DOT.TT: Matrix {
//    @inlinable
//    var rows: Int {
//        shape.first ?? 1
//    }
//    @inlinable
//    var cols: Int {
//        shape.last ?? 1
//    }
//    @usableFromInline
//    subscript(row: Int, col: Int) -> U {
//        fatalError()
//    }
//    @usableFromInline
//    subscript(row: Int, col: some RangeExpression<Int>) -> V {
//        fatalError()
//    }
//    @usableFromInline
//    subscript(row: some RangeExpression<Int>, col: Int) -> DOT<Element>.TT<X.S, Y.S> {
//        fatalError()
//    }
//    @usableFromInline
//    subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> DOT<Element>.TT<X.S, Y.S> {
//        fatalError()
//    }
//}
//extension DOT.TT: Tensor {
//	@inlinable
//	var shape: Array<Int> {
//		contraction(lhs: x.shape, rhs: y.shape, order: order)
//	}
//	@usableFromInline
//	var diagonal: V {
////		Basic<Element>.Diagonal(source: self)
//        fatalError()
//	}
//	@usableFromInline
//	var transpose: T {
//		.init(x: y.transpose, y: x.transpose, order: order)
//	}
//	@usableFromInline
//	subscript(position: some RandomAccessCollection<Int>) -> U {
//		let r = (x.shape.dropLast(order), x.shape.suffix(order))
//		let c = (y.shape.prefix(order), y.shape.dropFirst(order))
////		return.init(x: .init(core: x[position.prefix(r.0.count).map { $0..<$0 } + r.1.map{0..<$0}]),
////					y: .init(core: y[c.0.map{0..<$0} + position.dropFirst(r.0.count).map{$0..<$0}]))
//        fatalError()
//	}
//	@usableFromInline
//	subscript(bounds: some RandomAccessCollection<some RangeExpression<Int>>) -> S {
//		let r = (x.shape.dropLast(order), x.shape.suffix(order))
//		let c = (y.shape.prefix(order), y.shape.dropFirst(order))
//		return.init(x: x[narrowcast(ranges: zip(r.0, bounds.prefix(r.0.count)).map{(0..<$0)[$1]} + r.1.map{0..<$0}, target: shape, source: x.shape)],
//					y: y[narrowcast(ranges: c.0.map{0..<$0} + zip(c.1, bounds.dropFirst(r.0.count)).map{(0..<$0)[$1]}, target: shape, source: y.shape)],
//					order: order)
//	}
//	@inlinable
//	func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
//		let (xs, xm) = try x(for: .rowMajor)
//		let (ys, ym) = try y(for: .columnMajor)
//		let ((m, n, k), lda, ldb, ldc, stride, offset) = contraction(lhs: (x.shape, xs),
//																	 rhs: (y.shape, ys),
//																	 order: order, strategy: strategy)
//		let length = k.1
//		// MARK: Inner dot
//		switch (m, n, k.0, lda, ldb, ldc) {
//		case (1, 1, let N, (0, let incx), (let incy, 0), (1, 1)):
//			return (stride, {
//				await withUnsafePointer(xm(), ym()) { x, y in
//						.init(arrayLiteral: length.reduce(0 as Element) {
//							$0 + Element.Inner(n: N,
//											   x: x.advanced(by: $1.x), ldx: incx,
//											   y: y.advanced(by: $1.y), ldy: incy)
//						})
//				}
//			})
//			// MARK: Outer dot
//		case (let m, let n, 1, (let incx, 0), (0, let incy), (1, let ldc)): // Col-Major
//			let capacity = capacity(alloc: shape, stride: stride)
//			return (stride, {
//				await withUnsafePointer(xm(), ym()) { x, y in
//						.init(unsafeUninitializedCapacity: capacity) {
//							let z = $0.baseAddress.unsafelyUnwrapped
//							$0.initialize(repeating: .zero)
//							for offset in offset {
//								let x = x.advanced(by: offset.x)
//								let y = y.advanced(by: offset.y)
//								let z = z.advanced(by: offset.z)
//								for offset in length {
//									Element.Outer(m: m, n: n,
//												  α: 1,
//												  x: x.advanced(by: offset.x), ldx: incx,
//												  y: y.advanced(by: offset.y), ldy: incy,
//												  β: 1,
//												  a: z, lda: ldc)
//								}
//							}
//							$1 = $0.count
//						}
//				}
//			})
//		case (let m, let n, 1, (let incx, 0), (0, let incy), (let ldc, 1)): // Row-Major
//			let capacity = capacity(alloc: shape, stride: stride)
//			return (stride, {
//				await withUnsafePointer(xm(), ym()) { x, y in
//						.init(unsafeUninitializedCapacity: capacity) {
//							let z = $0.baseAddress.unsafelyUnwrapped
//							$0.initialize(repeating: .zero)
//							for offset in offset {
//								let x = x.advanced(by: offset.x)
//								let y = y.advanced(by: offset.y)
//								let z = z.advanced(by: offset.z)
//								for offset in length {
//									Element.Outer(m: n, n: m,
//												  α: 1,
//												  x: y.advanced(by: offset.y), ldx: incy,
//												  y: x.advanced(by: offset.x), ldy: incx,
//												  β: 1,
//												  a: z, lda: ldc)
//								}
//							}
//							$1 = $0.count
//						}
//				}
//			})
//			// MARK: LHS GEMV routines
//		case (let m, 1, let k, (1, let lda), let incx, let incy): // Col-Major Col-Vector
//			let capacity = capacity(alloc: shape, stride: stride)
//			let incx = incx.0
//			let incy = incy.0
//			return (stride, {
//				await withUnsafePointer(xm(), ym()) { x, y in
//						.init(unsafeUninitializedCapacity: capacity) {
//							let z = $0.baseAddress.unsafelyUnwrapped
//							for offset in offset {
//								let x = x.advanced(by: offset.x)
//								let y = y.advanced(by: offset.y)
//								let z = z.advanced(by: offset.z)
//								Element.GEMV(m: m, n: k,
//											 α: 1,
//											 a: x, lda: lda, opa: "N",
//											 x: y, ldx: incx,
//											 β: 0,
//											 y: z, ldy: incy)
//								for offset in length.dropFirst() {
//									Element.GEMV(m: m, n: k,
//												 α: 1,
//												 a: x.advanced(by: offset.x), lda: lda, opa: "N",
//												 x: y.advanced(by: offset.y), ldx: incx,
//												 β: 1,
//												 y: z, ldy: incy)
//								}
//							}
//							$1 = $0.count
//						}
//				}
//			})
//		case (let m, 1, let k, (let lda, 1), let incx, let incy): // Row-Major Col-Vector
//			let capacity = capacity(alloc: shape, stride: stride)
//			let incx = incx.0
//			let incy = incy.0
//			return (stride, {
//				await withUnsafePointer(xm(), ym()) { x, y in
//						.init(unsafeUninitializedCapacity: capacity) {
//							let z = $0.baseAddress.unsafelyUnwrapped
//							for offset in offset {
//								let x = x.advanced(by: offset.x)
//								let y = y.advanced(by: offset.y)
//								let z = z.advanced(by: offset.z)
//								Element.GEMV(m: k, n: m,
//											 α: 1,
//											 a: x, lda: lda, opa: "T",
//											 x: y, ldx: incx,
//											 β: 0,
//											 y: z, ldy: incy)
//								for offset in length.dropFirst() {
//									Element.GEMV(m: k, n: m,
//												 α: 1,
//												 a: x.advanced(by: offset.x), lda: lda, opa: "T",
//												 x: y.advanced(by: offset.y), ldx: incx,
//												 β: 1,
//												 y: z, ldy: incy)
//								}
//							}
//							$1 = $0.count
//						}
//				}
//			})
//			// MARK: RHS GEMV routines
//		case (1, let n, let k, let incx, (1, let ldb), let incy): // Row-Vector Col-Major
//			let capacity = capacity(alloc: shape, stride: stride)
//			let incx = incx.1
//			let incy = incy.1
//			return (stride, {
//				await withUnsafePointer(xm(), ym()) { x, y in
//						.init(unsafeUninitializedCapacity: capacity) {
//							let z = $0.baseAddress.unsafelyUnwrapped
//							for offset in offset {
//								let x = x.advanced(by: offset.x)
//								let y = y.advanced(by: offset.y)
//								let z = z.advanced(by: offset.z)
//								Element.GEMV(m: k, n: n,
//											 α: 1,
//											 a: y, lda: ldb, opa: "T",
//											 x: x, ldx: incx,
//											 β: 0,
//											 y: z, ldy: incy)
//								for offset in length.dropFirst() {
//									Element.GEMV(m: k, n: n,
//												 α: 1,
//												 a: y.advanced(by: offset.y), lda: ldb, opa: "T",
//												 x: x.advanced(by: offset.x), ldx: incx,
//												 β: 1,
//												 y: z, ldy: incy)
//								}
//							}
//							$1 = $0.count
//						}
//				}
//			})
//		case (1, let n, let k, let incx, (let ldb, 1), let incy): // Row-Vector Row-Major
//			let capacity = capacity(alloc: shape, stride: stride)
//			let incx = incx.1
//			let incy = incy.1
//			return (stride, {
//				await withUnsafePointer(xm(), ym()) { x, y in
//						.init(unsafeUninitializedCapacity: capacity) {
//							let z = $0.baseAddress.unsafelyUnwrapped
//							for offset in offset {
//								let x = x.advanced(by: offset.x)
//								let y = y.advanced(by: offset.y)
//								let z = z.advanced(by: offset.z)
//								Element.GEMV(m: n, n: k,
//											 α: 1,
//											 a: y, lda: ldb, opa: "N",
//											 x: x, ldx: incx,
//											 β: 0,
//											 y: z, ldy: incy)
//								for offset in length.dropFirst() {
//									Element.GEMV(m: n, n: k,
//												 α: 1,
//												 a: y.advanced(by: offset.y), lda: ldb, opa: "N",
//												 x: x.advanced(by: offset.x), ldx: incx,
//												 β: 1,
//												 y: z, ldy: incy)
//								}
//							}
//							$1 = $0.count
//						}
//				}
//			})
//			// MARK: GEMM routines
//		case (let m, let n, let k, (1, let lda), (1, let ldb), (1, let ldc)): // Col-Major, Col-Major, Col-Major
//			let capacity = capacity(alloc: shape, stride: stride)
//			return (stride, {
//				await withUnsafePointer(xm(), ym()) { x, y in
//						.init(unsafeUninitializedCapacity: capacity) {
//							let z = $0.baseAddress.unsafelyUnwrapped
//							for offset in offset {
//								let x = x.advanced(by: offset.x)
//								let y = y.advanced(by: offset.y)
//								let z = z.advanced(by: offset.z)
//								Element.GEMM(m: m, n: n, k: k,
//											 α: 1,
//											 a: x, lda: lda, opa: "N",
//											 b: y, ldb: ldb, opb: "N",
//											 β: 0,
//											 c: z, ldc: ldc)
//								for offset in length.dropFirst() {
//									Element.GEMM(m: m, n: n, k: k,
//												 α: 1,
//												 a: x.advanced(by: offset.x), lda: lda, opa: "N",
//												 b: y.advanced(by: offset.y), ldb: ldb, opb: "N",
//												 β: 1,
//												 c: z, ldc: ldc)
//								}
//							}
//							$1 = $0.count
//						}
//				}
//			})
//		case (let m, let n, let k, (1, let lda), (let ldb, 1), (1, let ldc)): // Col-Major, Row-Major, Col-Major
//			let capacity = capacity(alloc: shape, stride: stride)
//			return (stride, {
//				await withUnsafePointer(xm(), ym()) { x, y in
//					.init(unsafeUninitializedCapacity: capacity) {
//						let z = $0.baseAddress.unsafelyUnwrapped
//						for offset in offset {
//							let x = x.advanced(by: offset.x)
//							let y = y.advanced(by: offset.y)
//							let z = z.advanced(by: offset.z)
//							Element.GEMM(m: m, n: n, k: k,
//										 α: 1,
//										 a: x, lda: lda, opa: "F",
//										 b: y, ldb: ldb, opb: "T",
//										 β: 0,
//										 c: z, ldc: ldc)
//							for offset in length.dropFirst() {
//								Element.GEMM(m: m, n: n, k: k,
//											 α: 1,
//											 a: x.advanced(by: offset.x), lda: lda, opa: "F",
//											 b: y.advanced(by: offset.y), ldb: ldb, opb: "T",
//											 β: 1,
//											 c: z, ldc: ldc)
//							}
//						}
//						$1 = $0.count
//					}
//				}
//			})
//		case (let m, let n, let k, (let lda, 1), (1, let ldb), (1, let ldc)): // Row-Major, Col-Major, Col-Major
//			let capacity = capacity(alloc: shape, stride: stride)
//			return (stride, {
//				await withUnsafePointer(xm(), ym()) { x, y in
//						.init(unsafeUninitializedCapacity: capacity) {
//							let z = $0.baseAddress.unsafelyUnwrapped
//							for offset in offset {
//								let x = x.advanced(by: offset.x)
//								let y = y.advanced(by: offset.y)
//								let z = z.advanced(by: offset.z)
//								Element.GEMM(m: m, n: n, k: k,
//											 α: 1,
//											 a: x, lda: lda, opa: "T",
//											 b: y, ldb: ldb, opb: "N",
//											 β: 0,
//											 c: z, ldc: ldc)
//								for offset in length.dropFirst() {
//									Element.GEMM(m: m, n: n, k: k,
//												 α: 1,
//												 a: x.advanced(by: offset.x), lda: lda, opa: "T",
//												 b: y.advanced(by: offset.y), ldb: ldb, opb: "N",
//												 β: 1,
//												 c: z, ldc: ldc)
//								}
//							}
//							$1 = $0.count
//						}
//				}
//			})
//		case (let m, let n, let k, (let lda, 1), (let ldb, 1), (1, let ldc)): // Row-Major, Row-Major, Col-Major
//			let capacity = capacity(alloc: shape, stride: stride)
//			return (stride, {
//				await withUnsafePointer(xm(), ym()) { x, y in
//						.init(unsafeUninitializedCapacity: capacity) {
//							let z = $0.baseAddress.unsafelyUnwrapped
//							for offset in offset {
//								let x = x.advanced(by: offset.x)
//								let y = y.advanced(by: offset.y)
//								let z = z.advanced(by: offset.z)
//								Element.GEMM(m: m, n: n, k: k,
//											 α: 1,
//											 a: x, lda: lda, opa: "T",
//											 b: y, ldb: ldb, opb: "T",
//											 β: 0,
//											 c: z, ldc: ldc)
//								for offset in length.dropFirst() {
//									Element.GEMM(m: m, n: n, k: k,
//												 α: 1,
//												 a: x.advanced(by: offset.x), lda: lda, opa: "T",
//												 b: y.advanced(by: offset.y), ldb: ldb, opb: "T",
//												 β: 1,
//												 c: z, ldc: ldc)
//								}
//							}
//							$1 = $0.count
//						}
//				}
//			})
//		case (let m, let n, let k, (1, let lda), (1, let ldb), (let ldc, 1)): // Col-Major, Col-Major, Row-Major
//			let capacity = capacity(alloc: shape, stride: stride)
//			return (stride, {
//				await withUnsafePointer(xm(), ym()) { x, y in
//						.init(unsafeUninitializedCapacity: capacity) {
//							let z = $0.baseAddress.unsafelyUnwrapped
//							for offset in offset {
//								let x = x.advanced(by: offset.x)
//								let y = y.advanced(by: offset.y)
//								let z = z.advanced(by: offset.z)
//								Element.GEMM(m: n, n: m, k: k,
//											 α: 1,
//											 a: y, lda: ldb, opa: "T",
//											 b: x, ldb: lda, opb: "T",
//											 β: 0,
//											 c: z, ldc: ldc)
//								for offset in length.dropFirst() {
//									Element.GEMM(m: n, n: m, k: k,
//												 α: 1,
//												 a: y.advanced(by: offset.y), lda: ldb, opa: "T",
//												 b: x.advanced(by: offset.x), ldb: lda, opb: "T",
//												 β: 1,
//												 c: z, ldc: ldc)
//								}
//							}
//							$1 = $0.count
//						}
//				}
//			})
//		case (let m, let n, let k, (1, let lda), (let ldb, 1), (let ldc, 1)): // Col-Major, Row-Major, Row-Major
//			let capacity = capacity(alloc: shape, stride: stride)
//			return (stride, {
//				await withUnsafePointer(xm(), ym()) { x, y in
//						.init(unsafeUninitializedCapacity: capacity) {
//							let z = $0.baseAddress.unsafelyUnwrapped
//							for offset in offset {
//								let x = x.advanced(by: offset.x)
//								let y = y.advanced(by: offset.y)
//								let z = z.advanced(by: offset.z)
//								Element.GEMM(m: n, n: m, k: k,
//											 α: 1,
//											 a: y, lda: ldb, opa: "N",
//											 b: x, ldb: lda, opb: "T",
//											 β: 0,
//											 c: z, ldc: ldc)
//								for offset in length.dropFirst() {
//									Element.GEMM(m: n, n: m, k: k,
//												 α: 1,
//												 a: y.advanced(by: offset.y), lda: ldb, opa: "N",
//												 b: x.advanced(by: offset.x), ldb: lda, opb: "T",
//												 β: 1,
//												 c: z, ldc: ldc)
//								}
//							}
//							$1 = $0.count
//						}
//				}
//			})
//		case (let m, let n, let k, (let lda, 1), (1, let ldb), (let ldc, 1)): // Row-Major, Col-Major, Row-Major
//			let capacity = capacity(alloc: shape, stride: stride)
//			return (stride, {
//				await withUnsafePointer(xm(), ym()) { x, y in
//						.init(unsafeUninitializedCapacity: capacity) {
//							let z = $0.baseAddress.unsafelyUnwrapped
//							for offset in offset {
//								let x = x.advanced(by: offset.x)
//								let y = y.advanced(by: offset.y)
//								let z = z.advanced(by: offset.z)
//								Element.GEMM(m: n, n: m, k: k,
//											 α: 1,
//											 a: y, lda: ldb, opa: "T",
//											 b: x, ldb: lda, opb: "N",
//											 β: 0,
//											 c: z, ldc: ldc)
//								for offset in length.dropFirst() {
//									Element.GEMM(m: n, n: m, k: k,
//												 α: 1,
//												 a: y.advanced(by: offset.y), lda: ldb, opa: "T",
//												 b: x.advanced(by: offset.x), ldb: lda, opb: "N",
//												 β: 0,
//												 c: z, ldc: ldc)
//								}
//							}
//							$1 = $0.count
//						}
//				}
//			})
//		case (let m, let n, let k, (let lda, 1), (let ldb, 1), (let ldc, 1)): // Row-Major, Row-Major, Row-Major
//			let capacity = capacity(alloc: shape, stride: stride)
//			return (stride, {
//				await withUnsafePointer(xm(), ym()) { x, y in
//						.init(unsafeUninitializedCapacity: capacity) {
//							let z = $0.baseAddress.unsafelyUnwrapped
//							for offset in offset {
//								let x = x.advanced(by: offset.x)
//								let y = y.advanced(by: offset.y)
//								let z = z.advanced(by: offset.z)
//								Element.GEMM(m: n, n: m, k: k,
//											 α: 1,
//											 a: y, lda: ldb, opa: "N",
//											 b: x, ldb: lda, opb: "N",
//											 β: 0,
//											 c: z, ldc: ldc)
//								for offset in length.dropFirst() {
//									Element.GEMM(m: n, n: m, k: k,
//												 α: 1,
//												 a: y.advanced(by: offset.y), lda: ldb, opa: "N",
//												 b: x.advanced(by: offset.x), ldb: lda, opb: "N",
//												 β: 1,
//												 c: z, ldc: ldc)
//								}
//							}
//							$1 = $0.count
//						}
//				}
//			})
//		default:
//			assertionFailure("[TRAP] try to specialize production for m=\(m), n=\(n), k=\(k), lda=\(lda), ldb=\(ldb), ldc=\(ldc)")
//			let xk = x.shape
//			let yk = y.shape
//			let xr = xk.dropLast(order)
//			let xc = xk.suffix(order)
//			let yr = yk.prefix(order)
//			let yc = yk.dropFirst(order)
//			let zk = xr + yc
//			let xt = MemoryStrategy.rowMajor.stride(for: xk)
//			let yt = MemoryStrategy.columnMajor.stride(for: yk)
//			let xo = flatten(shape: xk, xs: xs, ys: xt)
//			let yo = flatten(shape: yk, xs: ys, ys: yt)
//			let xb = capacity(alloc: xk, stride: xt)
//			let yb = capacity(alloc: yk, stride: yt)
//			let zr = MemoryStrategy.rowMajor.stride(for: xr)
//			let zc = MemoryStrategy.columnMajor.stride(for: yc)
//			let m = xr.reduce(1, &*)
//			let n = yc.reduce(1, &*)
//			switch strategy {
//			case.columnMajor:
//				let k = zip(xc, yr.reversed()).lazy.map(broadcast).reduce(1, &*) as Int
//				let zs = capacity(alloc: xr, stride: zr)
//				let zt = zr + zc.lazy.map { $0 * zs }
//				let zb = capacity(alloc: zk, stride: zt)
//				return (zt, {
//					await withUnsafePointer(xm(), ym()) { x, y in
//						.init(unsafeUninitializedCapacity: zb + xb + yb) {
//							let c = $0.baseAddress.unsafelyUnwrapped
//							let b = c.advanced(by: zb)
//							let a = b.advanced(by: yb)
//							for offset in xo.2 {
//								Element.Copy(x: x.advanced(by: offset.x), ldx: xo.1.x,
//											 y: a.advanced(by: offset.y), ldy: xo.1.y,
//											 length: xo.0)
//							}
//							for offset in yo.2 {
//								Element.Copy(x: y.advanced(by: offset.x), ldx: yo.1.x,
//											 y: b.advanced(by: offset.y), ldy: yo.1.y,
//											 length: yo.0)
//							}
//							Element.GEMM(m: m, n: n, k: k,
//										 α: 1,
//										 a: a, lda: k, opa: "T",
//										 b: b, ldb: k, opb: "N",
//										 β: 0,
//										 c: c, ldc: m)
//							$1 = zb
//						}
//					}
//				})
//			case.rowMajor:
//				let k = zip(xc.reversed(), yr).lazy.map(broadcast).reduce(1, &*) as Int
//				let zs = capacity(alloc: yc, stride: zc)
//				let zt = zr.lazy.map { $0 &* zs } + zc
//				let zb = capacity(alloc: zk, stride: zt)
//				return (zt, {
//					await withUnsafePointer(xm(), ym()) { x, y in
//						.init(unsafeUninitializedCapacity: zb + xb + yb) {
//							let c = $0.baseAddress.unsafelyUnwrapped
//							let b = c.advanced(by: zb)
//							let a = b.advanced(by: yb)
//							for offset in xo.2 {
//								Element.Copy(x: x.advanced(by: offset.x), ldx: xo.1.x,
//											 y: a.advanced(by: offset.y), ldy: xo.1.y,
//											 length: xo.0)
//							}
//							for offset in yo.2 {
//								Element.Copy(x: y.advanced(by: offset.x), ldx: yo.1.x,
//											 y: b.advanced(by: offset.y), ldy: yo.1.y,
//											 length: yo.0)
//							}
//							Element.GEMM(m: n, n: m, k: k,
//										 α: 1,
//										 a: b, lda: k, opa: "T",
//										 b: a, ldb: k, opb: "N",
//										 β: 0,
//										 c: c, ldc: n)
//							$1 = zb
//						}
//					}
//				})
//			}
//		}
//	}
//}
//@_disfavoredOverload
//public func •<Element: BLASElement & ArithmeticElement>(_ lhs: some Tensor<Element>, _ rhs: some Tensor<Element>) -> some Tensor<Element> {
//	DOT.TT(x: lhs, y: rhs, order: 1)
//}
//@_disfavoredOverload
//public func outer<Element: BLASElement & ArithmeticElement>(_ lhs: some Tensor<Element>, _ rhs: some Tensor<Element>) -> some Tensor<Element> {
//	DOT.TT(x: lhs, y: rhs, order: 0)
//}

