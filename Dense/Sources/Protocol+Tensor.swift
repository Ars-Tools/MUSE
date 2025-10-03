//
//  Protocol+Tensor.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
@_exported import typealias Layout.MemoryStrategy
@_exported import func Layout.capacity
@_exported import func Layout.concat
@_exported import func Layout.product
@_exported import func Layout.zip
public protocol Tensor<Element>: Sendable {
    associatedtype Element: BitwiseCopyable & Sendable
    associatedtype Storage: Collection & Sendable where Storage.Index: Strideable, Storage.Index.Stride == Int, Storage.Element == Element
    associatedtype S: Tensor<Element>
    associatedtype T: Tensor<Element>
    associatedtype U: Tensor<Element>
    associatedtype V: Tensor<Element>
    @inlinable var shape: Array<Int> { get }
    @inlinable var transpose: T { get }
    @inlinable subscript<P>(position: P) -> U where P: RandomAccessCollection, P.Index: Strideable, P.Index.Stride == Int, P.Element == Int { get }
    @inlinable subscript<Q>(bounds: Q) -> S where Q: RandomAccessCollection, Q.Index: Strideable, Q.Index.Stride == Int, Q.Element: RangeExpression<Int> { get }
    @inlinable func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Storage)
}
public protocol InstantTensor<Element>: Tensor where S: InstantTensor<Element>, T: InstantTensor<Element>, U: InstantTensor<Element>, V: InstantTensor<Element> {
    @inlinable func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Storage)
}
public protocol MutableTensor<Element>: InstantTensor where S: MutableTensor<Element>, T: MutableTensor<Element>, U: MutableTensor<Element>, V: MutableTensor<Element>, Storage: MutableCollection {
//    @inlinable var diagonal: V { get set }
    @inlinable subscript<P>(position: P) -> U where P: RandomAccessCollection, P.Index: Strideable, P.Index.Stride == Int, P.Element == Int { get set }
    @inlinable subscript<Q>(bounds: Q) -> S where Q: RandomAccessCollection, Q.Index: Strideable, Q.Index.Stride == Int, Q.Element: RangeExpression<Int> { get set }
}
//
extension InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Storage) {
        try evaluation(for: strategy) as (Array<Int>, @Sendable () -> Storage)
    }
}
//
@usableFromInline
enum Error: Swift.Error {
    case shapeMismatch
    case numericalError(tensor: any Tensor, status: Any, operation: String)
}
