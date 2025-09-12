//
//  Protocol+Vector.swift
//  MUSE
//
//  Created by Kota on 9/9/R7.
//
import typealias Layout.MemoryStrategy
import protocol Dense.Vector
import protocol Dense.MutVector
public protocol SparseVector<Element>: SparseTensor & Vector where S: SparseVector {
	associatedtype COO: Sequence where COO.Element == (Int, Element)
	@inlinable var coo: COO { get }
	@inlinable var state: Set<Int> { get }
}
public protocol MutSparseVector<Element>: MutSparseTensor & MutVector & SparseVector where S: MutSparseVector {
	@inlinable init(shape: (Int), _ nonzero: some Sequence<(Int, Element)>)
}
extension SparseVector {
	@inlinable
	public var nonzero: LazyMapSequence<COO, (Array<Int>, Element)> {
		coo.lazy.map { ([$0], $1) }
	}
}
extension SparseVector where Element: Numeric {
	@inlinable
	public var state: Set<Int> {
		.init(coo.lazy.compactMap {
			$1 != .zero ? .some($0) : .none
		})
	}
	@inlinable
	public func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
		let result = Array<Element>(unsafeUninitializedCapacity: count) {
			$0.initialize(repeating: .zero)
			for (key, val) in coo {
				$0[key] = val
			}
			$1 = $0.count
		}
		return ([1], {result})
	}
	@inlinable
	public var description: String {
		Array<Element>(unsafeUninitializedCapacity: count) {
			$0.initialize(repeating: .zero)
			for (key, val) in coo {
				$0[key] = val
			}
			$1 = $0.count
		}.description
	}
}
extension SparseVector where Element == Bool {
	@inlinable
	public var coo: LazyMapSequence<Set<Int>, (Int, Element)> {
		state.lazy.map { ($0, true) }
	}
	@inlinable
	public func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
		let result = Array<Element>(unsafeUninitializedCapacity: count) {
			$0.initialize(repeating: false)
			for index in state {
				$0[index] = true
			}
			$1 = $0.count
		}
		return ([1], {result})
	}
	@inlinable
	public var description: String {
		Array<Element>(unsafeUninitializedCapacity: count) {
			$0.initialize(repeating: false)
			for index in state {
				$0[index] = true
			}
			$1 = $0.count
		}.description
	}
}
extension MutSparseVector {
	@inlinable
	public init(_ source: some SparseVector<Element>) {
		self.init(shape: source.count, source.coo)
	}
}
