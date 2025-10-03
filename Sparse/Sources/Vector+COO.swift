//
//  Vector+COO.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
extension Vector where Element: Numeric {
    @dynamicMemberLookup
    @usableFromInline@frozen struct COV<COO: Sequence<(Int, Element)> & Sendable> {
        @usableFromInline typealias U = Element
        @usableFromInline typealias V = Self
        @usableFromInline let count: Int
        @usableFromInline let coo: COO
    }
}
extension Vector.COV {
    @inlinable@inline(__always)
    public subscript<R>(dynamicMember lookup: KeyPath<COO, R>) -> R {
        coo[keyPath: lookup]
    }
    @inlinable@inline(__always)
    public subscript<R>(dynamicMember lookup: ReferenceWritableKeyPath<COO, R>) -> R {
        _read {
            yield coo[keyPath: lookup]
        }
        _modify {
            yield &coo[keyPath: lookup]
        }
    }
}
extension Vector.COV: SparseVector {
    @usableFromInline typealias Element = Element
    @inlinable
    subscript(position: Int) -> Element {
        coo.first {
            $0 == position && $1 != .zero
        }.map(\.1) ?? .zero
    }
    @usableFromInline
    subscript(bounds: some RangeExpression<Int>) -> Vector.COV<LazyMapSequence<LazyFilterSequence<LazyMapSequence<COO, Optional<(Int, Element)>>>, (Int, Element)>> {
        let bounds = bounds.relative(to: 0..<count)
        return.init(count: bounds.count, coo: coo.lazy.compactMap {
            switch ($0, $1) {
            case (bounds, .zero):
                    .none
            case (bounds, let v):
                    .some(($0 &- bounds.lowerBound, v))
            default:
                    .none
            }
        })
    }
}
