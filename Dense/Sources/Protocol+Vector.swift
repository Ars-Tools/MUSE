//
//  Protocol+Vector.swift
//  MUSE
//
//  Created by Kota on 9/8/R7.
//
public protocol Vector<Element>: Tensor where S: Vector<Element>, U: Scalar<Element>, V == Self, T == Self {
	@inlinable var count: Int { get }
	@inlinable subscript(position: Int) -> U { get }
	@inlinable subscript(bounds: some RangeExpression<Int>) -> S { get }
}
public protocol MutVector<Element>: MutTensor & Vector where S: MutVector<Element> {
	@inlinable subscript(position: Int) -> U { get set }
	@inlinable subscript(bounds: some RangeExpression<Int>) -> S { get set }
}
extension Vector {
	@inlinable
	public var shape: Array<Int> {
		[count]
	}
	@inlinable
	public var transpose: Self {
		self
	}
	@inlinable
	public var diagonal: Self {
		self
	}
	@inlinable
	public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		self[position[0]]
	}
	@inlinable
	public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		self[bounds[0]]
	}
}
extension MutVector {
	@inlinable
	public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		_read {
			yield self[position[0]]
		}
		_modify {
			yield &self[position[0]]
		}
	}
	@inlinable
	public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		_read {
			yield self[bounds[0]]
		}
		_modify {
			yield &self[bounds[0]]
		}
	}
}
