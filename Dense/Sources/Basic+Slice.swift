//
//  Basic+Slice.swift
//  MUSE
//
//  Created by Kota on 10/3/25.
//
import typealias Layout.MemoryStrategy
import func Layout.offset
import func Layout.capacity
extension Basic {
    public struct Slice<Source: Tensor<Element>> {
        public typealias Storage = Source.Storage.SubSequence
        public typealias S = Self
        public typealias T = Slice<Source.T>
        public typealias U = Source.U
        public typealias V = Source.V
        @usableFromInline let source: Source
        @usableFromInline let order: MemoryStrategy
        @usableFromInline let slice: Array<Range<Int>>
    }
}
extension Basic.Slice: Scalar where Source: Scalar {
    
}
extension Basic.Slice: Vector where Source: Vector {
    @inlinable@_transparent
    var subrange: Range<Int> {
        switch order {
        case.rowMajor:
            slice.first.unsafelyUnwrapped
        case.columnMajor:
            slice.last.unsafelyUnwrapped
        }
    }
    @inlinable
    public var count: Int {
        subrange.count
    }
    public subscript(position: Int) -> U {
        source[slice.map(\.lowerBound).reduce(position, +)]
    }
    public subscript(bounds: some RangeExpression<Int>) -> S {
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
    @inlinable@_transparent
    var submatrix: (row: Range<Int>, col: Range<Int>) {
        switch order {
        case.rowMajor:
            (slice.first.unsafelyUnwrapped, slice.dropFirst().first.unsafelyUnwrapped)
        case.columnMajor:
            (slice.dropLast().last.unsafelyUnwrapped, slice.last.unsafelyUnwrapped)
        }
    }
    @inlinable
    public var rows: Int {
        submatrix.row.count
    }
    @inlinable
    public var cols: Int {
        submatrix.col.count
    }
    @inlinable
    public subscript(row: Int, col: Int) -> U {
        let (r, c) = submatrix
        return source[r.lowerBound + row, c.lowerBound + col]
    }
    public subscript(row: Int, col: some RangeExpression<Int>) -> V {
        let (r, c) = submatrix
        let row = row + r.lowerBound
        let col = col.relative(to: 0..<c.count)
        let lower = col.lowerBound + c.lowerBound
        let upper = lower + col.count
        return source[row, lower..<upper]
    }
    public subscript(row: some RangeExpression<Int>, col: Int) -> V {
        let (r, c) = submatrix
        let row = row.relative(to: 0..<r.count)
        let lower = row.lowerBound + r.lowerBound
        let upper = lower + row.count
        let col = col + c.lowerBound
        return source[lower..<upper, col]
    }
    public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        let (r, c) = submatrix
        let row = row.relative(to: 0..<r.count)
        let col = col.relative(to: 0..<c.count)
        let lower = (
            r: row.lowerBound + r.lowerBound,
            c: col.lowerBound + c.lowerBound
        )
        return.init(source: source,
                    order: order,
                    slice: [lower.r..<lower.r+row.count,
                            lower.c..<lower.c+col.count])
    }
}
extension Basic.Slice: Tensor {
    public typealias Element = Element
    @inlinable
    public var shape: Array<Int> {
        slice.map(\.count)
    }
    public var transpose: T {
        .init(source: source.transpose, order: order.transpose, slice: slice.reversed())
    }
    @inlinable
    public subscript<P>(position: P) -> Source.U where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        source[zip(position, slice).map { $0 + $1.lowerBound }]
    }
    public subscript<Q>(bounds: Q) -> Basic<Element>.Slice<Source> where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        switch order {
        case.rowMajor:
            let head = zip(bounds.prefix(slice.count), slice).map {
                let range = $0.relative(to: 0..<$1.count)
                let lower = $1.lowerBound + range.lowerBound
                let upper = lower + range.count
                return lower..<upper
            }
            let tail = slice.dropFirst(head.count)
            let append = zip(bounds.dropFirst(slice.count), source.shape.dropFirst(slice.count)).map { $0.relative(to: 0..<$1) }
            let origin = source.shape.dropFirst(max(bounds.count, slice.count)).map { 0..<$0 }
            return.init(source: source,
                        order: .rowMajor,
                        slice: head + tail + append + origin)
        case.columnMajor:
            let tail = zip(bounds.suffix(slice.count), slice).map {
                let range = $0.relative(to: 0..<$1.count)
                let lower = $1.lowerBound + range.lowerBound
                let upper = lower + range.count
                return lower..<upper
            }
            let head = slice.dropLast(tail.count)
            let prepend = zip(bounds.dropLast(slice.count), source.shape.dropLast(slice.count)).map { $0.relative(to: 0..<$1) }
            let origin = source.shape.dropLast(max(bounds.count, slice.count)).map { 0..<$0 }
            return.init(source: source,
                        order: .columnMajor,
                        slice: origin + prepend + head + tail)
        }
    }
    @inlinable
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Storage) {
        switch try source.evaluation(for: strategy) {
        case (let stride, let kernel):
            let start = offset(position: slice.map(\.lowerBound), stride: stride)
            let count = capacity(slice: slice.map(\.count), stride: stride)
            return (stride, {
                let result = await kernel()
                let lower = result.startIndex.advanced(by: start)
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
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Storage) {
        switch try source.evaluation(for: strategy) {
        case (let stride, let kernel):
            let start = offset(position: slice.map(\.lowerBound), stride: stride)
            let count = capacity(slice: slice.map(\.count), stride: stride)
            return (stride, {
                let result = kernel()
                let lower = result.startIndex.advanced(by: start)
                let upper = lower.advanced(by: count)
                return result[lower..<upper]
            })
        }
    }
}
