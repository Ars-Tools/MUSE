//
//  Buffer+Scalar.swift
//  MUSE
//
//  Created by Kota on 9/8/R7.
//
import protocol Accelerate.AccelerateBuffer
import protocol Accelerate.AccelerateMutableBuffer
import typealias Numerics.Complex32
import typealias Numerics.Complex64
import typealias Numerics.Complex128
import typealias Layout.MemoryStrategy
extension CollectionOfOne: @retroactive AccelerateBuffer & AccelerateMutableBuffer {
    @inlinable
    public func withUnsafeBufferPointer<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R) rethrows -> R {
        try span.withUnsafeBufferPointer(body)
    }
}
public protocol ScalarBuffer<Element>: MutableScalar<Self> & BitwiseCopyable & Sendable where R == CollectionOfOne<Self>, Element == Self {}
extension ScalarBuffer {
    @inlinable@inline(__always)
    public subscript() -> Element {
        _read {
            yield self
        }
        _modify {
            yield &self
        }
    }
    @inlinable
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> CollectionOfOne<Self>) {
        ([], {CollectionOfOne(self)})
    }
}
extension Bool: ScalarBuffer {}
extension Int: ScalarBuffer {}
extension Int8: ScalarBuffer {}
extension Int16: ScalarBuffer {}
extension Int32: ScalarBuffer {}
extension Int64: ScalarBuffer {}
extension Int128: ScalarBuffer {}
extension UInt8: ScalarBuffer {}
extension UInt16: ScalarBuffer {}
extension UInt32: ScalarBuffer {}
extension UInt64: ScalarBuffer {}
extension UInt128: ScalarBuffer {}
extension Float16: ScalarBuffer {}
extension Float32: ScalarBuffer {}
extension Float64: ScalarBuffer {}
extension Complex32: ScalarBuffer {}
extension Complex64: ScalarBuffer {}
extension Complex128: ScalarBuffer {}
