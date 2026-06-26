//
//  Complex+Primitives.swift
//  MUSE
//
//  Created by Kota on 5/15/R7.
//
import func simd.length
import func simd.length_squared
import func simd.atan2f
import func simd.atan2l
import func simd.simd_length
import func simd.simd_all
import func simd.simd_equal
import typealias simd.simd_half2
import protocol Synchronization.AtomicRepresentable
@_spi(Internal)
import AltVec
@frozen public struct Complex32: ComplexNumber & BitwiseCopyable {
	public typealias FloatLiteralType = Float16
	public let real: FloatLiteralType
	public let imag: FloatLiteralType
    @inlinable@inline(__always)@_transparent
	public init(real r: FloatLiteralType, imag i: FloatLiteralType) {
		real = r
		imag = i
	}
    @inlinable@inline(__always)@_transparent
	public var magnitude: FloatLiteralType.Magnitude {
        simd_length(unsafeBitCast(self, to: simd_half2.self))
	}
    @inline(__always)
	public static let I = Self(real: 0, imag: 1)
}
extension Complex32 {
    @inlinable@inline(__always)@_transparent
    public static prefix func-(lhs: Self) -> Self {
        unsafeBitCast(-unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self), to: Self.self)
    }
    @inlinable@inline(__always)@_transparent
    public static func+(lhs: Self, rhs: Self) -> Self {
        unsafeBitCast(
            unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self) +
            unsafeBitCast(rhs, to: SIMD2<FloatLiteralType>.self),
        to: Self.self)
    }
    @inlinable@inline(__always)@_transparent
    public static func-(lhs: Self, rhs: Self) -> Self {
        unsafeBitCast(
            unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self) -
            unsafeBitCast(rhs, to: SIMD2<FloatLiteralType>.self),
        to: Self.self)
    }
    @inlinable@inline(__always)@_transparent
    public static func==(lhs: Self, rhs: Self) -> Bool {
        unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self) ==
        unsafeBitCast(rhs, to: SIMD2<FloatLiteralType>.self)
    }
}
extension Complex32: AtomicRepresentable {
    public typealias AtomicRepresentation = FloatLiteralType.SIMD2Storage
    @inlinable@inline(__always)@_transparent
    public static func encodeAtomicRepresentation(_ value: consuming Self) -> AtomicRepresentation {
        unsafeBitCast(value, to: AtomicRepresentation.self)
    }
    @inlinable@inline(__always)@_transparent
    public static func decodeAtomicRepresentation(_ storage: consuming AtomicRepresentation) -> Self {
        unsafeBitCast(storage, to: Self.self)
    }
}
@frozen public struct Complex64: ComplexNumber & BitwiseCopyable & RawRepresentable & Hashable {
    public typealias FloatLiteralType = Float32
    public let rawValue: complex64_t
    @inlinable@inline(__always)@_transparent
    public init(rawValue value: RawValue) {
        rawValue = value
    }
    @inlinable@inline(__always)@_transparent
    public init(real: FloatLiteralType, imag: FloatLiteralType) {
        rawValue = .init(.init(r: real, i: imag))
    }
    @inlinable@inline(__always)@_transparent
    public var real: FloatLiteralType {
        rawValue.r
    }
    @inlinable@inline(__always)@_transparent
    public var imag: FloatLiteralType {
        rawValue.i
    }
    @inlinable@inline(__always)@_transparent
    public var magnitude: FloatLiteralType {
        length(rawValue.vector)
    }
    @inlinable@inline(__always)@_transparent
    public var magnitude_squared: FloatLiteralType {
        length_squared(rawValue.vector)
    }
    @inlinable@inline(__always)@_transparent
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue.vector)
    }
    @inline(__always)
    public static let I = Self(real: 0, imag: 1)
}
extension Complex64 {
    @inlinable@inline(__always)@_transparent
    public static func==(lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue.vector == rhs.rawValue.vector
    }
    @inlinable@inline(__always)@_transparent
    public static prefix func-(lhs: Self) -> Self {
        .init(rawValue: complex_neg(lhs.rawValue))
    }
    @inlinable@inline(__always)@_transparent
    public static func+(lhs: Self, rhs: Self) -> Self {
        .init(rawValue: complex_add(lhs.rawValue, rhs.rawValue))
    }
    @inlinable@inline(__always)@_transparent
    public static func-(lhs: Self, rhs: Self) -> Self {
        .init(rawValue: complex_sub(lhs.rawValue, rhs.rawValue))
    }
    @inlinable@inline(__always)@_transparent
    public static func*(lhs: Self, rhs: Self) -> Self {
        .init(rawValue: complex_mul(lhs.rawValue, rhs.rawValue))
    }
    @inlinable@inline(__always)@_transparent
    public static func/(lhs: Self, rhs: Self) -> Self {
        .init(rawValue: complex_div(lhs.rawValue, rhs.rawValue))
    }
    @inlinable@inline(__always)@_transparent
    public init(r: FloatLiteralType, θ: FloatLiteralType) {
        rawValue = complex_new_rt(r, θ)
    }
    @inlinable@inline(__always)@_transparent
    public init(r: FloatLiteralType, πr: FloatLiteralType) {
        rawValue = complex_new_rp(r, πr)
    }
    @inlinable@inline(__always)@_transparent
    public var θ: FloatLiteralType {
        complex_arg(rawValue);
    }
    @inlinable@inline(__always)@_transparent
    public var conj: Self {
        .init(rawValue: complex_conj(rawValue))
    }
    @inlinable@inline(__always)@_transparent
    public var proj: Self {
        .init(rawValue: complex_proj(rawValue))
    }
}
extension Complex64: AtomicRepresentable {
	public typealias AtomicRepresentation = FloatLiteralType.SIMD2Storage
	@inlinable@inline(__always)@_transparent
	public static func encodeAtomicRepresentation(_ value: consuming Self) -> AtomicRepresentation {
        unsafeBitCast(value.rawValue.vector, to: AtomicRepresentation.self)
	}
	@inlinable@inline(__always)@_transparent
	public static func decodeAtomicRepresentation(_ storage: consuming AtomicRepresentation) -> Self {
        unsafeBitCast(storage, to: Self.self)
	}
}
@frozen public struct Complex128: ComplexNumber & BitwiseCopyable & RawRepresentable & Hashable {
    public typealias FloatLiteralType = Float64
    public let rawValue: complex128_t
    @inlinable@inline(__always)@_transparent
    public init(rawValue value: RawValue) {
        rawValue = value
    }
    @inlinable@inline(__always)@_transparent
    public init(real: FloatLiteralType, imag: FloatLiteralType) {
        rawValue = .init(.init(r: real, i: imag))
    }
    @inlinable@inline(__always)@_transparent
    public var real: FloatLiteralType {
        rawValue.r
    }
    @inlinable@inline(__always)@_transparent
    public var imag: FloatLiteralType {
        rawValue.i
    }
    @inlinable@inline(__always)@_transparent
    public var magnitude: FloatLiteralType {
        length(rawValue.vector)
    }
    @inlinable@inline(__always)@_transparent
    public var magnitude_squared: FloatLiteralType {
        length_squared(rawValue.vector)
    }
    @inlinable@inline(__always)@_transparent
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue.vector)
    }
    @inline(__always)
    public static let I = Self(real: 0, imag: 1)
}
extension Complex128 {
    @inlinable@inline(__always)@_transparent
    public static func==(lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue.vector == rhs.rawValue.vector
    }
    @inlinable@inline(__always)@_transparent
    public static prefix func-(lhs: Self) -> Self {
        .init(rawValue: complex_neg(lhs.rawValue))
    }
    @inlinable@inline(__always)@_transparent
    public static func+(lhs: Self, rhs: Self) -> Self {
        .init(rawValue: complex_add(lhs.rawValue, rhs.rawValue))
    }
    @inlinable@inline(__always)@_transparent
    public static func-(lhs: Self, rhs: Self) -> Self {
        .init(rawValue: complex_sub(lhs.rawValue, rhs.rawValue))
    }
    @inlinable@inline(__always)@_transparent
    public static func*(lhs: Self, rhs: Self) -> Self {
        .init(rawValue: complex_mul(lhs.rawValue, rhs.rawValue))
    }
    @inlinable@inline(__always)@_transparent
    public static func/(lhs: Self, rhs: Self) -> Self {
        .init(rawValue: complex_div(lhs.rawValue, rhs.rawValue))
    }
    @inlinable@inline(__always)@_transparent
    public init(r: FloatLiteralType, θ: FloatLiteralType) {
        rawValue = complex_new_rt(r, θ)
    }
    @inlinable@inline(__always)@_transparent
    public init(r: FloatLiteralType, πr: FloatLiteralType) {
        rawValue = complex_new_rp(r, πr)
    }
    @inlinable@inline(__always)@_transparent
    public var θ: FloatLiteralType {
        complex_arg(rawValue);
    }
    @inlinable@inline(__always)@_transparent
    public var conj: Self {
        .init(rawValue: complex_conj(rawValue))
    }
    @inlinable@inline(__always)@_transparent
    public var proj: Self {
        .init(rawValue: complex_proj(rawValue))
    }
}
extension Complex128: AtomicRepresentable {
	public typealias AtomicRepresentation = FloatLiteralType.SIMD2Storage
	@inlinable@inline(__always)@_transparent
	public static func encodeAtomicRepresentation(_ value: consuming Self) -> AtomicRepresentation {
		unsafeBitCast(value, to: AtomicRepresentation.self)
	}
	@inlinable@inline(__always)@_transparent
	public static func decodeAtomicRepresentation(_ storage: consuming AtomicRepresentation) -> Self {
		unsafeBitCast(storage, to: Self.self)
	}
}
//public typealias Complex64 = DSPComplex
extension DSPComplex {//}: ComplexNumber, @unchecked Sendable {
    public typealias FloatLiteralType = Float32
    @inlinable@inline(__always)@_transparent
    public func hash(into hasher: inout Hasher) {
        real.hash(into: &hasher)
        imag.hash(into: &hasher)
    }
    @inlinable@inline(__always)@_transparent
    public var magnitude: FloatLiteralType.Magnitude {
        length(unsafeBitCast(self, to: SIMD2<FloatLiteralType>.self))
    }
    @inlinable@inline(__always)@_transparent
    public var magnitudeSquared: FloatLiteralType.Magnitude {
        length_squared(unsafeBitCast(self, to: SIMD2<FloatLiteralType>.self))
    }
    @inlinable@inline(__always)@_transparent
    public var argument: FloatLiteralType {
        atan2f(imag, real)
    }
    @inline(__always)
    public static let i = Self(real: 0, imag: 1)
}
extension DSPComplex: @retroactive AtomicRepresentable {
    public typealias AtomicRepresentation = SIMD2<FloatLiteralType>
    @inlinable@inline(__always)@_transparent
    public static func encodeAtomicRepresentation(_ value: consuming Self) -> AtomicRepresentation {
        unsafeBitCast(value, to: AtomicRepresentation.self)
    }
    @inlinable@inline(__always)@_transparent
    public static func decodeAtomicRepresentation(_ storage: consuming AtomicRepresentation) -> Self {
        unsafeBitCast(storage, to: Self.self)
    }
}
//public typealias Complex128 = DSPDoubleComplex
extension DSPDoubleComplex {//}: ComplexNumber, @unchecked Sendable {
	public typealias FloatLiteralType = Float64
	@inlinable@inline(__always)@_transparent
	public func hash(into hasher: inout Hasher) {
		real.hash(into: &hasher)
		imag.hash(into: &hasher)
	}
	@inlinable@inline(__always)@_transparent
	public var magnitude: FloatLiteralType.Magnitude {
		length(unsafeBitCast(self, to: SIMD2<FloatLiteralType>.self))
	}
    @inlinable@inline(__always)@_transparent
    public var magnitudeSquared: FloatLiteralType.Magnitude {
        length_squared(unsafeBitCast(self, to: SIMD2<FloatLiteralType>.self))
    }
	@inlinable@inline(__always)@_transparent
	public var argument: FloatLiteralType {
		atan2l(imag, real)
	}
	@inline(__always)
	public static let i = Self(real: 0, imag: 1)
}
extension DSPDoubleComplex: @retroactive AtomicRepresentable {
	public typealias AtomicRepresentation = SIMD2<FloatLiteralType>
	@inlinable@inline(__always)@_transparent
	public static func encodeAtomicRepresentation(_ value: consuming Self) -> AtomicRepresentation {
		unsafeBitCast(value, to: AtomicRepresentation.self)
	}
	@inlinable@inline(__always)@_transparent
	public static func decodeAtomicRepresentation(_ storage: consuming AtomicRepresentation) -> Self {
		unsafeBitCast(storage, to: Self.self)
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
