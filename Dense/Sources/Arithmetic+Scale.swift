//
//  Arithmetic+Scale.swift
//  MUSE
//
//  Created by Kota on 9/17/R7.
//
import typealias Layout.MemoryStrategy
import func Layout.broadcast
import func Layout.capacity
import func Layout.flatten
//extension Arithmetic {
//	@usableFromInline
//    @frozen struct Scale<Factor: Scalar<Element>, Source: Tensor<Element>> {
//		@usableFromInline typealias R = Array<Element>
//		@usableFromInline typealias S = Scale<Factor, Source.S>
//		@usableFromInline typealias T = Scale<Factor, Source.T>
//		@usableFromInline typealias U = Scale<Factor, Source.U>
//		@usableFromInline typealias V = Scale<Factor, Source.V>
//		@usableFromInline let factor: Factor
//		@usableFromInline let source: Source
//	}
//}
//extension Arithmetic.Scale: Tensor {
//	@inlinable@inline(__always)@_transparent
//	var shape: Array<Int> {
//		source.shape
//	}
//	@usableFromInline
//	var transpose: T {
//		.init(factor: factor, source: source.transpose)
//	}
//	@usableFromInline
//	var diagonal: V {
//		.init(factor: factor, source: source.diagonal)
//	}
//	@usableFromInline
//	subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index == Int {
//		.init(factor: factor, source: source[position])
//	}
//	@usableFromInline
//	subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index == Int, Q.Element.Bound == Int {
//		.init(factor: factor, source: source[bounds])
//	}
//    @usableFromInline
//    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
//        print(#function)
//        fatalError()
//        let (xs, xk) = try source.evaluation(for: strategy)
//        let (ys, yk) = try factor.evaluation(for: strategy)
//        precondition(ys.reduce(1, *) <= 1)
//        let (length, stride, offset) = flatten(shape: source.shape, xs: xs)
//        let capacity = capacity(alloc: source.shape, stride: xs)
//        print(length, stride, offset)
//        return (xs, {
//            await withUnsafePointer(xk(), yk()) { x, y in
//                .init(unsafeUninitializedCapacity: capacity) {
//                    let z = $0.baseAddress.unsafelyUnwrapped
//                    for offset in offset {
//                        Element.Scale(x: x.advanced(by: offset), ldx: stride,
//                                      y: y,
//                                      z: z.advanced(by: offset), ldz: stride,
//                                      length: length)
//                    }
//                    $1 = $0.count
//                }
//            }
//        })
//    }
//}
//extension Arithmetic.Scale: InstantScalar where Source: InstantScalar, Factor: InstantScalar {}
//extension Arithmetic.Scale: InstantVector where Source: InstantVector, Factor: InstantVector {}
//extension Arithmetic.Scale: InstantMatrix where Source: InstantMatrix, Factor: InstantMatrix {}
//extension Arithmetic.Scale: InstantTensor where Source: InstantTensor, Factor: InstantTensor {
//	@usableFromInline
//	func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
//        print(#function)
//        fatalError()
//        let (xs, xk) = try source.evaluation(for: strategy)
//        let (ys, yk) = try factor.evaluation(for: strategy)
//        precondition(ys.reduce(1, *) <= 1)
//        let (length, stride, offset) = flatten(shape: source.shape, xs: xs)
//        let capacity = capacity(alloc: source.shape, stride: xs)
//        print(length, stride, offset)
//        return (xs, {
//            withUnsafePointer(xk(), yk()) { x, y in
//                .init(unsafeUninitializedCapacity: capacity) {
//                    let z = $0.baseAddress.unsafelyUnwrapped
//                    for offset in offset {
//                        Element.Scale(x: x.advanced(by: offset), ldx: stride,
//                                      y: y,
//                                      z: z.advanced(by: offset), ldz: stride,
//                                      length: length)
//                    }
//                    $1 = $0.count
//                }
//            }
//        })
//	}
//}
//extension Arithmetic.Scale: Scalar where Source: Scalar {}
//extension Arithmetic.Scale: Vector where Source: Vector {
//	@inlinable@inline(__always)@_transparent
//	var count: Int {
//		source.count
//	}
//	@usableFromInline
//	subscript(position: Int) -> U {
//		.init(factor: factor, source: source[position])
//	}
//	@usableFromInline
//	subscript(bounds: some RangeExpression<Int>) -> Arithmetic<Element>.Scale<Factor, Source.S> {
//		.init(factor: factor, source: source[bounds])
//	}
//}
//extension Arithmetic.Scale: Matrix where Source: Matrix {
//	@inlinable@inline(__always)@_transparent
//	var rows: Int {
//		source.rows
//	}
//	@inlinable@inline(__always)@_transparent
//	var cols: Int {
//		source.cols
//	}
//	@usableFromInline
//	subscript(row: Int, col: Int) -> U {
//		.init(factor: factor, source: source[row, col])
//	}
//	@usableFromInline
//	subscript(row: Int, col: some RangeExpression<Int>) -> V {
//		.init(factor: factor, source: source[row, col])
//	}
//	@usableFromInline
//	subscript(row: some RangeExpression<Int>, col: Int) -> V {
//		.init(factor: factor, source: source[row, col])
//	}
//	@usableFromInline
//	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
//		.init(factor: factor, source: source[row, col])
//	}
//}
//@_disfavoredOverload
//public func *<Element: ArithmeticElement>(_ factor: some Scalar<Element>, _ source: some Vector<Element>) -> some Vector<Element> {
//	Arithmetic.Scale(factor: factor, source: source)
//}
//@_disfavoredOverload
//public func *<Element: ArithmeticElement>(_ factor: some Scalar<Element>, _ source: some Matrix<Element>) -> some Matrix<Element> {
//	Arithmetic.Scale(factor: factor, source: source)
//}
//@_disfavoredOverload
//public func *<Element: ArithmeticElement>(_ factor: some Scalar<Element>, _ source: some Tensor<Element>) -> some Tensor<Element> {
//	Arithmetic.Scale(factor: factor, source: source)
//}
//@_disfavoredOverload
//public func *<Element: ArithmeticElement>(_ factor: some InstantScalar<Element>, _ source: some InstantVector<Element>) -> some InstantVector<Element> {
//	Arithmetic.Scale(factor: factor, source: source)
//}
//@_disfavoredOverload
//public func *<Element: ArithmeticElement>(_ factor: some InstantScalar<Element>, _ source: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
//	Arithmetic.Scale(factor: factor, source: source)
//}
//@_disfavoredOverload
//public func *<Element: ArithmeticElement>(_ factor: some InstantScalar<Element>, _ source: some InstantTensor<Element>) -> some InstantTensor<Element> {
//	Arithmetic.Scale(factor: factor, source: source)
//}
