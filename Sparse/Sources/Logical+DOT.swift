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
		@frozen struct DD<LHS: SparseMatrix<Bool>, RHS: SparseMatrix<Bool>> {
			@usableFromInline typealias Element = Bool
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias S = DD<LHS.S, RHS.S>
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
        @frozen enum VV<X: SparseMatrix<Bool>, Y: SparseMatrix<Bool>> {
            case DD(X, Y)
            case MV(X, Y)
            case VM(X, Y)
        }
		@usableFromInline
		@frozen struct MM<LHS: SparseMatrix<Bool>, RHS: SparseMatrix<Bool>> {
			@usableFromInline typealias Element = Bool
			@usableFromInline typealias R = Array<Element>
			@usableFromInline typealias S = MM<LHS.S, RHS.S>
			@usableFromInline typealias T = MM<RHS.T, LHS.T>
			@usableFromInline typealias U = Element
            @usableFromInline typealias V = VV<LHS.S, RHS.S>
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
extension Logical.DOT.DD: SparseVector {
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
extension Logical.DOT.VV: SparseVector {
    @usableFromInline typealias R = Array<Bool>
    @usableFromInline typealias S = Logical.DOT.VV<X.S, Y.S>
    @usableFromInline typealias U = Bool
    @inlinable
    var count: Int {
        switch self {
        case.DD(let x, let y):
            min(x.rows, y.cols)
        case.MV(let x, _):
            x.rows
        case.VM(_, let y):
            y.cols
        }
    }
    @usableFromInline
    subscript(position: Int) -> U {
        switch self {
        case.DD(let x, let y):
            x[position, 0...] • y[0..., position]
        case.MV(let x, let y):
            x[position, 0...] • y[0..., 0]
        case.VM(let x, let y):
            x[0, 0...] • y[0..., position]
        }
    }
    @usableFromInline
    subscript(bounds: some RangeExpression<Int>) -> S {
        switch self {
        case.DD(let x, let y):
            .DD(x[bounds, 0...], y[0..., bounds])
        case.MV(let x, let y):
            .MV(x[bounds, 0...], y[0..., 0...])
        case.VM(let x, let y):
            .VM(x[0..., 0...], y[0..., bounds])
        }
    }
    @usableFromInline
    var state: Set<Int> {
        switch self {
        case.DD(let x, let y):
            Logical.DOT.DD(lhs: x, rhs: y).state
        case.MV(let x, let y):
            Logical.DOT.MV(lhs: x, rhs: y[0..., 0]).state
        case.VM(let x, let y):
            Logical.DOT.VM(lhs: x[0, 0...], rhs: y).state
        }
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
        .DD(lhs[0..., 0...], rhs[0..., 0...])
	}
	@usableFromInline
	subscript(row: Int, col: Int) -> Element {
		!lhs[row, 0...].state.intersection(rhs[0..., col].state).isEmpty
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .MV(lhs[row, 0...], rhs[0..., col...col])
	}
	@usableFromInline
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .VM(lhs[row...row, 0...], rhs[0..., col])
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
