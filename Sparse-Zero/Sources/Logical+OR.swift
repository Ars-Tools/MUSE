//
//  Logical+OR.swift
//  MUSE
//
//  Created by Kota on 9/12/R7.
//
import protocol Dense.Tensor
import typealias Layout.MemoryStrategy
import func Layout.broadcast
import func Layout.narrowcast
extension Logical {
	@usableFromInline
	@frozen enum OR {
		@usableFromInline
		@frozen struct Vector<LHS: SparseVector<Bool>, RHS: SparseVector<Bool>> {
			@usableFromInline typealias Element = Bool
			@usableFromInline typealias R = Array<Bool>
			@usableFromInline typealias S = Vector<LHS.S, RHS.S>
			@usableFromInline typealias U = Bool
			@usableFromInline let lhs: LHS
			@usableFromInline let rhs: RHS
		}
		@usableFromInline
		@frozen struct Matrix<LHS: SparseMatrix<Bool>, RHS: SparseMatrix<Bool>> {
			@usableFromInline typealias Element = Bool
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias S = Matrix<LHS.S, RHS.S>
			@usableFromInline typealias T = Matrix<LHS.T, RHS.T>
			@usableFromInline typealias U = Element
			@usableFromInline typealias V = Vector<LHS.V, RHS.V>
			@usableFromInline let lhs: LHS
			@usableFromInline let rhs: RHS
		}
	}
}
extension Logical.OR.Vector: SparseVector {
	@inlinable
	var count: Int {
		broadcast(x: lhs.count, y: rhs.count)
	}
	@inlinable
	subscript(position: Int) -> Element {
		lhs[narrowcast(point: position, shape: lhs.count)] ||
		rhs[narrowcast(point: position, shape: rhs.count)]
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[narrowcast(bounds: bounds, target: count, source: lhs.count)],
			  rhs: rhs[narrowcast(bounds: bounds, target: count, source: rhs.count)])
	}
	@inlinable
	var state: Set<Int> {
		switch (count / lhs.count, count / rhs.count) {
		case (1, 1):
			lhs.state.union(rhs.state)
		case (2..., 1):
			lhs.state.isEmpty ? rhs.state : .init(0..<count)
		case (1, 2...):
			rhs.state.isEmpty ? lhs.state : .init(0..<count)
		case (2..., 2...):
			lhs.state.isEmpty && rhs.state.isEmpty ? .init() : .init(0..<count)
		default:
			.init()
		}
	}
}
extension Logical.OR.Matrix: SparseMatrix {
	@inlinable
	var rows: Int {
		broadcast(x: lhs.rows, y: rhs.rows)
	}
	@inlinable
	var cols: Int {
		broadcast(x: lhs.cols, y: rhs.cols)
	}
	@usableFromInline
	var diagonal: V {
		let lhs = switch (rows / lhs.rows, cols / lhs.cols) {
		case (1, 1):
			lhs.diagonal
		case (1, 2...):
			lhs[0, 0...]
		case (2..., 1):
			lhs[0..., 0]
		default:
			lhs.diagonal
		}
		let rhs = switch (rows / rhs.rows, cols / rhs.cols) {
		case (1, 1):
			rhs.diagonal
		case (1, 2...):
			rhs[0, 0...]
		case (2..., 1):
			rhs[0..., 0]
		default:
			rhs.diagonal
		}
		return.init(lhs: lhs, rhs: rhs)
	}
	@usableFromInline
	var transpose: T {
		.init(lhs: lhs.transpose, rhs: rhs.transpose)
	}
	@inlinable
	subscript(row: Int, col: Int) -> Element {
		lhs[narrowcast(point: row, shape: lhs.rows), narrowcast(point: col, shape: lhs.cols)] ||
		rhs[narrowcast(point: row, shape: rhs.rows), narrowcast(point: col, shape: rhs.cols)]
	}
	@usableFromInline
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(lhs: lhs[narrowcast(point: row, shape: lhs.rows), narrowcast(bounds: col, target: cols, source: lhs.cols)],
			  rhs: rhs[narrowcast(point: row, shape: rhs.rows), narrowcast(bounds: col, target: cols, source: rhs.cols)])
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(lhs: lhs[narrowcast(bounds: row, target: rows, source: lhs.rows), narrowcast(point: col, shape: lhs.cols)],
			  rhs: rhs[narrowcast(bounds: row, target: rows, source: rhs.rows), narrowcast(point: col, shape: rhs.cols)])
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[narrowcast(bounds: row, target: rows, source: lhs.rows), narrowcast(bounds: col, target: cols, source: lhs.cols)],
			  rhs: rhs[narrowcast(bounds: row, target: rows, source: rhs.rows), narrowcast(bounds: col, target: cols, source: rhs.cols)])
	}
	@usableFromInline
	var state: Set<SIMD2<Int>> {
		`repeat`(position: lhs.state, count: (rows / lhs.rows, cols / lhs.cols)).union(
			`repeat`(position: rhs.state, count: (rows / rhs.rows, cols / rhs.cols))
		)
	}
}
public func||(_ lhs: some SparseVector<Bool>, _ rhs: some SparseVector<Bool>) -> some SparseVector<Bool> {
	Logical.OR.Vector(lhs: lhs, rhs: rhs)
}
public func||(_ lhs: some SparseMatrix<Bool>, _ rhs: some SparseMatrix<Bool>) -> some SparseMatrix<Bool> {
	Logical.OR.Matrix(lhs: lhs, rhs: rhs)
}
