//
//  Arithmetic+Scale.swift
//  MUSE
//
//  Created by Kota on 9/17/R7.
//
import Layout
extension Arithmetic {
	@usableFromInline
	struct Scale<Factor: Scalar<Element>, Source: Tensor<Element>> {
		@usableFromInline typealias R = Array<Element>
		@usableFromInline typealias S = Scale<Factor, Source.S>
		@usableFromInline typealias T = Scale<Factor, Source.T>
		@usableFromInline typealias U = Scale<Factor, Source.U>
		@usableFromInline typealias V = Scale<Factor, Source.V>
		@usableFromInline let factor: Factor
		@usableFromInline let source: Source
	}
}
extension Arithmetic.Scale: Tensor {
	@inlinable@inline(__always)@_transparent
	var shape: Array<Int> {
		source.shape
	}
	@usableFromInline
	var transpose: T {
		.init(factor: factor, source: source.transpose)
	}
	@usableFromInline
	var diagonal: V {
		.init(factor: factor, source: source.diagonal)
	}
	@usableFromInline
	subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		.init(factor: factor, source: source[position])
	}
	@usableFromInline
	subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		.init(factor: factor, source: source[bounds])
	}
	@usableFromInline@inline(__always)@_transparent
	func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
		let (xs, xk) = try source(for: strategy)
		let (ys, yk) = try factor(for: strategy)
		let capacity = capacity(alloc: source.shape, stride: xs)
		let (length, stride, offset) = flatten(shape: source.shape, xs: xs)
		assert(ys.isEmpty)
		return (xs, {
			await withUnsafePointer(xk(), yk()) { x, y in
				.init(unsafeUninitializedCapacity: capacity) {
					let z = $0.baseAddress.unsafelyUnwrapped
					for offset in offset {
						Element.Scale(x: x.advanced(by: offset), ldx: stride,
									  y: y,
									  z: z.advanced(by: offset), ldz: stride,
									  length: length)
					}
					$1 = $0.count
				}
			}
		})
	}
}
extension Arithmetic.Scale: Immediate where Source: Immediate, Factor: Immediate {
	@usableFromInline@inline(__always)@_transparent
	func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
		let (xs, xk) = try source(for: strategy)
		let (ys, yk) = try factor(for: strategy)
		let capacity = capacity(alloc: source.shape, stride: xs)
		let (length, stride, offset) = flatten(shape: source.shape, xs: xs)
		assert(ys.isEmpty)
		return (xs, {
			withUnsafePointer(xk(), yk()) { x, y in
				.init(unsafeUninitializedCapacity: capacity) {
					let z = $0.baseAddress.unsafelyUnwrapped
					for offset in offset {
						Element.Scale(x: x.advanced(by: offset), ldx: stride,
									  y: y,
									  z: z.advanced(by: offset), ldz: stride,
									  length: length)
					}
					$1 = $0.count
				}
			}
		})
	}
}
extension Arithmetic.Scale: Scalar where Source: Scalar {}
extension Arithmetic.Scale: Vector where Source: Vector {
	@inlinable@inline(__always)@_transparent
	var count: Int {
		source.count
	}
	@usableFromInline
	subscript(position: Int) -> U {
		.init(factor: factor, source: source[position])
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> Arithmetic<Element>.Scale<Factor, Source.S> {
		.init(factor: factor, source: source[bounds])
	}
}
extension Arithmetic.Scale: Matrix where Source: Matrix {
	@inlinable@inline(__always)@_transparent
	var rows: Int {
		source.rows
	}
	@inlinable@inline(__always)@_transparent
	var cols: Int {
		source.cols
	}
	@usableFromInline
	subscript(row: Int, col: Int) -> U {
		.init(factor: factor, source: source[row, col])
	}
	@usableFromInline
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(factor: factor, source: source[row, col])
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(factor: factor, source: source[row, col])
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(factor: factor, source: source[row, col])
	}
}
@_disfavoredOverload
public func *<Element: ArithmeticElement>(_ factor: some Scalar<Element>, _ source: some Vector<Element>) -> some Vector<Element> {
	Arithmetic.Scale(factor: factor, source: source)
}
@_disfavoredOverload
public func *<Element: ArithmeticElement>(_ factor: some Scalar<Element>, _ source: some Matrix<Element>) -> some Matrix<Element> {
	Arithmetic.Scale(factor: factor, source: source)
}
@_disfavoredOverload
public func *<Element: ArithmeticElement>(_ factor: some Scalar<Element>, _ source: some Tensor<Element>) -> some Tensor<Element> {
	Arithmetic.Scale(factor: factor, source: source)
}
