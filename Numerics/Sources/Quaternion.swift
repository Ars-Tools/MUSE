//
//  Quaternion.swift
//  MUSE
//
//  Created by Kota on 5/15/R7.
//
public protocol QuoternionNumber: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral where FloatLiteralType: BinaryFloatingPoint & SIMDScalar {
	var real: FloatLiteralType { get set }
	var imag: SIMD3<FloatLiteralType> { get set }
	init(real: FloatLiteralType, imag: SIMD3<FloatLiteralType>)
	init(ix: FloatLiteralType, iy: FloatLiteralType, iz: FloatLiteralType, r: FloatLiteralType)
}
extension QuoternionNumber {
	@inlinable @inline(__always)
	public init(floatLiteral value: FloatLiteralType) {
		self.init(real: .init(value), imag: .zero)
	}
	@inlinable @inline(__always)
	public init(integerLiteral value: FloatLiteralType.IntegerLiteralType) {
		self.init(floatLiteral: .init(integerLiteral: value))
	}
}
