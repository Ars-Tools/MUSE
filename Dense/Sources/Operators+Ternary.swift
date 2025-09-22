//
//  Operators+Ternary.swift
//  MUSE
//
//  Created by Kota on 9/19/R7.
//
import func Layout.broadcast
import func Layout.narrowcast
extension Operators {
    @usableFromInline
    protocol TernaryScalar<Element>: Scalar & TernaryVector & TernaryMatrix & TernaryTensor where
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
    protocol TernaryTensor<Element>: Tensor where
    S: TernaryTensor<Element>, T: TernaryTensor<Element>, U: TernaryScalar<Element>, V: TernaryVector<Element>,
    S.X == X.S, T.X == X.T, U.X == X.U, V.X == X.V,
    S.Y == Y.S, T.Y == Y.T, U.Y == Y.U, V.Y == Y.V,
    S.Z == Z.S, T.Z == Z.T, U.Z == Z.U, V.Z == Z.V {
        associatedtype X: Tensor
        associatedtype Y: Tensor
        associatedtype Z: Tensor
        @inlinable var x: X { get }
        @inlinable var y: Y { get }
        @inlinable var z: Z { get }
        @inlinable init(x: X, y: Y, z: Z)
    }
}
extension Operators.TernaryScalar where X: Scalar, Y: Scalar, Z: Scalar {}
extension Operators.TernaryVector where X: Vector, Y: Vector, Z: Vector {
    @inlinable@inline(__always)@_transparent
    var count: Int {
        broadcast(x: x.count, y: y.count)
    }
    @usableFromInline@inline(__always)
    subscript(position: Int) -> U {
        .init(x: x[narrowcast(point: position, shape: x.count)],
              y: y[narrowcast(point: position, shape: y.count)],
              z: z[narrowcast(point: position, shape: z.count)])
    }
    @usableFromInline@inline(__always)
    subscript(bounds: some RangeExpression<Int>) -> S {
        .init(x: x[narrowcast(bounds: bounds, target: count, source: x.count)],
              y: y[narrowcast(bounds: bounds, target: count, source: y.count)],
              z: z[narrowcast(bounds: bounds, target: count, source: z.count)])
    }
}
extension Operators.TernaryMatrix where X: Matrix, Y: Matrix, Z: Matrix {
    @inlinable@inline(__always)@_transparent
    var rows: Int {
        broadcast(x: x.rows, y: y.rows)
    }
    @inlinable@inline(__always)@_transparent
    var cols: Int {
        broadcast(x: x.cols, y: y.cols)
    }
    @usableFromInline@inline(__always)
    subscript(row: Int, col: Int) -> U {
        .init(x: x[narrowcast(point: row, shape: x.rows), narrowcast(point: col, shape: x.cols)],
              y: y[narrowcast(point: row, shape: y.rows), narrowcast(point: col, shape: y.cols)],
              z: z[narrowcast(point: row, shape: z.rows), narrowcast(point: col, shape: z.cols)])
    }
    @usableFromInline@inline(__always)
    subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .init(x: x[narrowcast(point: row, shape: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
              y: y[narrowcast(point: row, shape: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)],
              z: z[narrowcast(point: row, shape: z.rows), narrowcast(bounds: col, target: cols, source: z.cols)])
    }
    @usableFromInline@inline(__always)
    subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .init(x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(point: col, shape: x.cols)],
              y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(point: col, shape: y.cols)],
              z: z[narrowcast(bounds: row, target: rows, source: z.rows), narrowcast(point: col, shape: z.cols)])
    }
    @usableFromInline@inline(__always)
    subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        .init(x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
              y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)],
              z: z[narrowcast(bounds: row, target: rows, source: z.rows), narrowcast(bounds: col, target: cols, source: z.cols)])
    }
}
extension Operators.TernaryTensor {
    @inlinable@inline(__always)@_transparent
    var shape: Array<Int> {
        broadcast(lhs: x.shape, rhs: y.shape)
    }
    @usableFromInline
    @inline(__always)
    var transpose: T {
        .init(x: x.transpose, y: y.transpose, z: z.transpose)
    }
    @usableFromInline
    @inline(__always)
    var diagonal: V {
        .init(x: x.diagonal, y: y.diagonal, z: z.diagonal)
    }
    @usableFromInline
    @inline(__always)
    subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
        .init(x: x[narrowcast(point: position, shape: x.shape)],
              y: y[narrowcast(point: position, shape: y.shape)],
              z: z[narrowcast(point: position, shape: z.shape)])
    }
    @usableFromInline
    @inline(__always)
    subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
        .init(x: x[narrowcast(ranges: bounds, target: shape, source: x.shape)],
              y: y[narrowcast(ranges: bounds, target: shape, source: y.shape)],
              z: z[narrowcast(ranges: bounds, target: shape, source: z.shape)])
    }
}
