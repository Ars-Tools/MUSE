//
//  Protocol+Matrix.swift
//  MUSE
//
//  Created by Kota on 9/9/R7.
//
import typealias Layout.MemoryStrategy
import protocol Dense.Matrix
import protocol Dense.MutMatrix
public protocol SparseMatrix<Element>: SparseTensor & Matrix where S: SparseMatrix<Element>, T: SparseMatrix<Element>, V: SparseVector<Element> {
	associatedtype LIL: RandomAccessCollection where LIL.Index == Int, LIL.Element: Sequence, LIL.Element.Element == (Int, Element)
	@inlinable func lil(for layout: MemoryStrategy) -> (MemoryStrategy, LIL)
	@inlinable var state: Set<SIMD2<Int>> { get }
}
public protocol MutSparseMatrix<Element>: MutSparseTensor & MutMatrix & SparseMatrix where S: MutSparseMatrix<Element>, T: MutSparseMatrix<Element>, V: MutSparseVector<Element> {
	@inlinable init(shape: (Int, Int), _ nonzero: some Sequence<(SIMD2<Int>, Element)>)
}
extension SparseMatrix {
	@inlinable
	public var nonzero: LazySequence<FlattenSequence<LazyMapSequence<EnumeratedSequence<LIL>, LazyMapSequence<LIL.Element, (Array<Int>, Element)>>>> {
		switch lil(for: .rowMajor) {
		case(.rowMajor, let lil):
			lil.enumerated().lazy.flatMap { row, col in
				col.lazy.map { ([row, $0], $1) }
			}
		case(.columnMajor, let lil):
			lil.enumerated().lazy.flatMap { col, row in
				row.lazy.map { ([$0, col], $1) }
			}
		}
	}
}
extension SparseMatrix where Element: Numeric {
	@inlinable
	public var state: Set<SIMD2<Int>> {
		switch lil(for: .rowMajor) {
		case(.rowMajor, let lil):
			.init(lil.enumerated().lazy.flatMap { row, col in
				col.lazy.compactMap {
					$1 != .zero ? .some(SIMD2<Int>(row, $0)) : .none
				}
			})
		case(.columnMajor, let lil):
			.init(lil.enumerated().lazy.flatMap { col, row in
				row.lazy.compactMap {
					$1 != .zero ? .some(SIMD2<Int>($0, col)) : .none
				}
			})
		}
	}
	@inlinable
	public func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
		let (layout, memory) = switch lil(for: strategy) {
		case(.rowMajor, let lil):
			([cols, 1], Array<Element>(unsafeUninitializedCapacity: rows * cols) {
				for (row, col) in lil.enumerated() {
					$0[row*cols..<row*cols+cols].initialize(repeating: .zero)
					for (col, val) in col {
						$0[row*cols+col] = val
					}
				}
				$1 = $0.count
			})
		case(.columnMajor, let lil):
			([1, rows], Array<Element>(unsafeUninitializedCapacity: rows * cols) {
				for (col, row) in lil.enumerated() {
					$0[col*rows..<col*rows+rows].initialize(repeating: .zero)
					for (row, val) in row {
						$0[row+rows*col] = val
					}
				}
				$1 = $0.count
			})
		}
		return (layout, {memory})
	}
	@inlinable
	public var description: String {
		switch lil(for: .rowMajor) {
		case(.rowMajor, let lil):
			"[" + lil.lazy.map { row in
				Array<Element>(unsafeUninitializedCapacity: cols) {
					$0.initialize(repeating: .zero)
					for (c, v) in row {
						$0[c] = v
					}
					$1 = $0.count
				}.description
			}.joined(separator: ",\r\n ") + "]"
		case(.columnMajor, let lil):
			"[" + Sparse.transpose(lil: lil, for: rows).lazy.map { row in
				Array<Element>(unsafeUninitializedCapacity: cols) {
					$0.initialize(repeating: .zero)
					for (c, v) in row {
						$0[c] = v
					}
					$1 = $0.count
				}.description
			}.joined(separator: ",\r\n ") + "]"
		}
	}
}
extension SparseMatrix where Element == Bool {
	@inlinable
	public func lil(for layout: MemoryStrategy) -> (MemoryStrategy, LazyMapSequence<Array<Set<Int>>, LazyMapSequence<Set<Int>, (Int, Element)>>) {
		switch layout {
		case.rowMajor:
			(.rowMajor, state.reduce(into: Array<Set<Int>>(repeating: .init(), count: rows)) {
				$0[$1.x].insert($1.y)
			}.lazy.map { $0.lazy.map { ($0, true) } })
		case.columnMajor:
			(.columnMajor, state.reduce(into: Array<Set<Int>>(repeating: .init(), count: rows)) {
				$0[$1.y].insert($1.x)
			}.lazy.map { $0.lazy.map { ($0, true) } })
		}
	}
	@inlinable
	public func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
		let (layout, result) = switch strategy {
		case.rowMajor:
			([cols, 1], Array<Element>(unsafeUninitializedCapacity: rows * cols) { [state] in
				$0.initialize(repeating: false)
				for position in state {
					$0[position.x*cols+position.y] = true
				}
				$1 = $0.count
			})
		case.columnMajor:
			([1, rows], Array<Element>(unsafeUninitializedCapacity: rows * cols) { [state] in
				$0.initialize(repeating: false)
				for position in state {
					$0[position.x+rows*position.y] = true
				}
				$1 = $0.count
			})
		}
		return (layout, {result})
	}
	@inlinable
	public var description: String {
		"[" + state.reduce(into: Array<Set<Int>>(repeating: .init(), count: rows)) {
			$0[$1.x].insert($1.y)
		}.lazy.map { $0.lazy.map { ($0, true) } }.lazy.map { row in
			Array<Element>(unsafeUninitializedCapacity: cols) {
				$0.initialize(repeating: false)
				for (c, v) in row {
					$0[c] = v
				}
				$1 = $0.count
			}.description
		}.joined(separator: ",\r\n ") + "]"
	}
}
extension MutSparseMatrix {
	@inlinable
	public init(diagonal vector: some Collection<Element>) {
		self.init(shape: (vector.count, vector.count), vector.enumerated().lazy.map { (SIMD2(repeating: $0), $1) })
	}
	@_disfavoredOverload
	@inlinable
	public init(diagonal vector: Element...) {
		self.init(diagonal: vector)
	}
	@inlinable
	public init(diagonal vector: some SparseVector<Element>) {
		self.init(shape: (vector.count, vector.count), vector.coo.lazy.map { (SIMD2(repeating: $0), $1) })
	}
	@inlinable
	public init(_ vector: some SparseVector<Element>, layout: MemoryStrategy) {
		switch layout {
		case.rowMajor:
			self.init(shape: (1, vector.count), vector.coo.lazy.map { (SIMD2(0, $0), $1) })
		case.columnMajor:
			self.init(shape: (vector.count, 1), vector.coo.lazy.map { (SIMD2($0, 0), $1) })
		}
	}
}
extension MutSparseMatrix where Element: Numeric {
	@inlinable
	public init(identity count: Int) {
		self.init(diagonal: repeatElement(1 as Element, count: count))
	}
}
extension MutSparseMatrix where Element == Bool {
	@inlinable
	public init(identity count: Int) {
		self.init(diagonal: repeatElement(true, count: count))
	}
}
