//
//  Matrix+DOK.swift
//  MUSE
//
//  Created by Kota on 9/9/R7.
//
import protocol Dense.Matrix
import protocol Dense.MutScalar
import typealias Layout.MemoryStrategy
import func simd.simd_reduce_min
@dynamicMemberLookup
@frozen public struct DOK<Element> where Element: SparseScalar<Element> {
	public let rows: Int
	public let cols: Int
	@usableFromInline
	private(set) var store: Dictionary<SIMD2<Int>, Element>
}
extension DOK {
	@inlinable
	public subscript<Λ>(dynamicMember lookup: KeyPath<Dictionary<SIMD2<Int>, Element>, Λ>) -> Λ {
		store[keyPath: lookup]
	}
	@inlinable
	public subscript<Λ>(dynamicMember lookup: ReferenceWritableKeyPath<Dictionary<SIMD2<Int>, Element>, Λ>) -> Λ {
		_read {
			yield store[keyPath: lookup]
		}
		_modify {
			yield &store[keyPath: lookup]
		}
	}
}
extension DOK {
	public typealias LIL = Array<Array<(Int, Element)>>
	public func lil(for layout: MemoryStrategy) -> (MemoryStrategy, LIL) {
		switch layout {
		case.rowMajor:
			(.rowMajor, store.reduce(into: Array<Array<(Int, Element)>>(repeating: [], count: rows)) {
				$0[$1.0.x].append(($1.0.y, $1.1))
			})
		case.columnMajor:
			(.columnMajor, store.reduce(into: Array<Array<(Int, Element)>>(repeating: [], count: cols)) {
				$0[$1.0.y].append(($1.0.x, $1.1))
			})
		}
	}
}
extension DOK: MutSparseMatrix {
	public typealias R = Array<Element>
	public typealias S = Self
	public typealias T = Self
	public typealias U = Element
	public typealias V = SPV<Element>
	public var transpose: DOK<Element> {
		.init(rows: cols, cols: rows, store: .init(uniqueKeysWithValues: store.compactMap {
			switch ($0.x, $0.y, $1) {
			case (0..<rows, 0..<cols, let v) where v != .zero:
				.some((.init($0.y, $0.x), v))
			default:
				.none
			}
		}))
	}
	public var diagonal: V {
		get {
			.init(count: min(rows, cols), store: .init(uniqueKeysWithValues: store.lazy.compactMap {
				$0.x == $0.y && $1 != .zero ? .some((simd_reduce_min($0), $1)) : .none
			}))
		}
		set {
			for (index, value) in newValue.coo {
				self[index, index] = value
			}
		}
	}
	@inlinable
	public subscript(row: Int, col: Int) -> U {
		_read {
			yield store[.init(row, col), default: .zero]
		}
		_modify {
			yield &store[.init(row, col), default: .zero]
		}
	}
	public subscript(row: Int, col: some RangeExpression<Int>) -> V {
		get {
			let col = col.relative(to: 0..<cols)
			return.init(count: col.count, store: .init(uniqueKeysWithValues: store.lazy.compactMap {
				switch ($0.x, $0.y, $1) {
				case (row, col, let v) where v != .zero:
					.some(($0.y - col.lowerBound, v))
				default:
					.none
				}
			}))
		}
		set {
			let col = col.relative(to: 0..<cols)
			for key in store.keys where row ~= key.x && col ~= key.y {
				store.removeValue(forKey: key)
			}
			store.merge(newValue.store.compactMap {
				$1 != .zero ? .some((.init(row, $0 &- col.lowerBound), $1)) : .none
			}, uniquingKeysWith: +)
		}
	}
	public subscript(row: some RangeExpression<Int>, col: Int) -> V {
		get {
			let row = row.relative(to: 0..<rows)
			return.init(count: row.count, store: .init(uniqueKeysWithValues: store.lazy.compactMap {
				switch ($0.x, $0.y, $1) {
				case (row, col, let v) where v != .zero:
					.some(($0.x - row.lowerBound, v))
				default:
					.none
				}
			}))
		}
		set {
			let row = row.relative(to: 0..<rows)
			for key in store.keys where col ~= key.y && row ~= key.x {
				store.removeValue(forKey: key)
			}
			store.merge(newValue.store.compactMap {
				$1 != .zero ? .some((.init($0 &- row.lowerBound, col), $1)) : .none
			}, uniquingKeysWith: +)
		}
	}
	public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		get {
			let row = row.relative(to: 0..<rows)
			let col = col.relative(to: 0..<cols)
			return.init(rows: row.count, cols: col.count, store: .init(uniqueKeysWithValues: store.compactMap {
				switch ($0.x, $0.y, $1) {
				case (row, col, let v) where v != .zero:
					.some((($0 &- .init(row.lowerBound, col.lowerBound), v)))
				default:
					.none
				}
			}))
		}
		set {
			let row = row.relative(to: 0..<rows)
			let col = col.relative(to: 0..<cols)
			for key in store.keys where [(row, key.x), (col, key.y)].allSatisfy(~=) {
				store.removeValue(forKey: key)
			}
			store.merge(newValue.store.compactMap {
				$1 != .zero ? .some(($0 &- .init(row.lowerBound, col.lowerBound), $1)) : .none
			}, uniquingKeysWith: +)
		}
	}
}
extension DOK {
	@inlinable
	public init(shape: (Int, Int)) {
		(rows, cols) = shape
		precondition([rows, cols].allSatisfy { .zero < $0 }, "size should be greater than 0")
		store = .init()
	}
	@inlinable
	public init(rows source: some Collection<some Collection<Element>>) {
		rows = source.count
		cols = source.map(\.count).min() ?? .zero
		precondition([rows, cols].allSatisfy { .zero < $0 }, "size should be greater than 0")
		store = source.enumerated().reduce(into: Dictionary<SIMD2<Int>, Element>()) { a, x in
			a.merge(x.1.enumerated().lazy.compactMap {
				$1 == .zero ? .none : .some((SIMD2<Int>(x.0, $0), $1))
			}, uniquingKeysWith: +)
		}
	}
	@inlinable
	public init(cols source: some Collection<some Collection<Element>>) {
		rows = source.map(\.count).min() ?? .zero
		cols = source.count
		precondition([rows, cols].allSatisfy { .zero < $0 }, "size should be greater than 0")
		store = source.enumerated().reduce(into: Dictionary<SIMD2<Int>, Element>()) { a, x in
			a.merge(x.1.enumerated().lazy.compactMap {
				$1 == .zero ? .none : .some((SIMD2<Int>($0, x.0), $1))
			}, uniquingKeysWith: +)
		}
	}
	@inlinable
	public init(shape: (Int, Int), _ nonzero: some Sequence<(SIMD2<Int>, Element)>) {
		(rows, cols) = shape
		store = .init(uniqueKeysWithValues: nonzero)
	}
	@inlinable
	public init(_ source: some SparseMatrix<Element>) {
		switch source.lil(for: .rowMajor) {
		case (.rowMajor, let lil):
			self.init(shape: (source.rows, source.cols), lil.enumerated().lazy.flatMap { row, col in
				col.lazy.map { (SIMD2<Int>(row, $0), $1) }
			})
		case (.columnMajor, let lil):
			self.init(shape: (source.rows, source.cols), lil.enumerated().lazy.flatMap { col, row in
				row.lazy.map { (SIMD2<Int>($0, col), $1) }
			})
		}
	}
}
extension DOK: ExpressibleByArrayLiteral {
	@_disfavoredOverload
	@inlinable
	public init(arrayLiteral elements: Array<Element>...) {
		self.init(rows: elements)
	}
}
extension DOK: CustomStringConvertible {}
