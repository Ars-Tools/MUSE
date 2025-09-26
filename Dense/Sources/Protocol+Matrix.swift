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
            self[position.prefix(rows == 0 ? 0 : 1).first ?? .zero,
                 position.dropFirst(rows == 0 ? 0 : 1).first ?? .zero]
        case.columnMajor:
            self[position.dropLast(cols == 0 ? 0 : 1).last ?? .zero,
                 position.suffix(cols == 0 ? 0 : 1).last ?? .zero]
        }
    }
    @inlinable
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        switch MemoryStrategy.default {
        case.rowMajor:
            self[bounds.prefix(rows == 0 ? 0 : 1).first.map { $0.relative(to: 0..<rows) } ?? 0..<0,
                 bounds.dropFirst(rows == 0 ? 0 : 1).first.map { $0.relative(to: 0..<cols) } ?? 0..<0]
        case.columnMajor:
            self[bounds.dropLast(cols == 0 ? 0 : 1).last.map { $0.relative(to: 0..<rows) } ?? 0..<0,
                 bounds.suffix(cols == 0 ? 0 : 1).last.map { $0.relative(to: 0..<cols) } ?? 0..<0]
        }
    }
}
extension MutableMatrix {
    @inlinable
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        _read {
            switch MemoryStrategy.default {
            case.rowMajor:
                yield self[position.prefix(rows == 0 ? 0 : 1).first ?? .zero,
                           position.dropFirst(rows == 0 ? 0 : 1).first ?? .zero]
            case.columnMajor:
                yield self[position.dropLast(cols == 0 ? 0 : 1).last ?? .zero,
                           position.suffix(cols == 0 ? 0 : 1).last ?? .zero]
            }
        }
        _modify {
            switch MemoryStrategy.default {
            case.rowMajor:
                yield &self[position.prefix(rows == 0 ? 0 : 1).first ?? .zero,
                            position.dropFirst(rows == 0 ? 0 : 1).first ?? .zero]
            case.columnMajor:
                yield &self[position.dropLast(cols == 0 ? 0 : 1).last ?? .zero,
                            position.suffix(cols == 0 ? 0 : 1).last ?? .zero]
            }
        }
    }
    @inlinable
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        _read {
            switch MemoryStrategy.default {
            case.rowMajor:
                yield self[bounds.prefix(rows == 0 ? 0 : 1).first.map { $0.relative(to: 0..<rows) } ?? 0..<0,
                           bounds.dropFirst(rows == 0 ? 0 : 1).first.map { $0.relative(to: 0..<cols) } ?? 0..<0]
            case.columnMajor:
                yield self[bounds.dropLast(cols == 0 ? 0 : 1).last.map { $0.relative(to: 0..<rows) } ?? 0..<0,
                           bounds.suffix(cols == 0 ? 0 : 1).last.map { $0.relative(to: 0..<cols) } ?? 0..<0]
            }
        }
        _modify {
            switch MemoryStrategy.default {
            case.rowMajor:
                yield &self[bounds.prefix(rows == 0 ? 0 : 1).first.map { $0.relative(to: 0..<rows) } ?? 0..<0,
                            bounds.dropFirst(rows == 0 ? 0 : 1).first.map { $0.relative(to: 0..<cols) } ?? 0..<0]
            case.columnMajor:
                yield &self[bounds.dropLast(cols == 0 ? 0 : 1).last.map { $0.relative(to: 0..<rows) } ?? 0..<0,
                            bounds.suffix(cols == 0 ? 0 : 1).last.map { $0.relative(to: 0..<cols) } ?? 0..<0]
            }
        }
    }
}
