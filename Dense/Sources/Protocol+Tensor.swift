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
	@inlinable func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R)
}
public protocol MutTensor<Element>: Tensor where S: MutTensor<Element>, T: MutTensor<Element>, U: MutScalar<Element>, V: MutVector<Element>, R: MutableStorage, R.SubSequence: MutableStorage {
	@inlinable subscript<P: RandomAccessCollection>(position: P) -> U where P.Index == Int, P.Element == Int { get set }
	@inlinable subscript<Q: RandomAccessCollection>(bounds: Q) -> S where Q.Index == Int, Q.Element: RangeExpression<Int> { get set }
}
public protocol Immediate<Element>: Tensor {
	@inlinable func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R)
}
extension Immediate {
	@inlinable
	public func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R) {
		switch try callAsFunction(for: strategy) as (Array<Int>, @Sendable () -> R) {
		case (let stride, let kernel):
			(stride, kernel)
		}
	}
}
infix operator •: MultiplicationPrecedence
