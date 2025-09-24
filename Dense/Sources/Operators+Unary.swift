//
//  Operators+Unary.swift
//  MUSE
//
//  Created by Kota on 9/19/R7.
//
extension Operators {
    @usableFromInline
    protocol UnaryScalar<Element>: Scalar & UnaryVector & UnaryMatrix & UnaryTensor where
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
    protocol UnaryTensor<Element>: Tensor where
    S: UnaryTensor<Element>, T: UnaryTensor<Element>, U: UnaryScalar<Element>, V: UnaryVector<Element>,
    S.X == X.S, T.X == X.T, U.X == X.U, V.X == X.V {
        associatedtype X: Tensor
        @inlinable var x: X { get }
        @inlinable init(x: X)
    }
}
extension Operators.UnaryScalar {}
extension Operators.UnaryVector {
    @inlinable
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
extension Operators.UnaryMatrix {
    @inlinable
    public var rows: Int {
        x.rows
    }
    @inlinable
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
extension Operators.UnaryTensor {
    @inlinable
    public var shape: Array<Int> {
		x.shape
	}
    @inlinable
    public var transpose: T {
		.init(x: x.transpose)
	}
    @inlinable
    public var diagonal: V {
		.init(x: x.diagonal)
	}
    @inlinable
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		.init(x: x[position])
	}
    @inlinable
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		.init(x: x[bounds])
	}
}
extension Operators.UnaryTensor {
    
}
