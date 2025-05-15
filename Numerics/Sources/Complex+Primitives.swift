//
//  Complex+Primitives.swift
//  MUSE
//
//  Created by Kota on 5/15/R7.
//
import Accelerate
import simd
import protocol Synchronization.AtomicRepresentable
@frozen public struct Complex32: ComplexNumber {
	public typealias FloatLiteralType = Float16
	public let real: FloatLiteralType
	public let imag: FloatLiteralType
	@inlinable
	@inline(__always)
	public init(real r: FloatLiteralType, imag i: FloatLiteralType) {
		real = r
		imag = i
	}
	@inlinable
	@inline(__always)
	public var magnitude: FloatLiteralType.Magnitude {
		(real * real + imag * imag).squareRoot()
	}
	public static let i = Self(real: 0, imag: 1)
}
extension Complex32: AtomicRepresentable {
	public static func decodeAtomicRepresentation(_ storage: consuming SIMD2<FloatLiteralType>) -> Self {
		unsafeBitCast(storage, to: Self.self)
	}
	public static func encodeAtomicRepresentation(_ value: consuming Self) -> SIMD2<FloatLiteralType> {
		unsafeBitCast(value, to: SIMD2<FloatLiteralType>.self)
	}
}
//@frozen public struct Complex64: ComplexNumber {
//	public typealias FloatLiteralType = Float32
//	public let real: FloatLiteralType
//	public let imag: FloatLiteralType
//	@inlinable
//	@inline(__always)
//	public init(real r: FloatLiteralType, imag i: FloatLiteralType) {
//		real = r
//		imag = i
//	}
//	@inlinable
//	@inline(__always)
//	public var magnitude: FloatLiteralType.Magnitude {
//		length(unsafeBitCast(self, to: SIMD2<FloatLiteralType>.self))
//	}
//	public static let i = Self(real: 0, imag: 1)
//}
public typealias Complex64 = DSPComplex
extension Complex64: ComplexNumber, @unchecked Sendable {
	public typealias FloatLiteralType = Float32
	@inlinable
	@inline(__always)
	public func hash(into hasher: inout Hasher) {
		real.hash(into: &hasher)
		imag.hash(into: &hasher)
	}
	@inlinable
	@inline(__always)
	public var magnitude: FloatLiteralType.Magnitude {
		length(.init(real, imag))
	}
	public static let i = Self(real: 0, imag: 1)
}
extension Complex64: AtomicRepresentable {
	public static func decodeAtomicRepresentation(_ storage: consuming SIMD2<FloatLiteralType>) -> Self {
		unsafeBitCast(storage, to: Self.self)
	}
	public static func encodeAtomicRepresentation(_ value: consuming Self) -> SIMD2<FloatLiteralType> {
		unsafeBitCast(value, to: SIMD2<FloatLiteralType>.self)
	}
}
//@frozen public struct Complex128: ComplexNumber {
//	public typealias FloatLiteralType = Float64
//	public let real: FloatLiteralType
//	public let imag: FloatLiteralType
//	@inlinable
//	@inline(__always)
//	public init(real r: FloatLiteralType, imag i: FloatLiteralType) {
//		real = r
//		imag = i
//	}
//	@inlinable
//	@inline(__always)
//	public var magnitude: FloatLiteralType.Magnitude {
//		length(unsafeBitCast(self, to: SIMD2<FloatLiteralType>.self))
//	}
//	public static let i = Self(real: 0, imag: 1)
//}
public typealias Complex128 = DSPDoubleComplex
extension Complex128: ComplexNumber, @unchecked Sendable {
	public typealias FloatLiteralType = Float64
	@inlinable
	@inline(__always)
	public func hash(into hasher: inout Hasher) {
		real.hash(into: &hasher)
		imag.hash(into: &hasher)
	}
	@inlinable
	@inline(__always)
	public var magnitude: FloatLiteralType.Magnitude {
		length(.init(real, imag))
	}
	public static let i = Self(real: 0, imag: 1)
}
extension Complex128: AtomicRepresentable {
	public static func decodeAtomicRepresentation(_ storage: consuming SIMD2<FloatLiteralType>) -> Self {
		unsafeBitCast(storage, to: Self.self)
	}
	public static func encodeAtomicRepresentation(_ value: consuming Self) -> SIMD2<FloatLiteralType> {
		unsafeBitCast(value, to: SIMD2<FloatLiteralType>.self)
	}
}
//@frozen public struct Complex160: ComplexNumber {
//	public typealias FloatLiteralType = Float80
//	public let real: FloatLiteralType
//	public let imag: FloatLiteralType
//	@inlinable
//	@inline(__always)
//	public init(real r: FloatLiteralType, imag i: FloatLiteralType) {
//		real = r
//		imag = i
//	}
//	@inlinable
//	@inline(__always)
//	public var magnitude: FloatLiteralType.Magnitude {
//		length(.init(real, imag))
//	}
//}
//extension __CLPK_complex: ComplexNumber, @unchecked Sendable {
//	public typealias FloatLiteralType = __CLPK_real
//	@inlinable
//	@inline(__always)
//	public var real: __CLPK_real {
//		_read { yield r }
//		_modify { yield &r }
//	}
//	@inlinable
//	@inline(__always)
//	public var imag: __CLPK_real {
//		_read { yield i }
//		_modify { yield &i }
//	}
//	@inlinable
//	@inline(__always)
//	public init(real: __CLPK_real, imag: __CLPK_real) {
//		self.init(r: real, i: imag)
//	}
//	@inlinable
//	@inline(__always)
//	public func hash(into hasher: inout Hasher) {
//		r.hash(into: &hasher)
//		i.hash(into: &hasher)
//	}
//	@inlinable
//	@inline(__always)
//	public var magnitude: FloatLiteralType.Magnitude {
//		length(.init(r, i))
//	}
//}
//extension __CLPK_doublecomplex: ComplexNumber, @unchecked Sendable {
//	public typealias FloatLiteralType = __CLPK_doublereal
//	@inlinable
//	@inline(__always)
//	public var real: __CLPK_doublereal {
//		_read { yield r }
//		_modify { yield &r }
//	}
//	@inlinable
//	@inline(__always)
//	public var imag: __CLPK_doublereal {
//		_read { yield i }
//		_modify { yield &i }
//	}
//	@inlinable
//	@inline(__always)
//	public init(real: __CLPK_doublereal, imag: __CLPK_doublereal) {
//		self.init(r: real, i: imag)
//	}
//	@inlinable
//	@inline(__always)
//	public func hash(into hasher: inout Hasher) {
//		r.hash(into: &hasher)
//		i.hash(into: &hasher)
//	}
//	@inlinable
//	@inline(__always)
//	public var magnitude: FloatLiteralType.Magnitude {
//		length(.init(r, i))
//	}
//}
