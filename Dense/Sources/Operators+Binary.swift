//
//  Operators+Binary.swift
//  MUSE
//
//  Created by Kota on 9/19/R7.
//
import Layout
extension Operators {
	@usableFromInline
	struct Binary<X: Tensor, Y: Tensor, Element: BitwiseCopyable & Sendable> {
		@usableFromInline typealias R = Array<Element>
		@usableFromInline typealias S = Binary<X.S, Y.S, Element>
		@usableFromInline typealias T = Binary<X.T, Y.T, Element>
		@usableFromInline typealias U = Binary<X.U, Y.U, Element>
		@usableFromInline typealias V = Binary<X.V, Y.V, Element>
		@usableFromInline let ƒ: @convention(thin) (UnsafePointer<X.Element>, Int, UnsafePointer<Y.Element>, Int, UnsafeMutablePointer<Element>, Int, Int) -> Void
		@usableFromInline let x: X
		@usableFromInline let y: Y
	}
	@usableFromInline
	protocol BinaryScalar<Element>: Scalar & BinaryVector & BinaryMatrix & BinaryTensor where X: Scalar, Y: Scalar {}
	@usableFromInline
	protocol BinaryVector<Element>: Vector & BinaryTensor where S: BinaryVector, T: BinaryVector, U: BinaryScalar, V: BinaryVector, X: Vector, Y: Vector,
																S.X == X.S, T.X == X.T, U.X == X.U, V.X == X.V,
																S.Y == Y.S, T.Y == Y.T, U.Y == Y.U, V.Y == Y.V {}
	@usableFromInline
	protocol BinaryMatrix<Element>: Matrix & BinaryTensor where S: BinaryMatrix, T: BinaryMatrix, U: BinaryScalar, V: BinaryVector, X: Matrix, Y: Matrix,
																S.X == X.S, T.X == X.T, U.X == X.U, V.X == X.V,
																S.Y == Y.S, T.Y == Y.T, U.Y == Y.U, V.Y == Y.V {}
	@usableFromInline
	protocol BinaryTensor<Element>: Tensor where S: BinaryTensor, T: BinaryTensor, U: BinaryScalar, V: BinaryVector,
												 S.X == X.S, T.X == X.T, U.X == X.U, V.X == X.V,
												 S.Y == Y.S, T.Y == Y.T, U.Y == Y.U, V.Y == Y.V {
		associatedtype X: Tensor
		associatedtype Y: Tensor
		@inlinable var x: X { get }
		@inlinable var y: Y { get }
		@inlinable init(x: X, y: Y)
	}
}
extension Operators.BinaryScalar {}
extension Operators.BinaryVector {
	@usableFromInline@inline(__always)
	var count: Int {
		broadcast(x: x.count, y: y.count)
	}
	@usableFromInline@inline(__always)
	subscript(position: Int) -> U {
		.init(x: x[narrowcast(point: position, shape: x.count)],
			  y: y[narrowcast(point: position, shape: y.count)])
	}
	@usableFromInline@inline(__always)
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(x: x[narrowcast(bounds: bounds, target: count, source: x.count)],
			  y: y[narrowcast(bounds: bounds, target: count, source: y.count)])
	}
}
extension Operators.BinaryMatrix {
	@usableFromInline@inline(__always)@_transparent
	var rows: Int {
		broadcast(x: x.rows, y: y.rows)
	}
	@usableFromInline@inline(__always)@_transparent
	var cols: Int {
		broadcast(x: x.cols, y: y.cols)
	}
	@usableFromInline@inline(__always)
	subscript(row: Int, col: Int) -> U {
		.init(x: x[narrowcast(point: row, shape: x.rows), narrowcast(point: col, shape: x.cols)],
			  y: y[narrowcast(point: row, shape: y.rows), narrowcast(point: col, shape: y.cols)])
	}
	@usableFromInline@inline(__always)
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(x: x[narrowcast(point: row, shape: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
			  y: y[narrowcast(point: row, shape: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)])
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(point: col, shape: x.cols)],
			  y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(point: col, shape: y.cols)])
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
			  y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)])
	}
}
extension Operators.BinaryTensor {
	@usableFromInline@inline(__always)@_transparent
	var shape: Array<Int> {
		broadcast(lhs: x.shape, rhs: y.shape)
	}
	@usableFromInline@inline(__always)
	var transpose: T {
		.init(x: x.transpose,
			  y: y.transpose)
	}
	@usableFromInline@inline(__always)
	var diagonal: V {
		.init(x: x.diagonal,
			  y: y.diagonal)
	}
	@usableFromInline@inline(__always)
	subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		.init(x: x[narrowcast(point: position, shape: x.shape)],
			  y: y[narrowcast(point: position, shape: y.shape)])
	}
	@usableFromInline@inline(__always)
	subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		.init(x: x[narrowcast(ranges: bounds, target: shape, source: x.shape)],
			  y: y[narrowcast(ranges: bounds, target: shape, source: y.shape)])
	}
}
extension Operators.Binary {
    @inlinable@inline(__always)@_transparent
    func`operator`(x: (Array<Int>, Array<Int>), y: (Array<Int>, Array<Int>), z: (Array<Int>, Array<Int>)) -> @Sendable (X.R, Y.R) -> R {
        let xs = broadcast(target: z.0, source: x.0, stride: x.1)
        let ys = broadcast(target: z.0, source: y.0, stride: y.1)
        let zs = z.1
        let capacity = capacity(alloc: z.0, stride: zs)
        let (length, stride, offset) = flatten(shape: z.0, xs: xs, ys: ys, zs: zs)
        return {
            withUnsafePointer($0, $1) { x, y in
                    .init(unsafeUninitializedCapacity: capacity) {
                        let z = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            ƒ(x.advanced(by: offset.x), stride.x,
                              y.advanced(by: offset.y), stride.y,
                              z.advanced(by: offset.z), stride.z,
                              length)
                        }
                        $1 = $0.count
                    }
            }
        }
    }
}
extension Operators.Binary: Tensor {
	@inlinable@inline(__always)@_transparent
	var shape: Array<Int> {
		broadcast(lhs: x.shape, rhs: y.shape)
	}
	@usableFromInline@inline(__always)
	var transpose: T {
		.init(ƒ: ƒ, x: x.transpose, y: y.transpose)
	}
	@usableFromInline@inline(__always)
	var diagonal: V {
		.init(ƒ: ƒ, x: x.diagonal, y: y.diagonal)
	}
	@usableFromInline@inline(__always)
	subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		.init(ƒ: ƒ,
			  x: x[narrowcast(point: position, shape: x.shape)],
			  y: y[narrowcast(point: position, shape: y.shape)])
	}
	@usableFromInline@inline(__always)
	subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		.init(ƒ: ƒ,
			  x: x[narrowcast(ranges: bounds, target: shape, source: x.shape)],
			  y: y[narrowcast(ranges: bounds, target: shape, source: y.shape)])
	}
	@usableFromInline@inline(__always)
	func callAsFunction(as strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R) {
		let (xs, xk) = try x(as: strategy)
		let (ys, yk) = try y(as: strategy)
		let zs = strategy.stride(for: shape)
		let zk = `operator`(x: (x.shape, xs), y: (y.shape, ys), z: (shape, zs))
		return (zs, {await zk(xk(), yk())})
	}
}
extension Operators.Binary: InstantScalar where X: InstantScalar, Y: InstantScalar {}
extension Operators.Binary: InstantVector where X: InstantVector, Y: InstantVector {}
extension Operators.Binary: InstantMatrix where X: InstantMatrix, Y: InstantMatrix {}
extension Operators.Binary: InstantTensor where X: InstantTensor, Y: InstantTensor {
	@usableFromInline@inline(__always)
	func callAsFunction(by strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
		let (xs, xk) = try x(by: strategy)// as (Array<Int>, @Sendable () -> X.R)
		let (ys, yk) = try y(by: strategy)// as (Array<Int>, @Sendable () -> Y.R)
		let zs = strategy.stride(for: shape)
		let zk = `operator`(x: (x.shape, xs), y: (y.shape, ys), z: (shape, zs))
		return (zs, {zk(xk(), yk())})
	}
}
extension Operators.Binary: Matrix where X: Matrix, Y: Matrix {
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
			  y: y[narrowcast(point: row, shape: y.rows), narrowcast(point: col, shape: y.cols)])
	}
	@usableFromInline@inline(__always)
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(ƒ: ƒ,
			  x: x[narrowcast(point: row, shape: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
			  y: y[narrowcast(point: row, shape: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)])
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(ƒ: ƒ,
			  x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(point: col, shape: x.cols)],
			  y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(point: col, shape: y.cols)])
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(ƒ: ƒ,
			  x: x[narrowcast(bounds: row, target: rows, source: x.rows), narrowcast(bounds: col, target: cols, source: x.cols)],
			  y: y[narrowcast(bounds: row, target: rows, source: y.rows), narrowcast(bounds: col, target: cols, source: y.cols)])
	}
}
extension Operators.Binary: Vector where X: Vector, Y: Vector {
	@inlinable@inline(__always)@_transparent
	var count: Int {
		broadcast(x: x.count, y: y.count)
	}
	@usableFromInline@inline(__always)
	subscript(position: Int) -> U {
		.init(ƒ: ƒ,
			  x: x[narrowcast(point: position, shape: x.count)],
			  y: y[narrowcast(point: position, shape: y.count)])
	}
	@usableFromInline@inline(__always)
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(ƒ: ƒ,
			  x: x[narrowcast(bounds: bounds, target: count, source: x.count)],
			  y: y[narrowcast(bounds: bounds, target: count, source: y.count)])
	}
}
extension Operators.Binary: Scalar where X: Scalar, Y: Scalar {}
