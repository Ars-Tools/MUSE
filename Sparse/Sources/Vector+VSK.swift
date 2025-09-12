//
//  Vector+VSK.swift
//  MUSE
//
//  Created by Kota on 9/10/R7.
//
import protocol Dense.Vector
import typealias Layout.MemoryStrategy
@dynamicMemberLookup
@frozen public struct VSK {
	public typealias Element = Bool
	public typealias U = Element
	public let count: Int
	private(set) public var state: Set<Int>
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
extension VSK {
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
				bounds.contains($0) ? .some($0 &- bounds.lowerBound) : .none
			}))
		}
		set {
			let bounds = bounds.relative(to: 0..<count)
			for index in state.filter(bounds.contains(_:)) {
				state.remove(index)
			}
			for index in newValue.state {
				state.insert(index &+ bounds.lowerBound)
			}
		}
	}
}
extension VSK: MutSparseVector {
	public init(shape: (Int)) {
		count = shape
		state = .init()
	}
	public init(shape: (Int), _ nonzero: some Sequence<(Int, Element)>) {
		count = shape
		state = nonzero.reduce(into: .init()) {
			if $1.1 {
				$0.insert($1.0)
			}
		}
	}
}
extension VSK {
	public init(_ source: some SparseVector) {
		count = source.count
		state = source.state
	}
}
extension VSK: ExpressibleByArrayLiteral {
	public init(arrayLiteral elements: Bool...) {
		count = elements.count
		state = .init(elements.enumerated().lazy.filter(\.1).map(\.0))
	}
}
extension VSK: CustomStringConvertible {}
