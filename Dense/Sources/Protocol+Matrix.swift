//
//  Protocol+Matrix.swift
//  MUSE
//
//  Created by Kota on 9/8/R7.
//
public protocol Matrix<Element>: Tensor where S: Matrix<Element>, T: Matrix<Element>, U: Scalar<Element>, V: Vector<Element> {
	@inlinable var rows: Int { get }
	@inlinable var cols: Int { get }
	@inlinable subscript(row: Int, col: Int) -> U { get }
	@inlinable subscript(row: Int, col: some RangeExpression<Int>) -> V { get }
	@inlinable subscript(row: some RangeExpression<Int>, col: Int) -> V { get }
	@inlinable subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S { get }
}
public protocol MutMatrix<Element>: MutTensor & Matrix where S: MutMatrix<Element>, T: MutMatrix<Element>, U: MutScalar<Element>, V: MutVector<Element> {
	@inlinable subscript(row: Int, col: Int) -> U { get set }
	@inlinable subscript(row: Int, col: some RangeExpression<Int>) -> V { get set }
	@inlinable subscript(row: some RangeExpression<Int>, col: Int) -> V { get set }
	@inlinable subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S { get set }
}
extension Matrix {
	@inlinable
	public var shape: Array<Int> {
		[rows, cols]
	}
	@inlinable
	public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		self[position[0], position[1]]
	}
	@inlinable
	public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		self[bounds[0], bounds[1]]
	}
}
extension MutMatrix {
	@inlinable
	public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		_read {
			yield self[position[0], position[1]]
		}
		_modify {
			yield &self[position[0], position[1]]
		}
	}
	@inlinable
	public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		_read {
			yield self[bounds[0], bounds[1]]
		}
		_modify {
			yield &self[bounds[0], bounds[1]]
		}
	}
}
