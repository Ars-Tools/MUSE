//
//  DOT+MM.swift
//  MUSE
//
//  Created by Kota on 9/9/R7.
//
import protocol Dense.MutScalar
import enum Layout.MemoryStrategy
@usableFromInline
@frozen struct MM<Element, LHS: SparseMatrix<Element>, RHS: SparseMatrix<Element>> {
	@usableFromInline let lhs: LHS
	@usableFromInline let rhs: RHS
}
extension MM: SparseMatrix {
	@usableFromInline typealias R = Array<Element>
	@usableFromInline typealias S = MM<Element, LHS.S, RHS.S>
	@usableFromInline typealias T = MM<Element, RHS.T, LHS.T>
	@usableFromInline typealias V = ANY<Element>
	@usableFromInline typealias U = Element
	@inlinable@inline(__always)
	var rows: Int { lhs.rows }
	@inlinable@inline(__always)
	var cols: Int { rhs.cols }
	@usableFromInline@inline(__always)
	var diagonal: V {
		.init(core: Diagonal(lhs: lhs, rhs: rhs))
	}
	@usableFromInline@inline(__always)
	var transpose: T {
		.init(lhs: rhs.transpose, rhs: lhs.transpose)
	}
	@inlinable@inline(__always)
	subscript(row: Int, col: Int) -> Element {
		dot(lhs[row, 0...], rhs[0..., col])
	}
	@usableFromInline@inline(__always)
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(core: VM(lhs: lhs[row, 0...], rhs: rhs[0..., col]))
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(core: MV(lhs: lhs[row, 0...], rhs: rhs[0..., col]))
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[row, 0...], rhs: rhs[0..., col])
	}
	@inlinable@inline(__always)
	func lil(for strategy: MemoryStrategy) -> (MemoryStrategy, Array<LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Int, Element>, Optional<(Int, Element)>>>, (Int, Element)>>) {
		switch (strategy, lhs.lil(for: strategy), rhs.lil(for: strategy)) {
		case(.columnMajor, (.columnMajor, let lhs), (.columnMajor, let rhs)), (.rowMajor, (.columnMajor, let lhs), (.columnMajor, let rhs)):
			return (.columnMajor, rhs.map {
				unpack($0.reduce(into: Dictionary<Int, Element>()) { a, x in a.merge(lhs[x.0].lazy.map { ($0, $1 * x.1) }, uniquingKeysWith: +)})
			})
		case(.rowMajor, (.rowMajor, let lhs), (.rowMajor, let rhs)), (.columnMajor, (.rowMajor, let lhs), (.rowMajor, let rhs)):
			return (.rowMajor, lhs.map {
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
		case(.columnMajor, (.rowMajor, let lhs), (.columnMajor, let rhs)):
			let lhs = Sparse.transpose(lil: lhs, for: rhs.count)
			return (.columnMajor, rhs.map {
				unpack($0.reduce(into: Dictionary<Int, Element>()) { a, x in a.merge(lhs[x.0].lazy.map { ($0, $1 * x.1) }, uniquingKeysWith: +)})
			})
		case(.rowMajor, (.rowMajor, let lhs), (.columnMajor, let rhs)):
			let rhs = Sparse.transpose(lil: rhs, for: lhs.count)
			return (.rowMajor, lhs.map {
				unpack($0.reduce(into: Dictionary<Int, Element>()) { a, x in a.merge(rhs[x.0].lazy.map { ($0, $1 * x.1) }, uniquingKeysWith: +)})
			})
		}
	}
}
public func dot<Element>(_ lhs: some SparseMatrix<Element>, _ rhs: some SparseMatrix<Element>) -> some SparseMatrix<Element> {
	MM(lhs: lhs, rhs: rhs)
}
