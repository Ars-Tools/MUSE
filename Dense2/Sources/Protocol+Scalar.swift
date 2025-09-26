//
//  Protocol+Scalar.swift
//  MUSE
//
//  Created by Kota on 9/25/25.
//
import protocol Accelerate.AccelerateBuffer
import protocol Accelerate.AccelerateMutableBuffer
import typealias Layout.MemoryStrategy
public protocol Scalar<Element>: ElasticTensor where S: Scalar<Element>, T: Scalar<Element>, U: Scalar<Element>, V: Scalar<Element> {
    
}
public protocol MutableScalar<Element>: MutableTensor & Scalar where S: MutableScalar<Element>, T: MutableScalar<Element>, U: MutableScalar<Element>, V: MutableScalar<Element> {
    
}
extension Scalar {
    public var shape: Array<Int> { .init() }
    public var transpose: Self { self }
    public var diagonal: Self { self }
    public subscript<P>(position: P) -> Self where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        self
    }
    public subscript<Q>(bounds: Q) -> Self where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        self
    }
}
extension MutableScalar {
    public var shape: Array<Int> { .init() }
    public var diagonal: Self {
        _read {
            yield self
        }
        _modify {
            yield &self
        }
    }
    public subscript<P>(position: P) -> Self where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        _read {
            yield self
        }
        _modify {
            yield &self
        }
    }
    public subscript<Q>(bounds: Q) -> Self where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        _read {
            yield self
        }
        _modify {
            yield &self
        }
    }
}
