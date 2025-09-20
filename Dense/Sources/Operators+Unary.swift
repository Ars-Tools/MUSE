//
//  Operators+Unary.swift
//  MUSE
//
//  Created by Kota on 9/19/R7.
//
import Accelerate
import Layout
extension Operators {
	@usableFromInline
	struct Unary<X: Tensor, Element: BitwiseCopyable & Sendable> {
		@usableFromInline typealias R = Array<Element>
		@usableFromInline typealias S = Unary<X.S, Element>
		@usableFromInline typealias T = Unary<X.T, Element>
		@usableFromInline typealias U = Unary<X.U, Element>
		@usableFromInline typealias V = Unary<X.V, Element>
		@usableFromInline let x: X
		@usableFromInline let ƒ: @Sendable (UnsafePointer<X.Element>, Int, UnsafeMutablePointer<Element>, Int, Int) -> Void
	}
    @usableFromInline
	protocol UnaryScalar: Scalar & UnaryVector & UnaryMatrix & UnaryTensor where X: Scalar {}
    @usableFromInline
	protocol UnaryVector: Vector & UnaryTensor where S: UnaryVector, T: UnaryVector, U: UnaryScalar, V: UnaryVector, X: Vector,
													 S.X == X.S, T.X == X.T, U.X == X.U, V.X == X.V {}
    @usableFromInline
	protocol UnaryMatrix: Matrix & UnaryTensor where S: UnaryMatrix, T: UnaryMatrix, U: UnaryScalar, V: UnaryVector, X: Matrix,
													 S.X == X.S, T.X == X.T, U.X == X.U, V.X == X.V {}
    @usableFromInline
	protocol UnaryTensor: Tensor where S: UnaryTensor, T: UnaryTensor, U: UnaryScalar, V: UnaryVector,
									   S.X == X.S, T.X == X.T, U.X == X.U, V.X == X.V {
		associatedtype X: Tensor
		@inlinable var x: X { get }
		@inlinable init(x: X)
	}
}
extension Operators.UnaryScalar {}
extension Operators.UnaryVector {
    @inlinable
    var count: Int {
        x.count
    }
    @usableFromInline
    subscript(position: Int) -> U {
        .init(x: x[position])
    }
    @usableFromInline
    subscript(bounds: some RangeExpression<Int>) -> S {
        .init(x: x[bounds])
    }
}
extension Operators.UnaryMatrix {
    @inlinable
    var rows: Int {
        x.rows
    }
    @inlinable
    var cols: Int {
        x.cols
    }
    @usableFromInline
    subscript(row: Int, col: Int) -> U {
        .init(x: x[row, col])
    }
    @usableFromInline
    subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .init(x: x[row, col])
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .init(x: x[row, col])
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        .init(x: x[row, col])
    }
}
extension Operators.UnaryTensor {
	@inlinable
	var shape: Array<Int> {
		x.shape
	}
	@usableFromInline
	var transpose: T {
		.init(x: x.transpose)
	}
	@usableFromInline
	var diagonal: V {
		.init(x: x.diagonal)
	}
	@usableFromInline
	subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		.init(x: x[position])
	}
	@usableFromInline
	subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		.init(x: x[bounds])
	}
}
extension Operators.UnaryTensor {
    
}


extension Operators.Unary {
	@inlinable@inline(__always)@_transparent
	func`operator`(x: (Array<Int>, Array<Int>), y: (Array<Int>, Array<Int>)) -> @Sendable (X.R) -> R {
		let xs = broadcast(target: y.0, source: x.0, stride: x.1)
		let ys = y.1
		let capacity = capacity(alloc: y.0, stride: ys)
		let (length, stride, offset) = flatten(shape: y.0, xs: xs, ys: ys)
		return {
			withUnsafePointer($0) { x in
					.init(unsafeUninitializedCapacity: capacity) {
						let y = $0.baseAddress.unsafelyUnwrapped
						for offset in offset {
							ƒ(x.advanced(by: offset.x), stride.x,
							  y.advanced(by: offset.y), stride.y,
							  length)
						}
						$1 = $0.count
					}
			}
		}
	}
}
extension Operators.Unary: Tensor {
	@inlinable
	var shape: Array<Int> {
		x.shape
	}
	@usableFromInline
	var transpose: T {
		.init(x: x.transpose,
			  ƒ: ƒ)
	}
	@usableFromInline
	var diagonal: V {
		.init(x: x.diagonal,
			  ƒ: ƒ)
	}
	@usableFromInline
	subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		.init(x: x[position],
			  ƒ: ƒ)
	}
	@usableFromInline
	subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		.init(x: x[bounds],
			  ƒ: ƒ)
	}
	@inlinable@inline(__always)@_transparent
	func callAsFunction(as strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R) {
		let (xs, xk) = try x(as: strategy)
		let ys = strategy.stride(for: shape)
		let yk = `operator`(x: (x.shape, xs), y: (shape, ys))
		return (ys, {await yk(xk())})
	}
}
extension Operators.Unary: InstantScalar where X: InstantScalar {}
extension Operators.Unary: InstantVector where X: InstantVector {}
extension Operators.Unary: InstantMatrix where X: InstantMatrix {}
extension Operators.Unary: InstantTensor where X: InstantTensor {
	@inlinable@inline(__always)@_transparent
	func callAsFunction(by strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
		let (xs, xk) = try x(by: strategy) as (Array<Int>, @Sendable () -> X.R)
		let ys = strategy.stride(for: shape)
		let yk = `operator`(x: (x.shape, xs), y: (shape, ys))
		return (ys, {yk(xk())})
	}
}
extension Operators.Unary: Matrix where X: Matrix {
	@inlinable
	var rows: Int {
		x.rows
	}
	@inlinable
	var cols: Int {
		x.cols
	}
	@usableFromInline
	subscript(row: Int, col: Int) -> U {
		.init(x: x[row, col],
			  ƒ: ƒ)
	}
	@usableFromInline
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(x: x[row, col],
			  ƒ: ƒ)
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(x: x[row, col],
			  ƒ: ƒ)
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(x: x[row, col],
			  ƒ: ƒ)
	}
}
extension Operators.Unary: Vector where X: Vector {
	@inlinable
	var count: Int {
		x.count
	}
	@usableFromInline
	subscript(position: Int) -> U {
		.init(x: x[position],
			  ƒ: ƒ)
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(x: x[bounds],
			  ƒ: ƒ)
	}
}
extension Operators.Unary: Scalar where X: Scalar {}
