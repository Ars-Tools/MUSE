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
    var count: Int {
        x.count
    }
    @usableFromInline
    subscript(position: Int) -> U {
        .init(x: x[position])
    }
    @usableFromInline
    subscript(bounds: some RangeExpression<Int>) -> S {
        .init(x: x[bounds])
    }
}
extension Operators.UnaryMatrix {
    @inlinable
    var rows: Int {
        x.rows
    }
    @inlinable
    var cols: Int {
        x.cols
    }
    @usableFromInline
    subscript(row: Int, col: Int) -> U {
        .init(x: x[row, col])
    }
    @usableFromInline
    subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .init(x: x[row, col])
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .init(x: x[row, col])
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        .init(x: x[row, col])
    }
}
extension Operators.UnaryTensor {
	@inlinable
	var shape: Array<Int> {
		x.shape
	}
	@usableFromInline
	var transpose: T {
		.init(x: x.transpose)
	}
	@usableFromInline
	var diagonal: V {
		.init(x: x.diagonal)
	}
	@usableFromInline
	subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
		.init(x: x[position])
	}
	@usableFromInline
	subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
		.init(x: x[bounds])
	}
}
extension Operators.UnaryTensor {
    
}
