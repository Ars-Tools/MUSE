//
//  Vector+VSK.swift
//  MUSE
//
//  Created by Kota on 9/10/R7.
//
import protocol Dense.MutVector
import typealias Layout.MemoryStrategy
@dynamicMemberLookup
@frozen public struct VSK {
	public let count: Int
	@usableFromInline
	private(set) var state: Set<Int>
}
extension VSK {
	@inlinable
	public subscript<Λ>(dynamicMember lookup: KeyPath<Set<Int>, Λ>) -> Λ {
		state[keyPath: lookup]
	}
	@inlinable
	public subscript<Λ>(dynamicMember lookup: ReferenceWritableKeyPath<Set<Int>, Λ>) -> Λ {
		_read {
			yield state[keyPath: lookup]
		}
		_modify {
			yield &state[keyPath: lookup]
		}
	}
}
extension VSK: MutVector {
	public typealias U = Bool
	public subscript(position: Int) -> Element {
		get {
			state.contains(position)
		}
		set {
			if newValue {
				state.remove(position)
			} else {
				state.insert(position)
			}
		}
	}
	public subscript(bounds: some RangeExpression<Int>) -> Self {
		get {
			let bounds = bounds.relative(to: 0..<count)
			return.init(count: count, state: .init(state.lazy.compactMap {
				bounds.contains($0) ? .some($0 - bounds.lowerBound) : .none
			}))
		}
		set {
			let bounds = bounds.relative(to: 0..<count)
			let found = state.filter(bounds.contains(_:))
			for index in found {
				state.remove(index)
			}
			for index in newValue.state {
				state.insert(index)
			}
		}
	}
	public func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Bool>) {
		let result = Array<Bool>(unsafeUninitializedCapacity: count) {
			$0.initialize(repeating: false)
			for index in state {
				$0[index] = true
			}
			$1 = $0.count
		}
		return ([1], {result})
	}
}
extension VSK {
	public init(shape: (Int)) {
		count = shape
		state = .init()
	}
}
extension VSK {
	public init(_ source: some SparseVector) {
		count = source.count
		state = .init(source.coo.lazy.compactMap {
			$1 != .zero ? .some($0) : .none
		})
	}
}
