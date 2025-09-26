//
//  Protocol+Tensor.swift
//  MUSE
//
//  Created by Kota on 9/8/R7.
//
import protocol Accelerate.AccelerateBuffer
import protocol Accelerate.AccelerateMutableBuffer
import typealias Layout.MemoryStrategy
public typealias Storage = Sendable & RandomAccessCollection & AccelerateBuffer
public typealias MutableStorage = Storage & MutableCollection & AccelerateMutableBuffer
public protocol Scalar<Element>: Tensor & Vector & Matrix where S: Scalar<Element>, T: Scalar<Element>, U: Scalar<Element>, V: Scalar<Element> {
//    @inlinable subscript() -> Element { get async throws }
}
public protocol Vector<Element>: Tensor where S: Vector<Element>, T: Vector<Element>, U: Scalar<Element>, V: Vector<Element> {
	@inlinable var count: Int { get }
	@inlinable subscript(position: Int) -> U { get }
	@inlinable subscript(bounds: some RangeExpression<Int>) -> S { get }
}
public protocol Matrix<Element>: Tensor where S: Matrix<Element>, T: Matrix<Element>, U: Scalar<Element>, V: Vector<Element> {
	@inlinable var rows: Int { get }
	@inlinable var cols: Int { get }
	@inlinable subscript(row: Int, col: Int) -> U { get }
	@inlinable subscript(row: Int, col: some RangeExpression<Int>) -> V { get }
	@inlinable subscript(row: some RangeExpression<Int>, col: Int) -> V { get }
	@inlinable subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S { get }
}
public protocol Tensor<Element>: Sendable {
	associatedtype Element: BitwiseCopyable & Sendable
	associatedtype S: Tensor<Element>
	associatedtype T: Tensor<Element>
	associatedtype U: Scalar<Element>
	associatedtype V: Vector<Element>
	associatedtype R: Storage where R.Element == Element, R.Index: Strideable, R.Index.Stride == Int, R.SubSequence: Storage
	@inlinable var shape: Array<Int> { get }
	@inlinable var transpose: T { get }
	@inlinable var diagonal: V { get }
	@inlinable subscript<P: RandomAccessCollection>(position: P) -> U where P.Index == Int, P.Element == Int { get }
	@inlinable subscript<Q: RandomAccessCollection>(bounds: Q) -> S where Q.Index == Int, Q.Element: RangeExpression<Int> { get }
	@inlinable func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R)
}
public protocol InstantScalar<Element>: Scalar & InstantTensor & InstantMatrix & InstantVector where S: InstantScalar, T: InstantScalar, U: InstantScalar, V: InstantScalar {
//    @inlinable subscript() -> Element { get throws }
}
public protocol InstantVector<Element>: Vector & InstantTensor where S: InstantVector<Element>, T: InstantVector<Element>, U: InstantScalar<Element>, V: InstantVector<Element> {
}
public protocol InstantMatrix<Element>: Matrix & InstantTensor where S: InstantMatrix<Element>, T: InstantMatrix<Element>, U: InstantScalar<Element>, V: InstantVector<Element> {
}
public protocol InstantTensor<Element>: Tensor where S: InstantTensor<Element>, T: InstantTensor<Element>, U: InstantScalar<Element>, V: InstantVector<Element> {
    @inlinable func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R)
}
public protocol MutableScalar<Element>: InstantScalar & MutableTensor & MutableMatrix & MutableVector where S: MutableScalar, T: MutableScalar, U: MutableScalar, V: MutableScalar {
//    @inlinable subscript() -> Element { get set }
}
public protocol MutableVector<Element>: InstantVector & MutableTensor where S: MutableVector<Element>, T: MutableVector<Element>, U: MutableScalar<Element>, V: MutableVector<Element> {
	@inlinable subscript(position: Int) -> U { get set }
	@inlinable subscript(bounds: some RangeExpression<Int>) -> S { get set }
}
public protocol MutableMatrix<Element>: InstantMatrix & MutableTensor where S: MutableMatrix<Element>, T: MutableMatrix<Element>, U: MutableScalar<Element>, V: MutableVector<Element> {
	@inlinable subscript(row: Int, col: Int) -> U { get set }
	@inlinable subscript(row: Int, col: some RangeExpression<Int>) -> V { get set }
	@inlinable subscript(row: some RangeExpression<Int>, col: Int) -> V { get set }
	@inlinable subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S { get set }
}
public protocol MutableTensor<Element>: InstantTensor {
	@inlinable subscript<P: RandomAccessCollection>(position: P) -> U where P.Index == Int, P.Element == Int { get set }
	@inlinable subscript<Q: RandomAccessCollection>(bounds: Q) -> S where Q.Index == Int, Q.Element: RangeExpression<Int> { get set }
}
// MARK: Default
extension InstantTensor {
    @inlinable@inline(__always)
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R) {
        switch try evaluation(for: strategy) as (Array<Int>, @Sendable () -> R) {
        case (let stride, let kernel):
            (stride, {kernel()})
        }
    }
}
// MARK: Default
