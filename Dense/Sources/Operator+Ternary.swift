//
//  Operator+Ternary.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import func Layout.broadcast
import func Layout.narrowcast
extension Operator {
    @usableFromInline
    protocol TernaryScalar<X, Y, Z>: Scalar & TernaryTensor where X: Scalar, Y: Scalar, Z: Scalar,
    S: TernaryScalar<X.S, Y.S, Z.S>,
    T: TernaryScalar<X.T, Y.T, Z.T>,
    U: TernaryScalar<X.U, Y.U, Z.U>,
    V: TernaryScalar<X.V, Y.V, Z.V> {}
    @usableFromInline
    protocol TernaryVector<X, Y, Z>: Vector & TernaryTensor where X: Vector, Y: Vector, Z: Vector,
    S: TernaryVector<X.S, Y.S, Z.S>,
    T: TernaryVector<X.T, Y.T, Z.T>,
    U: TernaryScalar<X.U, Y.U, Z.U>,
    V: TernaryVector<X.V, Y.V, Z.V> {}
    @usableFromInline
    protocol TernaryMatrix<X, Y, Z>: Matrix & TernaryTensor where X: Matrix, Y: Matrix, Z: Matrix,
    S: TernaryMatrix<X.S, Y.S, Z.S>,
    T: TernaryMatrix<X.T, Y.T, Z.T>,
    U: TernaryScalar<X.U, Y.U, Z.U>,
    V: TernaryVector<X.V, Y.V, Z.V> {}
    @usableFromInline
    protocol TernaryTensor<X, Y, Z>: Tensor where
    S: TernaryTensor<X.S, Y.S, Z.S>,
    T: TernaryTensor<X.T, Y.T, Z.T>,
    U: TernaryTensor<X.U, Y.U, Z.U>,
    V: TernaryTensor<X.V, Y.V, Z.V> {
        associatedtype X: Tensor
        associatedtype Y: Tensor
        associatedtype Z: Tensor
        @inlinable var order: MemoryStrategy { get }
        @inlinable var x: X { get }
        @inlinable var y: Y { get }
        @inlinable var z: Z { get }
        @inlinable init(order: MemoryStrategy, x: X, y: Y, z: Z)
    }
}
extension Operator.TernaryScalar {
    
}
extension Operator.TernaryVector {
    @inlinable@_transparent
    public var count: Int {
        broadcast(x: x.count, y: y.count, z: z.count)
    }
    @inlinable
    public subscript(position: Int) -> U {
        .init(order: order,
              x: x[narrowcast(point: position, shape: x.count)],
              y: y[narrowcast(point: position, shape: y.count)],
              z: z[narrowcast(point: position, shape: z.count)])
    }
    @inlinable
    public subscript(bounds: some RangeExpression<Int>) -> S {
        .init(order: order,
              x: x[narrowcast(bounds: bounds, target: count, source: x.count)],
              y: y[narrowcast(bounds: bounds, target: count, source: y.count)],
              z: z[narrowcast(bounds: bounds, target: count, source: z.count)])
    }
}
extension Operator.TernaryMatrix {
    @inlinable
    public var rows: Int {
        broadcast(x: x.rows, y: y.rows, z: z.rows)
    }
    @inlinable
    public var cols: Int {
        broadcast(x: x.cols, y: y.cols, z: y.cols)
    }
    @inlinable
    public subscript(row: Int, col: Int) -> U {
        .init(order: order,
              x: x[narrowcast(point: row, shape: x.rows), narrowcast(point: col, shape: x.cols)],
              y: y[narrowcast(point: row, shape: y.rows), narrowcast(point: col, shape: y.cols)],
              z: z[narrowcast(point: row, shape: z.rows), narrowcast(point: col, shape: z.cols)])
    }
    @inlinable
    public subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .init(order: order,
              x: x[narrowcast(point: row, shape: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
              y: y[narrowcast(point: row, shape: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)],
              z: z[narrowcast(point: row, shape: z.rows), narrowcast(bounds: col, target: cols, source: z.cols)])
    }
    @inlinable
    public subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .init(order: order,
              x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(point: col, shape: x.cols)],
              y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(point: col, shape: y.cols)],
              z: z[narrowcast(bounds: row, target: rows, source: z.rows), narrowcast(point: col, shape: z.cols)])
    }
    @inlinable
    public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        .init(order: order,
              x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
              y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)],
              z: z[narrowcast(bounds: row, target: rows, source: z.rows), narrowcast(bounds: col, target: cols, source: z.cols)])
    }
}
extension Operator.TernaryTensor {
    @inlinable
    public var shape: Array<Int> {
        order.broadcast(x: x.shape, y: y.shape, z: z.shape)
    }
    @inlinable
    public var transpose: T {
        .init(order: order.transpose, x: x.transpose, y: y.transpose, z: z.transpose)
    }
    @inlinable
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        .init(order: order,
              x: x[order.narrowcast(point: position, shape: x.shape)],
              y: y[order.narrowcast(point: position, shape: y.shape)],
              z: z[order.narrowcast(point: position, shape: z.shape)])
    }
    @inlinable
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        .init(order: order,
              x: x[order.narrowcast(bounds: bounds, target: shape, source: x.shape)],
              y: y[order.narrowcast(bounds: bounds, target: shape, source: y.shape)],
              z: z[order.narrowcast(bounds: bounds, target: shape, source: z.shape)])
    }
}
