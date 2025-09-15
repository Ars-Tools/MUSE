//
//  LAPACK.swift
//  MUSE
//
//  Created by Kota on 9/12/R7.
//
import Accelerate.vecLib
public enum LAPACK {
	public protocol Element: BLAS.Element {
		@inlinable@inline(__always)
		@discardableResult
		static func GETRF(m: Int, n: Int,
						  a: UnsafeMutablePointer<Self>, lda: Int,
						  p: UnsafeMutablePointer<Int>) -> Int
	}
}
extension Float32: LAPACK.Element {
	@discardableResult
	public static func GETRF(m: Int, n: Int,
							 a: UnsafeMutablePointer<Self>, lda: Int,
							 p: UnsafeMutablePointer<Int>) -> Int {
		var info = 0
		sgetrf_(withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self),
				a, withUnsafePointer(to: lda, \.self),
				p, &info)
		return info
	}
}
extension Float64: LAPACK.Element {
	@discardableResult
	public static func GETRF(m: Int, n: Int,
							 a: UnsafeMutablePointer<Self>, lda: Int,
							 p: UnsafeMutablePointer<Int>) -> Int {
		var info = 0
		dgetrf_(withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self),
				a, withUnsafePointer(to: lda, \.self),
				p, &info)
		return info
	}
}
