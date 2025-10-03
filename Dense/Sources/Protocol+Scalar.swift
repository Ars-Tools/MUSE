//
//  Protocol+Scalar.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import Accelerate.vecLib
public protocol Scalar<Element>: Tensor where S: Scalar<Element>, T: Scalar<Element>, U: Scalar<Element>, V: Scalar<Element> {}
public protocol InstantScalar<Element>: InstantTensor & Scalar where S: InstantScalar<Element>, T: InstantScalar<Element>, U: InstantScalar<Element>, V: InstantScalar<Element> {}
public protocol MutableScalar<Element>: MutableTensor & InstantScalar where S: MutableScalar<Element>, T: MutableScalar<Element>, U: MutableScalar<Element>, V: MutableScalar<Element> {}
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
    public subscript<P>(position: P) -> Self where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        self
    }
    @inlinable@inline(__always)
    public subscript<Q>(bounds: Q) -> Self where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        self
    }
    @_disfavoredOverload
    @inlinable@inline(__always)
    public subscript() -> Element {
        get async throws {
            switch try evaluation(for: .default) {
            case (let stride, let kernel) where 1 == capacity(alloc: shape, stride: stride):
                await kernel().first.unsafelyUnwrapped
            default:
                throw Error.shapeMismatch
            }
        }
    }
}
extension InstantScalar {
    @inlinable@inline(__always)
    public subscript() -> Element {
        get throws {
            switch try evaluation(for: .default) {
            case (let stride, let kernel) where 1 == capacity(alloc: shape, stride: stride):
                kernel().first.unsafelyUnwrapped
            default:
                throw Error.shapeMismatch
            }
        }
    }
}
extension MutableScalar where Self == Element {
    @inlinable@inline(__always)
    public subscript() -> Element {
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
    public var diagonal: Self {
        _read {
            yield self
        }
        _modify {
            yield &self
        }
    }
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
    public subscript<P>(position: P) -> Self where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        _read {
            yield self
        }
        _modify {
            yield &self
        }
    }
    @inlinable@inline(__always)
    public subscript<Q>(bounds: Q) -> Self where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        _read {
            yield self
        }
        _modify {
            yield &self
        }
    }
}
