//
//  Operators+Binary.swift
//  MUSE
//
//  Created by Kota on 9/19/R7.
//
import typealias Layout.MemoryStrategy
import func Layout.broadcast
import func Layout.narrowcast
extension Operators {
	@usableFromInline
	protocol BinaryScalar<Element>: Scalar & BinaryVector & BinaryMatrix & BinaryTensor where
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
	protocol BinaryTensor<Element>: Tensor where S: BinaryTensor, T: BinaryTensor, U: BinaryScalar, V: BinaryVector,
												 S.X == X.S, T.X == X.T, U.X == X.U, V.X == X.V,
												 S.Y == Y.S, T.Y == Y.T, U.Y == Y.U, V.Y == Y.V {
		associatedtype X: Tensor
		associatedtype Y: Tensor
		@inlinable var x: X { get }
		@inlinable var y: Y { get }
		@inlinable init(x: X, y: Y)
	}
}
extension Operators.BinaryScalar {}
extension Operators.BinaryVector {
	@usableFromInline@inline(__always)
	var count: Int {
		broadcast(x: x.count, y: y.count)
	}
	@usableFromInline@inline(__always)
	subscript(position: Int) -> U {
		.init(x: x[narrowcast(point: position, shape: x.count)],
			  y: y[narrowcast(point: position, shape: y.count)])
	}
	@usableFromInline@inline(__always)
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(x: x[narrowcast(bounds: bounds, target: count, source: x.count)],
			  y: y[narrowcast(bounds: bounds, target: count, source: y.count)])
	}
}
extension Operators.BinaryMatrix {
	@usableFromInline@inline(__always)@_transparent
	var rows: Int {
		broadcast(x: x.rows, y: y.rows)
	}
	@usableFromInline@inline(__always)@_transparent
	var cols: Int {
		broadcast(x: x.cols, y: y.cols)
	}
	@usableFromInline@inline(__always)
	subscript(row: Int, col: Int) -> U {
		.init(x: x[narrowcast(point: row, shape: x.rows), narrowcast(point: col, shape: x.cols)],
			  y: y[narrowcast(point: row, shape: y.rows), narrowcast(point: col, shape: y.cols)])
	}
	@usableFromInline@inline(__always)
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(x: x[narrowcast(point: row, shape: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
			  y: y[narrowcast(point: row, shape: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)])
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(point: col, shape: x.cols)],
			  y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(point: col, shape: y.cols)])
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
			  y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)])
	}
}
extension Operators.BinaryTensor {
	@usableFromInline@inline(__always)@_transparent
	var shape: Array<Int> {
        MemoryStrategy.default.broadcast(x: x.shape, y: y.shape)
	}
	@usableFromInline@inline(__always)
	var transpose: T {
		.init(x: x.transpose,
			  y: y.transpose)
	}
	@usableFromInline@inline(__always)
	var diagonal: V {
		.init(x: x.diagonal,
			  y: y.diagonal)
	}
	@usableFromInline@inline(__always)
	subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
        .init(x: x[MemoryStrategy.default.narrowcast(point: position, shape: x.shape)],
              y: y[MemoryStrategy.default.narrowcast(point: position, shape: y.shape)])
	}
	@usableFromInline@inline(__always)
	subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
        .init(x: x[MemoryStrategy.default.narrowcast(bounds: bounds, target: shape, source: x.shape)],
              y: y[MemoryStrategy.default.narrowcast(bounds: bounds, target: shape, source: y.shape)])
	}
}
