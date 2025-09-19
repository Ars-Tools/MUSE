//
//  TYPECAST.swift
//  MUSE
//
//  Created by Kota on 9/18/R7.
//
import Accelerate.vecLib
import typealias Numerics.Complex64
import typealias Numerics.Complex128
@usableFromInline
enum TYPECAST {}
public protocol Float32CompatibleElement {
	static func Convert(_ A: UnsafePointer<Float32>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
	static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float32>, _ IB: Int, _ N: Int)
}
public protocol Float64CompatibleElement {
	static func Convert(_ A: UnsafePointer<Float64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
	static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float64>, _ IB: Int, _ N: Int)
}
extension Float32CompatibleElement {
	static func Convert(_ A: UnsafePointer<Complex64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		A.withMemoryRebound(to: Float32.self, capacity: 2 * IA * N) {
			Convert($0, 2 * IA, B, IB, N)
		}
	}
	static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Complex64>, _ IB: Int, _ N: Int) {
		B.withMemoryRebound(to: Float32.self, capacity: 2 * IB * N) {
			Convert(A, IA, $0, 2 * IB, N)
			vDSP_vclr($0.advanced(by: 1), 2 * IB, .init(N))
		}
	}
}
extension Float64CompatibleElement {
	static func Convert(_ A: UnsafePointer<Complex128>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		A.withMemoryRebound(to: Float64.self, capacity: 2 * IA * N) {
			Convert($0, 2 * IA, B, IB, N)
		}
	}
	static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Complex128>, _ IB: Int, _ N: Int) {
		B.withMemoryRebound(to: Float64.self, capacity: 2 * IB * N) {
			Convert(A, IA, $0, 2 * IB, N)
			vDSP_vclrD($0.advanced(by: 1), 2 * IB, .init(N))
		}
	}
}
extension Int8: Float32CompatibleElement & Float64CompatibleElement {
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Float32>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		vDSP_vfix8(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float32>, _ IB: Int, _ N: Int) {
		vDSP_vflt8(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Float64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		vDSP_vfix8D(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float64>, _ IB: Int, _ N: Int) {
		vDSP_vflt8D(A, IA, B, IB, .init(N))
	}
}
extension Int16: Float32CompatibleElement & Float64CompatibleElement {
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Float32>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		vDSP_vfix16(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float32>, _ IB: Int, _ N: Int) {
		vDSP_vflt16(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Float64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		vDSP_vfix16D(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float64>, _ IB: Int, _ N: Int) {
		vDSP_vflt16D(A, IA, B, IB, .init(N))
	}
}
extension Int32: Float32CompatibleElement & Float64CompatibleElement {
	public static func Convert(_ A: UnsafePointer<Float32>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		vDSP_vfix32(A, IA, B, IB, .init(N))
	}
	public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float32>, _ IB: Int, _ N: Int) {
		vDSP_vflt32(A, IA, B, IB, .init(N))
	}
	public static func Convert(_ A: UnsafePointer<Float64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		vDSP_vfix32D(A, IA, B, IB, .init(N))
	}
	public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float64>, _ IB: Int, _ N: Int) {
		vDSP_vflt32D(A, IA, B, IB, .init(N))
	}
}
extension UInt8: Float32CompatibleElement & Float64CompatibleElement {
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Float32>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		vDSP_vfixu8(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float32>, _ IB: Int, _ N: Int) {
		vDSP_vfltu8(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Float64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		vDSP_vfixu8D(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float64>, _ IB: Int, _ N: Int) {
		vDSP_vfltu8D(A, IA, B, IB, .init(N))
	}
}
extension UInt16: Float32CompatibleElement & Float64CompatibleElement {
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Float32>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		vDSP_vfixu16(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float32>, _ IB: Int, _ N: Int) {
		vDSP_vfltu16(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Float64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		vDSP_vfixu16D(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float64>, _ IB: Int, _ N: Int) {
		vDSP_vfltu16D(A, IA, B, IB, .init(N))
	}
}
extension UInt32: Float32CompatibleElement & Float64CompatibleElement {
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Float32>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		vDSP_vfixu32(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float32>, _ IB: Int, _ N: Int) {
		vDSP_vflt32(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Float64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		vDSP_vfix32D(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float64>, _ IB: Int, _ N: Int) {
		vDSP_vflt32D(A, IA, B, IB, .init(N))
	}
}
extension Float32: Float32CompatibleElement & Float64CompatibleElement {
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		cblas_scopy(N, A, IA, B, IB)
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Float64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		vDSP_vdpsp(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float64>, _ IB: Int, _ N: Int) {
		vDSP_vspdp(A, IA, B, IB, .init(N))
	}
}
extension Float64: Float32CompatibleElement & Float64CompatibleElement {
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Float32>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		vDSP_vspdp(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float32>, _ IB: Int, _ N: Int) {
		vDSP_vdpsp(A, IA, B, IB, .init(N))
	}
	@inlinable @inline(__always)
	public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
		cblas_dcopy(N, A, IA, B, IB)
	}
}
// MARK: General
// MARK: ->F32
public func typecast<S: Float32CompatibleElement>(_ source: some Scalar<S>, as: Float32.Type = Float32.self) -> some Scalar<Float32> {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float32CompatibleElement>(_ source: some Vector<S>, as: Float32.Type = Float32.self) -> some Vector<Float32> {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float32CompatibleElement>(_ source: some Matrix<S>, as: Float32.Type = Float32.self) -> some Matrix<Float32> {
	Operators.Unary(x: source, ƒ: S.Convert)
}
@_disfavoredOverload
public func typecast<S: Float32CompatibleElement>(_ source: some Tensor<S>, as: Float32.Type = Float32.self) -> some Tensor<Float32> {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float32CompatibleElement>(_ source: some Scalar<S>, as: Complex128.Type = Complex128.self) -> some Scalar<Complex64> {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float32CompatibleElement>(_ source: some Vector<S>, as: Complex64.Type = Complex64.self) -> some Vector<Complex64> {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float32CompatibleElement>(_ source: some Matrix<S>, as: Complex64.Type = Complex64.self) -> some Matrix<Complex64> {
	Operators.Unary(x: source, ƒ: S.Convert)
}
@_disfavoredOverload
public func typecast<S: Float32CompatibleElement>(_ source: some Tensor<S>, as: Complex64.Type = Complex64.self) -> some Tensor<Complex64> {
	Operators.Unary(x: source, ƒ: S.Convert)
}
// MARK: ->F64
public func typecast<S: Float64CompatibleElement>(_ source: some Scalar<S>, as: Float64.Type = Float64.self) -> some Scalar<Float64> {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float64CompatibleElement>(_ source: some Vector<S>, as: Float64.Type = Float64.self) -> some Vector<Float64> {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float64CompatibleElement>(_ source: some Matrix<S>, as: Float64.Type = Float64.self) -> some Matrix<Float64> {
	Operators.Unary(x: source, ƒ: S.Convert)
}
@_disfavoredOverload
public func typecast<S: Float64CompatibleElement>(_ source: some Tensor<S>, as: Float64.Type = Float64.self) -> some Tensor<Float64> {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float64CompatibleElement>(_ source: some Scalar<S>, as: Complex128.Type = Complex128.self) -> some Scalar<Complex128> {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float64CompatibleElement>(_ source: some Vector<S>, as: Complex128.Type = Complex128.self) -> some Vector<Complex128> {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float64CompatibleElement>(_ source: some Matrix<S>, as: Complex128.Type = Complex128.self) -> some Matrix<Complex128> {
	Operators.Unary(x: source, ƒ: S.Convert)
}
@_disfavoredOverload
public func typecast<S: Float64CompatibleElement>(_ source: some Tensor<S>, as: Complex128.Type = Complex128.self) -> some Tensor<Complex128> {
	Operators.Unary(x: source, ƒ: S.Convert)
}
// MARK: F32->
public func typecast<T: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Scalar<Float32>, as: T.Type = T.self) -> some Scalar<T> {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Vector<Float32>, as: T.Type = T.self) -> some Vector<T> {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Matrix<Float32>, as: T.Type = T.self) -> some Matrix<T> {
	Operators.Unary(x: source, ƒ: T.Convert)
}
@_disfavoredOverload
public func typecast<T: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Tensor<Float32>, as: T.Type = T.self) -> some Tensor<T> {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Scalar<Complex64>, as: T.Type = T.self) -> some Scalar<T> {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Vector<Complex64>, as: T.Type = T.self) -> some Vector<T> {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Matrix<Complex64>, as: T.Type = T.self) -> some Matrix<T> {
	Operators.Unary(x: source, ƒ: T.Convert)
}
@_disfavoredOverload
public func typecast<T: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Tensor<Complex64>, as: T.Type = T.self) -> some Tensor<T> {
	Operators.Unary(x: source, ƒ: T.Convert)
}
// MARK: F64->
public func typecast<T: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Scalar<Float64>, as: T.Type = T.self) -> some Scalar<T> {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Vector<Float64>, as: T.Type = T.self) -> some Vector<T> {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Matrix<Float64>, as: T.Type = T.self) -> some Matrix<T> {
	Operators.Unary(x: source, ƒ: T.Convert)
}
@_disfavoredOverload
public func typecast<T: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Tensor<Float64>, as: T.Type = T.self) -> some Tensor<T> {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Scalar<Complex128>, as: T.Type = T.self) -> some Scalar<T> {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Vector<Complex128>, as: T.Type = T.self) -> some Vector<T> {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Matrix<Complex128>, as: T.Type = T.self) -> some Matrix<T> {
	Operators.Unary(x: source, ƒ: T.Convert)
}
@_disfavoredOverload
public func typecast<T: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Tensor<Complex128>, as: T.Type = T.self) -> some Tensor<T> {
	Operators.Unary(x: source, ƒ: T.Convert)
}
// MARK: Immediate
// MARK: ->F32
public func typecast<S: Float32CompatibleElement>(_ source: some Scalar<S> & Immediate, as: Float32.Type = Float32.self) -> some Scalar<Float32> & Immediate {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float32CompatibleElement>(_ source: some Vector<S> & Immediate, as: Float32.Type = Float32.self) -> some Vector<Float32> & Immediate {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float32CompatibleElement>(_ source: some Matrix<S> & Immediate, as: Float32.Type = Float32.self) -> some Matrix<Float32> & Immediate {
	Operators.Unary(x: source, ƒ: S.Convert)
}
@_disfavoredOverload
public func typecast<S: Float32CompatibleElement>(_ source: some Tensor<S> & Immediate, as: Float32.Type = Float32.self) -> some Tensor<Float32> & Immediate {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float32CompatibleElement>(_ source: some Scalar<S> & Immediate, as: Complex128.Type = Complex128.self) -> some Scalar<Complex64> & Immediate {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float32CompatibleElement>(_ source: some Vector<S> & Immediate, as: Complex64.Type = Complex64.self) -> some Vector<Complex64> & Immediate {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float32CompatibleElement>(_ source: some Matrix<S> & Immediate, as: Complex64.Type = Complex64.self) -> some Matrix<Complex64> & Immediate {
	Operators.Unary(x: source, ƒ: S.Convert)
}
@_disfavoredOverload
public func typecast<S: Float32CompatibleElement>(_ source: some Tensor<S> & Immediate, as: Complex64.Type = Complex64.self) -> some Tensor<Complex64> & Immediate {
	Operators.Unary(x: source, ƒ: S.Convert)
}
// MARK: ->F64
public func typecast<S: Float64CompatibleElement>(_ source: some Scalar<S> & Immediate, as: Float64.Type = Float64.self) -> some Scalar<Float64> & Immediate {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float64CompatibleElement>(_ source: some Vector<S> & Immediate, as: Float64.Type = Float64.self) -> some Vector<Float64> & Immediate {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float64CompatibleElement>(_ source: some Matrix<S> & Immediate, as: Float64.Type = Float64.self) -> some Matrix<Float64> & Immediate {
	Operators.Unary(x: source, ƒ: S.Convert)
}
@_disfavoredOverload
public func typecast<S: Float64CompatibleElement>(_ source: some Tensor<S> & Immediate, as: Float64.Type = Float64.self) -> some Tensor<Float64> & Immediate {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float64CompatibleElement>(_ source: some Scalar<S> & Immediate, as: Complex128.Type = Complex128.self) -> some Scalar<Complex128> & Immediate {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float64CompatibleElement>(_ source: some Vector<S> & Immediate, as: Complex128.Type = Complex128.self) -> some Vector<Complex128> & Immediate {
	Operators.Unary(x: source, ƒ: S.Convert)
}
public func typecast<S: Float64CompatibleElement>(_ source: some Matrix<S> & Immediate, as: Complex128.Type = Complex128.self) -> some Matrix<Complex128> & Immediate {
	Operators.Unary(x: source, ƒ: S.Convert)
}
@_disfavoredOverload
public func typecast<S: Float64CompatibleElement>(_ source: some Tensor<S> & Immediate, as: Complex128.Type = Complex128.self) -> some Tensor<Complex128> & Immediate {
	Operators.Unary(x: source, ƒ: S.Convert)
}
// MARK: F32->
public func typecast<T: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Scalar<Float32> & Immediate, as: T.Type = T.self) -> some Scalar<T> & Immediate {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Vector<Float32> & Immediate, as: T.Type = T.self) -> some Vector<T> & Immediate {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Matrix<Float32> & Immediate, as: T.Type = T.self) -> some Matrix<T> & Immediate {
	Operators.Unary(x: source, ƒ: T.Convert)
}
@_disfavoredOverload
public func typecast<T: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Tensor<Float32> & Immediate, as: T.Type = T.self) -> some Tensor<T> & Immediate {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Scalar<Complex64> & Immediate, as: T.Type = T.self) -> some Scalar<T> & Immediate {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Vector<Complex64> & Immediate, as: T.Type = T.self) -> some Vector<T> & Immediate {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Matrix<Complex64> & Immediate, as: T.Type = T.self) -> some Matrix<T> & Immediate {
	Operators.Unary(x: source, ƒ: T.Convert)
}
@_disfavoredOverload
public func typecast<T: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Tensor<Complex64> & Immediate, as: T.Type = T.self) -> some Tensor<T> & Immediate {
	Operators.Unary(x: source, ƒ: T.Convert)
}
// MARK: F64->
public func typecast<T: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Scalar<Float64> & Immediate, as: T.Type = T.self) -> some Scalar<T> & Immediate {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Vector<Float64> & Immediate, as: T.Type = T.self) -> some Vector<T> & Immediate {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Matrix<Float64> & Immediate, as: T.Type = T.self) -> some Matrix<T> & Immediate {
	Operators.Unary(x: source, ƒ: T.Convert)
}
@_disfavoredOverload
public func typecast<T: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Tensor<Float64> & Immediate, as: T.Type = T.self) -> some Tensor<T> & Immediate {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Scalar<Complex128> & Immediate, as: T.Type = T.self) -> some Scalar<T> & Immediate {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Vector<Complex128> & Immediate, as: T.Type = T.self) -> some Vector<T> & Immediate {
	Operators.Unary(x: source, ƒ: T.Convert)
}
public func typecast<T: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Matrix<Complex128> & Immediate, as: T.Type = T.self) -> some Matrix<T> & Immediate {
	Operators.Unary(x: source, ƒ: T.Convert)
}
@_disfavoredOverload
public func typecast<T: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Tensor<Complex128> & Immediate, as: T.Type = T.self) -> some Tensor<T> & Immediate {
	Operators.Unary(x: source, ƒ: T.Convert)
}

