//
//  Basic.swift
//  MUSE
//
//  Created by Kota on 9/18/R7.
//
import Accelerate.vecLib
import typealias Layout.MemoryStrategy
public enum Basic<Element: BitwiseCopyable & Sendable> {}
extension Basic {
    public enum AB<A: Tensor<Element>, B: Tensor<Element>> {
        public typealias R = Array<Element>
        public typealias S = AB<A.S, B.S>
        public typealias T = AB<A.T, B.T>
        public typealias U = AB<A.U, B.U>
        public typealias V = AB<A.V, B.V>
        case A(A)
        case B(B)
    }
}
extension Basic.AB: Scalar where A: Scalar, B: Scalar {}
extension Basic.AB: Vector where A: Vector, B: Vector {
    @inlinable@_transparent
    public var count: Int {
        switch self {
        case.A(let a):
            a.count
        case.B(let b):
            b.count
        }
    }
    @inlinable
    public subscript(position: Int) -> U {
        switch self {
        case.A(let a):
            .A(a[position])
        case.B(let b):
            .B(b[position])
        }
    }
    @inlinable
    public subscript(bounds: some RangeExpression<Int>) -> S {
        switch self {
        case.A(let a):
            .A(a[bounds])
        case.B(let b):
            .B(b[bounds])
        }
    }
}
extension Basic.AB: Matrix where A: Matrix, B: Matrix {
    @inlinable@_transparent
    public var rows: Int {
        switch self {
        case.A(let a):
            a.rows
        case.B(let b):
            b.rows
        }
    }
    @inlinable@_transparent
    public var cols: Int {
        switch self {
        case.A(let a):
            a.cols
        case.B(let b):
            b.cols
        }
    }
    @inlinable
    public subscript(row: Int, col: Int) -> U {
        switch self {
        case.A(let a):
            .A(a[row, col])
        case.B(let b):
            .B(b[row, col])
        }
    }
    @inlinable
    public subscript(row: Int, col: some RangeExpression<Int>) -> V {
        switch self {
        case.A(let a):
            .A(a[row, col])
        case.B(let b):
            .B(b[row, col])
        }
    }
    @inlinable
    public subscript(row: some RangeExpression<Int>, col: Int) -> V {
        switch self {
        case.A(let a):
            .A(a[row, col])
        case.B(let b):
            .B(b[row, col])
        }
    }
    @inlinable
    public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        switch self {
        case.A(let a):
            .A(a[row, col])
        case.B(let b):
            .B(b[row, col])
        }
    }
}
extension Basic.AB: Tensor {
    @inlinable@_transparent
    public var shape: Array<Int> {
        switch self {
        case.A(let a):
            a.shape
        case .B(let b):
            b.shape
        }
    }
    @inlinable@_transparent
    public var transpose: T {
        switch self {
        case.A(let a):
            .A(a.transpose)
        case.B(let b):
            .B(b.transpose)
        }
    }
    @inlinable@_transparent
    public var diagonal: V {
        switch self {
        case.A(let a):
            .A(a.diagonal)
        case.B(let b):
            .B(b.diagonal)
        }
    }
    @inlinable
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
        switch self {
        case.A(let a):
            .A(a[position])
        case.B(let b):
            .B(b[position])
        }
    }
    @inlinable
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
        switch self {
        case.A(let a):
            .A(a[bounds])
        case.B(let b):
            .B(b[bounds])
        }
    }
    @inlinable
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch self {
        case.A(let a):
            switch try a.evaluation(for: strategy) {
            case (let stride, let kernel):
                (stride, {
                    await.init(kernel())
                })
            }
        case.B(let b):
            switch try b.evaluation(for: strategy) {
            case (let stride, let kernel):
                (stride, {
                    await.init(kernel())
                })
            }
        }
    }
}
extension Basic.AB: InstantScalar where A: InstantScalar, B: InstantScalar {}
extension Basic.AB: InstantVector where A: InstantVector, B: InstantVector {}
extension Basic.AB: InstantMatrix where A: InstantMatrix, B: InstantMatrix {}
extension Basic.AB: InstantTensor where A: InstantTensor, B: InstantTensor {
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch self {
        case.A(let a):
            switch try a.evaluation(for: strategy) {
            case (let stride, let kernel):
                (stride, {
                    .init(kernel())
                })
            }
        case.B(let b):
            switch try b.evaluation(for: strategy) {
            case (let stride, let kernel):
                (stride, {
                    .init(kernel())
                })
            }
        }
    }
}
