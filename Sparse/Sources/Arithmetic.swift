//
//  Arithmetic.swift
//  MUSE
//
//  Created by Kota on 9/11/R7.
//
import typealias Foundation.KeyPathComparator
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
	var coo: some Sequence<(Int, Element)> {
		AnySequence<(Int, Element)>((core.coo as any Sequence<(Int, Element)>))
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
		factor * source.coo
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
			(layout, source.lazy.map { [factor] in factor * $0 } )
		}
	}
}
public func*<Element: Numeric>(lhs: Element, rhs: some SparseVector<Element>) -> some SparseVector<Element> {
	Arithmetic.Scale.Vector(factor: lhs, source: rhs)
}
public func*<Element: Numeric>(lhs: Element, rhs: some SparseMatrix<Element>) -> some SparseMatrix<Element> {
	Arithmetic.Scale.Matrix(factor: lhs, source: rhs)
}
// MARK: Scale
@inlinable@inline(__always)
func*<Element: Numeric, Source: Sequence<(Int, Element)>>(_ factor: Element, _ source: Source) -> LazyMapSequence<Source, (Int, Element)> {
	source.lazy.map { ($0, factor * $1) }
}
@_disfavoredOverload
@inlinable@inline(__always)
func*<Element: Numeric>(_ factor: Element, _ source: Dictionary<Int, Element>) -> some Sequence<(Int, Element)> {
	source.lazy.map { ($0, factor * $1) }
}
// MARK: ADD
@inlinable@inline(__always)
func+<Element: Numeric>(_ lhs: some Sequence<(Int, Element)>, _ rhs: some Sequence<(Int, Element)>) -> some Sequence<(Int, Element)> {
	var lhs = lhs.sorted(using: KeyPathComparator(\.0)).makeIterator()
	var rhs = rhs.sorted(using: KeyPathComparator(\.0)).makeIterator()
	return sequence(state: (lhs.next(), rhs.next())) {
		switch $0 {
		case (.some(let x), .some(let y)) where x.0 < y.0:
			fallthrough
		case (.some(let x), .none):
			$0.0 = lhs.next()
			return.some(x)
		case (.some(let x), .some(let y)) where x.0 > y.0:
			fallthrough
		case (.none, .some(let y)):
			$0.1 = rhs.next()
			return.some(y)
		case (.some(let x), .some(let y)):
			assert(x.0 == y.0)
			$0 = (lhs.next(), rhs.next())
			return.some((min(x.0, y.0), x.1 + y.1))
		case (.none, .none):
			return.none
		}
	}.lazy.filter {
		$1 != .zero
	}
}
@_disfavoredOverload
@inlinable@inline(__always)
func+<Element: Numeric>(lhs: some Sequence<(Int, Element)>, rhs: Dictionary<Int, Element>) -> some Sequence<(Int, Element)> {
	let rhs: some Sequence<(Int, Element)> = rhs.lazy.map(\.self)
	return lhs + rhs
}
@_disfavoredOverload
@inlinable@inline(__always)
func+<Element: Numeric>(lhs: Dictionary<Int, Element>, rhs: some Sequence<(Int, Element)>) -> some Sequence<(Int, Element)> {
	let lhs: some Sequence<(Int, Element)> = lhs.lazy.map(\.self)
	return lhs + rhs
}
@_disfavoredOverload
@inlinable@inline(__always)
func+<Element: Numeric>(lhs: Dictionary<Int, Element>, rhs: Dictionary<Int, Element>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Set<Int>, Optional<(Int, Element)>>>, (Int, Element)> {
	let key = switch (lhs.keys, rhs.keys) {
	case (let l, let r) where l.count < r.count:
		Set(r).union(l)
	case (let l, let r):
		Set(l).union(r)
	}
	return key.lazy.compactMap {
		switch lhs[$0, default: .zero] + rhs[$0, default: .zero] {
		case.zero:
			.none
		case let v:
			.some(($0, v))
		}
	}
}
// MARK: SUB
@inlinable@inline(__always)
func-<Element: Numeric>(_ lhs: some Sequence<(Int, Element)>, _ rhs: some Sequence<(Int, Element)>) -> some Sequence<(Int, Element)> {
	var lhs = lhs.sorted(using: KeyPathComparator(\.0)).makeIterator()
	var rhs = rhs.sorted(using: KeyPathComparator(\.0)).makeIterator()
	return sequence(state: (lhs.next(), rhs.next())) {
		switch $0 {
		case (.some(let x), .some(let y)) where x.0 < y.0:
			$0.0 = lhs.next()
			return.some(x)
		case (.some(let x), .some(let y)) where x.0 > y.0:
			$0.1 = rhs.next()
			return.some((y.0, .zero - y.1))
		case (.some(let x), .some(let y)):
			assert(x.0 == y.0)
			$0 = (lhs.next(), rhs.next())
			return.some((min(x.0, y.0), x.1 + y.1))
		case (.some(let x), .none):
			return.some(x)
		case (.none, .some(let y)):
			return.some(y)
		case (.none, .none):
			return.none
		}
	}.lazy.filter {
		$1 != .zero
	}
}
@_disfavoredOverload
@inlinable@inline(__always)
func-<Element: Numeric>(lhs: some Sequence<(Int, Element)>, rhs: Dictionary<Int, Element>) -> some Sequence<(Int, Element)> {
	let rhs: some Sequence<(Int, Element)> = rhs.lazy.map(\.self)
	return lhs - rhs
}
@_disfavoredOverload
@inlinable@inline(__always)
func-<Element: Numeric>(lhs: Dictionary<Int, Element>, rhs: some Sequence<(Int, Element)>) -> some Sequence<(Int, Element)> {
	let lhs: some Sequence<(Int, Element)> = lhs.lazy.map(\.self)
	return lhs - rhs
}
@_disfavoredOverload
@inlinable@inline(__always)
func-<Element: Numeric>(lhs: Dictionary<Int, Element>, rhs: Dictionary<Int, Element>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Set<Int>, Optional<(Int, Element)>>>, (Int, Element)> {
	let key = switch (lhs.keys, rhs.keys) {
	case (let l, let r) where l.count < r.count:
		Set(r).union(l)
	case (let l, let r):
		Set(l).union(r)
	}
	return key.lazy.compactMap {
		switch lhs[$0, default: .zero] - rhs[$0, default: .zero] {
		case.zero:
			.none
		case let v:
			.some(($0, v))
		}
	}
}
// MARK: MUL
@inlinable@inline(__always)
func*<Element: Numeric>(_ lhs: some Sequence<(Int, Element)>, _ rhs: some Sequence<(Int, Element)>) -> some Sequence<(Int, Element)> {
	var lhs = lhs.sorted(using: KeyPathComparator(\.0)).makeIterator()
	var rhs = rhs.sorted(using: KeyPathComparator(\.0)).makeIterator()
	return sequence(state: (lhs.next(), rhs.next())) {
		while let x = $0.0 ?? lhs.next(), let y = $0.1 ?? rhs.next() {
			if x.0 == y.0 {
				$0 = (lhs.next(), rhs.next())
				switch x.1 * y.1 {
				case.zero:
					continue
				case let v:
					return.some((min(x.0, y.0), v))
				}
			} else if x.0 < y.0 {
				$0.0 = lhs.next()
			} else if x.0 > y.0 {
				$0.1 = rhs.next()
			} else {
				assertionFailure()
				break
			}
		}
		return.none
	}
}
@_disfavoredOverload
@inlinable@inline(__always)
func*<Element: Numeric>(lhs: some Sequence<(Int, Element)>, rhs: Dictionary<Int, Element>) -> some Sequence<(Int, Element)> {
	let rhs: some Sequence<(Int, Element)> = rhs.lazy.map(\.self)
	return lhs * rhs
}
@_disfavoredOverload
@inlinable@inline(__always)
func*<Element: Numeric>(lhs: Dictionary<Int, Element>, rhs: some Sequence<(Int, Element)>) -> some Sequence<(Int, Element)> {
	let lhs: some Sequence<(Int, Element)> = lhs.lazy.map(\.self)
	return lhs * rhs
}
@_disfavoredOverload
@inlinable@inline(__always)
func*<Element: Numeric>(lhs: Dictionary<Int, Element>, rhs: Dictionary<Int, Element>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Set<Int>, Optional<(Int, Element)>>>, (Int, Element)> {
	let key = switch (lhs.keys, rhs.keys) {
	case (let l, let r) where l.count < r.count:
		Set(r).intersection(l)
	case (let l, let r):
		Set(l).intersection(r)
	}
	return key.lazy.compactMap {
		switch lhs[$0, default: .zero] * rhs[$0, default: .zero] {
		case.zero:
			.none
		case let v:
			.some(($0, v))
		}
	}
}
// MARK: DOT
@inlinable@inline(__always)
func •<Element: Numeric>(_ lhs: some Sequence<(Int, Element)>, _ rhs: some Sequence<(Int, Element)>) -> Element {
	var lhs = lhs.sorted(using: KeyPathComparator(\.0)).makeIterator()
	var rhs = rhs.sorted(using: KeyPathComparator(\.0)).makeIterator()
	var l = lhs.next()
	var r = rhs.next()
	var a = Element.zero
	while let x = l ?? lhs.next(), let y = r ?? rhs.next() {
		if x.0 == y.0 {
			l = lhs.next()
			r = rhs.next()
			a += x.1 * y.1
		} else if x.0 < y.0 {
			l = lhs.next()
		} else if x.0 > y.0 {
			r = rhs.next()
		} else {
			assertionFailure()
			break
		}
	}
	return a
}
