//
//  Protocol+Vector.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import typealias Layout.MemoryStrategy
import protocol Dense.InstantTensor
import protocol Dense.Vector
import protocol Dense.MutableVector
public protocol SparseVector<Element>: Vector & InstantTensor where S: SparseVector<Element>, T: SparseVector<Element>, U: SparseScalar<U>, V: SparseVector<Element> {
    associatedtype COO: Sequence where COO.Element == (Int, Element)
    @inlinable var coo: COO { get }
    @inlinable var entry: Set<Int> { get }
}
public protocol MutableSparseVector<Element>: SparseVector & MutableVector where S: MutableSparseVector<Element>, T: MutableSparseVector<Element>, U: SparseScalar<U>, V: MutableSparseVector<Element> {
    @inlinable init(shape: (Int), _ nonzero: some Sequence<(Int, Element)>)
}
extension SparseVector where Element: Numeric {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let store = coo.reduce(into: Array<Element>(repeating: .zero, count: count)) { $0[$1.0] = $1.1 }
        return ([1], {store})
    }
    @inlinable@inline(__always)@_transparent
    public var entry: Set<Int> {
        .init(coo.lazy.compactMap { $1 != .zero ? .some($0) : .none })
    }
    @inlinable@inline(__always)@_transparent
    public var description: String {
        coo.reduce(into: Array<Element>(repeating: .zero, count: count)) { $0[$1.0] = $1.1 }.description
    }
}
extension SparseVector where Element == Bool {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let store = entry.reduce(into: Array<Element>(repeating: false, count: count)) { $0[$1] = true }
        return ([1], {store})
    }
    @inlinable@inline(__always)@_transparent
    public var coo: LazyMapSequence<Set<Int>, (Int, Bool)> {
        entry.lazy.map { ($0, true) }
    }
    @inlinable@inline(__always)@_transparent
    public var description: String {
        entry.reduce(into: Array<Element>(repeating: false, count: count)) { $0[$1] = true }.description
    }
}
extension MutableSparseVector {
    @inlinable@inline(__always)@_transparent
    public init(shape: (Int)) {
        self.init(shape: shape, [])
    }
    @inlinable
    public init(_ source: some SparseVector<Element>) {
        self.init(shape: source.count, source.coo)
    }
}
