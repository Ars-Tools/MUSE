//
//  Quaternion.swift
//  MUSE
//
//  Created by Kota on 5/15/R7.
//
public protocol QuaternionNumber: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, Copyable & Hashable where FloatLiteralType: BinaryFloatingPoint & Comparable & Hashable & BitwiseCopyable & SIMDScalar {
	var real: FloatLiteralType { get set }
	var imag: SIMD3<FloatLiteralType> { get set }
	init(real: FloatLiteralType, imag: SIMD3<FloatLiteralType>)
	init(ix: FloatLiteralType, iy: FloatLiteralType, iz: FloatLiteralType, r: FloatLiteralType)
}
extension QuaternionNumber {
	@inlinable @inline(__always)
	public init(floatLiteral value: FloatLiteralType) {
		self.init(real: .init(value), imag: .zero)
	}
	@inlinable @inline(__always)
	public init(integerLiteral value: FloatLiteralType.IntegerLiteralType) {
		self.init(floatLiteral: .init(integerLiteral: value))
	}
}
extension QuaternionNumber {
	public static func==(lhs: Self, rhs: Self) -> Bool {
		lhs.real == rhs.real && lhs.imag == rhs.imag
	}
	public func hash(into hasher: inout Hasher) {
		real.hash(into: &hasher)
		imag.hash(into: &hasher)
	}
}
