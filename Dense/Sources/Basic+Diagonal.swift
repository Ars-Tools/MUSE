//
//  Basic+Diagonal.swift
//  MUSE
//
//  Created by Kota on 9/18/R7.
//
import typealias Layout.MemoryStrategy
import protocol Accelerate.AccelerateBuffer
extension Basic {
	@usableFromInline
	struct Diagonal<Source: Tensor<Element>> {
		@usableFromInline typealias R = Source.R
		@usableFromInline typealias S = Diagonal<Source.S>
		@usableFromInline typealias U = Source.U
		@usableFromInline let source: Source
	}
}
extension Basic.Diagonal: Vector {
	@usableFromInline
	var count: Int {
		source.shape.min() ?? 1
	}
	@usableFromInline
	subscript(position: Int) -> U {
		source[repeatElement(position, count: source.shape.count)]
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(source: source[repeatElement(bounds, count: source.shape.count)])
	}
	@inlinable
	func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R) {
        switch try source.evaluation(for: strategy) {
		case (let stride, let kernel):
			([stride.reduce(0, +)], kernel)
		}
	}
}
extension Basic.Diagonal: InstantVector & InstantTensor where Source: InstantTensor {
	@inlinable
	func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        switch try source.evaluation(for: strategy) {
		case (let stride, let kernel):
			([stride.reduce(0, +)], kernel)
		}
	}
}
