//
//  Vector+VSK.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import protocol Dense.Vector
import typealias Layout.MemoryStrategy
@dynamicMemberLookup
@frozen public struct VSK {
    public typealias Element = Bool
    public typealias U = Element
    public let count: Int
    private(set) public var entry: Set<Int>
}
extension VSK {
    @inlinable
    public subscript<R>(dynamicMember lookup: KeyPath<Set<Int>, R>) -> R {
        entry[keyPath: lookup]
    }
    @inlinable
    public subscript<R>(dynamicMember lookup: ReferenceWritableKeyPath<Set<Int>, R>) -> R {
        _read {
            yield entry[keyPath: lookup]
        }
        _modify {
            yield &entry[keyPath: lookup]
        }
    }
}
extension VSK {
    public subscript(position: Int) -> Element {
        get {
            entry.contains(position)
        }
        set {
            if newValue {
                entry.remove(position)
            } else {
                entry.insert(position)
            }
        }
    }
    public subscript(bounds: some RangeExpression<Int>) -> Self {
        get {
            let bounds = bounds.relative(to: 0..<count)
            return.init(count: count, entry: .init(entry.lazy.compactMap {
                bounds.contains($0) ? .some($0 &- bounds.lowerBound) : .none
            }))
        }
        set {
            let bounds = bounds.relative(to: 0..<count)
            for index in entry.filter(bounds.contains(_:)) {
                entry.remove(index)
            }
            for index in newValue.entry {
                entry.insert(index &+ bounds.lowerBound)
            }
        }
    }
}
extension VSK: MutableSparseVector {
    public init(shape: (Int)) {
        count = shape
        entry = .init()
    }
    public init(shape: (Int), _ nonzero: some Sequence<(Int, Element)>) {
        count = shape
        entry = nonzero.reduce(into: .init()) {
            if $1.1 {
                $0.insert($1.0)
            }
        }
    }
}
extension VSK {
    public init(_ source: some SparseVector) {
        count = source.count
        entry = source.entry
    }
}
extension VSK: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Bool...) {
        count = elements.count
        entry = .init(elements.enumerated().lazy.filter(\.1).map(\.0))
    }
}
extension VSK: CustomStringConvertible {}
