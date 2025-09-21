//
//  Basic+Transpose.swift
//  MUSE
//
//  Created by Kota on 9/18/R7.
//
import typealias Layout.MemoryStrategy
import protocol Accelerate.AccelerateBuffer
extension Basic {
	@usableFromInline
	struct Transpose<Source: Tensor<Element>> {
		@usableFromInline typealias R = Source.R
		@usableFromInline typealias S = Source.S
		@usableFromInline typealias T = Source
		@usableFromInline typealias U = Source.U
		@usableFromInline typealias V = Source.V
		@usableFromInline let source: Source
	}
}
extension Basic.Transpose: Tensor {
	@inlinable
	var shape: Array<Int> {
		source.shape.reversed()
	}
	@inlinable
	var transpose: T {
		source
	}
	@inlinable
	var diagonal: V {
		source.diagonal
	}
	@inlinable
	subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		source[position.reversed()]
	}
	@inlinable
	subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		source[bounds.reversed()]
	}
	@inlinable
	func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R) {
        switch try source.evaluation(for: strategy) {
		case (let stride, let kernel):
			(stride.reversed(), kernel)
		}
	}
}
extension Basic.Transpose: Matrix where Source: Matrix {
	@inlinable
	var rows: Int {
		source.cols
	}
	@inlinable
	var cols: Int {
		source.rows
	}
	@inlinable
	subscript(row: Int, col: Int) -> U {
		source[col, row]
	}
	@inlinable
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		source[col, row]
	}
	@inlinable
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		source[col, row]
	}
	@inlinable
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		source[col, row]
	}
}
extension Basic.Transpose: InstantMatrix where Source: InstantMatrix {}
extension Basic.Transpose: InstantTensor where Source: InstantTensor {
	@inlinable
	func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        switch try source.evaluation(for: strategy) as (Array<Int>, @Sendable () -> R) {
		case (let stride, let kernel):
			(stride.reversed(), kernel)
		}
	}
}
