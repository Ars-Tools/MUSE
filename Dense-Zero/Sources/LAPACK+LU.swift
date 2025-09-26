//
//  LAPACK+LU.swift
//  MUSE
//
//  Created by Kota on 9/22/25.
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
    public init<R>(factorize x: MatrixBuffer<R>) throws where R.Element == Element {
        m = x.rows
        n = x.cols
        let (length, stride, offset) = MemoryStrategy.columnMajor.flatten(shape: [m, n], xs: [x.ldr, x.ldc], ys: [1, m])
        var a = Array<Element>(unsafeUninitializedCapacity: m * n) {
            let y = $0.baseAddress.unsafelyUnwrapped
            withUnsafePointer(x.data) { x in
                for offset in offset {
                    Element.Copy(x: x.advanced(by: offset.x), ldx: stride.x,
                                 y: y.advanced(by: offset.y), ldy: stride.y,
                                 length: length)
                }
            }
            $1 = $0.count
        }
        var p = Array<Int>(repeating: .zero, count: n)
        switch Element.GETRF(m: m, n: n,
                             a: &a, lda: m,
                             p: &p) {
        case.zero:
            break
        case let status:
            throw Error.numericalError(tensor: x, status: status, operation: "getrf@\(#function)")
        }
        system = a
        ipivot = p
    }
    public init<R, X>(factorize x: X) throws where X: InstantMatrix, X.R == R, X.Element == Element {
        try self.init(factorize: MatrixBuffer<R>(x))
    }
    public init<R, X>(factorize x: X) async throws where X: Matrix, X.R == R, X.Element == Element {
        try await self.init(factorize: MatrixBuffer<R>(x))
    }
}
extension LAPACK.LU {
    public var det: Element {
        ipivot.enumerated().reduce(1 as Element) {
            ($1.0 == $1.1 ? $0 : -$0) * system[$1.1 * n + $1.1]
        }
    }
}
extension LAPACK.LU {
    public var l: MatrixBuffer<Array<Element>> {
        var system = system // COW
        system.withUnsafeMutableBufferPointer {
            assert($0.startIndex == 0)
            for c in 0..<min(m, n) {
                $0[c*m..<c*m+m].prefix(c).update(repeating: .zero)
                $0[c*m+c] = 1
            }
        }
        return.init(shape: (m, min(m, n)), stride: (1, m), data: system)
    }
    public var u: MatrixBuffer<Array<Element>> {
        var system = system
        system.withUnsafeMutableBufferPointer {
            for c in 0..<min(m, n) {
                $0[c*m..<c*m+m].dropFirst(c+1).update(repeating: .zero)
            }
        }
        return.init(shape: (min(m, n), m), stride: (1, m), data: system)
    }
}
extension LAPACK.LU  {
    public var inv: MatrixBuffer<Array<Element>> {
        precondition(m == n, "inv requires square matrix")
        var system = system
        let status = Element.GETRI(n: n,
                                   a: &system, lda: m,
                                   p: ipivot)
        assert(status == 0)
        return.init(shape: (m, n), stride: (1, m), data: system)
    }
}
extension LAPACK.LU {
    public func solve<R>(y: VectorBuffer<R>) -> VectorBuffer<Array<Element>> where R.Element == Element {
        precondition(y.count == m)
        return.init(count: n, inc: 1, data: .init(unsafeUninitializedCapacity: max(m, n)) {
            Element.Copy(x: y.data.withUnsafeBufferPointer(\.baseAddress.unsafelyUnwrapped), ldx: y.inc,
                         y: $0.baseAddress.unsafelyUnwrapped, ldy: 1, length: y.count)
            let status = Element.GETRS(n: n, nrhs: 1,
                                       a: system, lda: m, opa: "N",
                                       b: $0.baseAddress.unsafelyUnwrapped, ldb: n,
                                       p: ipivot)
            assert(status == 0)
            $1 = $0.count
        })
    }
    public func solve<R>(y: MatrixBuffer<R>) -> MatrixBuffer<Array<Element>> where R.Element == Element {
        precondition(y.rows == m)
        let rows = max(m, n)
        let nrhs = y.cols
        return.init(rows: m, cols: nrhs, ldr: 1, ldc: m, data: .init(unsafeUninitializedCapacity: capacity(alloc: [rows, nrhs], stride: [1, rows])) {
            let (length, stride, offset) = MemoryStrategy.columnMajor.flatten(shape: [y.rows, y.cols], xs: [y.ldr, y.ldc], ys: [1, rows])
            for offset in offset {
                Element.Copy(x: y.data.withUnsafeBufferPointer(\.baseAddress.unsafelyUnwrapped).advanced(by: offset.x), ldx: stride.x,
                             y: $0.baseAddress.unsafelyUnwrapped.advanced(by: offset.y), ldy: stride.y, length: length)
            }
            Element.GETRS(n: n, nrhs: nrhs,
                          a: system, lda: m, opa: "N",
                          b: $0.baseAddress.unsafelyUnwrapped, ldb: rows,
                          p: ipivot)
            $1 = $0.count
        })
    }
}
extension LAPACK.LU {
    public func solve(y: some Matrix<Element>) async throws -> MatrixBuffer<Array<Element>> {
        try await solve(y: MatrixBuffer<Array<Element>>(y, for: .columnMajor))
    }
    public func solve(y: some InstantMatrix<Element>) throws -> MatrixBuffer<Array<Element>> {
        try solve(y: MatrixBuffer<Array<Element>>(y, for: .columnMajor))
    }
    public func solve(y: some Vector<Element>) async throws -> VectorBuffer<Array<Element>> {
        try await solve(y: VectorBuffer<Array<Element>>(y, for: .columnMajor))
    }
    public func solve(y: some InstantVector<Element>) throws -> VectorBuffer<Array<Element>> {
        try solve(y: VectorBuffer<Array<Element>>(y, for: .columnMajor))
    }
}
