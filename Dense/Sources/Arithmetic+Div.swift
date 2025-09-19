//
//  Arithmetic+Div.swift
//  MUSE
//
//  Created by Kota on 9/17/R7.
//
import Layout
extension Arithmetic {
	@usableFromInline
	struct Div<LHS: Tensor<Element>, RHS: Tensor<Element>> {
		@usableFromInline typealias R = Array<Element>
		@usableFromInline typealias S = Div<LHS.S, RHS.S>
		@usableFromInline typealias T = Div<LHS.T, RHS.T>
		@usableFromInline typealias U = Div<LHS.U, RHS.U>
		@usableFromInline typealias V = Div<LHS.V, RHS.V>
		@usableFromInline let lhs: LHS
		@usableFromInline let rhs: RHS
	}
}
extension Arithmetic.Div {
	@inlinable
	func`operator`(x: (Array<Int>, Array<Int>), y: (Array<Int>, Array<Int>), z: (Array<Int>, Array<Int>)) -> @Sendable (LHS.R, RHS.R) -> R {
		let xs = broadcast(target: z.0, source: x.0, stride: x.1)
		let ys = broadcast(target: z.0, source: y.0, stride: y.1)
		let capacity = capacity(alloc: z.0, stride: z.1)
		let (length, stride, offset) = flatten(shape: z.0, xs: xs, ys: ys, zs: z.1)
		return {
			withUnsafePointer($0, $1) { x, y in
					.init(unsafeUninitializedCapacity: capacity) {
						let z = $0.baseAddress.unsafelyUnwrapped
						for offset in offset {
							Element.Div(x: x.advanced(by: offset.x), ldx: stride.x,
										y: y.advanced(by: offset.y), ldy: stride.y,
										z: z.advanced(by: offset.z), ldz: stride.z,
										length: length)
						}
						$1 = $0.count
					}
			}
		}
	}
}
extension Arithmetic.Div: Tensor {
	@inlinable@inline(__always)@_transparent
	var shape: Array<Int> {
		broadcast(lhs: lhs.shape, rhs: rhs.shape)
	}
	@usableFromInline
	@inline(__always)
	var transpose: T {
		.init(lhs: lhs.transpose, rhs: rhs.transpose)
	}
	@usableFromInline
	@inline(__always)
	var diagonal: V {
		.init(lhs: lhs.diagonal, rhs: rhs.diagonal)
	}
	@usableFromInline
	@inline(__always)
	subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		.init(lhs: lhs[narrowcast(point: position, shape: lhs.shape)],
			  rhs: rhs[narrowcast(point: position, shape: rhs.shape)])
	}
	@usableFromInline
	@inline(__always)
	subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		.init(lhs: lhs[narrowcast(ranges: bounds, target: shape, source: lhs.shape)],
			  rhs: rhs[narrowcast(ranges: bounds, target: shape, source: rhs.shape)])
	}
	@usableFromInline
	@inline(__always)
	func callAsFunction(for strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
		switch try (lhs(for: strategy), rhs(for: strategy)) {
		case ((let xs, let xm), (let ys, let ym)):
			let zs = strategy.stride(for: shape)
			let zm = `operator`(x: (lhs.shape, xs), y: (rhs.shape, ys), z: (shape, zs))
			return (zs, {await zm(xm(), ym())})
		}
	}
}
extension Arithmetic.Div: Immediate where LHS: Immediate, RHS: Immediate {
	@usableFromInline
	@inline(__always)
	func callAsFunction(for strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
		switch try (lhs(for: strategy), rhs(for: strategy)) {
		case ((let xs, let xm), (let ys, let ym)):
			let zs = strategy.stride(for: shape)
			let zm = `operator`(x: (lhs.shape, xs), y: (rhs.shape, ys), z: (shape, zs))
			return (zs, {zm(xm(), ym())})
		}
	}
}
extension Arithmetic.Div: Scalar where LHS: Scalar, RHS: Scalar {}
extension Arithmetic.Div: Vector where LHS: Vector, RHS: Vector {
	@inlinable@inline(__always)@_transparent
	var count: Int {
		broadcast(x: lhs.count, y: rhs.count)
	}
	@usableFromInline@inline(__always)
	subscript(position: Int) -> U {
		.init(lhs: lhs[narrowcast(point: position, shape: count)],
			  rhs: rhs[narrowcast(point: position, shape: count)])
	}
	@usableFromInline@inline(__always)
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[narrowcast(bounds: bounds, target: count, source: lhs.count)],
			  rhs: rhs[narrowcast(bounds: bounds, target: count, source: rhs.count)])
	}
}
extension Arithmetic.Div: Matrix where LHS: Matrix, RHS: Matrix {
	@inlinable@inline(__always)@_transparent
	var rows: Int {
		broadcast(x: lhs.rows, y: rhs.rows)
	}
	@inlinable@inline(__always)@_transparent
	var cols: Int {
		broadcast(x: lhs.cols, y: rhs.cols)
	}
	@usableFromInline@inline(__always)
	subscript(row: Int, col: Int) -> U {
		.init(lhs: lhs[narrowcast(point: row, shape: lhs.rows), narrowcast(point: col, shape: lhs.cols)],
			  rhs: rhs[narrowcast(point: row, shape: rhs.rows), narrowcast(point: col, shape: rhs.cols)])
	}
	@usableFromInline@inline(__always)
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(lhs: lhs[narrowcast(point: row, shape: lhs.rows), narrowcast(bounds: col, target: cols, source: lhs.cols)],
			  rhs: rhs[narrowcast(point: row, shape: rhs.rows), narrowcast(bounds: col, target: cols, source: rhs.cols)])
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(lhs: lhs[narrowcast(bounds: row, target: rows, source: lhs.rows), narrowcast(point: col, shape: lhs.cols)],
			  rhs: rhs[narrowcast(bounds: row, target: rows, source: rhs.rows), narrowcast(point: col, shape: rhs.cols)])
	}
	@usableFromInline@inline(__always)
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[narrowcast(bounds: row, target: rows, source: lhs.rows), narrowcast(bounds: col, target: cols, source: lhs.cols)],
			  rhs: rhs[narrowcast(bounds: row, target: rows, source: rhs.rows), narrowcast(bounds: col, target: cols, source: rhs.cols)])
	}
}
@_disfavoredOverload
public func /<Element: ArithmeticElement>(_ lhs: some Scalar<Element>, _ rhs: some Scalar<Element>) -> some Scalar<Element> {
	Arithmetic.Div(lhs: lhs, rhs: rhs)
}
@_disfavoredOverload
public func /<Element: ArithmeticElement>(_ lhs: some Vector<Element>, _ rhs: some Vector<Element>) -> some Vector<Element> {
	Arithmetic.Div(lhs: lhs, rhs: rhs)
}
@_disfavoredOverload
public func /<Element: ArithmeticElement>(_ lhs: some Matrix<Element>, _ rhs: some Matrix<Element>) -> some Matrix<Element> {
	Arithmetic.Div(lhs: lhs, rhs: rhs)
}
@_disfavoredOverload
public func /<Element: ArithmeticElement>(_ lhs: some Tensor<Element>, _ rhs: some Tensor<Element>) -> some Tensor<Element> {
	Arithmetic.Div(lhs: lhs, rhs: rhs)
}
@_disfavoredOverload
public func /<Element: ArithmeticElement>(_ lhs: some Scalar<Element> & Immediate, _ rhs: some Scalar<Element> & Immediate) -> some Scalar<Element> & Immediate {
	Arithmetic.Div(lhs: lhs, rhs: rhs)
}
@_disfavoredOverload
public func /<Element: ArithmeticElement>(_ lhs: some Vector<Element> & Immediate, _ rhs: some Vector<Element> & Immediate) -> some Vector<Element> & Immediate {
	Arithmetic.Div(lhs: lhs, rhs: rhs)
}
@_disfavoredOverload
public func /<Element: ArithmeticElement>(_ lhs: some Matrix<Element> & Immediate, _ rhs: some Matrix<Element> & Immediate) -> some Matrix<Element> & Immediate {
	Arithmetic.Div(lhs: lhs, rhs: rhs)
}
@_disfavoredOverload
public func /<Element: ArithmeticElement>(_ lhs: some Tensor<Element> & Immediate, _ rhs: some Tensor<Element> & Immediate) -> some Tensor<Element> & Immediate {
	Arithmetic.Div(lhs: lhs, rhs: rhs)
}
