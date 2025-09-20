//
//  Protocol+Matrix.swift
//  MUSE
//
//  Created by Kota on 9/8/R7.
//
extension Matrix {
    @inlinable@inline(__always)
	public var shape: Array<Int> {
		[rows, cols]
	}
    @inlinable@inline(__always)
	public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		self[position[0], position[1]]
	}
    @inlinable@inline(__always)
	public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		self[bounds[0], bounds[1]]
	}
}
extension InstantMatrix {
	
}
extension MutableMatrix {
    @inlinable@inline(__always)
	public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		_read {
			yield self[position[0], position[1]]
		}
		_modify {
			yield &self[position[0], position[1]]
		}
	}
    @inlinable@inline(__always)
	public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		_read {
			yield self[bounds[0], bounds[1]]
		}
		_modify {
			yield &self[bounds[0], bounds[1]]
		}
	}
}
//
