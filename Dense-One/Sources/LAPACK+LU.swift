//
//  LAPACK+LU.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import protocol Accelerate.AccelerateBuffer
import typealias Layout.MemoryStrategy
import func Layout.capacity
import func Layout.flatten
extension LAPACK {
    @frozen public struct LU {
        @usableFromInline let m: Int
        @usableFromInline let n: Int
        @usableFromInline let system: Array<Element>
        public let ipivot: Array<Int>
    }
}
extension LAPACK.LU {
    @inlinable@_transparent
    init(rows: Int, cols: Int, matrix: some Collection<Element>, layout: Array<Int>) throws {
        m = rows
        n = cols
        precondition([rows, cols].allSatisfy { 0 < $0 }, "matrix size should be larger than 0")
        let (length, stride, offset) = MemoryStrategy.columnMajor.flatten(shape: [m, n], xs: layout, ys: [1, m])
        var a = Array<Element>(unsafeUninitializedCapacity: m * n) {
            let y = $0.baseAddress.unsafelyUnwrapped
            withUnsafePointer(matrix) { x in
                for offset in offset {
                    Element.Copy(x: x.advanced(by: offset.x), ldx: stride.x,
                                 y: y.advanced(by: offset.y), ldy: stride.y, length: length)
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
            throw Error.numericalError(status: status, operation: "getrf@\(#function)")
        }
        system = a
        ipivot = p
    }
//    @inlinable@inline(__always)@_transparent
    public init(factorize x: some Matrix<Element> & InstantTensor<Element>) throws {
        let (xs, xm) = try x.evaluation(for: .columnMajor)
        try self.init(rows: x.rows, cols: x.cols, matrix: xm(), layout: xs)
    }
//    @inlinable@inline(__always)@_transparent
    public init(factorize x: some Matrix<Element>) async throws {
        let (xs, xm) = try x.evaluation(for: .columnMajor)
        try await self.init(rows: x.rows, cols: x.cols, matrix: xm(), layout: xs)
    }
}
extension LAPACK.LU where Element: SignedNumeric {
    @inlinable@inline(__always)@_transparent
    public var det: Element {
        ipivot.enumerated().reduce(1 as Element) {
            ($1.0 == $1.1 ? $0 : -$0) * system[$1.1 * n + $1.1]
        }
    }
}
extension LAPACK.LU where Element: MutableScalar<Element> {
    @inline(__always)
    public var l: Buffer<Array<Element>>.Matrix {
        var system = system // COW
        system.withUnsafeMutableBufferPointer {
            assert($0.startIndex == 0)
            for c in 0..<min(m, n) {
                $0[c*m..<c*m+m].prefix(c).update(repeating: .zero)
                $0[c*m+c] = 1
            }
        }
        return.init(rows: m, cols: min(m, n), ldr: 1, ldc: m, store: system)
    }
    @inline(__always)
    public var u: Buffer<Array<Element>>.Matrix {
        var system = system // COW
        system.withUnsafeMutableBufferPointer {
            for c in 0..<min(m, n) {
                $0[c*m..<c*m+m].dropFirst(c+1).update(repeating: .zero)
            }
        }
        return.init(rows: min(m, n), cols: m, ldr: 1, ldc: m, store: system)
    }
}
extension LAPACK.LU where Element: MutableScalar<Element> {
    public var inv: Buffer<Array<Element>>.Matrix {
        precondition(m == n, "inv requires square matrix")
        var system = system // COW
        let status = Element.GETRI(n: n,
                                   a: &system, lda: m,
                                   p: ipivot)
        assert(status == 0)
        return.init(rows: n, cols: m, ldr: 1, ldc: n, store: system)
    }
}
