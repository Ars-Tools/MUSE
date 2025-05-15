//
//  Quoternion+Primitive.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
import typealias simd.simd_quath
import typealias simd.simd_quatf
import typealias simd.simd_quatd
public typealias Quoternion64 = simd_quath
public typealias Quoternion128 = simd_quatf
public typealias Quoternion256 = simd_quatd
extension Quoternion64: @retroactive ExpressibleByIntegerLiteral, @retroactive ExpressibleByFloatLiteral, QuoternionNumber {
	public typealias FloatLiteralType = Float16
	public var real: FloatLiteralType {
		_read { yield vector.w }
		_modify { yield &vector.w }
	}
	public var imag: SIMD3<FloatLiteralType> {
		get { .init(vector.x, vector.y, vector.z) }
		set {
			vector.x = newValue.x
			vector.y = newValue.y
			vector.z = newValue.z
		}
	}
	public init(real: Float16, imag: SIMD3<Float16>) {
		self.init(vector: .init(imag, real))
	}
	public init(ix: Float16, iy: Float16, iz: Float16, r: Float16) {
		self.init(vector: .init(x: ix, y: iy, z: iz, w: r))
	}
}
extension Quoternion128: @retroactive ExpressibleByIntegerLiteral, @retroactive ExpressibleByFloatLiteral, QuoternionNumber {
	public typealias FloatLiteralType = Float32
}
extension Quoternion256: @retroactive ExpressibleByIntegerLiteral, @retroactive ExpressibleByFloatLiteral, QuoternionNumber {
	public typealias FloatLiteralType = Float64
}
