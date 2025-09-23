//
//  Basic+Slice.swift
//  MUSE
//
//  Created by Kota on 9/22/25.
//
import typealias Layout.MemoryStrategy
import func Layout.offset
import func Layout.capacity
extension Basic {
    @usableFromInline
    struct Slice<Source: Tensor<Element>> {
        @usableFromInline typealias R = Source.R.SubSequence
        @usableFromInline typealias S = Self
        @usableFromInline typealias T = Slice<Source.T>
        @usableFromInline typealias U = Source.U
        @usableFromInline typealias V = Slice<Source.V>
        @usableFromInline let source: Source
        @usableFromInline let order: MemoryStrategy
        @usableFromInline let slice: Array<Range<Int>>
    }
}
extension Basic.Slice: Scalar where Source: Scalar {
    
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
                  slice: slice.suffix(1).map(bounds.relative(to:)))
        case.columnMajor:
            .init(source: source,
                  order: .columnMajor,
                  slice: slice.prefix(1).map(bounds.relative(to:)))
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
        source[row + slice.first.unsafelyUnwrapped.lowerBound,
               col + slice.last.unsafelyUnwrapped.lowerBound]
    }
    @usableFromInline
    subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .init(source: source[row, 0...],
              order: order,
              slice: slice.suffix(1).map(col.relative(to:)))
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .init(source: source[0..., col],
              order: order,
              slice: slice.prefix(1).map(row.relative(to:)))
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        .init(source: source,
              order: order,
              slice: slice.prefix(1).map(row.relative(to:)) + slice.suffix(1).map(col.relative(to:)))
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
        source[zip(position, slice).map { $0 + $1.lowerBound }]
    }
    @usableFromInline
    subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
        switch order {
        case.rowMajor:
                .init(source: source,
                      order: .rowMajor,
                      slice: zip(bounds, slice.prefix(bounds.count)).map { $0.relative(to: $1) } + slice.dropFirst(bounds.count))
        case.columnMajor:
                .init(source: source,
                      order: .columnMajor,
                      slice: slice.dropLast(bounds.count) + zip(bounds, slice.suffix(bounds.count)).map { $0.relative(to: $1) })
        }
    }
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R) {
        switch try source.evaluation(for: strategy) {
        case (let stride, let kernel):
            let lower = offset(position: slice.map(\.lowerBound), stride: stride)
            let count = capacity(slice: slice.map(\.count), stride: stride)
            return (stride, {
                let result = await kernel()
                let lower = result.startIndex.advanced(by: lower)
                let upper = lower.advanced(by: count)
                return result[lower..<upper]
            })
        }
    }
}
extension Basic.Slice: InstantScalar where Source: InstantScalar {}
extension Basic.Slice: InstantVector where Source: InstantVector {}
extension Basic.Slice: InstantMatrix where Source: InstantMatrix {}
extension Basic.Slice: InstantTensor where Source: InstantTensor {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        switch try source.evaluation(for: strategy) {
        case (let stride, let kernel):
            let lower = offset(position: slice.map(\.lowerBound), stride: stride)
            let count = capacity(slice: slice.map(\.count), stride: stride)
            return (stride, {
                let result = kernel()
                let lower = result.startIndex.advanced(by: lower)
                let upper = lower.advanced(by: count)
                return result[lower..<upper]
            })
        }
    }
}
