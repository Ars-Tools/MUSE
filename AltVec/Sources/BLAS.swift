//
//  BLAS.swift
//  MUSE
//
//  Created by Kota on 8/18/26.
//
import BLAS
import typealias Numerics.Complex64
import typealias Numerics.Complex128
public protocol BLASElement: Numeric {
    @inlinable@inline(__always)
    static func Norm(n: Int, x: UnsafePointer<Self>, inc: Int) -> Magnitude
    @inlinable@inline(__always)
    static func Inner(n: Int,
                      x: UnsafePointer<Self>, inc: Int,
                      y: UnsafePointer<Self>, inc: Int) -> Self
    @inlinable@inline(__always)
    static func Outer(m: Int, n: Int,
                      α: Self,
                      x: UnsafePointer<Self>, inc: Int,
                      y: UnsafePointer<Self>, inc: Int,
                      β: Self,
                      a: UnsafeMutablePointer<Self>, ld: Int)
    @inlinable@inline(__always)
    static func GEMM(m: Int, n: Int, k: Int,
                     α: Self,
                     a: UnsafePointer<Self>, ld: Int, op: op_t,
                     b: UnsafePointer<Self>, ld: Int, op: op_t,
                     β: Self,
                     c: UnsafeMutablePointer<Self>, ld: Int)
    @inlinable@inline(__always)
    static func GEMV(m: Int, n: Int,
                     α: Self,
                     a: UnsafePointer<Self>, ld: Int, op: op_t,
                     x: UnsafePointer<Self>, inc: Int,
                     β: Self,
                     y: UnsafeMutablePointer<Self>, inc: Int)
}
extension Float32: BLASElement {
    @inlinable@inline(__always)@_transparent
    public static func Norm(n: Int, x: UnsafePointer<Self>, inc: Int) -> Magnitude {
        nrm2(n, x, inc)
    }
    @inlinable@inline(__always)@_transparent
    public static func Scale(n: Int,
                             α: Self,
                             x: UnsafeMutablePointer<Self>, inc: Int) {
        scal(n, α, x, inc)
    }
    @inlinable@inline(__always)@_transparent
    public static func Inner(n: Int,
                             x: UnsafePointer<Self>, inc incx: Int,
                             y: UnsafePointer<Self>, inc incy: Int) -> Self {
        dot(n, x, incx, y, incy)
    }
    @inlinable@inline(__always)@_transparent
    public static func Outer(m: Int, n: Int,
                             α: Self,
                             x: UnsafePointer<Self>, inc incx: Int,
                             y: UnsafePointer<Self>, inc incy: Int,
                             β: Self,
                             a: UnsafeMutablePointer<Self>, ld: Int) {
        switch β {
        case 1:
            break
        default:
            for r in stride(from: 0, to: n * ld, by: ld).lazy.map(a.advanced(by:)) {
                scal(m, β, r, 1)
            }
        }
        ger(m, n, α, x, incx, y, incy, a, ld)
    }
    @inlinable@inline(__always)@_transparent
    public static func GEMM(m: Int, n: Int, k: Int,
                            α: Self,
                            a: UnsafePointer<Self>, ld lda: Int, op opa: op_t,
                            b: UnsafePointer<Self>, ld ldb: Int, op opb: op_t,
                            β: Self,
                            c: UnsafeMutablePointer<Self>, ld ldc: Int) {
        gemm(m, n, k,
             α,
             a, lda, opa,
             b, ldb, opb,
             β,
             c, ldc)
    }
    @inlinable@inline(__always)@_transparent
    public static func GEMV(m: Int, n: Int,
                            α: Self,
                            a: UnsafePointer<Self>, ld: Int, op: op_t,
                            x: UnsafePointer<Self>, inc incx: Int,
                            β: Self,
                            y: UnsafeMutablePointer<Self>, inc incy: Int) {
        gemv(m, n,
             α,
             a, ld, op,
             x, incx,
             β,
             y, incy)
    }
}
extension Float64: BLASElement {
    @inlinable@inline(__always)@_transparent
    public static func Norm(n: Int, x: UnsafePointer<Self>, inc: Int) -> Magnitude {
        nrm2(n, x, inc)
    }
    @inlinable@inline(__always)@_transparent
    public static func Scale(n: Int,
                             α: Self,
                             x: UnsafeMutablePointer<Self>, ldx: Int) {
        scal(n, α, x, ldx)
    }
    @inlinable@inline(__always)@_transparent
    public static func Inner(n: Int,
                             x: UnsafePointer<Self>, inc incx: Int,
                             y: UnsafePointer<Self>, inc incy: Int) -> Self {
        dot(n, x, incx, y, incy)
    }
    @inlinable@inline(__always)@_transparent
    public static func Outer(m: Int, n: Int,
                             α: Self,
                             x: UnsafePointer<Self>, inc incx: Int,
                             y: UnsafePointer<Self>, inc incy: Int,
                             β: Self,
                             a: UnsafeMutablePointer<Self>, ld: Int) {
        switch β {
        case 1:
            break
        default:
            for r in stride(from: 0, to: n * ld, by: ld).lazy.map(a.advanced(by:)) {
                scal(m, β, r, 1)
            }
        }
        ger(m, n, α, x, incx, y, incy, a, ld)
    }
    @inlinable@inline(__always)@_transparent
    public static func GEMM(m: Int, n: Int, k: Int,
                            α: Self,
                            a: UnsafePointer<Self>, ld lda: Int, op opa: op_t,
                            b: UnsafePointer<Self>, ld ldb: Int, op opb: op_t,
                            β: Self,
                            c: UnsafeMutablePointer<Self>, ld ldc: Int) {
        gemm(m, n, k,
             α,
             a, lda, opa,
             b, ldb, opb,
             β,
             c, ldc)
    }
    @inlinable@inline(__always)@_transparent
    public static func GEMV(m: Int, n: Int,
                            α: Self,
                            a: UnsafePointer<Self>, ld: Int, op: op_t,
                            x: UnsafePointer<Self>, inc incx: Int,
                            β: Self,
                            y: UnsafeMutablePointer<Self>, inc incy: Int) {
        gemv(m, n,
             α,
             a, ld, op,
             x, incx,
             β,
             y, incy)
    }
}
extension Complex64: BLASElement {
    @inlinable@inline(__always)@_transparent
    public static func Norm(n: Int, x: UnsafePointer<Self>, inc: Int) -> Magnitude {
        nrm2(n, .init(.init(x)) as UnsafePointer<RawValue>, inc)
    }
    @inlinable@inline(__always)@_transparent
    public static func Inner(n: Int,
                             x: UnsafePointer<Self>, inc incx: Int,
                             y: UnsafePointer<Self>, inc incy: Int) -> Self {
        .init(rawValue: dot(n,
                            .init(.init(x)), incx,
                            .init(.init(y)), incy))
    }
    @inlinable@inline(__always)@_transparent
    public static func Outer(m: Int, n: Int,
                             α: Self,
                             x: UnsafePointer<Self>, inc incx: Int,
                             y: UnsafePointer<Self>, inc incy: Int,
                             β: Self,
                             a: UnsafeMutablePointer<Self>, ld: Int) {
        switch β {
        case 1:
            break
        default:
            for r in stride(from: 0, to: n * ld, by: ld).lazy.map(a.advanced(by:)) {
                scal(m, β.rawValue, .init(.init(r)), 1)
            }
        }
        ger(m, n,
            α.rawValue,
            .init(.init(x)), incx,
            .init(.init(y)), incy,
            .init(.init(a)), ld)
    }
    @inlinable@inline(__always)@_transparent
    public static func GEMM(m: Int, n: Int, k: Int,
                            α: Self,
                            a: UnsafePointer<Self>, ld lda: Int, op opa: op_t,
                            b: UnsafePointer<Self>, ld ldb: Int, op opb: op_t,
                            β: Self,
                            c: UnsafeMutablePointer<Self>, ld ldc: Int) {
        gemm(m, n, k,
             α.rawValue,
             .init(.init(a)), lda, opa,
             .init(.init(b)), ldb, opb,
             β.rawValue,
             .init(.init(c)), ldc)
    }
    @inlinable@inline(__always)@_transparent
    public static func GEMV(m: Int, n: Int,
                            α: Self,
                            a: UnsafePointer<Self>, ld: Int, op: op_t,
                            x: UnsafePointer<Self>, inc incx: Int,
                            β: Self,
                            y: UnsafeMutablePointer<Self>, inc incy: Int) {
        gemv(m, n,
             α.rawValue,
             .init(.init(a)), ld, op,
             .init(.init(x)), incx,
             β.rawValue,
             .init(.init(y)), incy)
    }
}
extension Complex128: BLASElement {
    @inlinable@inline(__always)@_transparent
    public static func Norm(n: Int, x: UnsafePointer<Self>, inc: Int) -> Magnitude {
        nrm2(n, .init(.init(x)) as UnsafePointer<RawValue>, inc)
    }
    @inlinable@inline(__always)@_transparent
    public static func Inner(n: Int,
                             x: UnsafePointer<Self>, inc incx: Int,
                             y: UnsafePointer<Self>, inc incy: Int) -> Self {
        .init(rawValue: dot(n,
                            .init(.init(x)), incx,
                            .init(.init(y)), incy))
    }
    @inlinable@inline(__always)@_transparent
    public static func Outer(m: Int, n: Int,
                             α: Self,
                             x: UnsafePointer<Self>, inc incx: Int,
                             y: UnsafePointer<Self>, inc incy: Int,
                             β: Self,
                             a: UnsafeMutablePointer<Self>, ld: Int) {
        switch β {
        case 1:
            break
        default:
            for r in stride(from: 0, to: n * ld, by: ld).lazy.map(a.advanced(by:)) {
                scal(m, β.rawValue, .init(.init(r)), 1)
            }
        }
        ger(m, n,
            α.rawValue,
            .init(.init(x)), incx,
            .init(.init(y)), incy,
            .init(.init(a)), ld)
    }
    @inlinable@inline(__always)@_transparent
    public static func GEMM(m: Int, n: Int, k: Int,
                            α: Self,
                            a: UnsafePointer<Self>, ld lda: Int, op opa: op_t,
                            b: UnsafePointer<Self>, ld ldb: Int, op opb: op_t,
                            β: Self,
                            c: UnsafeMutablePointer<Self>, ld ldc: Int) {
        gemm(m, n, k,
             α.rawValue,
             .init(.init(a)), lda, opa,
             .init(.init(b)), ldb, opb,
             β.rawValue,
             .init(.init(c)), ldc)
    }
    @inlinable@inline(__always)@_transparent
    public static func GEMV(m: Int, n: Int,
                            α: Self,
                            a: UnsafePointer<Self>, ld: Int, op: op_t,
                            x: UnsafePointer<Self>, inc incx: Int,
                            β: Self,
                            y: UnsafeMutablePointer<Self>, inc incy: Int) {
        gemv(m, n,
             α.rawValue,
             .init(.init(a)), ld, op,
             .init(.init(x)), incx,
             β.rawValue,
             .init(.init(y)), incy)
    }
}
