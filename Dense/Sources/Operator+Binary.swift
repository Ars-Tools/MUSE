//
//  Operator+Binary.swift
//  MUSE
//
//  Created by Kota on 9/25/25.
//
import typealias Layout.MemoryStrategy
import func Layout.broadcast
import func Layout.narrowcast
import func Layout.capacity
extension Operator {
    @usableFromInline
    protocol BinaryScalar<Element>: Scalar & BinaryTensor where
    S: BinaryScalar<Element>, T: BinaryScalar<Element>, U: BinaryScalar<Element>, V: BinaryScalar<Element>,
    X: Scalar, Y: Scalar {}
    @usableFromInline
    protocol BinaryVector<Element>: Vector & BinaryTensor where
    S: BinaryVector<Element>, T: BinaryVector<Element>, U: BinaryScalar<Element>, V: BinaryVector<Element>,
    X: Vector, Y: Vector {}
    @usableFromInline
    protocol BinaryMatrix<Element>: Matrix & BinaryTensor where
    S: BinaryMatrix<Element>, T: BinaryMatrix<Element>, U: BinaryScalar<Element>, V: BinaryVector<Element>,
    X: Matrix, Y: Matrix {}
    @usableFromInline
    protocol BinaryTensor<Element>: ElasticTensor where S: BinaryTensor, T: BinaryTensor, U: BinaryTensor, V: BinaryTensor,
                                                        S.X == X.S, T.X == X.T, U.X == X.U, V.X == X.V,
                                                        S.Y == Y.S, T.Y == Y.T, U.Y == Y.U, V.Y == Y.V {
        associatedtype X: ElasticTensor
        associatedtype Y: ElasticTensor
        @inlinable var order: MemoryStrategy { get }
        @inlinable var x: X { get }
        @inlinable var y: Y { get }
        @inlinable init(order: MemoryStrategy, x: X, y: Y)
    }
}
extension Operator.BinaryScalar {}
extension Operator.BinaryVector {
    @inlinable@inline(__always)
    public var count: Int {
        broadcast(x: x.count, y: y.count)
    }
    @inlinable@inline(__always)
    public subscript(position: Int) -> U {
        .init(order: order,
              x: x[narrowcast(point: position, shape: x.count)],
              y: y[narrowcast(point: position, shape: y.count)])
    }
    @inlinable@inline(__always)
    public subscript(bounds: some RangeExpression<Int>) -> S {
        .init(order: order,
              x: x[narrowcast(bounds: bounds, target: count, source: x.count)],
              y: y[narrowcast(bounds: bounds, target: count, source: y.count)])
    }
}
extension Operator.BinaryMatrix {
    @inlinable@inline(__always)
    public var rows: Int {
        broadcast(x: x.rows, y: y.rows)
    }
    @inlinable@inline(__always)
    public var cols: Int {
        broadcast(x: x.cols, y: y.cols)
    }
    @inlinable@inline(__always)
    public subscript(row: Int, col: Int) -> U {
        .init(order: order,
              x: x[narrowcast(point: row, shape: x.rows), narrowcast(point: col, shape: x.cols)],
              y: y[narrowcast(point: row, shape: y.rows), narrowcast(point: col, shape: y.cols)])
    }
    @inlinable@inline(__always)
    public subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .init(order: order,
              x: x[narrowcast(point: row, shape: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
              y: y[narrowcast(point: row, shape: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)])
    }
    @inlinable@inline(__always)
    public subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .init(order: order,
              x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(point: col, shape: x.cols)],
              y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(point: col, shape: y.cols)])
    }
    @inlinable@inline(__always)
    public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        .init(order: order,
              x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
              y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)])
    }
}
extension Operator.BinaryTensor {
    @inlinable@inline(__always)
    public var shape: Array<Int> {
        order.broadcast(x: x.shape, y: y.shape)
    }
    @inlinable@inline(__always)
    public var transpose: T {
        .init(order: order.transpose,
              x: x.transpose,
              y: y.transpose)
    }
    @inlinable@inline(__always)
    public var diagonal: V {
        .init(order: order,
              x: x.diagonal,
              y: y.diagonal)
    }
    @inlinable@inline(__always)
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        .init(order: order,
              x: x[order.narrowcast(point: position, shape: x.shape)],
              y: y[order.narrowcast(point: position, shape: y.shape)])
    }
    @inlinable@inline(__always)
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        .init(order: order,
              x: x[order.narrowcast(bounds: bounds, target: shape, source: x.shape)],
              y: y[order.narrowcast(bounds: bounds, target: shape, source: y.shape)])
    }
}
