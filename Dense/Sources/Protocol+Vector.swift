//
//  Protocol+Vector.swift
//  MUSE
//
//  Created by Kota on 9/8/R7.
//
extension Vector {
    @inlinable@inline(__always)
	public var shape: Array<Int> {
		[count]
	}
    @inlinable@inline(__always)
	public var transpose: Self {
		self
	}
    @inlinable@inline(__always)
	public var diagonal: Self {
		self
	}
    @inlinable@inline(__always)
	public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		self[position.last.unsafelyUnwrapped]
	}
	@inlinable
	public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		self[bounds.last.unsafelyUnwrapped]
	}
}
extension InstantVector {
	
}
extension MutableVector {
    @inlinable@inline(__always)
	public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		_read {
			yield self[position.last.unsafelyUnwrapped]
		}
		_modify {
			yield &self[position.last.unsafelyUnwrapped]
		}
	}
    @inlinable@inline(__always)
	public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		_read {
			yield self[bounds.last.unsafelyUnwrapped]
		}
		_modify {
			yield &self[bounds.last.unsafelyUnwrapped]
		}
	}
}
//
