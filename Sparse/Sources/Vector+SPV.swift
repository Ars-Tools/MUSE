//
//  Vector+SPV.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import typealias Layout.MemoryStrategy
@dynamicMemberLookup
@frozen public struct SPV<Element: SparseScalar<Element> & Numeric> {
    public typealias U = Element
    public let count: Int
    @usableFromInline
    private(set) var store: Dictionary<Int, Element>
}
extension SPV {
    @inlinable@inline(__always)
    public subscript<R>(dynamicMember lookup: KeyPath<Dictionary<Int, Element>, R>) -> R {
        store[keyPath: lookup]
    }
    @inlinable@inline(__always)
    public subscript<R>(dynamicMember lookup: ReferenceWritableKeyPath<Dictionary<Int, Element>, R>) -> R {
        _read {
            yield store[keyPath: lookup]
        }
        _modify {
            yield &store[keyPath: lookup]
        }
    }
}
extension SPV {
    @inlinable@inline(__always)
    public subscript(position: Int) -> Element {
        _read {
            yield store[position, default: .zero]
        }
        _modify {
            yield &store[position, default: .zero]
        }
    }
    public subscript(bounds: some RangeExpression<Int>) -> Self {
        get {
            let bounds = bounds.relative(to: 0..<count)
            return.init(count: count, store: .init(uniqueKeysWithValues: store.compactMap {
                switch ($0, $1) {
                case (bounds, let v) where v != .zero:
                    .some(($0 &- bounds.lowerBound, $1))
                default:
                    .none
                }
            }))
        }
        set {
            let bounds = bounds.relative(to: 0..<count)
            for key in store.keys.filter(bounds.contains) {
                store.removeValue(forKey: key)
            }
            for (key, value) in newValue.store where value != .zero {
                store.updateValue(value, forKey: .init(key &+ bounds.lowerBound))
            }
        }
    }
}
extension SPV: MutableSparseVector {
    @inlinable
    public var coo: some Sequence<(Int, Element)> {
        store.lazy.map(\.self)
    }
    @inlinable
    public var entry: Set<Int> {
        .init(store.keys)
    }
    @inlinable
    public init(shape: (Int), _ nonzero: some Sequence<(Int, Element)>) {
        count = shape
        store = .init(uniqueKeysWithValues: nonzero)
    }
}
extension SPV: ExpressibleByArrayLiteral {
    @_disfavoredOverload
    @inlinable
    public init(_ elements: some Collection<Element>, ε: Element.Magnitude) {
        count = elements.count
        store = .init(uniqueKeysWithValues: elements.enumerated().filter { ε < $1.magnitude })
    }
    @inlinable
    public init(arrayLiteral elements: Element...) {
        self.init(elements, ε: .zero)
    }
}
extension SPV: CustomStringConvertible {
    
}
