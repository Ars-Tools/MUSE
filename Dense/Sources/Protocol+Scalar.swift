//
//  Protocol+Scalar.swift
//  MUSE
//
//  Created by Kota on 9/8/R7.
//
import typealias Layout.MemoryStrategy
import protocol Accelerate.AccelerateBuffer
import protocol Accelerate.AccelerateMutableBuffer
import func Layout.capacity
extension CollectionOfOne: @retroactive AccelerateBuffer & AccelerateMutableBuffer {
	@inlinable@inline(__always)@_transparent
	public func withUnsafeBufferPointer<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R) rethrows -> R {
		try Swift.withUnsafeBytes(of: self) {
			try $0.withMemoryRebound(to: Element.self, body)
		}
	}
}
public protocol Scalar<Element>: Tensor & Vector & Matrix where S == Self, T == Self, U == Self, V == Self {}
public protocol MutScalar<Element>: MutTensor & MutVector & MutMatrix & Scalar & BitwiseCopyable & Immediate where R == CollectionOfOne<Self> {}
extension Scalar {
	@inlinable
	public var count: Int { 1 }
	@inlinable
	public var rows: Int { 1 }
	@inlinable
	public var cols: Int { 1 }
	@inlinable@inline(__always)
	public subscript(position: Int) -> Self {
		self
	}
	@inlinable@inline(__always)
	public subscript(row: Int, col: some RangeExpression<Int>) -> V {
		self
	}
	@inlinable@inline(__always)
	public subscript(row: Int, col: Int) -> U {
		self
	}
	@inlinable@inline(__always)
	public subscript(row: some RangeExpression<Int>, col: Int) -> V {
		self
	}
	@inlinable@inline(__always)
	public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		self
	}
}
extension MutScalar {
	@inlinable
	public subscript(position: Int) -> U {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
	@inlinable
	public subscript(bounds: some RangeExpression<Int>) -> S {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
	@inlinable@inline(__always)
	public subscript(row: Int, col: Int) -> U {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
	@inlinable
	public subscript(row: Int, col: some RangeExpression<Int>) -> V {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
	@inlinable
	public subscript(row: some RangeExpression<Int>, col: Int) -> V {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
	@inlinable
	public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
}
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
	public subscript(bounds: some RangeExpression<Int>) -> Self {
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
	public subscript() -> Element {
		get async throws {
			switch try callAsFunction(for: .columnMajor) {
			case (let stride, let kernel) where 1 == capacity(alloc: shape, stride: stride):
				await kernel().withUnsafeBufferPointer(\.baseAddress.unsafelyUnwrapped.pointee)
			default:
				throw Error.invalidShape(self)
			}
		}
	}
}
extension MutScalar {
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
	public func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
		([], {.init(self)})
	}
}

