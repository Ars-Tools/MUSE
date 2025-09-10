//
//  DOT+SS.swift
//  MUSE
//
//  Created by Kota on 9/9/R7.
//
import protocol Dense.MutScalar
import enum Layout.MemoryStrategy
@usableFromInline
@frozen struct ScaleVector<Element: SparseScalar<Element>, RHS: SparseVector<Element>> {
	@usableFromInline let factor: Element
	@usableFromInline let rhs: RHS
}
extension ScaleVector: SparseVector {
	@usableFromInline typealias R = Array<Element>
	@usableFromInline typealias U = Element
	@usableFromInline typealias S = ScaleVector<Element, RHS.S>
	@inlinable@inline(__always)
	var count: Int { rhs.count }
	@inlinable@inline(__always)
	subscript(position: Int) -> Element {
		factor * rhs[position]
	}
	@usableFromInline@inline(__always)
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(factor: factor, rhs: rhs[bounds])
	}
	@inlinable@inline(__always)
	var coo: LazyMapSequence<RHS.COO, (Int, Element)> {
		rhs.coo.lazy.map { [factor] in ($0, $1 * factor) }
	}
}
@usableFromInline
@frozen struct ScaleMatrix<Element: Numeric, RHS: SparseMatrix<Element>> {
	@usableFromInline let factor: Element
	@usableFromInline let rhs: RHS
}
extension ScaleMatrix: SparseMatrix {
	@usableFromInline typealias R = Array<Element>
	@usableFromInline typealias U = Element
	@usableFromInline typealias V = ScaleVector<Element, RHS.V>
	@usableFromInline typealias T = ScaleMatrix<Element, RHS.T>
	@usableFromInline typealias S = ScaleMatrix<Element, RHS.S>
	@inlinable@inline(__always)
	var rows: Int { rhs.rows }
	@inlinable@inline(__always)
	var cols: Int { rhs.cols }
	@usableFromInline@inline(__always)
	var transpose: T {
		.init(factor: factor, rhs: rhs.transpose)
	}
	@usableFromInline@inline(__always)
	var diagonal: V {
		.init(factor: factor, rhs: rhs.diagonal)
	}
	@inlinable@inline(__always)
	subscript(row: Int, col: Int) -> Element {
		factor * rhs[row, col]
	}
	@usableFromInline@inline(__always)
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(factor: factor, rhs: rhs[row, col])
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(factor: factor, rhs: rhs[row, col])
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(factor: factor, rhs: rhs[row, col])
	}
	@inlinable@inline(__always)
	func lil(for layout: MemoryStrategy) -> (MemoryStrategy, Array<LazyMapSequence<RHS.LIL.Element, (Int, Element)>>) {
		switch rhs.lil(for: layout) {
		case (let layout, let source):
			(layout, source.map { [factor] in $0.lazy.map { ($0, $1 * factor) } })
		}
	}
}
public func*<Element>(lhs: Element, rhs: some SparseVector<Element>) -> some SparseVector<Element> {
	ScaleVector(factor: lhs, rhs: rhs)
}
public func*<Element>(lhs: Element, rhs: some SparseMatrix<Element>) -> some SparseMatrix<Element> {
	ScaleMatrix(factor: lhs, rhs: rhs)
}
