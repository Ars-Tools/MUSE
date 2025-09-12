//
//  Dictionary+.swift
//  MUSE
//
//  Created by Kota on 9/10/R7.
//
import func Layout.product
@inlinable@inline(__always)
func unpack<Key, Value: Numeric>(_ dictionary: Dictionary<Key, Value>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Key, Value>, Optional<(Key, Value)>>>, (Key, Value)> {
	dictionary.lazy.compactMap { $1 == .zero ? .none : .some(($0, $1)) }
}
@inlinable@inline(__always)
func transpose<Element>(lil: some Collection<some Sequence<(Int, Element)>>, for count: Int) -> Array<Dictionary<Int, Element>> {
	lil.enumerated().reduce(into: Array<Dictionary<Int, Element>>(repeating: .init(), count: count)) {
		for (idx, val) in $1.1 {
			$0[idx].updateValue(val, forKey: $1.0)
		}
	}
}
@inlinable@inline(__always)
func+<Element: Numeric>(lhs: Dictionary<Int, Element>, rhs: Dictionary<Int, Element>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Set<Int>, Optional<(Int, Element)>>>, (Int, Element)> {
	let key = switch (lhs.keys, rhs.keys) {
	case (let l, let r) where l.count < r.count:
		Set(r).union(l)
	case (let l, let r):
		Set(l).union(r)
	}
	return key.lazy.compactMap {
		switch lhs[$0, default: .zero] + rhs[$0, default: .zero] {
		case.zero:
			.none
		case let v:
			.some(($0, v))
		}
	}
}
@inlinable@inline(__always)
func*<Element: Numeric>(lhs: Dictionary<Int, Element>, rhs: Dictionary<Int, Element>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Set<Int>, Optional<(Int, Element)>>>, (Int, Element)> {
	let key = switch (lhs.keys, rhs.keys) {
	case (let l, let r) where l.count < r.count:
		Set(r).intersection(l)
	case (let l, let r):
		Set(l).intersection(r)
	}
	return key.lazy.compactMap {
		switch lhs[$0, default: .zero] * rhs[$0, default: .zero] {
		case.zero:
			.none
		case let v:
			.some(($0, v))
		}
	}
}
@inlinable@inline(__always)
func dot<Element: Numeric>(lhs: some Sequence<(Int, Element)>, rhs: some Sequence<(Int, Element)>) -> Element {
	switch (Dictionary(uniqueKeysWithValues: lhs), Dictionary(uniqueKeysWithValues: rhs)) {
	case (let lhs, let rhs) where lhs.count < rhs.count:
		lhs.reduce(into: .zero) {
			if let rhs = rhs[$1.0] {
				$0 += $1.1 * rhs
			}
		}
	case (let lhs, let rhs):
		rhs.reduce(into: .zero) {
			if let lhs = lhs[$1.0] {
				$0 += lhs * $1.1
			}
		}
	}
}
@inlinable@inline(__always)
func`repeat`<Λ, Element>(lil: Λ, count: (Int, Int)) -> LazySequence<FlattenSequence<LazyMapSequence<Repeated<LazyMapSequence<Λ, Dictionary<Int, Element>>>, LazyMapSequence<Λ, Dictionary<Int, Element>>>>> where Λ: Collection, Λ.Element: Sequence, Λ.Element.Element == (Int, Element) {
	repeatElement(lil.lazy.map {
		switch count.1 {
		case 1:
			Dictionary(uniqueKeysWithValues: $0)
		case let count:
			Dictionary(uniqueKeysWithValues: $0.lazy.flatMap { repeatElement($1, count: count).enumerated() })
		}
	}, count: count.0).lazy.flatMap(\.self)
}
@inlinable@inline(__always)
func`repeat`<Λ, Element>(lil: Λ, count: (Int, Int)) -> LazySequence<FlattenSequence<LazyMapSequence<Repeated<LazyMapSequence<Λ, Dictionary<Int, Element>>>, LazyMapSequence<Λ, Dictionary<Int, Element>>>>> where Λ: Collection, Λ.Element == Dictionary<Int, Element> {
	repeatElement(lil.lazy.map {
		switch count.1 {
		case 1:
			$0
		case let count:
			Dictionary(uniqueKeysWithValues: $0.lazy.flatMap { repeatElement($1, count: count).enumerated() })
		}
	}, count: count.0).lazy.flatMap(\.self)
}
@inlinable@inline(__always)
func`repeat`(position: Set<SIMD2<Int>>, count: (Int, Int)) -> Set<SIMD2<Int>> {
	switch count {
	case (1, 1):
		position
	case (let l, 1):
		.init(position.lazy.flatMap {
			repeatElement($0.y, count: l).enumerated().lazy.map { .init($0, $1) }
		 })
	case (1, let r):
		.init(position.lazy.flatMap {
			repeatElement($0.x, count: r).enumerated().lazy.map { .init($1, $0) }
		})
	case let (l, r):
		position.isEmpty ? .init() : .init(product(0..<l, 0..<r))
	}
}
@usableFromInline
@frozen struct OptionalSequence<Wrapped: Sequence>: RawRepresentable {
	@usableFromInline typealias RawValue = Optional<Wrapped>
	@usableFromInline let rawValue: Optional<Wrapped>
	@usableFromInline
	init(rawValue: Optional<Wrapped>) {
		self.rawValue = rawValue
	}
}
extension OptionalSequence: Sequence, @unchecked Sendable {
	@usableFromInline typealias Element = Wrapped.Element
	@usableFromInline
	@frozen struct Iterator: IteratorProtocol & RawRepresentable {
		@usableFromInline
		typealias RawValue = Optional<Wrapped.Iterator>
		@usableFromInline
		var rawValue: RawValue
		@inlinable
		mutating func next() -> Optional<Wrapped.Element> {
			rawValue?.next()
		}
		@inlinable
		init(rawValue: RawValue) {
			self.rawValue = rawValue
		}
	}
	@inlinable
	func makeIterator() -> Iterator {
		.init(rawValue: rawValue?.makeIterator())
	}
}
