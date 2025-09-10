//
//  Protocol+Scalar.swift
//  MUSE
//
//  Created by Kota on 9/8/R7.
//
import typealias Layout.MemoryStrategy
import protocol Accelerate.AccelerateBuffer
import protocol Accelerate.AccelerateMutableBuffer
extension CollectionOfOne: @retroactive AccelerateBuffer & AccelerateMutableBuffer {}
public protocol Scalar<Element>: Tensor & BitwiseCopyable & Sendable & Numeric & Hashable where S == Self, T == Self, U == Self, V == Self {}
public protocol MutScalar<Element>: MutTensor & Scalar where R == CollectionOfOne<Self> {}
extension Scalar {
	@inlinable
	public var shape: Array<Int> {
		.init()
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
	public subscript(position: Int) -> Self {
		self
	}
	@inlinable
	public subscript(bounds: Range<Int>) -> Self {
		self
	}
	@inlinable
	public subscript<P>(position: P) -> Self where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		self
	}
	@inlinable
	public subscript<Q>(bounds: Q) -> Self where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		self
	}
}
extension MutScalar {
	@inlinable
	public subscript(position: Int) -> Self {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
	@inlinable
	public subscript(bounds: Range<Int>) -> Self {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
	@inlinable
	public subscript<P>(position: P) -> Self where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
	@inlinable
	public subscript<Q>(bounds: Q) -> Self where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
	@inlinable
	public subscript() -> Element {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
	@inlinable
	public func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R) {
		([], {.init(self)})
	}
}
