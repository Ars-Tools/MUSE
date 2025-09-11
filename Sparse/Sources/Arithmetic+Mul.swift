//
//  Arithmetic+Mul.swift
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
@frozen struct MulVector<Element, LHS: SparseVector<Element>, RHS: SparseVector<Element>> {
	@usableFromInline let lhs: LHS
	@usableFromInline let rhs: RHS
}
extension MulVector: SparseVector {
	@usableFromInline typealias R = Array<Element>
	@usableFromInline typealias U = Element
	@inlinable
	var count: Int {
		broadcast(x: lhs.count, y: rhs.count)
	}
	@inlinable
	subscript(position: Int) -> Element {
		lhs[narrowcast(point: position, shape: lhs.count)] *
		rhs[narrowcast(point: position, shape: rhs.count)]
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> MulVector<Element, LHS.S, RHS.S> {
		.init(lhs: lhs[narrowcast(bounds: bounds, target: count, source: lhs.count)],
			  rhs: rhs[narrowcast(bounds: bounds, target: count, source: rhs.count)])
	}
	@inlinable
	var coo: some Sequence<(Int, Element)> {
		Dictionary<Int, Element>(uniqueKeysWithValues: lhs.coo) *
		Dictionary<Int, Element>(uniqueKeysWithValues: rhs.coo)
	}
}
@usableFromInline
@frozen struct MulMatrix<Element: Numeric, LHS: SparseMatrix<Element>, RHS: SparseMatrix<Element>> {
	@usableFromInline let lhs: LHS
	@usableFromInline let rhs: RHS
}
extension MulMatrix: SparseMatrix {
	@usableFromInline typealias R = Array<Element>
	@usableFromInline typealias S = MulMatrix<Element, LHS.S, RHS.S>
	@usableFromInline typealias T = MulMatrix<Element, LHS.T, RHS.T>
	@usableFromInline typealias U = Element
	@usableFromInline typealias V = MulVector<Element, LHS.V, RHS.V>
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
		lhs[narrowcast(point: row, shape: lhs.rows), narrowcast(point: col, shape: lhs.cols)] *
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
	func lil(for layout: MemoryStrategy) -> (MemoryStrategy, Array<LazyMapSequence<LazyFilterSequence<LazyMapSequence<Set<Int>, Optional<(Int, Element)>>>, (Int, Element)>>) {
		switch (layout, lhs.lil(for: layout), rhs.lil(for: layout)) {
		case (.columnMajor, (.columnMajor, let l), (.columnMajor, let r)), (.rowMajor, (.columnMajor, let l), (.columnMajor, let r)):
			(.columnMajor, zip(
				`repeat`(lil: l, count: (cols / lhs.cols, rows / lhs.rows)),
				`repeat`(lil: r, count: (cols / rhs.cols, rows / rhs.rows))
			).lazy.map(*))
		case (.columnMajor, (.rowMajor, let l), (.rowMajor, let r)), (.rowMajor, (.rowMajor, let l), (.rowMajor, let r)):
			(.rowMajor, zip(
				`repeat`(lil: l, count: (rows / lhs.rows, cols / lhs.cols)),
				`repeat`(lil: r, count: (rows / rhs.rows, cols / rhs.cols))
			).lazy.map(*))
		case (.columnMajor, (.columnMajor, let l), (.rowMajor, let r)):
			(.columnMajor, zip(
				`repeat`(lil: Sparse.transpose(lil: r, for: rhs.cols), count: (cols / rhs.cols, rows / rhs.rows)),
				`repeat`(lil: l, count: (cols / lhs.cols, rows / lhs.rows))
			).lazy.map(*))
		case (.rowMajor, (.rowMajor, let l), (.columnMajor, let r)):
			(.rowMajor, zip(
				`repeat`(lil: Sparse.transpose(lil: r, for: rhs.rows), count: (rows / rhs.rows, cols / rhs.cols)),
				`repeat`(lil: l, count: (rows / lhs.rows, cols / lhs.cols))
			).lazy.map(*))
		case (.columnMajor, (.rowMajor, let l), (.columnMajor, let r)):
			(.columnMajor, zip(
				`repeat`(lil: Sparse.transpose(lil: l, for: lhs.cols), count: (cols / lhs.cols, rows / lhs.rows)),
				`repeat`(lil: r, count: (cols / rhs.cols, rows / rhs.rows))
			).lazy.map(*))
		case (.rowMajor, (.columnMajor, let l), (.rowMajor, let r)):
			(.rowMajor, zip(
				`repeat`(lil: Sparse.transpose(lil: l, for: lhs.rows), count: (rows / lhs.rows, cols / lhs.cols)),
				`repeat`(lil: r, count: (rows / rhs.rows, cols / rhs.cols))
			).lazy.map(*))
		}
	}
}
public func*<Element: Numeric>(lhs: some SparseVector<Element>, rhs: some SparseVector<Element>) -> some SparseVector<Element> {
	MulVector(lhs: lhs, rhs: rhs)
}
public func*<Element: Numeric>(lhs: some SparseMatrix<Element>, rhs: some SparseMatrix<Element>) -> some SparseMatrix<Element> {
	MulMatrix(lhs: lhs, rhs: rhs)
}
