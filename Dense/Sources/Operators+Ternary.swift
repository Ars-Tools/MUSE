//
//  Operators+Ternary.swift
//  MUSE
//
//  Created by Kota on 9/19/R7.
//
import Layout
extension Operators {
	@usableFromInline
	struct Ternary<X: Tensor, Y: Tensor, Z: Tensor, Element: BitwiseCopyable & Sendable> {
		@usableFromInline typealias R = Array<Element>
		@usableFromInline typealias S = Ternary<X.S, Y.S, Z.S, Element>
		@usableFromInline typealias T = Ternary<X.T, Y.T, Z.T, Element>
		@usableFromInline typealias U = Ternary<X.U, Y.U, Z.U, Element>
		@usableFromInline typealias V = Ternary<X.V, Y.V, Z.V, Element>
		@usableFromInline let ƒ: @convention(thin) (UnsafePointer<X.Element>, Int, UnsafePointer<Y.Element>, Int, UnsafePointer<Z.Element>, Int, UnsafeMutablePointer<Element>, Int, Int) -> Void
		@usableFromInline let x: X
		@usableFromInline let y: Y
		@usableFromInline let z: Z
	}
    @usableFromInline
	protocol TernaryScalar: Scalar & TernaryVector & TernaryMatrix & TernaryTensor where X: Scalar, Y: Scalar, Z: Scalar {}
    @usableFromInline
	protocol TernaryVector: Vector & TernaryTensor where S: TernaryVector, T: TernaryVector, U: TernaryScalar, V: TernaryVector, X: Vector, Y: Vector, Z: Vector,
														 S.X == X.S, T.X == X.T, U.X == X.U, V.X == X.V,
														 S.Y == Y.S, T.Y == Y.T, U.Y == Y.U, V.Y == Y.V,
														 S.Z == Z.S, T.Z == Z.T, U.Z == Z.U, V.Z == Z.V {}
    @usableFromInline
	protocol TernaryMatrix: Matrix & TernaryTensor where S: TernaryMatrix, T: TernaryMatrix, U: TernaryScalar, V: TernaryVector, X: Matrix, Y: Matrix, Z: Matrix,
														 S.X == X.S, T.X == X.T, U.X == X.U, V.X == X.V,
														 S.Y == Y.S, T.Y == Y.T, U.Y == Y.U, V.Y == Y.V,
														 S.Z == Z.S, T.Z == Z.T, U.Z == Z.U, V.Z == Z.V {}
    @usableFromInline
	protocol TernaryTensor: Tensor where S: TernaryTensor, T: TernaryTensor, U: TernaryScalar, V: TernaryVector,
										 S.X == X.S, T.X == X.T, U.X == X.U, V.X == X.V,
										 S.Y == Y.S, T.Y == Y.T, U.Y == Y.U, V.Y == Y.V,
										 S.Z == Z.S, T.Z == Z.T, U.Z == Z.U, V.Z == Z.V {
		associatedtype X: Tensor
		associatedtype Y: Tensor
		associatedtype Z: Tensor
		@inlinable var x: X { get }
		@inlinable var y: Y { get }
		@inlinable var z: Z { get }
		@inlinable init(x: X, y: Y, z: Z)
	}
}
extension Operators.Ternary {
	@inlinable@inline(__always)@_transparent
	func`operator`(x: (Array<Int>, Array<Int>), y: (Array<Int>, Array<Int>), z: (Array<Int>, Array<Int>), w: (Array<Int>, Array<Int>)) -> @Sendable (X.R, Y.R, Z.R) -> R {
		let xs = broadcast(target: w.0, source: x.0, stride: x.1)
		let ys = broadcast(target: w.0, source: y.0, stride: y.1)
		let zs = broadcast(target: w.0, source: z.0, stride: z.1)
		let ws = w.1
		let capacity = capacity(alloc: w.0, stride: ws)
		let (length, stride, offset) = flatten(shape: w.0, xs: xs, ys: ys, zs: zs, ws: ws)
		return {
			withUnsafePointer($0, $1, $2) { x, y, z in
					.init(unsafeUninitializedCapacity: capacity) {
						let w = $0.baseAddress.unsafelyUnwrapped
						for offset in offset {
							ƒ(x.advanced(by: offset.x), stride.x,
							  y.advanced(by: offset.y), stride.y,
							  z.advanced(by: offset.z), stride.z,
							  w.advanced(by: offset.w), stride.w,
							  length)
						}
						$1 = $0.count
					}
			}
		}
	}
}
extension Operators.Ternary: Tensor {
	@inlinable@inline(__always)@_transparent
	var shape: Array<Int> {
		broadcast(lhs: x.shape, rhs: y.shape)
	}
	@usableFromInline
	@inline(__always)
	var transpose: T {
		.init(ƒ: ƒ, x: x.transpose, y: y.transpose, z: z.transpose)
	}
	@usableFromInline
	@inline(__always)
	var diagonal: V {
		.init(ƒ: ƒ, x: x.diagonal, y: y.diagonal, z: z.diagonal)
	}
	@usableFromInline
	@inline(__always)
	subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		.init(ƒ: ƒ,
			  x: x[narrowcast(point: position, shape: x.shape)],
			  y: y[narrowcast(point: position, shape: y.shape)],
			  z: z[narrowcast(point: position, shape: z.shape)])
	}
	@usableFromInline
	@inline(__always)
	subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		.init(ƒ: ƒ,
			  x: x[narrowcast(ranges: bounds, target: shape, source: x.shape)],
			  y: y[narrowcast(ranges: bounds, target: shape, source: y.shape)],
			  z: z[narrowcast(ranges: bounds, target: shape, source: z.shape)])
	}
	@usableFromInline
	@inline(__always)
	func evaluation(for strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R) {
        let (xs, xk) = try x.evaluation(for: strategy)
        let (ys, yk) = try y.evaluation(for: strategy)
        let (zs, zk) = try z.evaluation(for: strategy)
		let ws = strategy.stride(for: shape)
		let wk = `operator`(x: (x.shape, xs), y: (y.shape, ys), z: (z.shape, zs), w: (shape, ws))
		return (ws, {await wk(xk(), yk(), zk())})
	}
}
extension Operators.Ternary: InstantScalar where X: InstantScalar, Y: InstantScalar, Z: InstantScalar {
	@usableFromInline
	subscript() -> Element {
		fatalError()
	}
}
extension Operators.Ternary: InstantVector where X: InstantVector, Y: InstantVector, Z: InstantVector {}
extension Operators.Ternary: InstantMatrix where X: InstantMatrix, Y: InstantMatrix, Z: InstantMatrix {}
extension Operators.Ternary: InstantTensor where X: InstantTensor, Y: InstantTensor, Z: InstantTensor {
	@usableFromInline
	@inline(__always)
	func evaluation(for strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        let (xs, xk) = try x.evaluation(for: strategy) as (Array<Int>, @Sendable () -> X.R)
        let (ys, yk) = try y.evaluation(for: strategy) as (Array<Int>, @Sendable () -> Y.R)
        let (zs, zk) = try z.evaluation(for: strategy) as (Array<Int>, @Sendable () -> Z.R)
		let ws = strategy.stride(for: shape)
		let wk = `operator`(x: (x.shape, xs), y: (y.shape, ys), z: (z.shape, zs), w: (shape, ws))
		return (ws, {wk(xk(), yk(), zk())})
	}
}
extension Operators.Ternary: Matrix where X: Matrix, Y: Matrix, Z: Matrix {
	@inlinable@inline(__always)@_transparent
	var rows: Int {
		broadcast(x: x.rows, y: y.rows)
	}
	@inlinable@inline(__always)@_transparent
	var cols: Int {
		broadcast(x: x.cols, y: y.cols)
	}
	@usableFromInline@inline(__always)
	subscript(row: Int, col: Int) -> U {
		.init(ƒ: ƒ,
			  x: x[narrowcast(point: row, shape: x.rows), narrowcast(point: col, shape: x.cols)],
			  y: y[narrowcast(point: row, shape: y.rows), narrowcast(point: col, shape: y.cols)],
			  z: z[narrowcast(point: row, shape: z.rows), narrowcast(point: col, shape: z.cols)])
	}
	@usableFromInline@inline(__always)
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(ƒ: ƒ,
			  x: x[narrowcast(point: row, shape: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
			  y: y[narrowcast(point: row, shape: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)],
			  z: z[narrowcast(point: row, shape: z.rows), narrowcast(bounds: col, target: cols, source: z.cols)])
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(ƒ: ƒ,
			  x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(point: col, shape: x.cols)],
			  y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(point: col, shape: y.cols)],
			  z: z[narrowcast(bounds: row, target: rows, source: z.rows), narrowcast(point: col, shape: z.cols)])
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(ƒ: ƒ,
			  x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
			  y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)],
			  z: z[narrowcast(bounds: row, target: rows, source: z.rows), narrowcast(bounds: col, target: cols, source: z.cols)])
	}
}
extension Operators.Ternary: Vector where X: Vector, Y: Vector, Z: Vector {
	@inlinable@inline(__always)@_transparent
	var count: Int {
		broadcast(x: x.count, y: y.count)
	}
	@usableFromInline@inline(__always)
	subscript(position: Int) -> U {
		.init(ƒ: ƒ,
			  x: x[narrowcast(point: position, shape: x.count)],
			  y: y[narrowcast(point: position, shape: y.count)],
			  z: z[narrowcast(point: position, shape: z.count)])
	}
	@usableFromInline@inline(__always)
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(ƒ: ƒ,
			  x: x[narrowcast(bounds: bounds, target: count, source: x.count)],
			  y: y[narrowcast(bounds: bounds, target: count, source: y.count)],
			  z: z[narrowcast(bounds: bounds, target: count, source: z.count)])
	}
}
extension Operators.Ternary: Scalar where X: Scalar, Y: Scalar, Z: Scalar {}
