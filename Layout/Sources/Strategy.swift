//
//  Strategy.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
@_exported import enum Accelerate.AccelerateMatrixOrder
public typealias MemoryStrategy = AccelerateMatrixOrder
extension MemoryStrategy {
	@inlinable
	public var transpose: Self {
		switch self {
		case.rowMajor:
			.columnMajor
		case.columnMajor:
			.rowMajor
		}
	}
}
extension MemoryStrategy {
	public func stride(for shape: some BidirectionalCollection<Int>) -> Array<Int> {
		switch self {
		case.columnMajor:
			.init(sequence(state: (1, shape.makeIterator())) { state in
				state.1.next().map { value in
					defer {
						state.0 *= value
					}
					return state.0
				}
			})
		case.rowMajor:
			sequence(state: (1, shape.reversed().makeIterator())) { state in
				state.1.next().map { value in
					defer {
						state.0 *= value
					}
					return state.0
				}
			}.reversed()
		}
	}
}
