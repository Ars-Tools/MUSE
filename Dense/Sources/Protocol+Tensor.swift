//
//  Protocol+Tensor.swift
//  MUSE
//
//  Created by Kota on 9/8/R7.
//
import protocol Accelerate.AccelerateBuffer
import protocol Accelerate.AccelerateMutableBuffer
import typealias Layout.MemoryStrategy
public protocol Tensor<Element>: Sendable {
	associatedtype Element: BitwiseCopyable & Hashable & Sendable
	associatedtype S: Tensor<Element>
	associatedtype T: Tensor<Element>
	associatedtype U: Tensor<Element>
	associatedtype V: Tensor<Element>
	associatedtype R: AccelerateBuffer<Element>
	@inlinable var shape: Array<Int> { get }
	@inlinable var transpose: T { get }
	@inlinable var diagonal: V { get }
	@inlinable subscript<P: RandomAccessCollection>(position: P) -> U where P.Index == Int, P.Element == Int { get }
	@inlinable subscript<Q: RandomAccessCollection>(bounds: Q) -> S where Q.Index == Int, Q.Element: RangeExpression<Int> { get }
	@inlinable func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R)
}
public protocol MutTensor<Element>: Tensor where U == Element, R: AccelerateMutableBuffer {
	@inlinable subscript<P: RandomAccessCollection>(position: P) -> U where P.Index == Int, P.Element == Int { get set }
	@inlinable subscript<Q: RandomAccessCollection>(bounds: Q) -> S where Q.Index == Int, Q.Element: RangeExpression<Int> { get set }
}
infix operator •: MultiplicationPrecedence
