//
//  Element+LAPACK.swift
//  MUSE
//
//  Created by Kota on 9/12/R7.
//
import Accelerate.vecLib
import typealias Numerics.Complex64
import typealias Numerics.Complex128
public protocol LAPACKSuiteElement: BLASElement {
	@inlinable@inline(__always)
	@discardableResult
	static func GETRF(m: Int, n: Int,
					  a: UnsafeMutablePointer<Self>, lda: Int,
					  p: UnsafeMutablePointer<Int>) -> Int
	@discardableResult
	@inlinable@inline(__always)
	static func GETRI(n: Int,
					  a: UnsafeMutablePointer<Self>, lda: Int,
					  p: UnsafePointer<Int>) -> Int
	@discardableResult
	@inlinable@inline(__always)
	static func GETRS(n: Int, nrhs: Int,
					  a: UnsafePointer<Self>, lda: Int, opa: UnsafePointer<CChar>,
					  b: UnsafeMutablePointer<Self>, ldb: Int,
					  p: UnsafePointer<Int>) -> Int
}
extension Float32: LAPACKSuiteElement {
	@discardableResult
	@inlinable@inline(__always)@_transparent
	public static func GETRF(m: Int, n: Int,
							 a: UnsafeMutablePointer<Self>, lda: Int,
							 p: UnsafeMutablePointer<Int>) -> Int {
		var info = 0
		sgetrf_(withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self),
				a, withUnsafePointer(to: lda, \.self),
				p, &info)
		return info
	}
	@discardableResult
	@inlinable@inline(__always)@_transparent
	public static func GETRI(n: Int,
							 a: UnsafeMutablePointer<Self>, lda: Int,
							 p: UnsafePointer<Int>) -> Int {
		var info = 0
		var size = 0 as Self
		sgetri_(withUnsafePointer(to: n, \.self),
				a, withUnsafePointer(to: lda, \.self),
				p,
				&size, withUnsafePointer(to: -1, \.self),
				&info)
		assert(info == 0)
		withUnsafeTemporaryAllocation(of: Self.self, capacity: .init(size)) {
			sgetri_(withUnsafePointer(to: n, \.self),
					a, withUnsafePointer(to: lda, \.self),
					p,
					$0.baseAddress.unsafelyUnwrapped, withUnsafePointer(to: $0.count, \.self),
					&info)
		}
		return info
	}
	@discardableResult
	@inlinable@inline(__always)@_transparent
	public static func GETRS(n: Int, nrhs: Int,
							 a: UnsafePointer<Self>, lda: Int, opa: UnsafePointer<CChar>,
							 b: UnsafeMutablePointer<Self>, ldb: Int,
							 p: UnsafePointer<Int>) -> Int {
		var info = 0
		sgetrs_(opa,
				withUnsafePointer(to: n, \.self), withUnsafePointer(to: nrhs, \.self),
				a, withUnsafePointer(to: lda, \.self),
				p,
				b, withUnsafePointer(to: ldb, \.self),
				&info)
		return info
	}
}
extension Float64: LAPACKSuiteElement {
	@discardableResult
	@inlinable@inline(__always)@_transparent
	public static func GETRF(m: Int, n: Int,
							 a: UnsafeMutablePointer<Self>, lda: Int,
							 p: UnsafeMutablePointer<Int>) -> Int {
		var info = 0
		dgetrf_(withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self),
				a, withUnsafePointer(to: lda, \.self),
				p, &info)
		return info
	}
	@discardableResult
	@inlinable@inline(__always)@_transparent
	public static func GETRI(n: Int,
							 a: UnsafeMutablePointer<Self>, lda: Int,
							 p: UnsafePointer<Int>) -> Int {
		var info = 0
		var size = 0 as Self
		dgetri_(withUnsafePointer(to: n, \.self),
				a, withUnsafePointer(to: lda, \.self),
				p,
				&size, withUnsafePointer(to: -1, \.self),
				&info)
		assert(info == 0)
		withUnsafeTemporaryAllocation(of: Self.self, capacity: .init(size)) {
			dgetri_(withUnsafePointer(to: n, \.self),
					a, withUnsafePointer(to: lda, \.self),
					p,
					$0.baseAddress.unsafelyUnwrapped, withUnsafePointer(to: $0.count, \.self),
					&info)
		}
		return info
	}
	@discardableResult
	@inlinable@inline(__always)@_transparent
	public static func GETRS(n: Int, nrhs: Int,
							 a: UnsafePointer<Self>, lda: Int, opa: UnsafePointer<CChar>,
							 b: UnsafeMutablePointer<Self>, ldb: Int,
							 p: UnsafePointer<Int>) -> Int {
		var info = 0
		dgetrs_(opa,
				withUnsafePointer(to: n, \.self), withUnsafePointer(to: nrhs, \.self),
				a, withUnsafePointer(to: lda, \.self),
				p,
				b, withUnsafePointer(to: ldb, \.self),
				&info)
		return info
	}
}
extension Complex64: LAPACKSuiteElement {
	@discardableResult
	@inlinable@inline(__always)@_transparent
	public static func GETRF(m: Int, n: Int,
							 a: UnsafeMutablePointer<Self>, lda: Int,
							 p: UnsafeMutablePointer<Int>) -> Int {
		var info = 0
		cgetrf_(withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self),
				.init(a), withUnsafePointer(to: lda, \.self),
				p, &info)
		return info
	}
	@discardableResult
	@inlinable@inline(__always)@_transparent
	public static func GETRI(n: Int,
							 a: UnsafeMutablePointer<Self>, lda: Int,
							 p: UnsafePointer<Int>) -> Int {
		var info = 0
		var size = 0 as Self
		cgetri_(withUnsafePointer(to: n, \.self),
				.init(a), withUnsafePointer(to: lda, \.self),
				p,
				.init(withUnsafePointer(to: &size, \.self)), withUnsafePointer(to: -1, \.self),
				&info)
		assert(info == 0)
		withUnsafeTemporaryAllocation(of: Self.self, capacity: .init(size.real)) {
			cgetri_(withUnsafePointer(to: n, \.self),
					.init(a), withUnsafePointer(to: lda, \.self),
					p,
					.init($0.baseAddress.unsafelyUnwrapped), withUnsafePointer(to: $0.count, \.self),
					&info)
		}
		return info
	}
	@discardableResult
	@inlinable@inline(__always)@_transparent
	public static func GETRS(n: Int, nrhs: Int,
							 a: UnsafePointer<Self>, lda: Int, opa: UnsafePointer<CChar>,
							 b: UnsafeMutablePointer<Self>, ldb: Int,
							 p: UnsafePointer<Int>) -> Int {
		var info = 0
		cgetrs_(opa,
				withUnsafePointer(to: n, \.self), withUnsafePointer(to: nrhs, \.self),
				.init(a), withUnsafePointer(to: lda, \.self),
				p,
				.init(b), withUnsafePointer(to: ldb, \.self),
				&info)
		return info
	}
}
extension Complex128: LAPACKSuiteElement {
	@discardableResult
	@inlinable@inline(__always)@_transparent
	public static func GETRF(m: Int, n: Int,
							 a: UnsafeMutablePointer<Self>, lda: Int,
							 p: UnsafeMutablePointer<Int>) -> Int {
		var info = 0
		zgetrf_(withUnsafePointer(to: m, \.self), withUnsafePointer(to: n, \.self),
				.init(a), withUnsafePointer(to: lda, \.self),
				p, &info)
		return info
	}
	@discardableResult
	@inlinable@inline(__always)@_transparent
	public static func GETRI(n: Int,
							 a: UnsafeMutablePointer<Self>, lda: Int,
							 p: UnsafePointer<Int>) -> Int {
		var info = 0
		var size = 0 as Self
		zgetri_(withUnsafePointer(to: n, \.self),
				.init(a), withUnsafePointer(to: lda, \.self),
				p,
				.init(withUnsafePointer(to: &size, \.self)), withUnsafePointer(to: -1, \.self),
				&info)
		assert(info == 0)
		withUnsafeTemporaryAllocation(of: Self.self, capacity: .init(size.real)) {
			zgetri_(withUnsafePointer(to: n, \.self),
					.init(a), withUnsafePointer(to: lda, \.self),
					p,
					.init($0.baseAddress.unsafelyUnwrapped), withUnsafePointer(to: $0.count, \.self),
					&info)
		}
		return info
	}
	@discardableResult
	@inlinable@inline(__always)@_transparent
	public static func GETRS(n: Int, nrhs: Int,
							 a: UnsafePointer<Self>, lda: Int, opa: UnsafePointer<CChar>,
							 b: UnsafeMutablePointer<Self>, ldb: Int,
							 p: UnsafePointer<Int>) -> Int {
		var info = 0
		zgetrs_(opa,
				withUnsafePointer(to: n, \.self), withUnsafePointer(to: nrhs, \.self),
				.init(a), withUnsafePointer(to: lda, \.self),
				p,
				.init(b), withUnsafePointer(to: ldb, \.self),
				&info)
		return info
	}
}
