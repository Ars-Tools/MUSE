//
//  Rational+Primitive.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
import protocol Synchronization.AtomicRepresentable
@frozen public struct Rational<IntegerLiteralType: BinaryInteger & _ExpressibleByBuiltinIntegerLiteral & Sendable & Copyable> where IntegerLiteralType.Magnitude: BinaryInteger & _ExpressibleByBuiltinIntegerLiteral & Sendable {
	public var numerator: IntegerLiteralType
	public var denominator: IntegerLiteralType
	public init(numerator n: IntegerLiteralType, denominator d: IntegerLiteralType) {
		(numerator, denominator) = (n, d)
	}
}
extension Rational: RationalNumber {
	public typealias Magnitude = Rational<IntegerLiteralType.Magnitude>
	@inline(__always)
	@inlinable
	public var magnitude: Magnitude {
		.init(numerator: numerator.magnitude, denominator: denominator.magnitude)
	}
}
extension Rational: ExpressibleByFloatLiteral where IntegerLiteralType: SignedInteger {}
@frozen public struct Rational16 {
	public typealias IntegerLiteralType = Int8
	public typealias RawValue = SIMD2<Int8>
	public var rawValue: RawValue
}
extension Rational16: RationalNumber & CustomStringConvertible & ExpressibleByFloatLiteral {
	public typealias Magnitude = Rational<IntegerLiteralType.Magnitude>
	public var magnitude: Rational<IntegerLiteralType.Magnitude> {
		.init(numerator: rawValue.x.magnitude, denominator: rawValue.y.magnitude)
	}
	public var numerator: IntegerLiteralType { rawValue.x }
	public var denominator: IntegerLiteralType { rawValue.y }
	public init(numerator: IntegerLiteralType, denominator: IntegerLiteralType) {
		rawValue = .init(numerator, denominator)
	}
}
extension Rational16: AtomicRepresentable {
	public static func encodeAtomicRepresentation(_ value: consuming Self) -> RawValue {
		unsafeBitCast(self, to: RawValue.self)
	}
	public static func decodeAtomicRepresentation(_ storage: consuming RawValue) -> Self {
		unsafeBitCast(storage, to: Self.self)
	}
}
@frozen public struct Rational32 {
	public typealias IntegerLiteralType = Int16
	public typealias RawValue = SIMD2<IntegerLiteralType>
	public var rawValue: RawValue
}
extension Rational32: RationalNumber & CustomStringConvertible & ExpressibleByFloatLiteral {
	public typealias Magnitude = Rational<IntegerLiteralType.Magnitude>
	public var magnitude: Rational<IntegerLiteralType.Magnitude> {
		.init(numerator: rawValue.x.magnitude, denominator: rawValue.y.magnitude)
	}
	public var numerator: IntegerLiteralType { rawValue.x }
	public var denominator: IntegerLiteralType { rawValue.y }
	public init(numerator: IntegerLiteralType, denominator: IntegerLiteralType) {
		rawValue = .init(numerator, denominator)
	}
}
extension Rational32: AtomicRepresentable {
	public static func encodeAtomicRepresentation(_ value: consuming Self) -> RawValue {
		unsafeBitCast(self, to: RawValue.self)
	}
	public static func decodeAtomicRepresentation(_ storage: consuming RawValue) -> Self {
		unsafeBitCast(storage, to: Self.self)
	}
}
@frozen public struct Rational64 {
	public typealias IntegerLiteralType = Int32
	public typealias RawValue = SIMD2<IntegerLiteralType>
	public var rawValue: RawValue
}
extension Rational64: RationalNumber & CustomStringConvertible & ExpressibleByFloatLiteral {
	public typealias Magnitude = Rational<IntegerLiteralType.Magnitude>
	public var magnitude: Rational<IntegerLiteralType.Magnitude> {
		.init(numerator: rawValue.x.magnitude, denominator: rawValue.y.magnitude)
	}
	public var numerator: IntegerLiteralType { rawValue.x }
	public var denominator: IntegerLiteralType { rawValue.y }
	public init(numerator: IntegerLiteralType, denominator: IntegerLiteralType) {
		rawValue = .init(numerator, denominator)
	}
}
extension Rational64: AtomicRepresentable {
	public static func encodeAtomicRepresentation(_ value: consuming Self) -> RawValue {
		unsafeBitCast(self, to: RawValue.self)
	}
	public static func decodeAtomicRepresentation(_ storage: consuming RawValue) -> Self {
		unsafeBitCast(storage, to: Self.self)
	}
}
@frozen public struct Rational128 {
	public typealias IntegerLiteralType = Int64
	public typealias RawValue = SIMD2<IntegerLiteralType>
	public var rawValue: RawValue
}
extension Rational128: RationalNumber & CustomStringConvertible & ExpressibleByFloatLiteral {
	public typealias Magnitude = Rational<IntegerLiteralType.Magnitude>
	public var magnitude: Rational<IntegerLiteralType.Magnitude> {
		.init(numerator: rawValue.x.magnitude, denominator: rawValue.y.magnitude)
	}
	public var numerator: IntegerLiteralType { rawValue.x }
	public var denominator: IntegerLiteralType { rawValue.y }
	public init(numerator: IntegerLiteralType, denominator: IntegerLiteralType) {
		rawValue = .init(numerator, denominator)
	}
}
extension Rational128: AtomicRepresentable {
	public static func encodeAtomicRepresentation(_ value: consuming Self) -> RawValue {
		unsafeBitCast(self, to: RawValue.self)
	}
	public static func decodeAtomicRepresentation(_ storage: consuming RawValue) -> Self {
		unsafeBitCast(storage, to: Self.self)
	}
}
@frozen public struct Rational256 {
	public typealias IntegerLiteralType = Int128
	public var numerator: IntegerLiteralType
	public var denominator: IntegerLiteralType
	public init(numerator n: IntegerLiteralType, denominator d: IntegerLiteralType) {
		(numerator, denominator) = (n, d)
	}
	public var magnitude: Rational<IntegerLiteralType.Magnitude> {
		.init(numerator: numerator.magnitude, denominator: denominator.magnitude)
	}
}
extension Rational256: RationalNumber & CustomStringConvertible & ExpressibleByFloatLiteral {
	public typealias Magnitude = Rational<IntegerLiteralType.Magnitude>
}
extension Rational256: AtomicRepresentable {
	public static func encodeAtomicRepresentation(_ value: consuming Self) -> SIMD4<UInt64> {
		unsafeBitCast(self, to: SIMD4<UInt64>.self)
	}
	public static func decodeAtomicRepresentation(_ storage: consuming SIMD4<UInt64>) -> Self {
		unsafeBitCast(storage, to: Self.self)
	}
}
