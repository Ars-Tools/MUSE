//
//  Logical+DOT.swift
//  MUSE
//
//  Created by Kota on 9/12/R7.
//
import protocol Accelerate.AccelerateBuffer
import protocol Dense.Matrix
import typealias Layout.MemoryStrategy
import func Layout.product
extension Logical {
	@usableFromInline
	@frozen enum DOT {
		@usableFromInline
		@frozen struct Outer<LHS: SparseVector<Bool>, RHS: SparseVector<Bool>> {
			@usableFromInline typealias Element = Bool
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias S = Outer<LHS.S, RHS.S>
			@usableFromInline typealias T = Outer<RHS.T, LHS.T>
			@usableFromInline typealias U = Element
			@usableFromInline typealias V = VSK
			@usableFromInline let lhs: LHS
			@usableFromInline let rhs: RHS
		}
		@usableFromInline
		@frozen struct Diagonal<LHS: SparseMatrix<Bool>, RHS: SparseMatrix<Bool>> {
			@usableFromInline typealias Element = Bool
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias S = Diagonal<LHS.S, RHS.S>
			@usableFromInline typealias U = Element
			@usableFromInline let lhs: LHS
			@usableFromInline let rhs: RHS
		}
		@usableFromInline
		@frozen struct MV<LHS: SparseMatrix<Bool>, RHS: SparseVector<Bool>> {
			@usableFromInline typealias Element = Bool
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias S = MV<LHS.S, RHS>
			@usableFromInline typealias U = Element
			@usableFromInline let lhs: LHS
			@usableFromInline let rhs: RHS
		}
		@usableFromInline
		@frozen struct VM<LHS: SparseVector<Bool>, RHS: SparseMatrix<Bool>> {
			@usableFromInline typealias Element = Bool
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias S = VM<LHS, RHS.S>
			@usableFromInline typealias U = Element
			@usableFromInline let lhs: LHS
			@usableFromInline let rhs: RHS
		}
		@usableFromInline
		@frozen struct MM<LHS: SparseMatrix<Bool>, RHS: SparseMatrix<Bool>> {
			@usableFromInline typealias Element = Bool
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias S = MM<LHS.S, RHS.S>
			@usableFromInline typealias T = MM<RHS.T, LHS.T>
			@usableFromInline typealias U = Element
			@usableFromInline typealias V = ANY
			@usableFromInline let lhs: LHS
			@usableFromInline let rhs: RHS
		}
	}
}
extension Logical.DOT.Outer: SparseMatrix {
	@inlinable var rows: Int { lhs.count }
	@inlinable var cols: Int { rhs.count }
	@usableFromInline
	var transpose: T {
		.init(lhs: rhs.transpose, rhs: lhs.transpose)
	}
	@usableFromInline
	var diagonal: V {
		.init(count: min(lhs.count, rhs.count), state: lhs.state.intersection(rhs.state))
	}
	@inlinable
	subscript(row: Int, col: Int) -> Element {
		!lhs.state.intersection(rhs.state).isEmpty
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		let lhs = lhs[row]
		return.init(count: lhs.count, state: rhs[col] ? .init() : lhs.state)
	}
	@usableFromInline
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		let rhs = rhs[col]
		return.init(count: rhs.count, state: lhs[row] ? .init() : rhs.state)
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[row], rhs: rhs[col])
	}
	@usableFromInline
	var state: Set<SIMD2<Int>> {
		.init(product(lhs.state, rhs.state))
	}
}
extension Logical.DOT.Diagonal: SparseVector {
	@inlinable
	var count: Int {
		min(lhs.rows, rhs.cols)
	}
	@inlinable
	subscript(position: Int) -> Element {
		true
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[bounds, 0...], rhs: rhs[0..., bounds])
	}
	@usableFromInline
	var state: Set<Int> {
		let lhs = lhs.state.reduce(into: Dictionary<Int, Set<Int>>()) {
			$0[$1.x, default: .init()].insert($1.y)
		}
		let rhs = rhs.state.reduce(into: Dictionary<Int, Set<Int>>()) {
			$0[$1.y, default: .init()].insert($1.x)
		}
		return Set(lhs.keys).intersection(rhs.keys).filter {
			!lhs[$0, default: .init()].intersection(rhs[$0, default: .init()]).isEmpty
		}
	}
}
extension Logical.DOT.MV: SparseVector {
	@inlinable
	var count: Int { lhs.rows }
	@inlinable
	subscript(position: Int) -> Element {
		lhs[position, 0...] • rhs
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[bounds, 0...], rhs: rhs)
	}
	@usableFromInline
	var state: Set<Int> {
		let lhs = lhs.state.reduce(into: Dictionary<Int, Set<Int>>()) {
			$0[$1.y, default: .init()].insert($1.x)
		}
		return.init(rhs.state.lazy.flatMap {
			lhs[$0, default: .init()]
		})
	}
}
extension Logical.DOT.VM: SparseVector {
	@inlinable
	var count: Int { rhs.cols }
	@inlinable
	subscript(position: Int) -> Element {
		lhs • rhs[0..., position]
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(lhs: lhs, rhs: rhs[0..., bounds])
	}
	@usableFromInline
	var state: Set<Int> {
		let rhs = rhs.state.reduce(into: Dictionary<Int, Set<Int>>()) {
			$0[$1.x, default: .init()].insert($1.y)
		}
		return.init(lhs.state.lazy.flatMap {
			rhs[$0, default: .init()]
		})
	}
}
extension Logical.DOT.MM: SparseMatrix {
	@usableFromInline
	var rows: Int { lhs.rows }
	@usableFromInline
	var cols: Int { rhs.cols }
	@usableFromInline
	var transpose: T {
		.init(lhs: rhs.transpose, rhs: lhs.transpose)
	}
	@usableFromInline
	var diagonal: V {
		.init(core: Logical.DOT.Diagonal(lhs: lhs, rhs: rhs))
	}
	@usableFromInline
	subscript(row: Int, col: Int) -> Element {
		!lhs[row, 0...].state.intersection(rhs[0..., col].state).isEmpty
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(core: Logical.DOT.MV(lhs: lhs[row, 0...], rhs: rhs[0..., col]))
	}
	@usableFromInline
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(core: Logical.DOT.VM(lhs: lhs[row, 0...], rhs: rhs[0..., col]))
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[row, 0...], rhs: rhs[0..., col])
	}
	@usableFromInline
	var state: Set<SIMD2<Int>> {
		let lhs = lhs.state.reduce(into: Dictionary<Int, Set<Int>>()) {
			$0[$1.y, default: .init()].insert($1.x)
		}
		let rhs = rhs.state.reduce(into: Dictionary<Int, Set<Int>>()) {
			$0[$1.x, default: .init()].insert($1.y)
		}
		return.init(Set(lhs.keys).intersection(rhs.keys).flatMap {
			product(lhs[$0, default: .init()], rhs[$0, default: .init()])
		})
	}
}
@_disfavoredOverload
public func •(_ lhs: some SparseVector<Bool>, _ rhs: some SparseVector<Bool>) -> Bool {
	precondition(lhs.count == rhs.count, "dot length should be same")
	return !lhs.state.intersection(rhs.state).isEmpty
}
public func •(_ lhs: some SparseMatrix<Bool>, _ rhs: some SparseVector<Bool>) -> some SparseVector<Bool> {
	precondition(lhs.cols == rhs.count, "dot length should be same")
	return Logical.DOT.MV(lhs: lhs, rhs: rhs)
}
public func •(_ lhs: some SparseVector<Bool>, _ rhs: some SparseMatrix<Bool>) -> some SparseVector<Bool> {
	precondition(lhs.count == rhs.rows, "dot length should be same")
	return Logical.DOT.VM(lhs: lhs, rhs: rhs)
}
public func •(_ lhs: some SparseMatrix<Bool>, _ rhs: some SparseMatrix<Bool>) -> some SparseMatrix<Bool> {
	precondition(lhs.cols == rhs.rows, "dot length should be same")
	return Logical.DOT.MM(lhs: lhs, rhs: rhs)
}
public func outer(_ lhs: some SparseVector<Bool>, _ rhs: some SparseVector<Bool>) -> some SparseMatrix<Bool> {
	Logical.DOT.Outer(lhs: lhs, rhs: rhs)
}
