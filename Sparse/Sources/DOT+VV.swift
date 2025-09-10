//
//  DOT+VV.swift
//  MUSE
//
//  Created by Kota on 9/10/R7.
//
import protocol Dense.MutScalar
import enum Layout.MemoryStrategy
import func Layout.product
// MARK: Outer dot
@usableFromInline
@frozen struct Outer<Element, LHS: SparseVector<Element>, RHS: SparseVector<Element>> {
	@usableFromInline let lhs: LHS
	@usableFromInline let rhs: RHS
}
extension Outer: SparseMatrix {
	@usableFromInline typealias R = Array<Element>
	@usableFromInline typealias T = Outer<Element, RHS.T, LHS.T>
	@usableFromInline typealias V = ANY<Element>
	@usableFromInline typealias S = Outer<Element, LHS.S, RHS.S>
	@usableFromInline typealias U = Element
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
		.init(core: MulVector(lhs: lhs, rhs: rhs))
	}
	@inlinable@inline(__always)
	subscript(row: Int, col: Int) -> Element {
		lhs[row] * rhs[col]
	}
	@usableFromInline@inline(__always)
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(core: ScaleVector(factor: lhs[row], rhs: rhs[col]))
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(core: ScaleVector(factor: rhs[col], rhs: lhs[row]))
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> Outer<Element, LHS.S, RHS.S> {
		.init(lhs: lhs[row], rhs: rhs[col])
	}
	@inlinable@inline(__always)
	func lil(for layout: MemoryStrategy) -> (MemoryStrategy, Array<LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Int, Element>, Optional<(Int, Element)>>>, (Int, Element)>>) {
		switch layout {
		case.rowMajor:
			(.rowMajor, product(lhs.coo, rhs.coo).reduce(into: Array<Dictionary<Int, Element>>(repeating: .init(), count: rows)) {
				$0[$1.0.0].updateValue($1.0.1 * $1.1.1, forKey: $1.1.0)
			}.map(unpack))
		case.columnMajor:
			(.columnMajor, product(rhs.coo, lhs.coo).reduce(into: Array<Dictionary<Int, Element>>(repeating: .init(), count: cols)) {
				$0[$1.0.0].updateValue($1.0.1 * $1.1.1, forKey: $1.1.0)
			}.map(unpack))
		}
	}
}
@usableFromInline
@frozen struct MV<Element, LHS: SparseMatrix<Element>, RHS: SparseVector<Element>> {
	@usableFromInline let lhs: LHS
	@usableFromInline let rhs: RHS
}
extension MV: SparseVector {
	@usableFromInline typealias R = Array<Element>
	@usableFromInline typealias U = Element
	@usableFromInline typealias S = MV<Element, LHS.S, RHS>
	@inlinable@inline(__always)
	var count: Int {
		lhs.rows
	}
	@inlinable@inline(__always)
	subscript(position: Int) -> Element {
		dot(lhs[position, 0...], rhs)
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
@usableFromInline
@frozen struct VM<Element: Numeric, LHS: SparseVector<Element>, RHS: SparseMatrix<Element>> {
	@usableFromInline let lhs: LHS
	@usableFromInline let rhs: RHS
}
extension VM: SparseVector {
	@usableFromInline typealias R = Array<Element>
	@usableFromInline typealias U = Element
	@usableFromInline typealias S = VM<Element, LHS, RHS.S>
	@inlinable@inline(__always)
	var count: Int { rhs.cols }
	@inlinable@inline(__always)
	subscript(position: Int) -> Element {
		dot(lhs, rhs[0..., position])
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
@usableFromInline
@frozen struct Diagonal<Element: Numeric, LHS: SparseMatrix<Element>, RHS: SparseMatrix<Element>> {
	@usableFromInline let lhs: LHS
	@usableFromInline let rhs: RHS
}
extension Diagonal: SparseVector {
	@usableFromInline typealias R = Array<Element>
	@usableFromInline typealias U = Element
	@usableFromInline typealias S = Diagonal<Element, LHS.S, RHS.S>
	@inlinable@inline(__always)
	var count: Int { min(lhs.rows, rhs.cols) }
	@inlinable@inline(__always)
	subscript(position: Int) -> Element {
		dot(lhs[position, 0...], rhs[0..., position])
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
					switch lhs[$0] {
					case.none,.some(.zero):
						.none
					case.some(let v):
						.some(($0, $1 * v))
					}
				}, uniquingKeysWith: +)
			}.compactMap {
				$1 == .zero ? .none : .some(($0, $1))
			}
		case ((.columnMajor, let lhs), (.columnMajor, let rhs)):
			let lhs = lhs.map(Dictionary.init(uniqueKeysWithValues:))
			return rhs.enumerated().compactMap { idx, rhs in
				switch rhs.reduce(0 as Element, { $0 + (lhs[$1.0][idx] ?? .zero) * $1.1 }) {
				case.zero:
					.none
				case let value:
					.some((idx, value))
				}
			}
		case ((.rowMajor, let lhs), (.rowMajor, let rhs)):
			let rhs = rhs.map(Dictionary.init(uniqueKeysWithValues:))
			return lhs.enumerated().compactMap { idx, lhs in
				switch lhs.reduce(0 as Element, { $0 + (rhs[$1.0][idx] ?? .zero) * $1.1 }) {
				case.zero:
					.none
				case let value:
					.some((idx, value))
				}
			}
		}
	}
}
public func dot<Element>(_ lhs: some SparseVector<Element>, _ rhs: some SparseVector<Element>) -> Element {
	dot(lhs: lhs.coo, rhs: rhs.coo)
}
public func dot<Element>(_ lhs: some SparseMatrix<Element>, _ rhs: some SparseVector<Element>) -> some SparseVector<Element> {
	MV(lhs: lhs, rhs: rhs)
}
public func dot<Element>(_ lhs: some SparseVector<Element>, _ rhs: some SparseMatrix<Element>) -> some SparseVector<Element> {
	VM(lhs: lhs, rhs: rhs)
}
public func outer<Element>(_ lhs: some SparseVector<Element>, _ rhs: some SparseVector<Element>) -> some SparseMatrix<Element> {
	Outer(lhs: lhs, rhs: rhs)
}
