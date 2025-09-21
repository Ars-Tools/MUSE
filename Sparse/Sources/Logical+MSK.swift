//
//  Logical+MSK.swift
//  MUSE
//
//  Created by Kota on 9/12/R7.
//
import protocol Accelerate.AccelerateBuffer
import protocol Dense.Matrix
import typealias Layout.MemoryStrategy
import func Layout.broadcast
import func Layout.narrowcast
import func Layout.product
import func simd.simd_reduce_min
extension Logical {
	@usableFromInline
	@frozen enum MSK {
		@usableFromInline
		@frozen struct Vector<Maskee: SparseVector, Masker: SparseVector<Bool>> where Maskee.Element: Numeric {
			@usableFromInline typealias Element = Maskee.Element
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias S = Vector<Maskee.S, Masker.S>
			@usableFromInline typealias U = Element
			@usableFromInline let maskee: Maskee
			@usableFromInline let masker: Masker
		}
		@usableFromInline
		@frozen struct Matrix<Maskee: SparseMatrix, Masker: SparseMatrix<Bool>> where Maskee.Element: Numeric {
			@usableFromInline typealias Element = Maskee.Element
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias S = Matrix<Maskee.S, Masker.S>
			@usableFromInline typealias T = Matrix<Maskee.T, Masker.T>
			@usableFromInline typealias U = Element
			@usableFromInline typealias V = Vector<Maskee.V, Masker.V>
			@usableFromInline let maskee: Maskee
			@usableFromInline let masker: Masker
		}
	}
}
extension Logical.MSK.Vector: SparseVector {
	@usableFromInline
	var count: Int { broadcast(x: maskee.count, y: masker.count) }
	@inlinable
	subscript(position: Int) -> Element {
		masker[narrowcast(point: position, shape: count)] ?
		maskee[narrowcast(point: position, shape: count)] : .zero
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(maskee: maskee[narrowcast(bounds: bounds, target: count, source: maskee.count)],
			  masker: masker[narrowcast(bounds: bounds, target: count, source: masker.count)])
	}
	@usableFromInline
	var coo: LazyFilterSequence<Maskee.COO> {
		let masker = masker.state
		return maskee.coo.lazy.filter { masker.contains($0.0) }
	}
	@usableFromInline
	var state: Set<Int> {
		switch (count / maskee.count, count / masker.count) {
		case (1, 1):
			maskee.state.intersection(masker.state)
		case (2..., 1):
			maskee.state.isEmpty ? .init() : masker.state
		case (1, 2...):
			masker.state.isEmpty ? .init() : maskee.state
		case (2..., 2...):
			maskee.state.isEmpty || masker.state.isEmpty ? .init() : .init(0..<count)
		default:
			.init()
		}
	}
}
extension Logical.MSK.Matrix: SparseMatrix {
	@inlinable
	var cols: Int { broadcast(x: maskee.rows, y: maskee.rows) }
	@inlinable
	var rows: Int { broadcast(x: maskee.cols, y: masker.cols) }
	@usableFromInline
	var transpose: T {
		.init(maskee: maskee.transpose, masker: masker.transpose)
	}
	@usableFromInline
	var diagonal: V {
		let maskee = switch (rows / maskee.rows, cols / maskee.cols) {
		case (1, 1):
			maskee.diagonal
		case (1, 2...):
			maskee[0, 0...]
		case (2..., 1):
			maskee[0..., 0]
		default:
			maskee.diagonal
		}
		let masker = switch (rows / masker.rows, cols / masker.cols) {
		case (1, 1):
			masker.diagonal
		case (1, 2...):
			masker[0, 0...]
		case (2..., 1):
			masker[0..., 0]
		default:
			masker.diagonal
		}
		return.init(maskee: maskee, masker: masker)
	}
	@inlinable
	subscript(row: Int, col: Int) -> Element {
		masker[narrowcast(point: row, shape: masker.rows),
			   narrowcast(point: col, shape: masker.cols)] ? .zero :
		maskee[narrowcast(point: row, shape: masker.rows),
			   narrowcast(point: col, shape: masker.cols)]
	}
	@usableFromInline
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(maskee: maskee[narrowcast(point: row, shape: maskee.rows),
							 narrowcast(bounds: col, target: cols, source: maskee.cols)],
			  masker: masker[narrowcast(point: row, shape: masker.rows),
							 narrowcast(bounds: col, target: cols, source: masker.cols)])
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(maskee: maskee[narrowcast(bounds: row, target: rows, source: maskee.rows),
							 narrowcast(point: col, shape: maskee.cols)],
			  masker: masker[narrowcast(bounds: row, target: rows, source: masker.rows),
							 narrowcast(point: col, shape: masker.cols)])
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(maskee: maskee[narrowcast(bounds: row, target: rows, source: maskee.rows),
							 narrowcast(bounds: col, target: cols, source: maskee.cols)],
			  masker: masker[narrowcast(bounds: row, target: rows, source: masker.rows),
							 narrowcast(bounds: col, target: cols, source: masker.cols)])
	}
	@usableFromInline
	func lil(for layout: MemoryStrategy) -> (MemoryStrategy, Array<Optional<LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Int, Element>, Optional<(Int, Element)>>>, (Int, Element)>>>) {
		let (row, col) = `repeat`(position: masker.state, count: (rows / masker.rows, cols / masker.cols)).reduce(into: (Set<Int>(), Set<Int>())) {
			$0.0.insert($1.x)
			$0.1.insert($1.y)
		}
		return switch maskee.lil(for: layout) {
		case (.rowMajor, let lil):
			(.rowMajor, `repeat`(lil: lil, count: (rows / maskee.rows, cols / maskee.cols)).enumerated().map {
				row.contains($0) ? .some($1.lazy.compactMap {
					col.contains($0) && $1 != .zero ? .some(($0, $1)) : .none
				}) : .none
			})
		case (.columnMajor, let lil):
			(.columnMajor, `repeat`(lil: lil, count: (cols / maskee.cols, rows / maskee.rows)).enumerated().map {
				col.contains($0) ? .some($1.lazy.compactMap {
					row.contains($0) && $1 != .zero ? .some(($0, $1)) : .none
				}) : .none
			})
		}
	}
}
extension SparseVector where Element: Numeric {
	public subscript(_ masker: some SparseVector<Bool>) -> some SparseVector<Element> {
		Logical.MSK.Vector(maskee: self, masker: masker)
	}
}
extension SparseMatrix where Element: Numeric {
	public subscript(_ masker: some SparseMatrix<Bool>) -> some SparseMatrix<Element> {
		Logical.MSK.Matrix(maskee: self, masker: masker)
	}
	public subscript(_ row: some SparseVector<Bool>, _ col: some SparseVector<Bool>) -> some SparseMatrix<Element> {
		Logical.MSK.Matrix(maskee: self, masker: MSK(rows: row.count, cols: col.count, state: .init(product(row.state, col.state))))
	}
	public subscript(_ row: some SparseVector<Bool>, _ col: some RangeExpression<Int>) -> some SparseMatrix<Element> {
		let col = col.relative(to: 0..<cols)
		return Logical.MSK.Matrix(maskee: self, masker: MSK(rows: row.count, cols: col.count, state: .init(product(row.state, col))))
	}
	public subscript(_ row: some RangeExpression<Int>, _ col: some SparseVector<Bool>) -> some SparseMatrix<Element> {
		let row = row.relative(to: 0..<rows)
		return Logical.MSK.Matrix(maskee: self, masker: MSK(rows: row.count, cols: col.count, state: .init(product(row, col.state))))
	}
}
extension DOK {
	public subscript(_ masker: some SparseMatrix<Bool>) -> DOK<Element> {
		.init(rows: rows, cols: cols, store: .init(uniqueKeysWithValues: masker.state.compactMap {
			switch store[$0] {
			case.none,.some(.zero):
				.none
			case.some(let v):
				($0, v)
			}
		}))
	}
}
extension Matrix {
	@_disfavoredOverload
	public subscript(_ masker: some SparseMatrix<Bool>, for strategy: MemoryStrategy = .rowMajor) -> DOK<Element> {
		get async throws {
			let (layout, maskee) = try evaluation(for: strategy)
			precondition(layout.count == 2)
			async let result = maskee()
			let masker = masker.state
			return await result.withUnsafeBufferPointer { memory in
				.init(rows: rows, cols: cols, store: .init(uniqueKeysWithValues: masker.lazy.map {
					($0, memory[layout[0] * $0.x + layout[1] * $0.y])
				}))
			}
		}
	}
}
