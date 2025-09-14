//
//  Axes+Size.swift
//  MUSE
//
//  Created by Kota on 9/11/R7.
//
import protocol Dense.Matrix
import typealias Layout.MemoryStrategy
@usableFromInline
@frozen struct PaddedMatrix<Source: SparseMatrix> where Source.Element: Numeric {
	@usableFromInline let source: Source
	@usableFromInline let t: Int
	@usableFromInline let b: Int
	@usableFromInline let l: Int
	@usableFromInline let r: Int
}
extension PaddedMatrix: SparseMatrix {
	@usableFromInline typealias Element = Source.Element
	@usableFromInline typealias R = Array<Element>
	@usableFromInline typealias S = PaddedMatrix<Source.S>
	@usableFromInline typealias T = PaddedMatrix<Source.T>
	@usableFromInline typealias U = Element
	@usableFromInline typealias V = COV<Element, LazyMapSequence<LazyFilterSequence<LazyMapSequence<Range<Int>, Optional<(Int, Element)>>>, (Int, Element)>>
	@usableFromInline
	var rows: Int { t + source.rows + b }
	@usableFromInline
	var cols: Int { l + source.cols + r }
	@usableFromInline
	var diagonal: V {
		.init(count: min(rows, cols), coo: (0..<min(rows, cols)).lazy.compactMap { [source] in
			switch ($0 - t, $0 - l) {
			case (0..<source.rows, 0..<source.cols):
				.some(($0, source[$0 - t, $0 - l]))
			default:
				.none
			}
		})
	}
	@usableFromInline
	var transpose: T {
		.init(source: source.transpose, t: l, b: r, l: t, r: b)
	}
	@usableFromInline
	subscript(row: Int, col: Int) -> Element {
		switch (row - t, col - l) {
		case (0..<source.rows, 0..<source.cols):
			source[row - t, col - l]
		default:
			.zero
		}
	}
	@usableFromInline
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		let row = row - t
		let col = col.relative(to: 0..<cols)
		return.init(count: col.count, coo: col.lazy.compactMap { [source] in
			switch (row, $0 - l) {
			case (0..<source.rows, 0..<source.cols):
				.some(($0, source[row, $0 - l]))
			default:
				.none
			}
		})
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		let row = row.relative(to: 0..<rows)
		let col = col - l
		return.init(count: row.count, coo: row.lazy.compactMap { [source] in
			switch ($0 - t, col) {
			case (0..<source.rows, 0..<source.cols):
				.some(($0, source[$0 - t, col]))
			default:
				.none
			}
		})
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		let row = row.relative(to: 0..<rows)
		let col = col.relative(to: 0..<cols)
		print(row, max(0, row.lowerBound - t)..<min(source.rows, row.upperBound - t), source.rows)
		print(col, max(0, col.lowerBound - l)..<min(source.cols, col.upperBound - l), source.cols)
		return.init(source: source[max(0, row.lowerBound - t)..<min(source.rows, row.upperBound - t),
								   max(0, col.lowerBound - l)..<min(source.cols, col.upperBound - l)],
					t: max(0, t - row.lowerBound),
					b: b - min(b, rows - row.upperBound),
					l: max(0, l - col.lowerBound),
					r: r - min(r, cols - col.upperBound)
		)
	}
	@usableFromInline
	func lil(for layout: MemoryStrategy) -> (MemoryStrategy, Array<Optional<LazyMapSequence<Source.LIL.Element, (Int, Element)>>>) {
		switch source.lil(for: layout) {
		case (.rowMajor, let lil):
			return (.rowMajor,
					repeatElement(.none, count: t) +
					lil.map { .some($0.lazy.map { ($0 + l, $1) }) } +
					repeatElement(.none, count: b))
		case (.columnMajor, let lil):
			return (.columnMajor,
					repeatElement(.none, count: l) +
					lil.map { .some($0.lazy.map { ($0 + t, $1) }) } +
					repeatElement(.none, count: r))
		}
	}
}
public func padding<Element: Numeric>(_ source: some SparseMatrix<Element>, rows: (Int, Int), cols: (Int, Int)) -> some SparseMatrix<Element> {
	PaddedMatrix(source: source, t: rows.0, b: rows.1, l: cols.0, r: cols.1)
}
