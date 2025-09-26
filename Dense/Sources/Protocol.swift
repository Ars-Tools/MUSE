//
//  Protocol.swift
//  MUSE
//
//  Created by Kota on 9/25/25.
//
import protocol Accelerate.AccelerateBuffer
import protocol Accelerate.AccelerateMutableBuffer
import typealias Layout.MemoryStrategy
//public typealias Storage = Collection// & AccelerateBuffer<Element>
//public typealias MutableStorage = MutableCollection// & AccelerateMutableBuffer<Element>
public protocol Tensor<Element>: Sendable {
    associatedtype Storage: Collection & Sendable where Storage.Index: Strideable, Storage.Index.Stride == Int, Storage.Element == Element
    associatedtype Element: BitwiseCopyable & Sendable
    @inlinable var shape: Array<Int> { get }
    @inlinable func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Storage)
}
public protocol InstantTensor<Element>: Tensor {
    @inlinable func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Storage)
}
extension InstantTensor {
    @inlinable@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Storage) {
        try evaluation(for: strategy) as (Array<Int>, @Sendable () -> Storage)
    }
}
@usableFromInline
enum Error: Swift.Error {
    case numericalError(status: Any & Sendable, operation: String)
}
