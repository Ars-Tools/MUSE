//
//  Protocol+Vector.swift
//  MUSE
//
//  Created by Kota on 9/25/25.
//
import typealias Layout.MemoryStrategy
public protocol Vector<Element>: ElasticTensor where S: Vector<Element>, T: Vector<Element>, U: Scalar<Element>, V: Vector<Element> {
    var count: Int { get }
    subscript(position: Int) -> U { get }
    subscript(bounds: some RangeExpression<Int>) -> S { get }
}
public protocol MutableVector<Element>: MutableTensor & Vector where S: MutableVector<Element>, T: MutableVector<Element>, U: MutableScalar<Element>, V: MutableVector<Element> {
    subscript(position: Int) -> U { get set }
    subscript(bounds: some RangeExpression<Int>) -> S { get set }
}
extension Vector {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> {
        .init(arrayLiteral: count).filter { $0 != .zero }
    }
    @inlinable@inline(__always)@_transparent
    public var transpose: Self {
        self
    }
    @inlinable@inline(__always)@_transparent
    public var diagonal: Self {
        self
    }
    @inlinable@inline(__always)
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        switch MemoryStrategy.default {
        case.rowMajor:
            self[position.last ?? .zero]
        case.columnMajor:
            self[position.first ?? .zero]
        }
    }
    @inlinable@inline(__always)
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        switch MemoryStrategy.default {
        case.rowMajor:
            self[bounds.last.map { $0.relative(to: 0..<count) } ?? 0..<count]
        case.columnMajor:
            self[bounds.first.map { $0.relative(to: 0..<count) } ?? 0..<count]
        }
    }
}
extension MutableVector {
    @inlinable@inline(__always)
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        _read {
            switch MemoryStrategy.default {
            case.rowMajor:
                yield self[position.last ?? .zero]
            case.columnMajor:
                yield self[position.first ?? .zero]
            }
        }
        _modify {
            switch MemoryStrategy.default {
            case.rowMajor:
                yield &self[position.last ?? .zero]
            case.columnMajor:
                yield &self[position.first ?? .zero]
            }
        }
    }
    @inlinable@inline(__always)
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        _read {
            switch MemoryStrategy.default {
            case.rowMajor:
                yield self[bounds.last.map { $0.relative(to: 0..<count) } ?? 0..<count]
            case.columnMajor:
                yield self[bounds.first.map { $0.relative(to: 0..<count) } ?? 0..<count]
            }
        }
        _modify {
            switch MemoryStrategy.default {
            case.rowMajor:
                yield &self[bounds.last.map { $0.relative(to: 0..<count) } ?? 0..<count]
            case.columnMajor:
                yield &self[bounds.first.map { $0.relative(to: 0..<count) } ?? 0..<count]
            }
        }
    }
}
