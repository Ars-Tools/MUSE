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
import protocol Synchronization.AtomicRepresentable
import typealias Synchronization._Atomic64BitStorage
import typealias Synchronization._Atomic128BitStorage
extension simd_quath: @retroactive Equatable & Hashable {}
extension Quaternion64: @retroactive ExpressibleByIntegerLiteral, @retroactive ExpressibleByFloatLiteral, QuaternionNumber {
	public typealias FloatLiteralType = Float16
    @inlinable@inline(__always)@_transparent
	public var real: FloatLiteralType {
		_read { yield vector.w }
		_modify { yield &vector.w }
	}
    @inlinable@inline(__always)@_transparent
	public var imag: SIMD3<FloatLiteralType> {
		get { .init(vector.x, vector.y, vector.z) }
		set {
			vector.x = newValue.x
			vector.y = newValue.y
			vector.z = newValue.z
		}
	}
    @inlinable@inline(__always)@_transparent
	public init(real: Float16, imag: SIMD3<Float16>) {
		self.init(vector: .init(imag, real))
	}
    @inlinable@inline(__always)@_transparent
	public init(ix: Float16, iy: Float16, iz: Float16, r: Float16) {
		self.init(vector: .init(x: ix, y: iy, z: iz, w: r))
	}
}
extension Quaternion64: @retroactive AtomicRepresentable {
    public typealias AtomicRepresentation = FloatLiteralType.SIMD4Storage
    @inlinable@inline(__always)@_transparent
	public static func encodeAtomicRepresentation(_ value: consuming Self) -> AtomicRepresentation {
        unsafeBitCast(value.vector, to: AtomicRepresentation.self)
	}
    @inlinable@inline(__always)@_transparent
	public static func decodeAtomicRepresentation(_ storage: consuming AtomicRepresentation) -> Self {
        .init(vector: unsafeBitCast(storage, to: SIMD4<FloatLiteralType>.self))
	}
}
extension Quaternion128: @retroactive ExpressibleByIntegerLiteral, @retroactive ExpressibleByFloatLiteral, @retroactive AtomicRepresentable, QuaternionNumber {
	public typealias FloatLiteralType = Float32
	public typealias AtomicRepresentation = _Atomic128BitStorage
    @inlinable@inline(__always)@_transparent
	public static func encodeAtomicRepresentation(_ value: consuming Self) -> AtomicRepresentation {
        unsafeBitCast(value.vector, to: AtomicRepresentation.self)
	}
    @inlinable@inline(__always)@_transparent
	public static func decodeAtomicRepresentation(_ storage: consuming AtomicRepresentation) -> Self {
        .init(vector: unsafeBitCast(storage, to: SIMD4<FloatLiteralType>.self))
	}
}
extension Quaternion256: @retroactive ExpressibleByIntegerLiteral, @retroactive ExpressibleByFloatLiteral, @retroactive AtomicRepresentable, QuaternionNumber {
	public typealias FloatLiteralType = Float64
    public typealias AtomicRepresentation = FloatLiteralType.SIMD4Storage
    @inlinable@inline(__always)@_transparent
	public static func encodeAtomicRepresentation(_ value: consuming Self) -> AtomicRepresentation {
        unsafeBitCast(value.vector, to: AtomicRepresentation.self)
	}
    @inlinable@inline(__always)@_transparent
	public static func decodeAtomicRepresentation(_ storage: consuming AtomicRepresentation) -> Self {
        .init(vector: unsafeBitCast(storage, to: SIMD4<FloatLiteralType>.self))
	}
}
