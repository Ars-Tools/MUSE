//
//  Protocol+Vector.swift
//  MUSE
//
//  Created by Kota on 9/9/R7.
//
import typealias Layout.MemoryStrategy
import protocol Dense.InstantVector
import protocol Dense.MutableVector
public protocol SparseVector<Element>: InstantVector where S: SparseVector<Element>, T: SparseVector<Element>, U: SparseScalar<Element>, V: SparseVector<Element>, R == Array<Element> {
	associatedtype COO: Sequence where COO.Element == (Int, Element)
	@inlinable var coo: COO { get }
	@inlinable var state: Set<Int> { get }
}
public protocol MutableSparseVector<Element>: MutableVector & SparseVector where S: MutableSparseVector<Element>, T: MutableSparseVector<Element>, U: MutableSparseScalar<Element>, V: MutableSparseVector<Element> {
	@inlinable init(shape: (Int), _ nonzero: some Sequence<(Int, Element)>)
}
extension SparseVector where Element: Numeric {
	@inlinable
	public var state: Set<Int> {
		.init(coo.lazy.compactMap {
			$1 != .zero ? .some($0) : .none
		})
	}
	@inlinable
	public func callAsFunction(by strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
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
	public func callAsFunction(by strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
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
extension MutableSparseVector {
	@inlinable
	public init(_ source: some SparseVector<Element>) {
		self.init(shape: source.count, source.coo)
	}
}
