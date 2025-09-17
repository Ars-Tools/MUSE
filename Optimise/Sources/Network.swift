//
//  Network.swift
//  MUSE
//
//  Created by Kota on 9/16/R7.
//
import typealias Foundation.KeyPathComparator
import Sparse
public enum Network {}
extension Network {
	@usableFromInline // Linked-List to share parent nodes
	indirect enum List<Element> {
		case root(Element)
		case node(Element, parent: Self)
	}
	@usableFromInline
	struct PriorityQueue<Score: Comparable, Element> {
		@usableFromInline
		private(set) var sorted: Array<Array<(Score, Element)>>
		@usableFromInline
		private(set) var unscented: Array<(Score, Element)>
	}
}
extension Network.List where Element: Comparable {
	@inlinable@inline(__always)
	func contains(_ body: Element) -> Bool {
		switch self {
		case.root(body):
			true
		case.root:
			false
		case.node(body, _):
			true
		case.node(_, let parent):
			parent.contains(body)
		}
	}
}
extension Network.List {
	@inlinable@inline(__always)@_transparent
	init(_ body: Element) {
		self = .root(body)
	}
	@inlinable@inline(__always)@_transparent
	func appending(_ body: Element) -> Self {
		.node(body, parent: self)
	}
	@inlinable@inline(__always)
	var count: Int {
		switch self {
		case.root:
			.zero
		case.node(_, let head):
			head.count + 1
		}
	}
	@inlinable@inline(__always)
	var value: Element {
		switch self {
		case.root(let body):
			body
		case.node(let body, _):
			body
		}
	}
	@inlinable@inline(__always)
	var forward: Array<Element> {
		switch self {
		case.root(let body):
			[body]
		case.node(let body, let head):
			head.forward + [body]
		}
	}
	@inlinable@inline(__always)
	func forward<R>(map body: (Element) throws -> R) rethrows -> Array<R> {
		switch self {
		case.root(let item):
			return try.init(arrayLiteral: body(item))
		case.node(let item, let head):
			var ary = try head.forward(map: body)
			try ary.append(body(item))
			return ary
		}
	}
	@inlinable@inline(__always)
	var reverse: Array<Element> {
		switch self {
		case.root(let body):
			[body]
		case.node(let body, let tail):
			[body] + tail.reverse
		}
	}
	@inlinable@inline(__always)
	func reverse<R>(map body: (Element) throws -> R) rethrows -> Array<R> {
		switch self {
		case.root(let item):
			return try.init(arrayLiteral: body(item))
		case.node(let item, let head):
			var ary = try Array(arrayLiteral: body(item))
			try ary.append(contentsOf: head.forward(map: body))
			return ary
		}
	}
}
extension Network.PriorityQueue {
	@inlinable@inline(__always)@_transparent
	init() {
		sorted = .init()
		unscented = .init()
	}
	@inlinable@inline(__always)@_transparent
	mutating func insert(element: Element, as score: Score) {
		unscented.append((score, element))
	}
	@inlinable@inline(__always)@_transparent
	mutating func popMin() -> Optional<(Score, Element)> {
		organise()
		return sorted.enumerated().min {
			switch ($0.1.last.unsafelyUnwrapped, $1.1.last.unsafelyUnwrapped) {
			case (let x, let y):
				x.0 < y.0
			}
		}.flatMap {
			sorted[$0.offset].popLast()
		}
	}
	@inlinable@inline(__always)@_transparent
	mutating func popMin(extra compare: KeyPathComparator<Element>) -> Optional<(Score, Element)> {
		organise()
		return sorted.enumerated().min {
			switch ($0.1.last.unsafelyUnwrapped, $1.1.last.unsafelyUnwrapped) {
			case (let x, let y) where x.0 == y.0:
				compare.compare(x.1, y.1) == .orderedAscending
			case (let x, let y):
				x.0 < y.0
			}
		}.flatMap {
			sorted[$0.offset].popLast()
		}
	}
	@inlinable@inline(__always)@_transparent
	mutating func organise() {
		unscented.sort(using: KeyPathComparator(\.0, order: .reverse))
		sorted.append(unscented) // copy
		unscented.removeAll(keepingCapacity: true)
		sorted.removeAll(where: \.isEmpty)
	}
}
extension Network { // Djikstra Solvers
	// Dictionary
	@_disfavoredOverload
	@inlinable@inline(__always)@_transparent
	public static func Djikstra<Key: Hashable, Element: Comparable & Numeric>(source: Key, target: Key, weight: Dictionary<Key, Dictionary<Key, Element>>) -> (Dictionary<Key, Element>, Array<Key>) {
		var trail = Dictionary<Key, Element>()
		var queue = PriorityQueue<Element, List<Key>>()
		queue.insert(element: .init(source), as: .zero)
		var paths = Optional<List<Key>>.none
		while case.some((let score, let route)) = queue.popMin() {
			if case.some(let match) = trail[route.value], match <= score {
				continue
			} else if route.value == target {
				paths = route
				trail.updateValue(score, forKey: route.value)
				for (element, partial) in weight[route.value] {
					assert(.zero <= partial, "edge cost should be positive")
					queue.insert(element: route.appending(element), as: score + partial)
				}
			} else {
				trail.updateValue(score, forKey: route.value)
				for (element, partial) in weight[route.value] {
					assert(.zero <= partial, "edge cost should be positive")
					queue.insert(element: route.appending(element), as: score + partial)
				}
			}
		}
		return (trail, paths.map(\.forward) ?? .init())
	}
	@inlinable@inline(__always)@_transparent
	public static func Djikstra<Key: Hashable, Element: Comparable & Numeric>(source: Key, weight: Dictionary<Key, Dictionary<Key, Element>>) -> Dictionary<Key, Element> {
		var trail = Dictionary<Key, Element>()
		var queue = PriorityQueue<Element, Key>()
		queue.insert(element: source, as: .zero)
		while case.some((let score, let route)) = queue.popMin() {
			if case.some(let match) = trail[route], match <= score {
				continue
			} else {
				trail.updateValue(score, forKey: route)
				for (element, partial) in weight[route] {
					assert(.zero <= partial, "edge cost should be positive")
					queue.insert(element: element, as: score + partial)
				}
			}
		}
		return trail
	}
	@inlinable@inline(__always)@_transparent
	public static func Djikstra<Key: Hashable, Element: Comparable & Numeric>(source: Key, target: Key, weight: Dictionary<Key, Dictionary<Key, Element>>) -> Array<(Key, Element)> {
		var trail = Dictionary<Key, Element>()
		var queue = PriorityQueue<Element, List<Key>>()
		queue.insert(element: .init(source), as: .zero)
		while case.some((let score, let route)) = queue.popMin() {
			if case.some(let match) = trail[route.value], match <= score {
				continue
			} else if route.value == target {
				trail.updateValue(score, forKey: route.value)
				return route.forward {
					($0, trail[$0, default: .zero])
				}
			} else {
				trail.updateValue(score, forKey: route.value)
				for (element, partial) in weight[route.value] {
					assert(.zero <= partial, "edge cost should be positive")
					queue.insert(element: route.appending(element), as: score + partial)
				}
			}
		}
		return.init()
	}
	// Collection
	@_disfavoredOverload
	@inlinable@inline(__always)@_transparent
	public static func Djikstra<Key: Hashable, Element: Comparable & Numeric, Edges: Sequence<(Key, Element)>, Graph: Collection<Edges>>(source: Key, target: Key, weight: Graph) -> (Dictionary<Key, Element>, Array<Key>) where Graph.Index == Key {
		var trail = Dictionary<Key, Element>()
		var queue = PriorityQueue<Element, List<Key>>()
		queue.insert(element: .init(source), as: .zero)
		var paths = Optional<List<Key>>.none
		while case.some((let score, let route)) = queue.popMin() {
			if case.some(let match) = trail[route.value], match <= score {
				continue
			} else if route.value == target {
				paths = route
				trail.updateValue(score, forKey: route.value)
				for (element, partial) in weight[route.value] {
					assert(.zero <= partial, "edge cost should be positive")
					queue.insert(element: route.appending(element), as: score + partial)
				}
			} else {
				trail.updateValue(score, forKey: route.value)
				for (element, partial) in weight[route.value] {
					assert(.zero <= partial, "edge cost should be positive")
					queue.insert(element: route.appending(element), as: score + partial)
				}
			}
		}
		return (trail, paths.map(\.forward) ?? .init())
	}
	@inlinable@inline(__always)@_transparent
	public static func Djikstra<Key: Hashable, Element: Comparable & Numeric, Edges: Sequence<(Key, Element)>, Graph: Collection<Edges>>(source: Key, weight: Graph) -> Dictionary<Key, Element> where Graph.Index == Key {
		var trail = Dictionary<Key, Element>()
		var queue = PriorityQueue<Element, Key>()
		queue.insert(element: source, as: .zero)
		while case.some((let score, let route)) = queue.popMin() {
			if case.some(let match) = trail[route], match <= score {
				continue
			} else {
				trail.updateValue(score, forKey: route)
				for (element, partial) in weight[route] {
					assert(.zero <= partial, "edge cost should be positive")
					queue.insert(element: element, as: score + partial)
				}
			}
		}
		return trail
	}
	@inlinable@inline(__always)@_transparent
	public static func Djikstra<Key: Hashable, Element: Comparable & Numeric, Edges: Sequence<(Key, Element)>, Graph: Collection<Edges>>(source: Key, target: Key, weight: Graph) -> Array<(Key, Element)> where Graph.Index == Key {
		var trail = Dictionary<Key, Element>()
		var queue = PriorityQueue<Element, List<Key>>()
		queue.insert(element: .init(source), as: .zero)
		while case.some((let score, let route)) = queue.popMin() {
			if case.some(let match) = trail[route.value], match <= score {
				continue
			} else if route.value == target {
				trail.updateValue(score, forKey: route.value)
				return route.forward {
					($0, trail[$0, default: .zero])
				}
			} else {
				trail.updateValue(score, forKey: route.value)
				for (element, partial) in weight[route.value] {
					assert(.zero <= partial, "edge cost should be positive")
					queue.insert(element: route.appending(element), as: score + partial)
				}
			}
		}
		return.init()
	}
}
