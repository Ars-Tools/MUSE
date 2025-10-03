//
//  Operator+Binary.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import func Layout.broadcast
import func Layout.narrowcast
extension Operator {
    @usableFromInline
    protocol BinaryScalar<X, Y>: Scalar & BinaryTensor where X: Scalar, Y: Scalar,
    S: BinaryScalar<X.S, Y.S>,
    T: BinaryScalar<X.T, Y.T>,
    U: BinaryScalar<X.U, Y.U>,
    V: BinaryScalar<X.V, Y.V> {}
    @usableFromInline
    protocol BinaryVector<X, Y>: Vector & BinaryTensor where X: Vector, Y: Vector,
    S: BinaryVector<X.S, Y.S>,
    T: BinaryVector<X.T, Y.T>,
    U: BinaryScalar<X.U, Y.U>,
    V: BinaryVector<X.V, Y.V> {}
    @usableFromInline
    protocol BinaryMatrix<X, Y>: Matrix & BinaryTensor where X: Matrix, Y: Matrix,
    S: BinaryMatrix<X.S, Y.S>,
    T: BinaryMatrix<X.T, Y.T>,
    U: BinaryScalar<X.U, Y.U>,
    V: BinaryVector<X.V, Y.V> {}
    @usableFromInline
    protocol BinaryTensor<X, Y>: Tensor where
    S: BinaryTensor<X.S, Y.S>,
    T: BinaryTensor<X.T, Y.T>,
    U: BinaryTensor<X.U, Y.U>,
    V: BinaryTensor<X.V, Y.V> {
        associatedtype X: Tensor
        associatedtype Y: Tensor
        @inlinable var order: MemoryStrategy { get }
        @inlinable var x: X { get }
        @inlinable var y: Y { get }
        @inlinable init(order: MemoryStrategy, x: X, y: Y)
    }
}
extension Operator.BinaryScalar {
    
}
extension Operator.BinaryVector {
    @inlinable@_transparent
    public var count: Int {
        broadcast(x: x.count, y: y.count)
    }
    @inlinable
    public subscript(position: Int) -> U {
        .init(order: order,
              x: x[narrowcast(point: position, shape: x.count)],
              y: y[narrowcast(point: position, shape: y.count)])
    }
    @inlinable
    public subscript(bounds: some RangeExpression<Int>) -> S {
        .init(order: order,
              x: x[narrowcast(bounds: bounds, target: count, source: x.count)],
              y: y[narrowcast(bounds: bounds, target: count, source: y.count)])
    }
}
extension Operator.BinaryMatrix {
    @inlinable
    public var rows: Int {
        broadcast(x: x.rows, y: y.rows)
    }
    @inlinable
    public var cols: Int {
        broadcast(x: x.cols, y: y.cols)
    }
    @inlinable
    public subscript(row: Int, col: Int) -> U {
        .init(order: order,
              x: x[narrowcast(point: row, shape: x.rows), narrowcast(point: col, shape: x.cols)],
              y: y[narrowcast(point: row, shape: y.rows), narrowcast(point: col, shape: y.cols)])
    }
    @inlinable
    public subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .init(order: order,
              x: x[narrowcast(point: row, shape: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
              y: y[narrowcast(point: row, shape: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)],)
    }
    @inlinable
    public subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .init(order: order,
              x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(point: col, shape: x.cols)],
              y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(point: col, shape: y.cols)])
    }
    @inlinable
    public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        .init(order: order,
              x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
              y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)])
    }
}
extension Operator.BinaryTensor {
    @inlinable
    public var shape: Array<Int> {
        order.broadcast(x: x.shape, y: y.shape)
    }
    @inlinable
    public var transpose: T {
        .init(order: order.transpose, x: x.transpose, y: y.transpose)
    }
    @inlinable
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        .init(order: order,
              x: x[order.narrowcast(point: position, shape: x.shape)],
              y: y[order.narrowcast(point: position, shape: y.shape)])
    }
    @inlinable
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        .init(order: order,
              x: x[order.narrowcast(bounds: bounds, target: shape, source: x.shape)],
              y: y[order.narrowcast(bounds: bounds, target: shape, source: y.shape)])
    }
}
