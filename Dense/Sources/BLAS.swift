//
//  BLAS.swift
//  MUSE
//
//  Created by Kota on 9/12/R7.
//
import Accelerate.vecLib
import typealias Numerics.Complex64
import typealias Numerics.Complex128
public enum BLAS {
	public protocol Element: Numeric & BitwiseCopyable {
		@inlinable@inline(__always)
		static func GEMM(t: (UnsafePointer<CChar>, UnsafePointer<CChar>),
						 m: Int, n: Int, k: Int,
						 α: Self,
						 a: UnsafePointer<Self>, lda: Int,
						 b: UnsafePointer<Self>, ldb: Int,
						 β: Self,
						 c: UnsafeMutablePointer<Self>, ldc: Int)
		@inlinable@inline(__always)
		static func GEMV(t: UnsafePointer<CChar>,
						 m: Int, n: Int,
						 α: Self,
						 a: UnsafePointer<Self>, lda: Int,
						 x: UnsafePointer<Self>, ldx: Int,
						 β: Self,
						 y: UnsafeMutablePointer<Self>, ldy: Int)
	}
}
extension Float32: BLAS.Element {
	@inlinable@inline(__always)
	public static func GEMM(t: (UnsafePointer<CChar>, UnsafePointer<CChar>),
							m: Int, n: Int, k: Int,
							α: Self,
							a: UnsafePointer<Self>, lda: Int,
							b: UnsafePointer<Self>, ldb: Int,
							β: Self,
							c: UnsafeMutablePointer<Self>, ldc: Int) {
		sgemm_(t.0, t.1,
			   withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self), withUnsafePointer(to: k, \.self),
			   withUnsafePointer(to: α, \.self),
			   a, withUnsafePointer(to: lda, \.self),
			   b, withUnsafePointer(to: ldb, \.self),
			   withUnsafePointer(to: β, \.self),
			   c, withUnsafePointer(to: ldc, \.self))
	}
	@inlinable@inline(__always)
	public static func GEMV(t: UnsafePointer<CChar>,
							m: Int, n: Int,
							α: Float,
							a: UnsafePointer<Self>, lda: Int,
							x: UnsafePointer<Self>, ldx: Int,
							β: Float,
							y: UnsafeMutablePointer<Self>, ldy: Int) {
		sgemv_(t,
			   withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self),
			   withUnsafePointer(to: α, \.self),
			   a, withUnsafePointer(to: lda, \.self),
			   x, withUnsafePointer(to: ldx, \.self),
			   withUnsafePointer(to: β, \.self),
			   y, withUnsafePointer(to: ldy, \.self))
	}
}
extension Float64: BLAS.Element {
	public static func GEMM(t: (UnsafePointer<CChar>, UnsafePointer<CChar>),
							m: Int, n: Int, k: Int,
							α: Self,
							a: UnsafePointer<Self>, lda: Int,
							b: UnsafePointer<Self>, ldb: Int,
							β: Self,
							c: UnsafeMutablePointer<Self>, ldc: Int) {
		dgemm_(t.0, t.1,
			   withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self), withUnsafePointer(to: k, \.self),
			   withUnsafePointer(to: α, \.self),
			   a, withUnsafePointer(to: lda, \.self),
			   b, withUnsafePointer(to: ldb, \.self),
			   withUnsafePointer(to: β, \.self),
			   c, withUnsafePointer(to: ldc, \.self))
	}
	@inlinable@inline(__always)
	public static func GEMV(t: UnsafePointer<CChar>,
							m: Int, n: Int,
							α: Self,
							a: UnsafePointer<Self>, lda: Int,
							x: UnsafePointer<Self>, ldx: Int,
							β: Self,
							y: UnsafeMutablePointer<Self>, ldy: Int) {
		dgemv_(t,
			   withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self),
			   withUnsafePointer(to: α, \.self),
			   a, withUnsafePointer(to: lda, \.self),
			   x, withUnsafePointer(to: ldx, \.self),
			   withUnsafePointer(to: β, \.self),
			   y, withUnsafePointer(to: ldy, \.self))
	}
}
//extension Complex64: BLAS.Element {}
//extension Complex128: BLAS.Element {}
