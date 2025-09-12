//
//  Arithmetic+DOT.swift
//  MUSE
//
//  Created by Kota on 9/12/R7.
//
import protocol Dense.Matrix
import enum Layout.MemoryStrategy
import Auxiliary
extension Arithmetic {
	@usableFromInline
	@frozen enum DOT {
		@usableFromInline
		@frozen struct Outer<Element: Numeric, LHS: SparseVector<Element>, RHS: SparseVector<Element>> {
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias T = Outer<Element, RHS.T, LHS.T>
			@usableFromInline typealias V = ANY<Element>
			@usableFromInline typealias S = Outer<Element, LHS.S, RHS.S>
			@usableFromInline typealias U = Element
			@usableFromInline let lhs: LHS
			@usableFromInline let rhs: RHS
		}
		@usableFromInline
		@frozen struct Diagonal<Element: Numeric, LHS: SparseMatrix<Element>, RHS: SparseMatrix<Element>> {
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias U = Element
			@usableFromInline typealias S = Diagonal<Element, LHS.S, RHS.S>
			@usableFromInline let lhs: LHS
			@usableFromInline let rhs: RHS
		}
		@usableFromInline
		@frozen struct MV<Element: Numeric, LHS: SparseMatrix<Element>, RHS: SparseVector<Element>> {
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias U = Element
			@usableFromInline typealias S = MV<Element, LHS.S, RHS>
			@usableFromInline let lhs: LHS
			@usableFromInline let rhs: RHS
		}
		@usableFromInline
		@frozen struct VM<Element: Numeric, LHS: SparseVector<Element>, RHS: SparseMatrix<Element>> {
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias U = Element
			@usableFromInline typealias S = VM<Element, LHS, RHS.S>
			@usableFromInline let lhs: LHS
			@usableFromInline let rhs: RHS
		}
		@usableFromInline
		@frozen struct MM<Element: Numeric, LHS: SparseMatrix<Element>, RHS: SparseMatrix<Element>> {
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias S = MM<Element, LHS.S, RHS.S>
			@usableFromInline typealias T = MM<Element, RHS.T, LHS.T>
			@usableFromInline typealias U = Element
			@usableFromInline typealias V = ANY<Element>
			@usableFromInline let lhs: LHS
			@usableFromInline let rhs: RHS
		}
	}
}
extension Arithmetic.DOT.Outer: SparseMatrix {
	@inlinable@inline(__always)
	var rows: Int { lhs.count }
	@inlinable@inline(__always)
	var cols: Int { rhs.count }
	@usableFromInline@inline(__always)
	var transpose: T {
		.init(lhs: rhs.transpose, rhs: lhs.transpose)
	}
	@usableFromInline@inline(__always)
	var diagonal: V {
		.init(core: lhs * rhs)
	}
	@inlinable@inline(__always)
	subscript(row: Int, col: Int) -> Element {
		lhs[row] * rhs[col]
	}
	@usableFromInline@inline(__always)
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(core: lhs[row] * rhs[col])
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(core: rhs[col] * lhs[row])
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[row], rhs: rhs[col])
	}
	@inlinable@inline(__always)
	func lil(for layout: MemoryStrategy) -> (MemoryStrategy, LazyMapSequence<Range<Int>, OptionalSequence<LazyMapSequence<Array<(Int, Element)>, (Int, Element)>>>) {
		switch layout {
		case.rowMajor:
			let l = Dictionary(uniqueKeysWithValues: lhs.coo)
			let r = Array(rhs.coo)
			return (.rowMajor, (0..<lhs.count).lazy.map {
				OptionalSequence(rawValue: l[$0].map { l in r.lazy.map { ($0, l * $1) } })
			})
		case.columnMajor:
			let l = Array(lhs.coo)
			let r = Dictionary(uniqueKeysWithValues: rhs.coo)
			return (.columnMajor, (0..<rhs.count).lazy.map {
				OptionalSequence(rawValue: r[$0].map { r in l.lazy.map { ($0, $1 * r) } })
			})
		}
	}
}
extension Arithmetic.DOT.Diagonal: SparseVector {
	@inlinable@inline(__always)
	var count: Int { min(lhs.rows, rhs.cols) }
	@inlinable@inline(__always)
	subscript(position: Int) -> Element {
		lhs[position, 0...] • rhs[0..., position]
	}
	@usableFromInline@inline(__always)
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[bounds, 0...], rhs: rhs[0..., bounds])
	}
	@inlinable@inline(__always)
	var coo: Array<(Int, Element)> {
		switch (lhs.lil(for: .rowMajor), rhs.lil(for: .columnMajor)) {
		case ((.rowMajor, let lhs), (.columnMajor, let rhs)):
			return zip(lhs, rhs).enumerated().compactMap {
				switch dot(lhs: $1.0, rhs: $1.1) {
				case.zero:
					.none
				case let value:
					.some(($0, value))
				}
			}
		case ((.columnMajor, let lhs), (.rowMajor, let rhs)):
			return zip(lhs, rhs).reduce(into: Dictionary<Int, Element>()) {
				let lhs = Dictionary(uniqueKeysWithValues: $1.0)
				$0.merge($1.1.compactMap {
					switch lhs[$0, default: .zero] * $1 {
					case.zero:
						.none
					case let v:
						.some(($0, v))
					}
				}, uniquingKeysWith: +)
			}.compactMap {
				$1 == .zero ? .none : .some(($0, $1))
			}
		case ((.columnMajor, let lhs), (.columnMajor, let rhs)):
			let lhs = lhs.map(Dictionary.init(uniqueKeysWithValues:))
			return rhs.enumerated().compactMap { idx, rhs in
				switch rhs.reduce(Element.zero, { $0 + lhs[$1.0][idx, default: .zero] * $1.1 }) {
				case.zero:
					.none
				case let value:
					.some((idx, value))
				}
			}
		case ((.rowMajor, let lhs), (.rowMajor, let rhs)):
			let rhs = rhs.map(Dictionary.init(uniqueKeysWithValues:))
			return lhs.enumerated().compactMap { idx, lhs in
				switch lhs.reduce(Element.zero, { $0 + rhs[$1.0][idx, default: .zero] * $1.1 }) {
				case.zero:
					.none
				case let value:
					.some((idx, value))
				}
			}
		}
	}
}
extension Arithmetic.DOT.MV: SparseVector {
	@inlinable@inline(__always)
	var count: Int {
		lhs.rows
	}
	@inlinable@inline(__always)
	subscript(position: Int) -> Element {
		lhs[position, 0...] • rhs
	}
	@usableFromInline@inline(__always)
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[bounds, 0...], rhs: rhs)
	}
	@inlinable@inline(__always)
	var coo: Array<(Int, Element)> {
		switch lhs.lil(for: .columnMajor) {
		case (.columnMajor, let lhs):
			return rhs.coo.reduce(into: Dictionary<Int, Element>()) { a, x in
				a.merge(lhs[x.0].lazy.map { ($0, $1 * x.1) }, uniquingKeysWith: +)
			}.compactMap {
				$1 == .zero ? .none : .some(($0, $1))
			}
		case (.rowMajor, let lhs):
			let rhs = Dictionary(uniqueKeysWithValues: rhs.coo)
			return lhs.enumerated().compactMap {
				let a = (Dictionary(uniqueKeysWithValues: $1) * rhs).reduce(0 as Element) { $0 + $1.1 }
				return a == .zero ? .none : .some(($0, a))
			}
		}
	}
}
extension Arithmetic.DOT.VM: SparseVector {
	@inlinable@inline(__always)
	var count: Int { rhs.cols }
	@inlinable@inline(__always)
	subscript(position: Int) -> Element {
		lhs • rhs[0..., position]
	}
	@usableFromInline@inline(__always)
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(lhs: lhs, rhs: rhs[0..., bounds])
	}
	@inlinable@inline(__always)
	var coo: Array<(Int, Element)> {
		switch rhs.lil(for: .columnMajor) {
		case (.columnMajor, let rhs):
			let lhs = Dictionary(uniqueKeysWithValues: lhs.coo)
			return rhs.enumerated().compactMap {
				let a = (lhs * Dictionary(uniqueKeysWithValues: $1)).reduce(0 as Element) { $0 + $1.1 }
				return a == .zero ? .none : .some(($0, a))
			}
		case (.rowMajor, let rhs):
			return lhs.coo.reduce(into: Dictionary<Int, Element>()) { a, x in
				a.merge(rhs[x.0].lazy.map { ($0, $1 * x.1) }, uniquingKeysWith: +)
			}.compactMap {
				$1 == .zero ? .none : .some(($0, $1))
			}
		}
	}
}
extension Arithmetic.DOT.MM: SparseMatrix {
	@inlinable@inline(__always)
	var rows: Int { lhs.rows }
	@inlinable@inline(__always)
	var cols: Int { rhs.cols }
	@usableFromInline@inline(__always)
	var diagonal: V {
		.init(core: Arithmetic.DOT.Diagonal(lhs: lhs, rhs: rhs))
	}
	@usableFromInline@inline(__always)
	var transpose: T {
		.init(lhs: rhs.transpose, rhs: lhs.transpose)
	}
	@inlinable@inline(__always)
	subscript(row: Int, col: Int) -> Element {
		lhs[row, 0...] • rhs[0..., col]
	}
	@usableFromInline@inline(__always)
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(core: Arithmetic.DOT.VM(lhs: lhs[row, 0...], rhs: rhs[0..., col]))
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(core: Arithmetic.DOT.MV(lhs: lhs[row, 0...], rhs: rhs[0..., col]))
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[row, 0...], rhs: rhs[0..., col])
	}
	@inlinable@inline(__always)
	func lil(for strategy: MemoryStrategy) -> (MemoryStrategy, Array<LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Int, Element>, Optional<(Int, Element)>>>, (Int, Element)>>) {
		switch (strategy, lhs.lil(for: strategy), rhs.lil(for: strategy)) {
		case(.columnMajor, (.columnMajor, let lhs), (.columnMajor, let rhs)), (.rowMajor, (.columnMajor, let lhs), (.columnMajor, let rhs)):
			return (.columnMajor, rhs.parallelMap {
				unpack($0.reduce(into: Dictionary<Int, Element>()) { a, x in a.merge(lhs[x.0].lazy.map { ($0, $1 * x.1) }, uniquingKeysWith: +)})
			})
		case(.rowMajor, (.rowMajor, let lhs), (.rowMajor, let rhs)), (.columnMajor, (.rowMajor, let lhs), (.rowMajor, let rhs)):
			return (.rowMajor, lhs.parallelMap {
				unpack($0.reduce(into: Dictionary<Int, Element>()) { a, x in a.merge(rhs[x.0].lazy.map { ($0, $1 * x.1) }, uniquingKeysWith: +)})
			})
		case(.columnMajor, (.rowMajor, let lhs), (.columnMajor, let rhs)):
			let lhs = Sparse.transpose(lil: lhs, for: rhs.count)
			return (.columnMajor, rhs.parallelMap {
				unpack($0.reduce(into: Dictionary<Int, Element>()) { a, x in a.merge(lhs[x.0].lazy.map { ($0, $1 * x.1) }, uniquingKeysWith: +)})
			})
		case(.rowMajor, (.rowMajor, let lhs), (.columnMajor, let rhs)):
			let rhs = Sparse.transpose(lil: rhs, for: lhs.count)
			return (.rowMajor, lhs.parallelMap {
				unpack($0.reduce(into: Dictionary<Int, Element>()) { a, x in a.merge(rhs[x.0].lazy.map { ($0, $1 * x.1) }, uniquingKeysWith: +)})
			})
		case(.columnMajor, (.columnMajor, let lhs), (.rowMajor, let rhs)):
			return (.columnMajor, zip(lhs, rhs).reduce(into: Array<Dictionary<Int, Element>>(repeating: .init(), count: cols)) { a, t in
				for (col, val) in t.1 where val != .zero {
					a[col].merge(t.0.lazy.map { (($0, $1 * val)) }, uniquingKeysWith: +)
				}
			}.map(unpack))
		case(.rowMajor, (.columnMajor, let lhs), (.rowMajor, let rhs)):
			return (.rowMajor, zip(lhs, rhs).reduce(into: Array<Dictionary<Int, Element>>(repeating: .init(), count: rows)) { a, t in
				for (row, val) in t.0 where val != .zero{
					a[row].merge(t.1.lazy.map { (($0, $1 * val)) }, uniquingKeysWith: +)
				}
			}.map(unpack))
		}
	}
}
@_disfavoredOverload
@inlinable
public func •<Element: Numeric>(_ lhs: some SparseVector<Element>, _ rhs: some SparseVector<Element>) -> Element {
	precondition(lhs.count == rhs.count, "dot length should be same")
	return dot(lhs: lhs.coo, rhs: rhs.coo)
}
public func •<Element: Numeric>(_ lhs: some SparseMatrix<Element>, _ rhs: some SparseVector<Element>) -> some SparseVector<Element> {
	precondition(lhs.cols == rhs.count, "dot length should be same")
	return Arithmetic.DOT.MV(lhs: lhs, rhs: rhs)
}
public func •<Element: Numeric>(_ lhs: some SparseVector<Element>, _ rhs: some SparseMatrix<Element>) -> some SparseVector<Element> {
	precondition(lhs.count == rhs.rows, "dot length should be same")
	return Arithmetic.DOT.VM(lhs: lhs, rhs: rhs)
}
public func •<Element: Numeric>(_ lhs: some SparseMatrix<Element>, _ rhs: some SparseMatrix<Element>) -> some SparseMatrix<Element> {
	precondition(lhs.cols == rhs.rows, "dot length should be same")
	return Arithmetic.DOT.MM(lhs: lhs, rhs: rhs)
}
public func outer<Element: Numeric>(_ lhs: some SparseVector<Element>, _ rhs: some SparseVector<Element>) -> some SparseMatrix<Element> {
	Arithmetic.DOT.Outer(lhs: lhs, rhs: rhs)
}
