//
//  Matrix+MSK.swift
//  MUSE
//
//  Created by Kota on 9/10/R7.
//
import protocol Dense.Matrix
import typealias Layout.MemoryStrategy
import func simd.simd_reduce_min
@dynamicMemberLookup
@frozen public struct MSK {
	public typealias Element = Bool
	public let rows: Int
	public let cols: Int
	private(set) public var state: Set<SIMD2<Int>>
}
extension MSK {
	@inlinable
	public subscript<Λ>(dynamicMember lookup: KeyPath<Set<SIMD2<Int>>, Λ>) -> Λ {
		state[keyPath: lookup]
	}
	@inlinable
	public subscript<Λ>(dynamicMember lookup: ReferenceWritableKeyPath<Set<SIMD2<Int>>, Λ>) -> Λ {
		_read {
			yield state[keyPath: lookup]
		}
		_modify {
			yield &state[keyPath: lookup]
		}
	}
}
extension MSK {
	public typealias S = Self
	public typealias T = Self
	public typealias U = Element
	public typealias V = VSK
	public var diagonal: V {
		.init(count: min(rows, cols), state: .init(state.lazy.compactMap {
			$0.x == $0.y ? .some(simd_reduce_min($0)) : .none
		}))
	}
	public var transpose: T {
		.init(rows: cols, cols: rows, state: .init(state.lazy.map { .init($0.y, $0.x) }))
	}
	public subscript(row: Int, col: Int) -> U {
		get {
			state.contains(.init(row, col))
		}
		set {
			if newValue {
				state.insert(.init(row, col))
			} else {
				state.remove(.init(row, col))
			}
		}
	}
	public subscript(row: Int, col: some RangeExpression<Int>) -> V {
		get {
			let col = col.relative(to: 0..<cols)
			return.init(count: col.count, state: .init(state.lazy.compactMap {
				switch ($0.x, $0.y) {
				case (row, col):
					.some($0.y &- col.lowerBound)
				default:
					.none
				}
			}))
		}
		set {
			let col = col.relative(to: 0..<cols)
			state.subtract(state.filter { col.contains($0.y) })
			for index in newValue.state {
				state.insert(.init(row, index &+ col.lowerBound))
			}
		}
	}
	public subscript(row: some RangeExpression<Int>, col: Int) -> V {
		get {
			let row = row.relative(to: 0..<rows)
			return.init(count: row.count, state: .init(state.lazy.compactMap {
				switch ($0.x, $0.y) {
				case (row, col):
					.some($0.x &- row.lowerBound)
				default:
					.none
				}
			}))
		}
		set {
			let row = row.relative(to: 0..<rows)
			state.subtract(state.filter { row.contains($0.x) })
			for index in newValue.state {
				state.insert(.init(index &+ row.lowerBound, col))
			}
		}
	}
	public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		get {
			let row = row.relative(to: 0..<rows)
			let col = col.relative(to: 0..<cols)
			return.init(rows: row.count, cols: col.count, state: .init(state.lazy.compactMap {
				switch ($0.x, $0.y) {
				case (row, col):
					.some($0 &- .init(row.lowerBound, col.lowerBound))
				default:
					.none
				}
			}))
		}
		set {
			let row = row.relative(to: 0..<rows)
			let col = col.relative(to: 0..<cols)
			state.subtract(state.filter {
				switch ($0.x, $0.y) {
				case (row, col):
					true
				default:
					false
				}
			})
			for index in newValue.state {
				state.insert(index &+ .init(row.lowerBound, col.lowerBound))
			}
		}
	}
}
extension MSK: MutSparseMatrix {
	public init(shape: (Int, Int)) {
		(rows, cols) = shape
		state = .init()
	}
	public init(shape: (Int, Int), _ nonzero: some Sequence<(SIMD2<Int>, Element)>) {
		(rows, cols) = shape
		state = nonzero.reduce(into: .init()) {
			if $1.1 {
				$0.insert($1.0)
			}
		}
	}
}
extension MSK {
	public init(_ source: some SparseMatrix) {
		rows = source.rows
		cols = source.cols
		state = source.state
	}
}
extension MSK: CustomStringConvertible {}
