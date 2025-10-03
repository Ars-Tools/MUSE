//
//  Basic+Transpose.swift
//  MUSE
//
//  Created by Kota on 10/1/25.
//
extension Basic {
    public struct Transpose<Source: Tensor<Element>> {
        public typealias Storage = Source.Storage
        public typealias S = Transpose<Source.S>
        public typealias T = Source
        public typealias U = Source.U
        public typealias V = Source.V
        @usableFromInline let source: Source
    }
}
extension Basic.Transpose: Matrix where Source: Matrix {
    public var rows: Int {
        source.cols
    }
    public var cols: Int {
        source.rows
    }
    public subscript(row: Int, col: Int) -> U {
        source[col, row]
    }
    public subscript(row: Int, col: some RangeExpression<Int>) -> V {
        source[col, row]
    }
    public subscript(row: some RangeExpression<Int>, col: Int) -> V {
        source[col, row]
    }
    public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        .init(source: source[row, col])
    }
}
extension Basic.Transpose: Tensor {
    public typealias Element = Element
    @inlinable
    public var shape: Array<Int> {
        source.shape.reversed()
    }
    @inlinable
    public var transpose: Source {
        source
    }
    @inlinable
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        let position = switch MemoryStrategy.default {
        case.rowMajor:
            source.shape.dropLast(position.count) + position
        case.columnMajor:
            position + source.shape.dropFirst(position.count)
        }
        return source[position.reversed()]
    }
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        let bounds = switch MemoryStrategy.default {
        case.rowMajor:
            source.shape.dropLast(bounds.count).map { 0..<$0 } +
            zip(bounds.reversed(), source.shape.suffix(bounds.count)).map { $0.relative(to: 0..<$1)}
        case.columnMajor:
            zip(bounds.reversed(), source.shape.prefix(bounds.count)).map { $0.relative(to: 0..<$1) } +
            source.shape.dropFirst(bounds.count).map { 0..<$0 }
        }
        return.init(source: source[bounds])
    }
    @inlinable
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Source.Storage) {
        let (layout, memory) = try source.evaluation(for: strategy.transpose)
        return (layout.reversed(), memory)
    }
}
extension Basic.Transpose: InstantTensor where Source: InstantTensor {
    @inlinable
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Source.Storage) {
        let (layout, memory) = try source.evaluation(for: strategy.transpose)
        return (layout.reversed(), memory)
    }
}
