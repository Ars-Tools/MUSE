//
//  BLAS.swift
//  MUSE
//
//  Created by Kota on 9/18/R7.
//
import Accelerate.vecLib
import typealias Numerics.Complex64
import typealias Numerics.Complex128
import typealias Layout.MemoryStrategy
@usableFromInline
enum BLAS<Element: BLASElement & ArithmeticElement> {}
infix operator •: MultiplicationPrecedence
public protocol BLASElement {
	@inlinable@inline(__always)
	static func Inner(n: Int,
					  x: UnsafePointer<Self>, ldx: Int,
					  y: UnsafePointer<Self>, ldy: Int) -> Self
	@inlinable@inline(__always)
	static func Outer(m: Int, n: Int,
					  α: Self,
					  x: UnsafePointer<Self>, ldx: Int,
					  y: UnsafePointer<Self>, ldy: Int,
					  β: Self,
					  a: UnsafeMutablePointer<Self>, lda: Int)
	@inlinable@inline(__always)
	static func GEMM(m: Int, n: Int, k: Int,
					 α: Self,
					 a: UnsafePointer<Self>, lda: Int, opa: UnsafePointer<CChar>,
					 b: UnsafePointer<Self>, ldb: Int, opb: UnsafePointer<CChar>,
					 β: Self,
					 c: UnsafeMutablePointer<Self>, ldc: Int)
	@inlinable@inline(__always)
	static func GEMV(m: Int, n: Int,
					 α: Self,
					 a: UnsafePointer<Self>, lda: Int, opa: UnsafePointer<CChar>,
					 x: UnsafePointer<Self>, ldx: Int,
					 β: Self,
					 y: UnsafeMutablePointer<Self>, ldy: Int)
}
extension Float32: BLASElement {
	@inlinable@inline(__always)
	public static func Inner(n: Int,
							 x: UnsafePointer<Self>, ldx: Int,
							 y: UnsafePointer<Self>, ldy: Int) -> Self {
		sdot_(withUnsafePointer(to: n, \.self),
			  x, withUnsafePointer(to: ldx, \.self),
			  y, withUnsafePointer(to: ldy, \.self))
	}
	@inlinable@inline(__always)
	public static func Outer(m: Int, n: Int,
							 α: Self,
							 x: UnsafePointer<Self>, ldx: Int,
							 y: UnsafePointer<Self>, ldy: Int,
							 β: Self,
							 a: UnsafeMutablePointer<Self>, lda: Int) {
		switch β {
		case 1:
			break
		default:
			for r in stride(from: 0, to: n * lda, by: lda).lazy.map(a.advanced(by:)) {
				sscal_(withUnsafePointer(to: m, \.self),
					   withUnsafePointer(to: β, \.self),
					   r,
					   withUnsafePointer(to: 1, \.self))
			}
		}
		sger_(withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self),
			  withUnsafePointer(to: α, \.self),
			  x, withUnsafePointer(to: ldx, \.self),
			  y, withUnsafePointer(to: ldy, \.self),
			  a, withUnsafePointer(to: lda, \.self))
	}
	@inlinable@inline(__always)
	public static func GEMM(m: Int, n: Int, k: Int,
							α: Self,
							a: UnsafePointer<Self>, lda: Int, opa: UnsafePointer<CChar>,
							b: UnsafePointer<Self>, ldb: Int, opb: UnsafePointer<CChar>,
							β: Self,
							c: UnsafeMutablePointer<Self>, ldc: Int) {
		sgemm_(opa, opb,
			   withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self), withUnsafePointer(to: k, \.self),
			   withUnsafePointer(to: α, \.self),
			   a, withUnsafePointer(to: lda, \.self),
			   b, withUnsafePointer(to: ldb, \.self),
			   withUnsafePointer(to: β, \.self),
			   c, withUnsafePointer(to: ldc, \.self))
	}
	@inlinable@inline(__always)
	public static func GEMV(m: Int, n: Int,
							α: Float,
							a: UnsafePointer<Self>, lda: Int, opa: UnsafePointer<CChar>,
							x: UnsafePointer<Self>, ldx: Int,
							β: Float,
							y: UnsafeMutablePointer<Self>, ldy: Int) {
		sgemv_(opa,
			   withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self),
			   withUnsafePointer(to: α, \.self),
			   a, withUnsafePointer(to: lda, \.self),
			   x, withUnsafePointer(to: ldx, \.self),
			   withUnsafePointer(to: β, \.self),
			   y, withUnsafePointer(to: ldy, \.self))
	}
}
extension Float64: BLASElement {
	@inlinable@inline(__always)
	public static func Inner(n: Int,
							 x: UnsafePointer<Self>, ldx: Int,
							 y: UnsafePointer<Self>, ldy: Int) -> Self {
		ddot_(withUnsafePointer(to: n, \.self),
			  x, withUnsafePointer(to: ldx, \.self),
			  y, withUnsafePointer(to: ldy, \.self))
	}
	@inlinable@inline(__always)
	public static func Outer(m: Int, n: Int,
							 α: Self,
							 x: UnsafePointer<Self>, ldx: Int,
							 y: UnsafePointer<Self>, ldy: Int,
							 β: Self,
							 a: UnsafeMutablePointer<Self>, lda: Int) {
		switch β {
		case 1:
			break
		default:
			for r in stride(from: 0, to: n * lda, by: lda).lazy.map(a.advanced(by:)) {
				dscal_(withUnsafePointer(to: m, \.self),
					   withUnsafePointer(to: β, \.self),
					   r,
					   withUnsafePointer(to: 1, \.self))
			}
		}
		dger_(withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self),
			  withUnsafePointer(to: α, \.self),
			  x, withUnsafePointer(to: ldx, \.self),
			  y, withUnsafePointer(to: ldy, \.self),
			  a, withUnsafePointer(to: lda, \.self))
	}
	@inlinable@inline(__always)
	public static func GEMM(m: Int, n: Int, k: Int,
							α: Self,
							a: UnsafePointer<Self>, lda: Int, opa: UnsafePointer<CChar>,
							b: UnsafePointer<Self>, ldb: Int, opb: UnsafePointer<CChar>,
							β: Self,
							c: UnsafeMutablePointer<Self>, ldc: Int) {
		dgemm_(opa, opb,
			   withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self), withUnsafePointer(to: k, \.self),
			   withUnsafePointer(to: α, \.self),
			   a, withUnsafePointer(to: lda, \.self),
			   b, withUnsafePointer(to: ldb, \.self),
			   withUnsafePointer(to: β, \.self),
			   c, withUnsafePointer(to: ldc, \.self))
	}
	@inlinable@inline(__always)
	public static func GEMV(m: Int, n: Int,
							α: Self,
							a: UnsafePointer<Self>, lda: Int, opa: UnsafePointer<CChar>,
							x: UnsafePointer<Self>, ldx: Int,
							β: Self,
							y: UnsafeMutablePointer<Self>, ldy: Int) {
		dgemv_(opa,
			   withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self),
			   withUnsafePointer(to: α, \.self),
			   a, withUnsafePointer(to: lda, \.self),
			   x, withUnsafePointer(to: ldx, \.self),
			   withUnsafePointer(to: β, \.self),
			   y, withUnsafePointer(to: ldy, \.self))
	}
}
extension Complex64: BLASElement {
	@inlinable@inline(__always)
	public static func Inner(n: Int,
							 x: UnsafePointer<Self>, ldx: Int,
							 y: UnsafePointer<Self>, ldy: Int) -> Self {
		withUnsafeTemporaryAllocation(byteCount: MemoryLayout<Self>.size, alignment: MemoryLayout<Self>.alignment) {
			cdotu_(.init($0.baseAddress.unsafelyUnwrapped),
				   withUnsafePointer(to: n, \.self),
				   .init(x), withUnsafePointer(to: ldx, \.self),
				   .init(y), withUnsafePointer(to: ldy, \.self))
			return $0.withMemoryRebound(to: Self.self, \.baseAddress.unsafelyUnwrapped.pointee)
		}
	}
	@inlinable@inline(__always)
	public static func Outer(m: Int, n: Int,
							 α: Self,
							 x: UnsafePointer<Self>, ldx: Int,
							 y: UnsafePointer<Self>, ldy: Int,
							 β: Self,
							 a: UnsafeMutablePointer<Self>, lda: Int) {
		switch β {
		case 1:
			break
		default:
			for r in stride(from: 0, to: n * lda, by: lda).lazy.map(a.advanced(by:)) {
				cscal_(withUnsafePointer(to: m, \.self),
					   .init(withUnsafePointer(to: β, \.self)),
					   .init(r),
					   withUnsafePointer(to: 1, \.self))
			}
		}
		cgeru_(withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self),
			   .init(withUnsafePointer(to: α, \.self)),
			   .init(x), withUnsafePointer(to: ldx, \.self),
			   .init(y), withUnsafePointer(to: ldy, \.self),
			   .init(a), withUnsafePointer(to: lda, \.self))
	}
	@inlinable@inline(__always)
	public static func GEMM(m: Int, n: Int, k: Int,
							α: Self,
							a: UnsafePointer<Self>, lda: Int, opa: UnsafePointer<CChar>,
							b: UnsafePointer<Self>, ldb: Int, opb: UnsafePointer<CChar>,
							β: Self,
							c: UnsafeMutablePointer<Self>, ldc: Int) {
		cgemm_(opa, opb,
			   withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self), withUnsafePointer(to: k, \.self),
			   .init(withUnsafePointer(to: α, \.self)),
			   .init(a), withUnsafePointer(to: lda, \.self),
			   .init(b), withUnsafePointer(to: ldb, \.self),
			   .init(withUnsafePointer(to: β, \.self)),
			   .init(c), withUnsafePointer(to: ldc, \.self))
	}
	@inlinable@inline(__always)
	public static func GEMV(m: Int, n: Int,
							α: Self,
							a: UnsafePointer<Self>, lda: Int, opa: UnsafePointer<CChar>,
							x: UnsafePointer<Self>, ldx: Int,
							β: Self,
							y: UnsafeMutablePointer<Self>, ldy: Int) {
		cgemv_(opa,
			   withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self),
			   .init(withUnsafePointer(to: α, \.self)),
			   .init(a), withUnsafePointer(to: lda, \.self),
			   .init(x), withUnsafePointer(to: ldx, \.self),
			   .init(withUnsafePointer(to: β, \.self)),
			   .init(y), withUnsafePointer(to: ldy, \.self))
	}
}
extension Complex128: BLASElement {
	@inlinable@inline(__always)
	public static func Inner(n: Int,
							 x: UnsafePointer<Self>, ldx: Int,
							 y: UnsafePointer<Self>, ldy: Int) -> Self {
		withUnsafeTemporaryAllocation(byteCount: MemoryLayout<Self>.size, alignment: MemoryLayout<Self>.alignment) {
			zdotu_(.init($0.baseAddress.unsafelyUnwrapped),
				   withUnsafePointer(to: n, \.self),
				   .init(x), withUnsafePointer(to: ldx, \.self),
				   .init(y), withUnsafePointer(to: ldy, \.self))
			return $0.withMemoryRebound(to: Self.self, \.baseAddress.unsafelyUnwrapped.pointee)
		}
	}
	@inlinable@inline(__always)
	public static func Outer(m: Int, n: Int,
							 α: Self,
							 x: UnsafePointer<Self>, ldx: Int,
							 y: UnsafePointer<Self>, ldy: Int,
							 β: Self,
							 a: UnsafeMutablePointer<Self>, lda: Int) {
		switch β {
		case 1:
			break
		default:
			for r in stride(from: 0, to: n * lda, by: lda).lazy.map(a.advanced(by:)) {
				zscal_(withUnsafePointer(to: m, \.self),
					   .init(withUnsafePointer(to: β, \.self)),
					   .init(r),
					   withUnsafePointer(to: 1, \.self))
			}
		}
		zgeru_(withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self),
			   .init(withUnsafePointer(to: α, \.self)),
			   .init(x), withUnsafePointer(to: ldx, \.self),
			   .init(y), withUnsafePointer(to: ldy, \.self),
			   .init(a), withUnsafePointer(to: lda, \.self))
	}
	@inlinable@inline(__always)
	public static func GEMM(m: Int, n: Int, k: Int,
							α: Self,
							a: UnsafePointer<Self>, lda: Int, opa: UnsafePointer<CChar>,
							b: UnsafePointer<Self>, ldb: Int, opb: UnsafePointer<CChar>,
							β: Self,
							c: UnsafeMutablePointer<Self>, ldc: Int) {
		zgemm_(opa, opb,
			   withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self), withUnsafePointer(to: k, \.self),
			   .init(withUnsafePointer(to: α, \.self)),
			   .init(a), withUnsafePointer(to: lda, \.self),
			   .init(b), withUnsafePointer(to: ldb, \.self),
			   .init(withUnsafePointer(to: β, \.self)),
			   .init(c), withUnsafePointer(to: ldc, \.self))
	}
	@inlinable@inline(__always)
	public static func GEMV(m: Int, n: Int,
							α: Self,
							a: UnsafePointer<Self>, lda: Int, opa: UnsafePointer<CChar>,
							x: UnsafePointer<Self>, ldx: Int,
							β: Self,
							y: UnsafeMutablePointer<Self>, ldy: Int) {
		zgemv_(opa,
			   withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self),
			   .init(withUnsafePointer(to: α, \.self)),
			   .init(a), withUnsafePointer(to: lda, \.self),
			   .init(x), withUnsafePointer(to: ldx, \.self),
			   .init(withUnsafePointer(to: β, \.self)),
			   .init(y), withUnsafePointer(to: ldy, \.self))
	}
}
