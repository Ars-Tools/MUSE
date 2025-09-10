//
//  Arithmetic+Map.swift
//  MUSE
//
//  Created by Kota on 9/10/R7.
//
import Dense
import typealias Layout.MemoryStrategy
@usableFromInline
@frozen struct MapVector<Element: SparseScalar<Element>, Source: SparseVector> {
	@usableFromInline let source: Source
	@usableFromInline let transform: @Sendable (Source.Element) -> Element
}
extension MapVector: SparseVector {
	@usableFromInline typealias R = Array<Element>
	@usableFromInline typealias S = MapVector<Element, Source.S>
	@usableFromInline typealias T = MapVector<Element, Source.T>
	@usableFromInline typealias V = MapVector<Element, Source.V>
	@usableFromInline typealias U = Element
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
	var coo: LazyMapSequence<LazyFilterSequence<LazyMapSequence<Source.COO, Optional<(Int, Element)>>>, (Int, Element)> {
		source.coo.lazy.compactMap {
			switch transform($1) {
			case.zero:
				.none
			case let value:
				.some(($0, value))
			}
		}
	}
}
@usableFromInline
@frozen struct MapMatrix<Element: SparseScalar<Element>, Source: SparseMatrix> {
	@usableFromInline let source: Source
	@usableFromInline let transform: @Sendable (Source.Element) -> Element
}
extension MapMatrix: SparseMatrix {
	@usableFromInline typealias R = Array<Element>
	@usableFromInline typealias S = MapMatrix<Element, Source.S>
	@usableFromInline typealias T = MapMatrix<Element, Source.T>
	@usableFromInline typealias V = MapVector<Element, Source.V>
	@usableFromInline typealias U = Element
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
	var diagonal: MapVector<Element, Source.V> {
		.init(source: source.diagonal, transform: transform)
	}
	@inlinable
	subscript(row: Int, col: Int) -> Element {
		transform(source[row, col])
	}
	@usableFromInline
	subscript(row: Int, col: some RangeExpression<Int>) -> MapVector<Element, Source.V> {
		.init(source: source[row, col], transform: transform)
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: Int) -> MapVector<Element, Source.V> {
		.init(source: source[row, col], transform: transform)
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> MapMatrix<Element, Source.S> {
		.init(source: source[row, col], transform: transform)
	}
	@inlinable
	func lil(for layout: MemoryStrategy) -> (MemoryStrategy, Array<LazyMapSequence<LazyFilterSequence<LazyMapSequence<Source.LIL.Element, Optional<(Int, Element)>>>, (Int, Element)>>) {
		switch source.lil(for: layout) {
		case (let layout, let lil):
			(layout, lil.map {
				$0.lazy.compactMap {
					switch transform($1) {
					case.zero:
						.none
					case let value:
						.some(($0, value))
					}
				}
			})
		}
	}
}
public prefix func-<Element: SignedNumeric>(_ source: some SparseVector<Element>) -> some SparseVector<Element> {
	MapVector(source: source) { -$0 }
}
public prefix func-<Element: SignedNumeric>(_ source: some SparseMatrix<Element>) -> some SparseMatrix<Element> {
	MapMatrix(source: source) { -$0 }
}
public func drop<Element>(_ source: some SparseVector<Element>, ε: Element.Magnitude) -> some SparseVector<Element> where Element.Magnitude: Sendable {
	MapVector(source: source) { ε < $0.magnitude ? $0 : .zero }
}
public func drop<Element>(_ source: some SparseMatrix<Element>, ε: Element.Magnitude) -> some SparseMatrix<Element> where Element.Magnitude: Sendable {
	MapMatrix(source: source) { ε < $0.magnitude ? $0 : .zero }
}
