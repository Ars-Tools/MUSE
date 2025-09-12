//
//  Arithmetic.swift
//  MUSE
//
//  Created by Kota on 9/11/R7.
//
import protocol Accelerate.AccelerateBuffer
import protocol Dense.Vector
import typealias Layout.MemoryStrategy
import Auxiliary
@usableFromInline
@frozen enum Arithmetic {}
extension Arithmetic {
	@usableFromInline
	@frozen struct ANY<Element: SparseScalar<Element> & Numeric> {
		@usableFromInline let core: any SparseVector<Element>
	}
}
extension Arithmetic.ANY: SparseVector {
	@usableFromInline typealias R = Array<Element>
	@usableFromInline typealias S = Self
	@usableFromInline typealias U = Element
	@usableFromInline
	var count: Int {
		core.count
	}
	@usableFromInline
	subscript(position: Int) -> Element {
		core[position]
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(core: core[bounds])
	}
	@usableFromInline
	var coo: AnySequence<(Int, Element)> {
		.init((core.coo as any Sequence<(Int, Element)>))
	}
}
extension Arithmetic {
	@usableFromInline
	@frozen enum Scale {
		@usableFromInline
		@frozen struct Vector<Element: SparseScalar<Element> & Numeric, Source: SparseVector<Element>> {
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias S = Vector<Element, Source.S>
			@usableFromInline typealias U = Element
			@usableFromInline let factor: Element
			@usableFromInline let source: Source
		}
		@usableFromInline
		@frozen struct Matrix<Element: Numeric, Source: SparseMatrix<Element>> {
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias S = Matrix<Element, Source.S>
			@usableFromInline typealias T = Matrix<Element, Source.T>
			@usableFromInline typealias U = Element
			@usableFromInline typealias V = Vector<Element, Source.V>
			@usableFromInline let factor: Element
			@usableFromInline let source: Source
		}
	}
}
extension Arithmetic.Scale.Vector: SparseVector {
	@inlinable@inline(__always)
	var count: Int { source.count }
	@inlinable@inline(__always)
	subscript(position: Int) -> Element {
		factor * source[position]
	}
	@usableFromInline@inline(__always)
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(factor: factor, source: source[bounds])
	}
	@inlinable@inline(__always)
	var coo: LazyMapSequence<Source.COO, (Int, Element)> {
		source.coo.lazy.map { [factor] in ($0, $1 * factor) }
	}
}
extension Arithmetic.Scale.Matrix: SparseMatrix {
	@inlinable@inline(__always)
	var rows: Int { source.rows }
	@inlinable@inline(__always)
	var cols: Int { source.cols }
	@usableFromInline@inline(__always)
	var transpose: T {
		.init(factor: factor, source: source.transpose)
	}
	@usableFromInline@inline(__always)
	var diagonal: V {
		.init(factor: factor, source: source.diagonal)
	}
	@inlinable@inline(__always)
	subscript(row: Int, col: Int) -> Element {
		factor * source[row, col]
	}
	@usableFromInline@inline(__always)
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(factor: factor, source: source[row, col])
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(factor: factor, source: source[row, col])
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(factor: factor, source: source[row, col])
	}
	@inlinable@inline(__always)
	func lil(for layout: MemoryStrategy) -> (MemoryStrategy, LazyMapSequence<Source.LIL, LazyMapSequence<Source.LIL.Element, (Int, Element)>>) {
		switch source.lil(for: layout) {
		case (let layout, let source):
			(layout, source.lazy.map { [factor] in $0.lazy.map { ($0, $1 * factor) } })
		}
	}
}
public func*<Element: Numeric>(lhs: Element, rhs: some SparseVector<Element>) -> some SparseVector<Element> {
	Arithmetic.Scale.Vector(factor: lhs, source: rhs)
}
public func*<Element: Numeric>(lhs: Element, rhs: some SparseMatrix<Element>) -> some SparseMatrix<Element> {
	Arithmetic.Scale.Matrix(factor: lhs, source: rhs)
}
