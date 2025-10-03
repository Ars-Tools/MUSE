//
//  BLAS+DOT.swift
//  MUSE
//
//  Created by Kota on 9/25/25.
//
import typealias Layout.MemoryStrategy
import func Layout.contraction
import func Layout.concat
import func Layout.capacity
import func Layout.broadcast
import os.log
extension BLAS {
    @frozen public struct DOT<X: Tensor<Element>, Y: Tensor<Element>> {
        public typealias Storage = Array<Element>
        public let order: MemoryStrategy
        public let width: Int
        public let x: X
        public let y: Y
    }
}
extension BLAS.DOT: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> {
        contraction(x: x.shape, y: y.shape, count: width)
    }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        let xk = x.shape
        let yk = y.shape
        let (xs, xm) = try x.evaluation(for: .rowMajor)
        let (ys, ym) = try y.evaluation(for: .columnMajor)
        let ((m, n, k), lda, ldb, ldc, stride, offset) = order.contraction(x: (xk, xs),
                                                                           y: (yk, ys), order: width)
        let length = k.1
        // MARK: Inner dot
        switch (m, n, k.0, lda, ldb, ldc) {
        case(1, 1, let n, (0, let incx), (let incy, 0), _):
            return (stride, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(arrayLiteral: length.reduce(0 as Element) {
                            $0 + Element.Inner(n: n,
                                               x: x.advanced(by: $1.x), ldx: max(1, incx),
                                               y: y.advanced(by: $1.y), ldy: max(1, incy))
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
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.Outer(m: m, n: n,
                                              α: 1,
                                              x: x.advanced(by: offset.x), ldx: max(1, incx),
                                              y: y.advanced(by: offset.y), ldy: max(1, incy),
                                              β: 0,
                                              a: z, lda: ldc)
                                for offset in length.dropFirst() {
                                    Element.Outer(m: m, n: n,
                                                  α: 1,
                                                  x: x.advanced(by: offset.x), ldx: max(1, incx),
                                                  y: y.advanced(by: offset.y), ldy: max(1, incy),
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
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.Outer(m: n, n: m,
                                              α: 1,
                                              x: y.advanced(by: offset.y), ldx: max(1, incy),
                                              y: x.advanced(by: offset.x), ldy: max(1, incx),
                                              β: 0,
                                              a: z, lda: ldc)
                                for offset in length.dropFirst() {
                                    Element.Outer(m: n, n: m,
                                                  α: 1,
                                                  x: y.advanced(by: offset.y), ldx: max(1, incy),
                                                  y: x.advanced(by: offset.x), ldy: max(1, incx),
                                                  β: 1,
                                                  a: z, lda: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        // MARK: LHS GEMV routines
        case(let m, 1, let k, (1, let lda), (let incx, _), (let incy, _)): // Col-Major Col-Vector
            let capacity = capacity(alloc: shape, stride: stride)
            let lda = max(m, lda)
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
        case(let m, 1, let k, (let lda, 1), (let incx, _), (let incy, _)): // Row-Major Col-Vector
            let capacity = capacity(alloc: shape, stride: stride)
            let lda = max(k, lda)
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
        case(1, let n, let k, (_, let incx), (1, let ldb), (_, let incy)): // Row-Vector Col-Major
            let capacity = capacity(alloc: shape, stride: stride)
            let ldb = max(k, ldb)
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
                                             x: x, ldx: max(1, incx),
                                             β: 0,
                                             y: z, ldy: max(1, incy))
                                for offset in length.dropFirst() {
                                    Element.GEMV(m: k, n: n,
                                                 α: 1,
                                                 a: y.advanced(by: offset.y), lda: ldb, opa: "T",
                                                 x: x.advanced(by: offset.x), ldx: max(1, incx),
                                                 β: 1,
                                                 y: z, ldy: max(1, incy))
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case(1, let n, let k, (_, let incx), (let ldb, 1), (_, let incy)): // Row-Vector Row-Major
            let capacity = capacity(alloc: shape, stride: stride)
            let ldb = max(n, ldb)
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
                                             x: x, ldx: max(1, incx),
                                             β: 0,
                                             y: z, ldy: max(1, incy))
                                for offset in length.dropFirst() {
                                    Element.GEMV(m: n, n: k,
                                                 α: 1,
                                                 a: y.advanced(by: offset.y), lda: ldb, opa: "N",
                                                 x: x.advanced(by: offset.x), ldx: max(1, incx),
                                                 β: 1,
                                                 y: z, ldy: max(1, incy))
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
                                             a: x, lda: lda, opa: "N",
                                             b: y, ldb: ldb, opb: "T",
                                             β: 0,
                                             c: z, ldc: ldc)
                                for offset in length.dropFirst() {
                                    Element.GEMM(m: m, n: n, k: k,
                                                 α: 1,
                                                 a: x.advanced(by: offset.x), lda: lda, opa: "N",
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
            os_log(.debug, log: .default, "try to specialize production for m=(%d, %d), n=(%d, %d), k=(%d, %d), lda=(%d, %d), ldb=(%d, %d), ldc=(%d, %d)", m, n, k.0, lda.0, lda.1, ldb.0, ldb.1, ldc.0, ldc.1)
            let xk = x.shape
            let yk = y.shape
            let xr = xk.dropLast(width)
            let xc = xk.suffix(width)
            let yr = yk.prefix(width)
            let yc = yk.dropFirst(width)
            let zk = xr + yc
            let xt = MemoryStrategy.rowMajor.stride(for: xk)
            let yt = MemoryStrategy.columnMajor.stride(for: yk)
            let xo = MemoryStrategy.rowMajor.flatten(shape: xk, xs: xs, ys: xt)
            let yo = MemoryStrategy.columnMajor.flatten(shape: yk, xs: ys, ys: yt)
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
extension BLAS.DOT: InstantTensor where X: InstantTensor, Y: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let xk = x.shape
        let yk = y.shape
        let (xs, xm) = try x.evaluation(for: .rowMajor)
        let (ys, ym) = try y.evaluation(for: .columnMajor)
        let ((m, n, k), lda, ldb, ldc, stride, offset) = order.contraction(x: (xk, xs),
                                                                           y: (yk, ys), order: width)
        let length = k.1
        // MARK: Inner dot
        switch (m, n, k.0, lda, ldb, ldc) {
        case(1, 1, let n, (0, let incx), (let incy, 0), _):
            return (stride, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(arrayLiteral: length.reduce(0 as Element) {
                            $0 + Element.Inner(n: n,
                                               x: x.advanced(by: $1.x), ldx: max(1, incx),
                                               y: y.advanced(by: $1.y), ldy: max(1, incy))
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
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.Outer(m: m, n: n,
                                              α: 1,
                                              x: x.advanced(by: offset.x), ldx: max(1, incx),
                                              y: y.advanced(by: offset.y), ldy: max(1, incy),
                                              β: 0,
                                              a: z, lda: ldc)
                                for offset in length.dropFirst() {
                                    Element.Outer(m: m, n: n,
                                                  α: 1,
                                                  x: x.advanced(by: offset.x), ldx: max(1, incx),
                                                  y: y.advanced(by: offset.y), ldy: max(1, incy),
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
                            for offset in offset {
                                let x = x.advanced(by: offset.x)
                                let y = y.advanced(by: offset.y)
                                let z = z.advanced(by: offset.z)
                                Element.Outer(m: n, n: m,
                                              α: 1,
                                              x: y.advanced(by: offset.y), ldx: max(1, incy),
                                              y: x.advanced(by: offset.x), ldy: max(1, incx),
                                              β: 0,
                                              a: z, lda: ldc)
                                for offset in length.dropFirst() {
                                    Element.Outer(m: n, n: m,
                                                  α: 1,
                                                  x: y.advanced(by: offset.y), ldx: max(1, incy),
                                                  y: x.advanced(by: offset.x), ldy: max(1, incx),
                                                  β: 1,
                                                  a: z, lda: ldc)
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        // MARK: LHS GEMV routines
        case(let m, 1, let k, (1, let lda), (let incx, _), (let incy, _)): // Col-Major Col-Vector
            let capacity = capacity(alloc: shape, stride: stride)
            let lda = max(m, lda)
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
        case(let m, 1, let k, (let lda, 1), (let incx, _), (let incy, _)): // Row-Major Col-Vector
            let capacity = capacity(alloc: shape, stride: stride)
            let lda = max(k, lda)
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
        case(1, let n, let k, (_, let incx), (1, let ldb), (_, let incy)): // Row-Vector Col-Major
            let capacity = capacity(alloc: shape, stride: stride)
            let ldb = max(k, ldb)
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
                                             x: x, ldx: max(1, incx),
                                             β: 0,
                                             y: z, ldy: max(1, incy))
                                for offset in length.dropFirst() {
                                    Element.GEMV(m: k, n: n,
                                                 α: 1,
                                                 a: y.advanced(by: offset.y), lda: ldb, opa: "T",
                                                 x: x.advanced(by: offset.x), ldx: max(1, incx),
                                                 β: 1,
                                                 y: z, ldy: max(1, incy))
                                }
                            }
                            $1 = $0.count
                        }
                }
            })
        case(1, let n, let k, (_, let incx), (let ldb, 1), (_, let incy)): // Row-Vector Row-Major
            let capacity = capacity(alloc: shape, stride: stride)
            let ldb = max(n, ldb)
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
                                             x: x, ldx: max(1, incx),
                                             β: 0,
                                             y: z, ldy: max(1, incy))
                                for offset in length.dropFirst() {
                                    Element.GEMV(m: n, n: k,
                                                 α: 1,
                                                 a: y.advanced(by: offset.y), lda: ldb, opa: "N",
                                                 x: x.advanced(by: offset.x), ldx: max(1, incx),
                                                 β: 1,
                                                 y: z, ldy: max(1, incy))
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
                                             a: x, lda: lda, opa: "N",
                                             b: y, ldb: ldb, opb: "T",
                                             β: 0,
                                             c: z, ldc: ldc)
                                for offset in length.dropFirst() {
                                    Element.GEMM(m: m, n: n, k: k,
                                                 α: 1,
                                                 a: x.advanced(by: offset.x), lda: lda, opa: "N",
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
            os_log(.debug, log: .default, "try to specialize production for m=(%d, %d), n=(%d, %d), k=(%d, %d), lda=(%d, %d), ldb=(%d, %d), ldc=(%d, %d)", m, n, k.0, lda.0, lda.1, ldb.0, ldb.1, ldc.0, ldc.1)
            let xk = x.shape
            let yk = y.shape
            let xr = xk.dropLast(width)
            let xc = xk.suffix(width)
            let yr = yk.prefix(width)
            let yc = yk.dropFirst(width)
            let zk = xr + yc
            let xt = MemoryStrategy.rowMajor.stride(for: xk)
            let yt = MemoryStrategy.columnMajor.stride(for: yk)
            let xo = MemoryStrategy.rowMajor.flatten(shape: xk, xs: xs, ys: xt)
            let yo = MemoryStrategy.columnMajor.flatten(shape: yk, xs: ys, ys: yt)
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
extension BLAS.DOT: Scalar where X: ElasticTensor, Y: ElasticTensor {}
extension BLAS.DOT: Vector where X: ElasticTensor, Y: ElasticTensor {
    @inlinable@inline(__always)@_transparent
    public var count: Int {
        switch order {
        case.rowMajor:
            shape.first ?? 1
        case.columnMajor:
            shape.last ?? 1
        }
    }
    @inlinable@inline(__always)
    public subscript(position: Int) -> U {
        self[[position]]
    }
    @inlinable@inline(__always)
    public subscript(bounds: some RangeExpression<Int>) -> S {
        self[[bounds]]
    }
}
extension BLAS.DOT: Matrix where X: ElasticTensor, Y: ElasticTensor {
    @inlinable@inline(__always)@_transparent
    public var rows: Int {
        switch order {
        case.rowMajor:
            shape.first ?? 1
        case.columnMajor:
            shape.dropLast().last ?? 1
        }
    }
    @inlinable@inline(__always)@_transparent
    public var cols: Int {
        switch order {
        case.rowMajor:
            shape.dropFirst().first ?? 1
        case.columnMajor:
            shape.last ?? 1
        }
    }
    @inlinable@inline(__always)
    public subscript(row: Int, col: Int) -> BLAS<Element>.DOT<X.S, Y.S> {
        self[[row, col]]
    }
    @inlinable@inline(__always)
    public subscript(row: Int, col: some RangeExpression<Int>) -> BLAS<Element>.DOT<X.S, Y.S> {
        self[[row..<row, col.relative(to: 0..<cols)]]
    }
    @inlinable@inline(__always)
    public subscript(row: some RangeExpression<Int>, col: Int) -> BLAS<Element>.DOT<X.S, Y.S> {
        self[[row.relative(to: 0..<rows), col..<col]]
    }
    @inlinable@inline(__always)
    public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> BLAS<Element>.DOT<X.S, Y.S> {
        self[[row.relative(to: 0..<rows), col.relative(to: 0..<cols)]]
    }
}
extension BLAS.DOT: ElasticTensor where X: ElasticTensor, Y: ElasticTensor {
    public typealias S = BLAS.DOT<X.S, Y.S>
    public typealias T = BLAS.DOT<Y.T, X.T>
    public typealias U = BLAS.DOT<X.S, Y.S>
    public typealias V = BLAS.DOT<X.S, Y.S>
    @inlinable@inline(__always)@_transparent
    public var diagonal: V {
        fatalError("WIP")
    }
    @inline(__always)
    public var transpose: T {
        .init(order: order.transpose, width: width, x: y.transpose, y: x.transpose)
    }
    @inlinable@inline(__always)
    public subscript<P>(position: P) -> BLAS<Element>.DOT<X.S, Y.S> where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        self[position.map { $0..<$0 }]
    }
    @inline(__always)
    public subscript<Q>(bounds: Q) -> BLAS<Element>.DOT<X.S, Y.S> where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        let xk = x.shape
        let yk = y.shape
        let zk = contraction(x: xk, y: yk, count: width)
        let xh = xk.dropLast(width)
        let xt = xk.suffix(width)
        let yh = yk.prefix(width)
        let yt = yk.dropFirst(width)
        switch order {
        case.rowMajor:
            let bounds = zip(bounds, zk.prefix(bounds.count)).map { $0.relative(to: 0..<$1) } + zk.dropFirst(bounds.count).map { 0..<$0 }
            let xb = bounds.prefix(xh.count)
            let yb = bounds.dropFirst(xb.count)
            let xs = xb + concat(xh.dropFirst(xb.count), xt).map { 0..<$0 }
            let ys = yh.map { 0..<$0 } + yb + (yt.dropFirst(yb.count).map { 0..<$0 } as Array<Range<Int>>)
//            assert((xs.count, ys.count) == (xk.count, yk.count))
            return.init(order: order, width: width, x: x[xs], y: y[ys])
        case.columnMajor:
            let bounds = zk.dropLast(bounds.count).map { 0..<$0 } + zip(bounds, zk.suffix(bounds.count)).map { $0.relative(to: 0..<$1) }
            let yb = bounds.suffix(yt.count)
            let xb = bounds.dropLast(yb.count)
            let ys = concat(yh, yt.dropLast(yb.count)).map { 0..<$0 } + yb
            let xs = (xh.dropLast(xb.count).map { 0..<$0 } as Array<Range<Int>>) + xb + xt.map { 0..<$0 }
//            assert((xs.count, ys.count) == (xk.count, yk.count))
            return.init(order: order, width: width, x: x[xs], y: y[ys])
        }
    }
}
@_disfavoredOverload
public func •<Element: BLASElement, X: Tensor<Element>, Y: Tensor<Element>>(_ lhs: X, _ rhs: Y) -> BLAS<Element>.DOT<X, Y> {
    .init(order: .default, width: 1, x: lhs, y: rhs)
}
@_disfavoredOverload
public func outer<Element: BLASElement, X: Tensor<Element>, Y: Tensor<Element>>(_ lhs: X, _ rhs: Y) -> BLAS<Element>.DOT<X, Y> {
    .init(order: .default, width: 0, x: lhs, y: rhs)
}
