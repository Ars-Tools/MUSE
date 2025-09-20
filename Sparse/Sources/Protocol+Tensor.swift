//
//  Protocol+Tensor.swift
//  MUSE
//
//  Created by Kota on 9/9/R7.
//
import protocol Dense.MutableScalar
public typealias SparseScalar<Element> = MutableScalar<Element>
public typealias MutableSparseScalar<Element> = SparseScalar<Element>
//public protocol SparseTensor<Element>: Tensor where S: SparseTensor<Element>, T: SparseTensor<Element>, U: SparseScalar<Element>, V: SparseVector<Element>, R == Array<Element> {
//}
//public protocol MutSparseTensor<Element>: MutTensor & SparseTensor where S: MutSparseTensor<Element>, T: MutSparseTensor<Element>, U: MutSparseScalar<Element>, V: MutSparseVector<Element> {}
//public protocol SparseTensor<Element>: Tensor where R == Array<Element>, S: SparseTensor<Element>, T: SparseTensor<Element>, U: SparseScalar<Element>, V: SparseVector<Element> {
//	associatedtype Nonzero: Sequence where Nonzero.Element == (Array<Int>, Element)
//	@inlinable var nonzero: Nonzero { get }
//}
//public protocol MutSparseTensor<Element>: MutTensor & SparseTensor {}
//extension SparseTensor where Element: Numeric {
//	@inlinable
//	public func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
//		let layout = strategy.stride(for: shape)
//		let memory = Array<Element>(unsafeUninitializedCapacity: capacity(alloc: shape, stride: layout)) {
//			$0.initialize(repeating: .zero)
//			for (key, value) in nonzero {
//				$0[zip(key, layout).lazy.map(*).reduce(0, +)] = value
//			}
//			$1 = $0.count
//		}
//		return (layout, {memory})
//	}
//}
//extension SparseTensor where Element == Bool {
//	@inlinable
//	public func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
//		let layout = strategy.stride(for: shape)
//		let memory = Array<Element>(unsafeUninitializedCapacity: capacity(alloc: shape, stride: layout)) {
//			$0.initialize(repeating: false)
//			for (key, value) in nonzero {
//				$0[zip(key, layout).lazy.map(*).reduce(0, +)] = value
//			}
//			$1 = $0.count
//		}
//		return (layout, {memory})
//	}
//}
