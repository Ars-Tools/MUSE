//
//  Misc.swift
//  MUSE
//
//  Created by Kota on 9/17/R7.
//
import protocol Accelerate.AccelerateBuffer
import protocol Accelerate.AccelerateMutableBuffer
import typealias Numerics.Complex64
import typealias Numerics.Complex128
import typealias Layout.MemoryStrategy
import func Layout.capacity
@inlinable@inline(__always)@_transparent
func withUnsafePointer<X: Storage, E, R>(_ x: X, with body: (UnsafePointer<X.Element>) throws (E) -> R) rethrows -> R {
	try x.withUnsafeBufferPointer { x in
		try body(x.baseAddress.unsafelyUnwrapped)
	}
}
@inlinable@inline(__always)@_transparent
func withUnsafePointer<X: Storage, Y: Storage, E, R>(_ x: X, _ y: Y, with body: (UnsafePointer<X.Element>, UnsafePointer<Y.Element>) throws (E) -> R) rethrows -> R {
	try x.withUnsafeBufferPointer { x in
		try y.withUnsafeBufferPointer { y in
			try body(x.baseAddress.unsafelyUnwrapped, y.baseAddress.unsafelyUnwrapped)
		}
	}
}
@inlinable@inline(__always)@_transparent
func withUnsafePointer<X: Storage, Y: Storage, Z: Storage, E, R>(_ x: X, _ y: Y, _ z: Z, with body: (UnsafePointer<X.Element>, UnsafePointer<Y.Element>, UnsafePointer<Z.Element>) throws (E) -> R) rethrows -> R {
	try x.withUnsafeBufferPointer { x in
		try y.withUnsafeBufferPointer { y in
			try z.withUnsafeBufferPointer { z in
				try body(x.baseAddress.unsafelyUnwrapped, y.baseAddress.unsafelyUnwrapped, z.baseAddress.unsafelyUnwrapped)
			}
		}
	}
}
@usableFromInline
enum Error: Swift.Error {
	case invalidShape(_ tensor: any Dense.Tensor)
    case unmatchShape(operation: String, lhs: Array<Int>, rhs: Array<Int>)
	case numericalError(tensor: any Dense.Tensor, status: Any & Sendable, operation: String)
}
