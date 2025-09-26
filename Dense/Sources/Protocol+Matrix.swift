//
//  Protocol+Matrix.swift
//  MUSE
//
//  Created by Kota on 9/25/25.
//
import protocol Accelerate.AccelerateBuffer
import protocol Accelerate.AccelerateMutableBuffer
import typealias Layout.MemoryStrategy
public protocol Matrix<Element>: ElasticTensor where S: Matrix<Element>, T: Matrix<Element>, U: Scalar<Element>, V: Vector<Element> {
    @inlinable var rows: Int { get }
    @inlinable var cols: Int { get }
    @inlinable subscript(row: Int, col: Int) -> U { get }
    @inlinable subscript(row: Int, col: some RangeExpression<Int>) -> V { get }
    @inlinable subscript(row: some RangeExpression<Int>, col: Int) -> V { get }
    @inlinable subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S { get }
}
public protocol MutableMatrix<Element>: MutableTensor & Matrix where S: MutableMatrix<Element>, T: MutableMatrix<Element>, U: MutableScalar<Element>, V: MutableVector<Element> {
    @inlinable subscript(row: Int, col: Int) -> U { get set }
    @inlinable subscript(row: Int, col: some RangeExpression<Int>) -> V { get set }
    @inlinable subscript(row: some RangeExpression<Int>, col: Int) -> V { get set }
    @inlinable subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S { get set }
}
extension Matrix {
    public var shape: Array<Int> {
        .init(arrayLiteral: rows, cols).filter { $0 != .zero }
    }
    @inlinable
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        switch MemoryStrategy.default {
        case.rowMajor:
            self[position.first ?? .zero,
                 position.dropFirst().first ?? .zero]
        case.columnMajor:
            self[position.dropLast().last ?? .zero,
                 position.last ?? .zero]
        }
    }
    @inlinable
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        switch MemoryStrategy.default {
        case.rowMajor:
            self[bounds.first.map { $0.relative(to: 0..<rows) } ?? 0..<rows,
                 bounds.dropFirst().first.map { $0.relative(to: 0..<cols) } ?? 0..<cols]
        case.columnMajor:
            self[bounds.dropLast().last.map { $0.relative(to: 0..<rows) } ?? 0..<rows,
                 bounds.last.map { $0.relative(to: 0..<cols) } ?? 0..<cols]
        }
    }
}
extension MutableMatrix {
    @inlinable
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        _read {
            switch MemoryStrategy.default {
            case.rowMajor:
                yield self[position.first ?? .zero,
                           position.dropFirst().first ?? .zero]
            case.columnMajor:
                yield self[position.dropLast().last ?? .zero,
                           position.last ?? .zero]
            }
        }
        _modify {
            switch MemoryStrategy.default {
            case.rowMajor:
                yield &self[position.first ?? .zero,
                            position.dropFirst().first ?? .zero]
            case.columnMajor:
                yield &self[position.dropLast().last ?? .zero,
                            position.last ?? .zero]
            }
        }
    }
    @inlinable
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        _read {
            switch MemoryStrategy.default {
            case.rowMajor:
                yield self[bounds.first.map { $0.relative(to: 0..<rows) } ?? 0..<rows,
                           bounds.dropFirst().first.map { $0.relative(to: 0..<cols) } ?? 0..<cols]
            case.columnMajor:
                yield self[bounds.dropLast().last.map { $0.relative(to: 0..<rows) } ?? 0..<rows,
                           bounds.last.map { $0.relative(to: 0..<cols) } ?? 0..<cols]
            }
        }
        _modify {
            switch MemoryStrategy.default {
            case.rowMajor:
                yield &self[bounds.first.map { $0.relative(to: 0..<rows) } ?? 0..<rows,
                            bounds.dropFirst().first.map { $0.relative(to: 0..<cols) } ?? 0..<cols]
            case.columnMajor:
                yield &self[bounds.dropLast().last.map { $0.relative(to: 0..<rows) } ?? 0..<rows,
                            bounds.last.map { $0.relative(to: 0..<cols) } ?? 0..<cols]
            }
        }
    }
}
