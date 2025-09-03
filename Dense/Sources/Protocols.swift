//
//  Protocols.swift
//  MUSE
//
//  Created by Kota on 5/26/R7.
//
import typealias Layout.MemoryStrategy
public protocol Tensor<Element>: RandomAccessCollection where Element: BitwiseCopyable & Sendable & Numeric {
	associatedtype S: Tensor<Element>
	associatedtype T: Tensor<Element>
	associatedtype U: Tensor<Element>
	associatedtype V: Tensor<Element>
	associatedtype R: RandomAccessCollection<Element>
	var shape: Array<Int> { get }
	var transpose: T { get }
	var diagonal: V { get }
	subscript<P: RandomAccessCollection>(position: P) -> U where P.Index == Int, P.Element == Int { get }
	subscript<Q: RandomAccessCollection>(bounds: Q) -> S where Q.Index == Int, Q.Element: RangeExpression<Int> { get }
	func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, () async -> R)
}
public protocol Scalar<Element>: Tensor & BitwiseCopyable & Sendable & Numeric where S == Self, T == Self, U == Self, V == Self {
	subscript() -> Element { get async throws }
}
public protocol Vector<Element>: Tensor where S: Vector<Element>, T: Vector<Element>, U: Scalar<Element>, V: Vector<Element> {
	var count: Int { get }
	subscript(position: Int) -> U { get }
	subscript(bounds: some RangeExpression<Int>) -> S { get }
}
public protocol Matrix<Element>: Tensor where S: Matrix<Element>, T: Matrix<Element>, U: Scalar<Element>, V: Vector<Element> {
	var rows: Int { get }
	var cols: Int { get }
	subscript(row: Int, col: Int) -> U { get }
	subscript(row: Int, col: some RangeExpression<Int>) -> V { get }
	subscript(row: some RangeExpression<Int>, col: Int) -> V { get }
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S { get }
}
public protocol MutTensor<Element>: Tensor {
	subscript<P: RandomAccessCollection>(position: P) -> U where P.Index == Int, P.Element == Int { get set }
	subscript<Q: RandomAccessCollection>(bounds: Q) -> S where Q.Index == Int, Q.Element: RangeExpression<Int> { get set }
}
public protocol MutScalar<Element>: MutTensor & Scalar {
	subscript() -> Element { get set }
}
public protocol MutVector<Element>: MutTensor & Vector where S: MutVector<Element>, T == Self {
	subscript(position: Int) -> U { get set }
	subscript(bounds: some RangeExpression<Int>) -> S { get set }
}
public protocol MutMatrix<Element>: MutTensor & Matrix where S: MutMatrix<Element>, T: MutMatrix<Element> {
	subscript(row: Int, col: Int) -> U { get set }
	subscript(row: Int, col: some RangeExpression<Int>) -> V { get set }
	subscript(row: some RangeExpression<Int>, col: Int) -> V { get set }
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S { get set }
}
