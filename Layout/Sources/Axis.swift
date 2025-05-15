//
//  Axis.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
extension Int: @retroactive RangeExpression {
	@_disfavoredOverload
	@inlinable @inline(__always)
	public func relative<C>(to collection: C) -> Range<Int> where C : Collection, Int == C.Index {
		(self..<self).relative(to: collection)
	}
	@_disfavoredOverload
	@inlinable @inline(__always)
	public func contains(_ element: Int) -> Bool {
		(self..<self).contains(element)
	}
}
