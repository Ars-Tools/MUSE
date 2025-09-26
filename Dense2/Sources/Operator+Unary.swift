//
//  Operator+Unary.swift
//  MUSE
//
//  Created by Kota on 9/25/25.
//
extension Operator {
    @usableFromInline
    protocol UnaryScalar<Element>: Scalar & UnaryTensor where
    S: UnaryScalar<Element>, T: UnaryScalar<Element>, U: UnaryScalar<Element>, V: UnaryScalar<Element>,
    X: Scalar {}
    @usableFromInline
    protocol UnaryVector<Element>: Vector & UnaryTensor where
    S: UnaryVector<Element>, T: UnaryVector<Element>, U: UnaryScalar<Element>, V: UnaryVector<Element>,
    X: Vector {}
    @usableFromInline
    protocol UnaryMatrix<Element>: Matrix & UnaryTensor where
    S: UnaryMatrix<Element>, T: UnaryMatrix<Element>, U: UnaryScalar<Element>, V: UnaryVector<Element>,
    X: Matrix {}
    @usableFromInline
    protocol UnaryTensor<Element>: ElasticTensor where
    S: UnaryTensor<Element>, T: UnaryTensor<Element>, U: UnaryTensor<Element>, V: UnaryTensor<Element>,
    S.X == X.S, T.X == X.T, U.X == X.U, V.X == X.V {
        associatedtype X: ElasticTensor
        @inlinable var x: X { get }
        @inlinable init(x: X)
    }
}
extension Operator.UnaryScalar {}
extension Operator.UnaryVector {
    @inlinable@inline(__always)
    public var count: Int {
        x.count
    }
    @inlinable@inline(__always)
    public subscript(position: Int) -> U {
        .init(x: x[position])
    }
    @inlinable@inline(__always)
    public subscript(bounds: some RangeExpression<Int>) -> S {
        .init(x: x[bounds])
    }
}
extension Operator.UnaryMatrix {
    @inlinable@inline(__always)
    public var rows: Int {
        x.rows
    }
    @inlinable@inline(__always)
    public var cols: Int {
        x.cols
    }
    @inlinable@inline(__always)
    public subscript(row: Int, col: Int) -> U {
        .init(x: x[row, col])
    }
    @inlinable@inline(__always)
    public subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .init(x: x[row, col])
    }
    @inlinable@inline(__always)
    public subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .init(x: x[row, col])
    }
    @inlinable@inline(__always)
    public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        .init(x: x[row, col])
    }
}
extension Operator.UnaryTensor {
    @inlinable@inline(__always)
    public var shape: Array<Int> {
        x.shape
    }
    @inlinable@inline(__always)
    public var transpose: T {
        .init(x: x.transpose)
    }
    @inlinable@inline(__always)
    public var diagonal: V {
        .init(x: x.diagonal)
    }
    @inlinable@inline(__always)
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        .init(x: x[position])
    }
    @inlinable@inline(__always)
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        .init(x: x[bounds])
    }
}
extension Operator.UnaryTensor {
    
}
