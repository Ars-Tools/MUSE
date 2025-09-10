//
//  Arithmetic+Sub.swift
//  MUSE
//
//  Created by Kota on 9/10/R7.
//
import protocol Accelerate.AccelerateBuffer
import protocol Dense.MutScalar
import typealias Layout.MemoryStrategy
import func Layout.broadcast
import func Layout.narrowcast
@usableFromInline
struct SubVector<Element, LHS: SparseVector<Element>, RHS: SparseVector<Element>> {
	@usableFromInline let lhs: LHS
	@usableFromInline let rhs: RHS
}
extension SubVector: SparseVector {
	@usableFromInline typealias R = Array<Element>
	@usableFromInline typealias S = SubVector<Element, LHS.S, RHS.S>
	@usableFromInline typealias T = SubVector<Element, LHS.T, RHS.T>
	@usableFromInline typealias U = Element
	@usableFromInline typealias V = SubVector<Element, LHS.V, RHS.V>
	@inlinable
	var count: Int {
		broadcast(x: lhs.count, y: rhs.count)
	}
	@inlinable
	subscript(position: Int) -> Element {
		lhs[narrowcast(point: position, shape: lhs.count)] -
		rhs[narrowcast(point: position, shape: rhs.count)]
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[narrowcast(bounds: bounds, target: count, source: lhs.count)],
			  rhs: rhs[narrowcast(bounds: bounds, target: count, source: rhs.count)])
	}
	@inlinable
	var coo: LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Int, Element>, Optional<(Int, Element)>>>, (Int, Element)> {
		Dictionary<Int, Element>(uniqueKeysWithValues: lhs.coo) + rhs.coo
	}
}
@usableFromInline
@frozen struct SubMatrix<Element: Numeric, LHS: SparseMatrix<Element>, RHS: SparseMatrix<Element>> {
	@usableFromInline let lhs: LHS
	@usableFromInline let rhs: RHS
}
extension SubMatrix: SparseMatrix {
	@usableFromInline typealias R = Array<Element>
	@usableFromInline typealias S = SubMatrix<Element, LHS.S, RHS.S>
	@usableFromInline typealias T = SubMatrix<Element, LHS.T, RHS.T>
	@usableFromInline typealias U = Element
	@usableFromInline typealias V = SubVector<Element, LHS.V, RHS.V>
	@inlinable
	var rows: Int {
		broadcast(x: lhs.rows, y: rhs.rows)
	}
	@inlinable
	var cols: Int {
		broadcast(x: lhs.cols, y: rhs.cols)
	}
	@usableFromInline
	var diagonal: V {
		.init(lhs: lhs.diagonal, rhs: rhs.diagonal)
	}
	@usableFromInline
	var transpose: T {
		.init(lhs: lhs.transpose, rhs: rhs.transpose)
	}
	@inlinable
	subscript(row: Int, col: Int) -> Element {	
		lhs[narrowcast(point: row, shape: lhs.rows), narrowcast(point: col, shape: lhs.cols)] -
		rhs[narrowcast(point: row, shape: rhs.rows), narrowcast(point: col, shape: rhs.cols)]
	}
	@usableFromInline
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(lhs: lhs[narrowcast(point: row, shape: lhs.rows), narrowcast(bounds: col, target: cols, source: lhs.cols)],
			  rhs: rhs[narrowcast(point: row, shape: rhs.rows), narrowcast(bounds: col, target: cols, source: rhs.cols)])
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(lhs: lhs[narrowcast(bounds: row, target: rows, source: lhs.rows), narrowcast(point: col, shape: lhs.cols)],
			  rhs: rhs[narrowcast(bounds: row, target: rows, source: rhs.rows), narrowcast(point: col, shape: rhs.cols)])
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[narrowcast(bounds: row, target: rows, source: lhs.rows), narrowcast(bounds: col, target: cols, source: lhs.cols)],
			  rhs: rhs[narrowcast(bounds: row, target: rows, source: rhs.rows), narrowcast(bounds: col, target: cols, source: rhs.cols)])
	}
	@inlinable
	func lil(for layout: MemoryStrategy) -> (MemoryStrategy, Array<LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Int, Element>, Optional<(Int, Element)>>>, (Int, Element)>>) {
		switch (layout, lhs.lil(for: layout), rhs.lil(for: layout)) {
		case (.columnMajor, (.columnMajor, let lhs), (.columnMajor, let rhs)), (.rowMajor, (.columnMajor, let lhs), (.columnMajor, let rhs)):
			(.columnMajor, zip(lhs.lazy.map(Dictionary.init(uniqueKeysWithValues:)), rhs).map(+))
		case (.columnMajor, (.rowMajor, let lhs), (.rowMajor, let rhs)), (.rowMajor, (.rowMajor, let lhs), (.rowMajor, let rhs)):
			(.rowMajor, zip(lhs, rhs.lazy.map(Dictionary.init(uniqueKeysWithValues:))).map(+))
		case (.columnMajor, (.columnMajor, let lhs), (.rowMajor, let rhs)), (.rowMajor, (.rowMajor, let lhs), (.columnMajor, let rhs)):
			(layout, zip(lhs, Sparse.transpose(lil: rhs, for: lhs.count)).map(+))
		case (.columnMajor, (.rowMajor, let lhs), (.columnMajor, let rhs)), (.rowMajor, (.columnMajor, let lhs), (.rowMajor, let rhs)):
			(layout, zip(Sparse.transpose(lil: lhs, for: rhs.count), rhs).map(+))
		}
	}
}
public func-<Element: Numeric>(lhs: some SparseVector<Element>, rhs: some SparseVector<Element>) -> some SparseVector<Element> {
	SubVector(lhs: lhs, rhs: rhs)
}
public func-<Element: Numeric>(lhs: some SparseMatrix<Element>, rhs: some SparseMatrix<Element>) -> some SparseMatrix<Element> {
	SubMatrix(lhs: lhs, rhs: rhs)
}
