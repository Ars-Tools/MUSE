//
//  Arithmetic+Map.swift
//  MUSE
//
//  Created by Kota on 9/10/R7.
//
import protocol Dense.Tensor
import typealias Layout.MemoryStrategy
extension Arithmetic {
	@usableFromInline
	@frozen enum MAP {
		@usableFromInline
		@frozen struct Vector<Element: SparseScalar<Element> & Numeric, Source: SparseVector> {
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias S = Vector<Element, Source.S>
			@usableFromInline typealias U = Element
			@usableFromInline let source: Source
			@usableFromInline let transform: @Sendable (Source.Element) -> Element
		}
		@usableFromInline
		@frozen struct Matrix<Element: SparseScalar<Element> & Numeric, Source: SparseMatrix> {
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias S = Matrix<Element, Source.S>
			@usableFromInline typealias T = Matrix<Element, Source.T>
			@usableFromInline typealias V = Vector<Element, Source.V>
			@usableFromInline typealias U = Element
			@usableFromInline let source: Source
			@usableFromInline let transform: @Sendable (Source.Element) -> Element
		}
	}
}
extension Arithmetic.MAP.Vector: SparseVector {
	@inlinable
	var count: Int {
		source.count
	}
	@inlinable
	subscript(position: Int) -> Element {
		transform(source[position])
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(source: source[bounds], transform: transform)
	}
	@inlinable
	var coo: LazyMapSequence<Source.COO, (Int, Element)> {
		source.coo.lazy.map { ($0, transform($1)) }
	}
}
extension Arithmetic.MAP.Matrix: SparseMatrix {
	@inlinable
	var rows: Int {
		source.rows
	}
	@inlinable
	var cols: Int {
		source.cols
	}
	@usableFromInline
	var transpose: T {
		.init(source: source.transpose, transform: transform)
	}
	@usableFromInline
	var diagonal: V {
		.init(source: source.diagonal, transform: transform)
	}
	@inlinable
	subscript(row: Int, col: Int) -> Element {
		transform(source[row, col])
	}
	@usableFromInline
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(source: source[row, col], transform: transform)
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(source: source[row, col], transform: transform)
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(source: source[row, col], transform: transform)
	}
	@inlinable
	func lil(for layout: MemoryStrategy) -> (MemoryStrategy, Array<LazyMapSequence<Source.LIL.Element, (Int, Element)>>) {
		switch source.lil(for: layout) {
		case (let layout, let lil):
			(layout, lil.map {
				$0.lazy.map { ($0, transform($1)) }
			})
		}
	}
}
public prefix func-<Element: SignedNumeric>(_ source: some SparseVector<Element>) -> some SparseVector<Element> {
	Arithmetic.MAP.Vector(source: source) { -$0 }
}
public prefix func-<Element: SignedNumeric>(_ source: some SparseMatrix<Element>) -> some SparseMatrix<Element> {
	Arithmetic.MAP.Matrix(source: source) { -$0 }
}
