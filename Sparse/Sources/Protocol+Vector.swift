//
//  Protocol+Vector.swift
//  MUSE
//
//  Created by Kota on 9/9/R7.
//
import protocol Dense.Vector
import protocol Dense.MutVector
import typealias Layout.MemoryStrategy
public protocol SparseVector<Element>: SparseTensor & Vector where S: SparseVector {
	associatedtype COO: Sequence where COO.Element == (Int, Element)
	@inlinable
	var coo: COO { get }
}
public protocol MutSparseVector<Element>: MutSparseTensor & MutVector & SparseVector where S: MutSparseVector {
	@inlinable init(shape: (Int), _ nonzero: some Sequence<(Int, Element)>)
}
extension SparseVector {
	@inlinable
	var dense: Array<Element> {
		.init(unsafeUninitializedCapacity: count) {
			$0.initialize(repeating: .zero)
			for (i, v) in coo {
				$0[i] = v
			}
			$1 = $0.count
		}
	}
}
extension SparseVector {
	@inlinable
	public var nonzero: LazyMapSequence<COO, (Array<Int>, Element)> {
		coo.lazy.map { ([$0], $1) }
	}
	@inlinable
	public func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R) {
		([1], {dense})
	}
}
extension SparseVector {
	@inlinable
	public var description: String {
		dense.description
	}
}
extension MutSparseVector {
	@inlinable
	public init(_ source: some SparseVector<Element>) {
		self.init(shape: source.count, source.coo)
	}
}
