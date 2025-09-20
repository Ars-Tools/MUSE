//
//  Any+Matrix.swift
//  MUSE
//
//  Created by Kota on 9/18/R7.
//
import typealias Foundation.KeyPathComparator
import typealias Layout.MemoryStrategy
extension ANY {
	@usableFromInline
	struct Matrix {
		@usableFromInline typealias R = Array<Element>
		@usableFromInline typealias S = Matrix
		@usableFromInline typealias T = Matrix
		@usableFromInline typealias U = Scalar
		@usableFromInline typealias V = Vector
		@usableFromInline let body: Core
		@usableFromInline
		class Core: @unchecked Sendable {
			@usableFromInline
			var rows: Int { fatalError() }
			@usableFromInline
			var cols: Int { fatalError() }
			@usableFromInline
			var transpose: T { fatalError() }
			@usableFromInline
			var diagonal: V { fatalError() }
			@usableFromInline
			subscript(row: Int, col: Int) -> U { fatalError() }
			@usableFromInline
			subscript(row: Int, col: some RangeExpression<Int>) -> V { fatalError() }
			@usableFromInline
			subscript(row: some RangeExpression<Int>, col: Int) -> V { fatalError() }
			@usableFromInline
			subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S { fatalError() }
			@usableFromInline
			func callAsFunction(as strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) { fatalError() }
		}
		@usableFromInline
		final class Mat<Body: Dense.Matrix<Element>>: Core, @unchecked Sendable {
			@usableFromInline let body: Body
			@usableFromInline
			init(core: Body) {
				body = core
			}
			@inlinable
			override var rows: Int {
				body.rows
			}
			@inlinable
			override var cols: Int {
				body.cols
			}
			@usableFromInline
			override var transpose: T {
				.init(core: body.transpose)
			}
			@usableFromInline
			override var diagonal: V {
				.init(core: body.diagonal)
			}
			@usableFromInline
			override subscript(row: Int, col: Int) -> U {
				.init(core: body[row, col])
			}
			@usableFromInline
			override subscript(row: Int, col: some RangeExpression<Int>) -> V {
				.init(core: body[row, col])
			}
			@usableFromInline
			override subscript(row: some RangeExpression<Int>, col: Int) -> V {
				.init(core: body[row, col])
			}
			@usableFromInline
			override subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
				.init(core: body[row, col])
			}
			@usableFromInline
			override func callAsFunction(as strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
				switch try body(as: strategy) {
				case (let stride, let kernel):
					(stride, {
						await kernel().withUnsafeBufferPointer(Array.init)
					})
				}
			}
		}
		@usableFromInline
		final class Row<Body: Dense.Tensor<Element>>: Core, @unchecked Sendable {
			@usableFromInline let body: Body
			@usableFromInline let axes: (row: Optional<Int>, col: Optional<Int>)
			@usableFromInline
			init(core: Body, row: Optional<Int>, col: Optional<Int>) {
				body = core
				axes = (row, col)
			}
			@inlinable
			override var rows: Int {
				body.shape.enumerated().first { $0.0 == axes.row }.map(\.1) ?? 1
			}
			@inlinable
			override var cols: Int {
				body.shape.enumerated().first { $0.0 == axes.col }.map(\.1) ?? 1
			}
			@usableFromInline
			override var transpose: T {
				.init(body: Col(core: body.transpose, row: axes.col, col: axes.row))
			}
			@usableFromInline
			override var diagonal: V {
				.init(body: Vector.Tensor(core: body.diagonal, axis: 0))
			}
			@usableFromInline
			override subscript(row: Int, col: Int) -> U {
				.init(core: body[(0..<body.shape.count).map {
					switch $0 {
					case axes.row:
						row
					case axes.col:
						col
					default:
						0
					}
				}])
			}
			@usableFromInline
			override subscript(row: Int, col: some RangeExpression<Int>) -> V {
				.init(body: Vector.Tensor(core: body[body.shape.enumerated().map {
					switch $0 {
					case axes.row:
						(row...row).relative(to: 0..<$1)
					case axes.col:
						col.relative(to: 0..<$1)
					default:
						(0..<$1)
					}
				}], axis: axes.col ?? .zero))
			}
			@usableFromInline
			override subscript(row: some RangeExpression<Int>, col: Int) -> V {
				.init(body: Vector.Tensor(core: body[body.shape.enumerated().map {
					switch $0 {
					case axes.row:
						row.relative(to: 0..<$1)
					case axes.col:
						(col...col).relative(to: 0..<$1)
					default:
						(0..<$1)
					}
				}], axis: axes.col ?? .zero))
			}
			@usableFromInline
			override subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
				.init(rows: body[body.shape.enumerated().map {
					switch $0 {
					case axes.row:
						row.relative(to: 0..<$1)
					case axes.col:
						col.relative(to: 0..<$1)
					default:
						(0..<$1)
					}
				}])
			}
			@usableFromInline
			override func callAsFunction(as strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
				switch try body(as: strategy) {
				case (let layout, let kernel):
					let stride = layout.enumerated().compactMap {
						switch $0 {
						case axes.row:
							.some($1)
						case axes.col:
							.some($1)
						default:
							.none
						}
					}
					return (repeatElement(0, count: max(0, 2 - stride.count)) + stride, {
						await kernel().withUnsafeBufferPointer(Array.init)
					})
				}
			}
		}
		@usableFromInline
		final class Col<Body: Dense.Tensor<Element>>: Core, @unchecked Sendable {
			@usableFromInline let body: Body
			@usableFromInline let axes: (row: Optional<Int>, col: Optional<Int>)
			@usableFromInline
			init(core: Body, row: Optional<Int>, col: Optional<Int>) {
				body = core
				axes = (row, col)
			}
			@inlinable
			override var rows: Int {
				axes.row.map { body.shape[$0] } ?? 1
			}
			@inlinable
			override var cols: Int {
				axes.col.map { body.shape[$0] } ?? 1
			}
			@usableFromInline
			override var transpose: T {
				.init(body: Row(core: body.transpose, row: axes.col, col: axes.row))
			}
			@usableFromInline
			override var diagonal: V {
				.init(body: Vector.Tensor(core: body.diagonal, axis: 0))
			}
			@usableFromInline
			override subscript(row: Int, col: Int) -> U {
				.init(core: body[(0..<body.shape.count).map {
					switch $0 {
					case axes.row:
						row
					case axes.col:
						col
					default:
						0
					}
				}])
			}
			@usableFromInline
			override subscript(row: Int, col: some RangeExpression<Int>) -> V {
				.init(body: Vector.Tensor(core: body[body.shape.enumerated().map {
					switch $0 {
					case axes.row:
						(row...row).relative(to: 0..<$1)
					case axes.col:
						col.relative(to: 0..<$1)
					default:
						(0..<1)
					}
				}], axis: axes.row ?? .zero))
			}
			@usableFromInline
			override subscript(row: some RangeExpression<Int>, col: Int) -> V {
				.init(body: Vector.Tensor(core: body[body.shape.enumerated().map {
					switch $0 {
					case axes.row:
						row.relative(to: 0..<$1)
					case axes.col:
						(col...col).relative(to: 0..<$1)
					default:
						(0..<1)
					}
				}], axis: axes.row ?? .zero))
			}
			@usableFromInline
			override subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
				.init(cols: body[body.shape.enumerated().map {
					switch $0 {
					case axes.row:
						row.relative(to: 0..<$1)
					case axes.col:
						col.relative(to: 0..<$1)
					default:
						(0..<$1)
					}
				}])
			}
			@usableFromInline
			override func callAsFunction(as strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
				switch try body(as: strategy) {
				case (let layout, let kernel):
					let stride = layout.enumerated().compactMap {
						switch $0 {
						case axes.row:
							.some($1)
						case axes.col:
							.some($1)
						default:
							.none
						}
					}
					return (stride + repeatElement(0, count: max(0, 2 - stride.count)), {
						await kernel().withUnsafeBufferPointer(Array.init)
					})
				}
			}
		}
	}
}
extension ANY.Matrix: Matrix {
	@inlinable
	init(core: some Dense.Matrix<Element>) {
		body = Mat(core: core)
	}
	@inlinable
	init(rows: some Dense.Tensor<Element>) {
		let axes = rows.shape.enumerated()
			.sorted(using: KeyPathComparator(\.1, order: .reverse)).prefix(2)
			.sorted(using: KeyPathComparator(\.0)).map(\.0)
		body = Row(core: rows,
				   row: axes.dropLast().first,
				   col: axes.last)
	}
	@inlinable
	init(cols: some Dense.Tensor<Element>) {
		let axes = cols.shape.enumerated()
			.sorted(using: KeyPathComparator(\.1, order: .reverse)).prefix(2)
			.sorted(using: KeyPathComparator(\.0)).map(\.0)
		body = Col(core: cols,
				   row: axes.first,
				   col: axes.dropFirst().last)
	}
	@usableFromInline
	var rows: Int {
		body.rows
	}
	@usableFromInline
	var cols: Int {
		body.cols
	}
	@usableFromInline
	var transpose: T {
		body.transpose
	}
	@usableFromInline
	var diagonal: V {
		body.diagonal
	}
	@usableFromInline
	subscript(row: Int, col: Int) -> U {
		body[row, col]
	}
	@usableFromInline
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		body[row, col]
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		body[row, col]
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		body[row, col]
	}
	@usableFromInline
	func callAsFunction(as strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
		try body(as: strategy)
	}
}
public func matrix<Element>(rows source: some Tensor<Element>) -> some Matrix<Element> {
	ANY.Matrix(rows: source)
}
public func matrix<Element>(cols source: some Tensor<Element>) -> some Matrix<Element> {
	ANY.Matrix(cols: source)
}
