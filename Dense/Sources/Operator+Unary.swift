//
//  Operator+Unary.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
extension Operator {
    @usableFromInline
    protocol UnaryScalar<X>: Scalar & UnaryTensor where X: Scalar,
    S: UnaryScalar<X.S>,
    T: UnaryScalar<X.T>,
    U: UnaryScalar<X.U>,
    V: UnaryScalar<X.V> {}
    @usableFromInline
    protocol UnaryVector<X>: Vector & UnaryTensor where X: Vector,
    S: UnaryVector<X.S>,
    T: UnaryVector<X.T>,
    U: UnaryScalar<X.U>,
    V: UnaryVector<X.V> {}
    @usableFromInline
    protocol UnaryMatrix<X>: Matrix & UnaryTensor where X: Matrix,
    S: UnaryMatrix<X.S>,
    T: UnaryMatrix<X.T>,
    U: UnaryScalar<X.U>,
    V: UnaryVector<X.V> {}
    @usableFromInline
    protocol UnaryTensor<X>: Tensor where
    S: UnaryTensor<X.S>,
    T: UnaryTensor<X.T>,
    U: UnaryTensor<X.U>,
    V: UnaryTensor<X.V> {
        associatedtype X: Tensor
        @inlinable var x: X { get }
        @inlinable init(x: X)
    }
}
extension Operator.UnaryScalar {
    
}
extension Operator.UnaryVector {
    @inlinable@_transparent
    public var count: Int {
        x.count
    }
    @inlinable
    public subscript(position: Int) -> U {
        .init(x: x[position])
    }
    @inlinable
    public subscript(bounds: some RangeExpression<Int>) -> S {
        .init(x: x[bounds])
    }
}
extension Operator.UnaryMatrix {
    @inlinable@_transparent
    public var rows: Int {
        x.rows
    }
    @inlinable@_transparent
    public var cols: Int {
        x.cols
    }
    @inlinable
    public subscript(row: Int, col: Int) -> U {
        .init(x: x[row, col])
    }
    @inlinable
    public subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .init(x: x[row, col])
    }
    @inlinable
    public subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .init(x: x[row, col])
    }
    @inlinable
    public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        .init(x: x[row, col])
    }
}
extension Operator.UnaryTensor {
    @inlinable@_transparent
    public var shape: Array<Int> {
        x.shape
    }
    @inlinable@_transparent
    public var transpose: T {
        .init(x: x.transpose)
    }
    @inlinable
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        .init(x: x[position])
    }
    @inlinable
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        .init(x: x[bounds])
    }
}
