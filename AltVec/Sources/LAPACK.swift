//
//  LAPACK.swift
//  MUSE
//
//  Created by Kota on 8/18/26.
//
import MKL
import LAPACK
import typealias Numerics.Complex64
import typealias Numerics.Complex128
public protocol LAPACKElement: BLASElement {
    @inlinable@inline(__always)
    @discardableResult
    static func GETRF(m: Int, n: Int,
                      a: UnsafeMutablePointer<Self>, ld: Int,
                      p: UnsafeMutablePointer<Int>) -> Int
    @discardableResult
    @inlinable@inline(__always)
    static func GETRI(n: Int,
                      a: UnsafeMutablePointer<Self>, ld: Int,
                      p: UnsafePointer<Int>) -> Int
    @discardableResult
    @inlinable@inline(__always)
    static func GETRS(n: Int, nrhs: Int,
                      a: UnsafePointer<Self>, ld: Int, op: op_t,
                      p: UnsafePointer<Int>,
                      b: UnsafeMutablePointer<Self>, ld: Int) -> Int
}
extension Float32: LAPACKElement {
    @discardableResult
    @inlinable@inline(__always)@_transparent
    public static func GETRF(m: Int, n: Int,
                             a: UnsafeMutablePointer<Self>, ld: Int,
                             p: UnsafeMutablePointer<Int>) -> Int {
        getrf(m, n, a, ld, p)
    }
    @discardableResult
    @inlinable@inline(__always)@_transparent
    public static func GETRI(n: Int,
                             a: UnsafeMutablePointer<Self>, ld: Int,
                             p: UnsafePointer<Int>) -> Int {
        switch getri(n, a, ld, p, .none, -1) {
        case let info:
            info < 0 ? info :
            withUnsafeTemporaryAllocation(of: Self.self, capacity: info) {
                getri(n,
                      a, ld,
                      p,
                      $0.baseAddress, $0.count)
            }
        }
    }
    @discardableResult
    @inlinable@inline(__always)@_transparent
    public static func GETRS(n: Int, nrhs: Int,
                             a: UnsafePointer<Self>, ld lda: Int, op: op_t,
                             p: UnsafePointer<Int>,
                             b: UnsafeMutablePointer<Self>, ld ldb: Int) -> Int {
        getrs(n, nrhs,
              a, lda, op,
              p,
              b, ldb)
    }
    @discardableResult
    @inlinable@inline(__always)
    public static func GELS(m: Int, n: Int, nrhs: Int,
                            a: UnsafeMutablePointer<Self>, ld lda: Int, op: op_t,
                            b: UnsafeMutablePointer<Self>, ld ldb: Int) -> Int {
        switch gels(m, n, nrhs,
                    a, lda, op,
                    b, ldb, .none, -1) {
        case let info:
            info < 0 ? info :
            withUnsafeTemporaryAllocation(of: Self.self, capacity: info) {
                gels(m, n, nrhs,
                     a, lda, op,
                     b, ldb,
                     $0.baseAddress, $0.count)
            }
        }
    }
}
extension Float64: LAPACKElement {
    @discardableResult
    @inlinable@inline(__always)@_transparent
    public static func GETRF(m: Int, n: Int,
                             a: UnsafeMutablePointer<Self>, ld: Int,
                             p: UnsafeMutablePointer<Int>) -> Int {
        getrf(m, n, a, ld, p)
    }
    @discardableResult
    @inlinable@inline(__always)@_transparent
    public static func GETRI(n: Int,
                             a: UnsafeMutablePointer<Self>, ld: Int,
                             p: UnsafePointer<Int>) -> Int {
        switch getri(n, a, ld, p, .none, -1) {
        case let info:
            info < 0 ? info :
            withUnsafeTemporaryAllocation(of: Self.self, capacity: info) {
                getri(n,
                      a, ld,
                      p,
                      $0.baseAddress, $0.count)
            }
        }
    }
    @discardableResult
    @inlinable@inline(__always)@_transparent
    public static func GETRS(n: Int, nrhs: Int,
                             a: UnsafePointer<Self>, ld lda: Int, op: op_t,
                             p: UnsafePointer<Int>,
                             b: UnsafeMutablePointer<Self>, ld ldb: Int) -> Int {
        getrs(n, nrhs,
              a, lda, op,
              p,
              b, ldb)
    }
    @discardableResult
    @inlinable@inline(__always)
    public static func GELS(m: Int, n: Int, nrhs: Int,
                            a: UnsafeMutablePointer<Self>, ld lda: Int, op: op_t,
                            b: UnsafeMutablePointer<Self>, ld ldb: Int) -> Int {
        switch gels(m, n, nrhs,
                    a, lda, op,
                    b, ldb, .none, -1) {
        case let info:
            info < 0 ? info :
            withUnsafeTemporaryAllocation(of: Self.self, capacity: info) {
                gels(m, n, nrhs,
                     a, lda, op,
                     b, ldb,
                     $0.baseAddress, $0.count)
            }
        }
    }
}
extension Complex64: LAPACKElement {
    @discardableResult
    @inlinable@inline(__always)@_transparent
    public static func GETRF(m: Int, n: Int,
                             a: UnsafeMutablePointer<Self>, ld: Int,
                             p: UnsafeMutablePointer<Int>) -> Int {
        getrf(m, n, .init(mutating: a.pointer(to: \.rawValue).unsafelyUnwrapped), ld, p)
    }
    @discardableResult
    @inlinable@inline(__always)@_transparent
    public static func GETRI(n: Int,
                             a: UnsafeMutablePointer<Self>, ld: Int,
                             p: UnsafePointer<Int>) -> Int {
        switch getri(n, a.pointer(to: \.rawValue).unsafelyUnwrapped, ld, p, .none, -1) {
        case let info:
            info < 0 ? info :
            withUnsafeTemporaryAllocation(of: RawValue.self, capacity: info) {
                getri(n,
                      a.pointer(to: \.rawValue).unsafelyUnwrapped, ld,
                      p,
                      $0.baseAddress.unsafelyUnwrapped, $0.count)
            }
        }
    }
    @discardableResult
    @inlinable@inline(__always)@_transparent
    public static func GETRS(n: Int, nrhs: Int,
                             a: UnsafePointer<Self>, ld lda: Int, op: op_t,
                             p: UnsafePointer<Int>,
                             b: UnsafeMutablePointer<Self>, ld ldb: Int) -> Int {
        getrs(n, nrhs,
              a.pointer(to: \.rawValue).unsafelyUnwrapped, lda, op,
              p,
              .init(mutating: b.pointer(to: \.rawValue).unsafelyUnwrapped), ldb)
    }
    @discardableResult
    @inlinable@inline(__always)
    public static func GELS(m: Int, n: Int, nrhs: Int,
                            a: UnsafeMutablePointer<Self>, ld lda: Int, op: op_t,
                            b: UnsafeMutablePointer<Self>, ld ldb: Int) -> Int {
        switch gels(m, n, nrhs,
                    .init(mutating: a.pointer(to: \.rawValue).unsafelyUnwrapped), lda, op,
                    .init(mutating: b.pointer(to: \.rawValue).unsafelyUnwrapped), ldb, .none, -1) {
        case let info:
            info < 0 ? info :
            withUnsafeTemporaryAllocation(of: Self.self, capacity: info) {
                gels(m, n, nrhs,
                     .init(mutating: a.pointer(to: \.rawValue).unsafelyUnwrapped), lda, op,
                     .init(mutating: b.pointer(to: \.rawValue).unsafelyUnwrapped), ldb,
                     .init(mutating: $0.baseAddress.unsafelyUnwrapped.pointer(to: \.rawValue)), $0.count)
            }
        }
    }
}
extension Complex128: LAPACKElement {
    @discardableResult
    @inlinable@inline(__always)@_transparent
    public static func GETRF(m: Int, n: Int,
                             a: UnsafeMutablePointer<Self>, ld: Int,
                             p: UnsafeMutablePointer<Int>) -> Int {
        getrf(m, n, .init(mutating: a.pointer(to: \.rawValue).unsafelyUnwrapped), ld, p)
    }
    @discardableResult
    @inlinable@inline(__always)@_transparent
    public static func GETRI(n: Int,
                             a: UnsafeMutablePointer<Self>, ld: Int,
                             p: UnsafePointer<Int>) -> Int {
        switch getri(n, a.pointer(to: \.rawValue).unsafelyUnwrapped, ld, p, .none, -1) {
        case let info:
            info < 0 ? info :
            withUnsafeTemporaryAllocation(of: RawValue.self, capacity: info) {
                getri(n,
                      a.pointer(to: \.rawValue).unsafelyUnwrapped, ld,
                      p,
                      $0.baseAddress.unsafelyUnwrapped, $0.count)
            }
        }
    }
    @discardableResult
    @inlinable@inline(__always)@_transparent
    public static func GETRS(n: Int, nrhs: Int,
                             a: UnsafePointer<Self>, ld lda: Int, op: op_t,
                             p: UnsafePointer<Int>,
                             b: UnsafeMutablePointer<Self>, ld ldb: Int) -> Int {
        getrs(n, nrhs,
              a.pointer(to: \.rawValue).unsafelyUnwrapped, lda, op,
              p,
              .init(mutating: b.pointer(to: \.rawValue).unsafelyUnwrapped), ldb)
    }
    @discardableResult
    @inlinable@inline(__always)
    public static func GELS(m: Int, n: Int, nrhs: Int,
                            a: UnsafeMutablePointer<Self>, ld lda: Int, op: op_t,
                            b: UnsafeMutablePointer<Self>, ld ldb: Int) -> Int {
        switch gels(m, n, nrhs,
                    .init(mutating: a.pointer(to: \.rawValue).unsafelyUnwrapped), lda, op,
                    .init(mutating: b.pointer(to: \.rawValue).unsafelyUnwrapped), ldb, .none, -1) {
        case let info:
            info < 0 ? info :
            withUnsafeTemporaryAllocation(of: Self.self, capacity: info) {
                gels(m, n, nrhs,
                     .init(mutating: a.pointer(to: \.rawValue).unsafelyUnwrapped), lda, op,
                     .init(mutating: b.pointer(to: \.rawValue).unsafelyUnwrapped), ldb,
                     .init(mutating: $0.baseAddress.unsafelyUnwrapped.pointer(to: \.rawValue)), $0.count)
            }
        }
    }
}
