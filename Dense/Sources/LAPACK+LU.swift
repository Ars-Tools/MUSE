//
//  LAPACK+LU.swift
//  MUSE
//
//  Created by Kota on 10/1/25.
//
import protocol Accelerate.AccelerateBuffer
import typealias Layout.MemoryStrategy
import func Layout.capacity
import func Layout.flatten
extension LAPACK {
    public struct LU {
        @usableFromInline let m: Int
        @usableFromInline let n: Int
        @usableFromInline let system: Array<Element>
        public let ipivot: Array<Int>
    }
}
extension LAPACK.LU {
    public init(factorize x: some InstantMatrix<Element>) throws {
        m = x.rows
        n = x.cols
        let capacity = m * n
        let (xs, xm) = try x.evaluation(for: .columnMajor)
        assert(xs.count == 2)
        let (length, stride, offset) = MemoryStrategy.columnMajor.flatten(shape: [m, n], xs: xs, ys: [1, m])
        var a = withUnsafePointer(xm()) { x in
            Array<Element>(unsafeUninitializedCapacity: capacity) {
                let y = $0.baseAddress.unsafelyUnwrapped
                for offset in offset {
                    Element.Copy(x: x.advanced(by: offset.x), inc: stride.x,
                                 y: y.advanced(by: offset.y), inc: stride.y,
                                 length: length)
                }
                $1 = $0.count
            }
        }
        var p = Array<Int>(repeating: .zero, count: n)
        switch Element.GETRF(m: m, n: n,
                             a: &a, ld: m,
                             p: &p) {
        case.zero:
            break
        case let status:
            throw Error.numericalError(tensor: x, status: status, operation: "GETRF@\(#function)")
        }
        system = a
        ipivot = p
    }
    public init(factorize x: some Matrix<Element>) async throws {
        m = x.rows
        n = x.cols
        let capacity = m * n
        let (xs, xm) = try x.evaluation(for: .columnMajor)
        assert(xs.count == 2)
        let (length, stride, offset) = MemoryStrategy.columnMajor.flatten(shape: [m, n], xs: xs, ys: [1, m])
        var a = await withUnsafePointer(xm()) { x in
            Array<Element>(unsafeUninitializedCapacity: capacity) {
                let y = $0.baseAddress.unsafelyUnwrapped
                for offset in offset {
                    Element.Copy(x: x.advanced(by: offset.x), inc: stride.x,
                                 y: y.advanced(by: offset.y), inc: stride.y,
                                 length: length)
                }
                $1 = $0.count
            }
        }
        var p = Array<Int>(repeating: .zero, count: n)
        switch Element.GETRF(m: m, n: n,
                             a: &a, ld: m,
                             p: &p) {
        case.zero:
            break
        case let status:
            throw Error.numericalError(tensor: x, status: status, operation: "GETRF@\(#function)")
        }
        system = a
        ipivot = p
    }
}
extension LAPACK.LU where Element: SignedNumeric {
    public var det: Element {
        ipivot.enumerated().reduce(1 as Element) {
            ($1.0 == $1.1 ? $0 : -$0) * system[$1.1 * n + $1.1]
        }
    }
}
extension LAPACK.LU where Element: MutableScalar<Element> {
    public var l: Buffer<Array<Element>>.Matrix {
        var store = system // COW
        store.withUnsafeMutableBufferPointer {
            assert($0.startIndex == 0)
            for c in 0..<min(m, n) {
                $0[c*m..<c*m+m].prefix(c).update(repeating: .zero)
                $0[c*m+c] = 1
            }
        }
        return.init(rows: m, cols: min(m, n), ldr: 1, ldc: m, store: store)
    }
    public var u: Buffer<Array<Element>>.Matrix {
        var store = system
        store.withUnsafeMutableBufferPointer {
            for c in 0..<min(m, n) {
                $0[c*m..<c*m+m].dropFirst(c+1).update(repeating: .zero)
            }
        }
        return.init(rows: min(m, n), cols: m, ldr: 1, ldc: m, store: store)
    }
}
extension LAPACK.LU where Element: MutableScalar<Element> {
    public var inv: Buffer<Array<Element>>.Matrix {
        precondition(m == n, "inv requires square matrix")
        var store = system
        let status = Element.GETRI(n: n,
                                   a: &store, ld: m,
                                   p: ipivot)
        assert(status == 0)
        return.init(rows: m, cols: n, ldr: 1, ldc: m, store: store)
    }
}
extension LAPACK.LU where Element: MutableScalar<Element> {
    public func solve<R>(b: Buffer<R>.Tensor) -> Buffer<Array<Element>>.Tensor where R.Element == Element {
        let ((nrhs, k), ldb, ldc, layout, chunks) = MemoryStrategy.columnMajor.contraction(m: n, y: (b.shape, b.pitch))
        let zk = [n] + b.shape.dropFirst()
        let (length, stride, offset) = MemoryStrategy.columnMajor.flatten(shape: [k, nrhs],
                                                                          xs: [ldb.0, ldb.1],
                                                                          ys: [ldc.0, ldc.1])
        assert(ldc.0 == 1)
        return.init(shape: zk, pitch: layout, store: .init(unsafeUninitializedCapacity: capacity(alloc: zk, stride: layout)) {
            let y = $0.baseAddress.unsafelyUnwrapped
            b.store.withUnsafePointerWithFallback { x in
                for chunks in chunks {
                    let x = x.advanced(by: chunks.x)
                    let y = y.advanced(by: chunks.y)
                    for offset in offset {
                        Element.Copy(x: x.advanced(by: offset.x), inc: stride.x,
                                     y: y.advanced(by: offset.y), inc: stride.y, length: length)
                    }
                    Element.GETRS(n: k, nrhs: nrhs,
                                  a: system, ld: m, op: .N,
                                  p: ipivot,
                                  b: y, ld: ldc.1)
                }
            }
            $1 = $0.count
        })
    }
    public func solve(b: some InstantTensor<Element>) throws -> Buffer<Array<Element>>.Tensor {
        let bk = b.shape
        let(bs, bm) = try b.evaluation(for: .columnMajor)
        let ((nrhs, k), ldb, ldc, layout, chunks) = MemoryStrategy.columnMajor.contraction(m: n, y: (bk, bs))
        let zk = [n] + b.shape.dropFirst()
        let (length, stride, offset) = MemoryStrategy.columnMajor.flatten(shape: [k, nrhs],
                                                                          xs: [ldb.0, ldb.1],
                                                                          ys: [ldc.0, ldc.1])
        assert(ldc.0 == 1)
        return.init(shape: zk, pitch: layout, store: .init(unsafeUninitializedCapacity: capacity(alloc: zk, stride: layout)) {
            let y = $0.baseAddress.unsafelyUnwrapped
            bm().withUnsafePointerWithFallback { x in
                for chunks in chunks {
                    let x = x.advanced(by: chunks.x)
                    let y = y.advanced(by: chunks.y)
                    for offset in offset {
                        Element.Copy(x: x.advanced(by: offset.x), inc: stride.x,
                                     y: y.advanced(by: offset.y), inc: stride.y, length: length)
                    }
                    Element.GETRS(n: k, nrhs: nrhs,
                                  a: system, ld: m, op: .N,
                                  p: ipivot,
                                  b: y, ld: ldc.1)
                }
            }
            $1 = $0.count
        })
    }
}

