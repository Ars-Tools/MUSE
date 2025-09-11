//
//  Matrix+MSK.swift
//  MUSE
//
//  Created by Kota on 9/10/R7.
//
import protocol Dense.MutMatrix
import typealias Layout.MemoryStrategy
import func simd.simd_reduce_min
@dynamicMemberLookup
@frozen public struct MSK {
	public let rows: Int
	public let cols: Int
	@usableFromInline
	private(set) var state: Set<SIMD2<Int>>
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
extension MSK: MutMatrix {
	public typealias Element = Bool
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
			let col = col.relative(to: 0..<rows)
			return.init(count: col.count, state: .init(state.lazy.compactMap {
				switch ($0.x, $0.y) {
				case (row, col):
					.some($0.x &- col.lowerBound)
				default:
					.none
				}
			}))
		}
		set {
			let col = col.relative(to: 0..<rows)
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
	public func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Bool>) {
		switch strategy {
		case.rowMajor:
			let result = Array<Bool>(unsafeUninitializedCapacity: rows * cols) {
				$0.initialize(repeating: false)
				for index in state {
					$0[index.x * cols + index.y] = true
				}
				$1 = $0.count
			}
			return ([cols, 1], {result})
		case.columnMajor:
			let result = Array<Bool>(unsafeUninitializedCapacity: rows * cols) {
				$0.initialize(repeating: false)
				for index in state {
					$0[index.x + rows * index.y] = true
				}
				$1 = $0.count
			}
			return ([1, rows], {result})
		}
	}
}
extension MSK {
	public init(shape: (Int, Int)) {
		(rows, cols) = shape
		state = .init()
	}
}
extension MSK {
	public init(_ source: some SparseMatrix) {
		rows = source.rows
		cols = source.cols
		state = switch source.lil(for: .rowMajor) {
		case (.rowMajor, let lil):
			.init(lil.enumerated().lazy.flatMap { row, col in
				col.compactMap { $1 == .zero ? .none : .some(.init(row, $0)) }
			})
		case (.columnMajor, let lil):
			.init(lil.enumerated().lazy.flatMap { col, row in
				row.compactMap { $1 == .zero ? .none : .some(.init($0, col)) }
			})
		}
	}
}
extension MSK: CustomStringConvertible {
	public var description: String {
		var rows = Array<Set<Int>>(repeating: .init(), count: rows)
		for index in state {
			rows[index.x].insert(index.y)
		}
		return "[" + rows.map { state in
			Array<Bool>(unsafeUninitializedCapacity: cols) {
				$0.initialize(repeating: false)
				for index in state {
					$0[index] = true
				}
				$1 = $0.count
			}.description
		}.joined(separator: ",\r\n ") + "]"
	}
}
