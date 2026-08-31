//
//  Graph.swift
//  MUSE
//
//  Created by Kota on 9/16/R7.
//
public enum Graph {}
extension Graph { // Djikstra Solvers
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
                for (element, partial) in weight[route.value] ?? [:] {
					assert(.zero <= partial, "edge cost should be positive")
					queue.insert(element: route.appending(element), as: score + partial)
				}
			} else {
				trail.updateValue(score, forKey: route.value)
                for (element, partial) in weight[route.value] ?? [:] {
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
                for (element, partial) in weight[route] ?? [:] {
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
                for (element, partial) in weight[route.value] ?? [:] {
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