//extension LAPACK.LU {

//    public func solve<R>(y: MatrixBuffer<R>) -> MatrixBuffer<Array<Element>> where R.Element == Element {
//        precondition(y.rows == m)
//        let rows = max(m, n)
//        let nrhs = y.cols
//        return.init(rows: m, cols: nrhs, ldr: 1, ldc: m, data: .init(unsafeUninitializedCapacity: capacity(alloc: [rows, nrhs], stride: [1, rows])) {
//            let (length, stride, offset) = MemoryStrategy.columnMajor.flatten(shape: [y.rows, y.cols], xs: [y.ldr, y.ldc], ys: [1, rows])
//            for offset in offset {
//                Element.Copy(x: y.data.withUnsafeBufferPointer(\.baseAddress.unsafelyUnwrapped).advanced(by: offset.x), ldx: stride.x,
//                             y: $0.baseAddress.unsafelyUnwrapped.advanced(by: offset.y), ldy: stride.y, length: length)
//            }
//            Element.GETRS(n: n, nrhs: nrhs,
//                          a: system, lda: m, opa: "N",
//                          b: $0.baseAddress.unsafelyUnwrapped, ldb: rows,
//                          p: ipivot)
//            $1 = $0.count
//        })
//    }
//}
//extension LAPACK.LU {
//    public func solve(y: some Matrix<Element>) async throws -> MatrixBuffer<Array<Element>> {
//        try await solve(y: MatrixBuffer<Array<Element>>(y, for: .columnMajor))
//    }
//    public func solve(y: some InstantMatrix<Element>) throws -> MatrixBuffer<Array<Element>> {
//        try solve(y: MatrixBuffer<Array<Element>>(y, for: .columnMajor))
//    }
//    public func solve(y: some Vector<Element>) async throws -> VectorBuffer<Array<Element>> {
//        try await solve(y: VectorBuffer<Array<Element>>(y, for: .columnMajor))
//    }
//    public func solve(y: some InstantVector<Element>) throws -> VectorBuffer<Array<Element>> {
//        try solve(y: VectorBuffer<Array<Element>>(y, for: .columnMajor))
//    }
//}
