//
//  Basic+Slice.swift
//  MUSE
//
//  Created by Kota on 9/22/25.
//
import typealias Layout.MemoryStrategy
extension Basic {
    @usableFromInline
    struct Slice<Source: Tensor<Element>> {
        @usableFromInline typealias R = Source.R
        @usableFromInline typealias S = Self
        @usableFromInline typealias T = Slice<Source.T>
        @usableFromInline typealias U = Source.U
        @usableFromInline typealias V = Slice<Source.V>
        @usableFromInline let source: Source
        @usableFromInline let order: MemoryStrategy
        @usableFromInline let slice: Array<Range<Int>>
    }
}
extension Basic.Slice: Vector where Source: Vector {
    @inlinable
    var count: Int {
        switch order {
        case.rowMajor:
            slice.suffix(1).map(\.count).reduce(1, *)
        case.columnMajor:
            slice.prefix(1).map(\.count).reduce(1, *)
        }
    }
    @usableFromInline
    subscript(position: Int) -> U {
        source[slice.map(\.lowerBound).reduce(position, +)]
    }
    @usableFromInline
    subscript(bounds: some RangeExpression<Int>) -> S {
        switch order {
        case.rowMajor:
                .init(source: source,
                      order: .rowMajor,
                      slice: slice.suffix(1).map(\.count).map { bounds.relative(to: 0..<$0) })
        case.columnMajor:
                .init(source: source,
                      order: .columnMajor,
                      slice: slice.prefix(1).map(\.count).map { bounds.relative(to: 0..<$0) })
        }
    }
}
extension Basic.Slice: Matrix where Source: Matrix {
    @inlinable
    var rows: Int {
        slice.first.unsafelyUnwrapped.count
    }
    @inlinable
    var cols: Int {
        slice.last.unsafelyUnwrapped.count
    }
    @inlinable
    subscript(row: Int, col: Int) -> U {
        source[slice.first.unsafelyUnwrapped.lowerBound + row, slice.last.unsafelyUnwrapped.lowerBound + col]
    }
    @usableFromInline
    subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .init(source: source[row, col], order: order, slice: [])
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .init(source: source[row, col], order: order, slice: [])
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        .init(source: source,
              order: order,
              slice: slice.dropLast().prefix(1).map { $0.relative(to: 0..<rows) } + slice.dropFirst().suffix(1).map { $0.relative(to: 0..<cols) })
    }
}
extension Basic.Slice: Tensor {
    @inlinable
    var shape: Array<Int> {
        slice.map(\.count)
    }
    @usableFromInline
    var transpose: T {
        .init(source: source.transpose, order: order.transpose, slice: slice.reversed())
    }
    @inlinable
    var diagonal: V {
        fatalError("WIP")
    }
    @inlinable
    subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
        source[position.reversed()]
    }
    @inlinable
    subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
        fatalError()
    }
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R) {
        switch try source.evaluation(for: strategy) {
        case (let stride, let kernel):
            (stride.reversed(), kernel)
        }
    }
}
//extension Basic.Slice: InstantMatrix where Source: InstantMatrix {}
//extension Basic.Slice: InstantTensor where Source: InstantTensor {
//    @inlinable
//    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
//        switch try source.evaluation(for: strategy) {
//        case (let stride, let kernel):
//            (stride.reversed(), kernel)
//        }
//    }
//}
