//
//  Buffer+Matrix.swift
//  MUSE
//
//  Created by Kota on 5/26/R7.
//
public struct MatrixBuffer<R: RandomAccessCollection> where R.Index == Int, R.Element: BitwiseCopyable & Sendable & Numeric {
	public let rows: Int
	public let cols: Int
	@usableFromInline let ldr: Int
	@usableFromInline let ldc: Int
	@usableFromInline
	private(set) var store: R
	@inlinable
	public init(shape: (Int, Int), stride: (Int, Int), buffer: R) {
		assert(max(shape.0 * stride.1, shape.1 * stride.0) <= buffer.count)
		(rows, cols) = shape
		(ldr, ldc) = stride
		store = buffer
	}
}
