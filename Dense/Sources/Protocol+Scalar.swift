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
extension Scalar {
	@inlinable@inline(__always)
	public var count: Int { 1 }
	@inlinable@inline(__always)
	public subscript(position: Int) -> Self {
		self
	}
	@inlinable@inline(__always)
	public subscript(bounds: some RangeExpression<Int>) -> Self {
		self
	}
}
extension Scalar {
	@inlinable@inline(__always)
	public var rows: Int { 1 }
	@inlinable@inline(__always)
	public var cols: Int { 1 }
	@inlinable@inline(__always)
	public subscript(row: Int, col: Int) -> Self {
		self
	}
	@inlinable@inline(__always)
	public subscript(row: Int, col: some RangeExpression<Int>) -> Self {
		self
	}
	@inlinable@inline(__always)
	public subscript(row: some RangeExpression<Int>, col: Int) -> Self {
		self
	}
	@inlinable@inline(__always)
	public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> Self {
		self
	}
}
extension Scalar {
	@inlinable@inline(__always)
	public var shape: Array<Int> {
		.init()
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
	public subscript<P>(position: P) -> Self where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		self
	}
	@inlinable@inline(__always)
	public subscript<Q>(bounds: Q) -> Self where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		self
	}
    @inlinable@inline(__always)
    public subscript() -> Element {
		get async throws {
			switch try evaluation(for: .rowMajor) {
			case (let stride, let kernel) where 1 == capacity(alloc: shape, stride: stride):
				await kernel().withUnsafeBufferPointer(\.baseAddress.unsafelyUnwrapped.pointee)
			default:
				throw Error.invalidShape(self)
			}
		}
	}
}
extension InstantScalar {
    @inlinable@inline(__always)
    public subscript() -> Element {
        get throws {
            switch try evaluation(for: .rowMajor) {
            case (let stride, let kernel) where 1 == capacity(alloc: shape, stride: stride):
                kernel().withUnsafeBufferPointer(\.baseAddress.unsafelyUnwrapped.pointee)
            default:
                throw Error.invalidShape(self)
            }
        }
    }
}
extension MutableScalar {
	@inlinable@inline(__always)
	public subscript(position: Int) -> Self {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
	@inlinable@inline(__always)
	public subscript(bounds: some RangeExpression<Int>) -> Self {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
}
extension MutableScalar {
	@inlinable@inline(__always)
	public subscript(row: Int, col: Int) -> Self {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
	@inlinable@inline(__always)
	public subscript(row: Int, col: some RangeExpression<Int>) -> Self {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
	@inlinable@inline(__always)
	public subscript(row: some RangeExpression<Int>, col: Int) -> Self {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
	@inlinable@inline(__always)
	public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> Self {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
}
extension MutableScalar {
	@inlinable@inline(__always)
	public subscript<P>(position: P) -> Self where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
	@inlinable@inline(__always)
	public subscript<Q>(bounds: Q) -> Self where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		_read {
			yield self
		}
		_modify {
			yield &self
		}
	}
}
