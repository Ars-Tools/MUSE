//
//  Protocol+Tensor.swift
//  MUSE
//
//  Created by Kota on 9/25/25.
//
public protocol ElasticTensor<Element>: Tensor {
    associatedtype S: ElasticTensor<Element>
    associatedtype T: ElasticTensor<Element>
    associatedtype U: ElasticTensor<Element>
    associatedtype V: ElasticTensor<Element>
    var transpose: T { get }
    var diagonal: V { get }
    subscript<P>(position: P) -> U where P: RandomAccessCollection, P.Index: Strideable, P.Index.Stride == Int, P.Element == Int { get }
    subscript<Q>(bounds: Q) -> S where Q: RandomAccessCollection, Q.Index: Strideable, Q.Index.Stride == Int, Q.Element: RangeExpression<Int> { get }
}
public protocol MutableTensor<Element>: ElasticTensor & InstantTensor where S: MutableTensor<Element>, T: MutableTensor<Element>, U: MutableTensor<Element>, V: MutableTensor<Element> {
    subscript<P>(position: P) -> U where P: RandomAccessCollection, P.Index: Strideable, P.Index.Stride == Int, P.Element == Int { get set }
    subscript<Q>(bounds: Q) -> S where Q: RandomAccessCollection, Q.Index: Strideable, Q.Index.Stride == Int, Q.Element: RangeExpression<Int> { get set }
}
extension ElasticTensor {
    @_disfavoredOverload
    public subscript(position: Int...) -> U {
        self[position]
    }
    @_disfavoredOverload
    public subscript<Bounds: RangeExpression<Int>>(bounds: Bounds...) -> S {
        self[bounds]
    }
}
extension MutableTensor {
    @inlinable
    public subscript(position: Int...) -> U {
        _read {
            yield self[position]
        }
        _modify {
            yield &self[position]
        }
    }
    @inlinable
    public subscript<Bounds: RangeExpression<Int>>(bounds: Bounds...) -> S {
        _read {
            yield self[bounds]
        }
        _modify {
            yield &self[bounds]
        }
    }
}
