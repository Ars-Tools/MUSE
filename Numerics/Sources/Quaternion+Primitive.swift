//
//  Quaternion+Primitive.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
import typealias simd.simd_quath
import typealias simd.simd_quatf
import typealias simd.simd_quatd
public typealias Quaternion64 = simd_quath
public typealias Quaternion128 = simd_quatf
public typealias Quaternion256 = simd_quatd
extension Quaternion64: @retroactive ExpressibleByIntegerLiteral, @retroactive ExpressibleByFloatLiteral, QuaternionNumber {
	public typealias FloatLiteralType = Float16
	@inlinable @inline(__always)
	public var real: FloatLiteralType {
		_read { yield vector.w }
		_modify { yield &vector.w }
	}
	@inlinable @inline(__always)
	public var imag: SIMD3<FloatLiteralType> {
		get { .init(vector.x, vector.y, vector.z) }
		set {
			vector.x = newValue.x
			vector.y = newValue.y
			vector.z = newValue.z
		}
	}
	@inlinable @inline(__always)
	public init(real: Float16, imag: SIMD3<Float16>) {
		self.init(vector: .init(imag, real))
	}
	@inlinable @inline(__always)
	public init(ix: Float16, iy: Float16, iz: Float16, r: Float16) {
		self.init(vector: .init(x: ix, y: iy, z: iz, w: r))
	}
}
extension Quaternion128: @retroactive ExpressibleByIntegerLiteral, @retroactive ExpressibleByFloatLiteral, QuaternionNumber {
	public typealias FloatLiteralType = Float32
}
extension Quaternion256: @retroactive ExpressibleByIntegerLiteral, @retroactive ExpressibleByFloatLiteral, QuaternionNumber {
	public typealias FloatLiteralType = Float64
}
