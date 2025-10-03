//
//  Operator+Ternary.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import typealias Layout.MemoryStrategy
import func Layout.broadcast
import func Layout.narrowcast
extension Operator {
    @usableFromInline
    protocol TernaryScalar<Element>: Scalar & TernaryTensor where
    S: TernaryScalar<Element>, T: TernaryScalar<Element>, U: TernaryScalar<Element>, V: TernaryScalar<Element>,
    X: Scalar, Y: Scalar, Z: Scalar {}
    @usableFromInline
    protocol TernaryVector<Element>: Vector & TernaryTensor where
    S: TernaryVector<Element>, T: TernaryVector<Element>, U: TernaryScalar<Element>, V: TernaryVector<Element>,
    X: Vector, Y: Vector, Z: Vector {}
    @usableFromInline
    protocol TernaryMatrix<Element>: Matrix & TernaryTensor where
    S: TernaryMatrix<Element>, T: TernaryMatrix<Element>, U: TernaryScalar<Element>, V: TernaryVector<Element>,
    X: Matrix, Y: Matrix, Z: Matrix {}
    @usableFromInline
    protocol TernaryTensor<Element>: ElasticTensor where S: TernaryTensor, T: TernaryTensor, U: TernaryTensor, V: TernaryTensor,
    S.X == X.S, T.X == X.T, U.X == X.U, V.X == X.V,
    S.Y == Y.S, T.Y == Y.T, U.Y == Y.U, V.Y == Y.V,
    S.Z == Z.S, T.Z == Z.T, U.Z == Z.U, V.Z == Z.V {
        associatedtype X: ElasticTensor
        associatedtype Y: ElasticTensor
        associatedtype Z: ElasticTensor
        @inlinable var order: MemoryStrategy { get }
        @inlinable var x: X { get }
        @inlinable var y: Y { get }
        @inlinable var z: Z { get }
        @inlinable init(order: MemoryStrategy, x: X, y: Y, z: Z)
    }
}
extension Operator.TernaryScalar {}
extension Operator.TernaryVector {
    @inlinable@inline(__always)
    public var count: Int {
        broadcast(x: x.count, y: y.count, z: z.count)
    }
    @inlinable@inline(__always)
    public subscript(position: Int) -> U {
        .init(order: order,
              x: x[narrowcast(point: position, shape: x.count)],
              y: y[narrowcast(point: position, shape: y.count)],
              z: z[narrowcast(point: position, shape: y.count)])
    }
    @inlinable@inline(__always)
    public subscript(bounds: some RangeExpression<Int>) -> S {
        .init(order: order,
              x: x[narrowcast(bounds: bounds, target: count, source: x.count)],
              y: y[narrowcast(bounds: bounds, target: count, source: y.count)],
              z: z[narrowcast(bounds: bounds, target: count, source: z.count)])
    }
}
extension Operator.TernaryMatrix {
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
              y: y[narrowcast(point: row, shape: y.rows), narrowcast(point: col, shape: y.cols)],
              z: z[narrowcast(point: row, shape: z.rows), narrowcast(point: col, shape: z.cols)])
    }
    @inlinable@inline(__always)
    public subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .init(order: order,
              x: x[narrowcast(point: row, shape: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
              y: y[narrowcast(point: row, shape: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)],
              z: z[narrowcast(point: row, shape: z.rows), narrowcast(bounds: col, target: cols, source: z.cols)])
    }
    @inlinable@inline(__always)
    public subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .init(order: order,
              x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(point: col, shape: x.cols)],
              y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(point: col, shape: y.cols)],
              z: z[narrowcast(bounds: row, target: rows, source: z.rows), narrowcast(point: col, shape: z.cols)])
    }
    @inlinable@inline(__always)
    public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        .init(order: order,
              x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
              y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)],
              z: z[narrowcast(bounds: row, target: rows, source: z.rows), narrowcast(bounds: col, target: cols, source: z.cols)])
    }
}
extension Operator.TernaryTensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> {
        order.broadcast(x: x.shape, y: y.shape, z: z.shape)
    }
    @inlinable@inline(__always)@_transparent
    public var transpose: T {
        .init(order: order.transpose, x: x.transpose, y: y.transpose, z: z.transpose)
    }
    @inlinable@inline(__always)@_transparent
    public var diagonal: V {
        .init(order: order, x: x.diagonal, y: y.diagonal, z: z.diagonal)
    }
    @inlinable@inline(__always)
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
        .init(order: order,
              x: x[order.narrowcast(point: position, shape: x.shape)],
              y: y[order.narrowcast(point: position, shape: y.shape)],
              z: z[order.narrowcast(point: position, shape: z.shape)])
    }
    @inlinable@inline(__always)
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
        .init(order: order,
              x: x[order.narrowcast(bounds: bounds, target: shape, source: x.shape)],
              y: y[order.narrowcast(bounds: bounds, target: shape, source: y.shape)],
              z: z[order.narrowcast(bounds: bounds, target: shape, source: z.shape)])
    }
}
