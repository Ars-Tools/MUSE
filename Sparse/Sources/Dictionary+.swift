//
//  Dictionary+.swift
//  MUSE
//
//  Created by Kota on 9/10/R7.
//
@inlinable@inline(__always)
func unpack<Key, Value: Numeric>(_ dictionary: Dictionary<Key, Value>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Key, Value>, Optional<(Key, Value)>>>, (Key, Value)> {
	dictionary.lazy.compactMap { $1 == .zero ? .none : .some(($0, $1)) }
}
@inlinable@inline(__always)
func transpose<Element: Numeric>(lil: some Collection<some Sequence<(Int, Element)>>, for count: Int) -> Array<Dictionary<Int, Element>> {
	lil.enumerated().reduce(into: Array<Dictionary<Int, Element>>(repeating: .init(), count: count)) {
		for (idx, val) in $1.1 where val != .zero {
			$0[idx].updateValue(val, forKey: $1.0)
		}
	}
}
@inlinable@inline(__always)
func+<Element: Numeric>(lhs: Dictionary<Int, Element>, rhs: some Sequence<(Int, Element)>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Int, Element>, Optional<(Int, Element)>>>, (Int, Element)> {
	lhs.merging(rhs, uniquingKeysWith: +)
		.lazy.compactMap {
			$1 == .zero ? .none : .some(($0, $1))
		}
}
@inlinable@inline(__always)
func+<Element: Numeric>(lhs: some Sequence<(Int, Element)>, rhs: Dictionary<Int, Element>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Int, Element>, Optional<(Int, Element)>>>, (Int, Element)> {
	rhs.merging(lhs, uniquingKeysWith: +)
		.lazy.compactMap {
			$1 == .zero ? .none : .some(($0, $1))
		}
}
@inlinable@inline(__always)
func-<Element: SignedNumeric>(lhs: some Sequence<(Int, Element)>, rhs: Dictionary<Int, Element>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Int, Element>, Optional<(Int, Element)>>>, (Int, Element)> {
	rhs.mapValues(-).merging(lhs, uniquingKeysWith: +)
		.lazy.compactMap {
			$1 == .zero ? .none : .some(($0, $1))
		}
}
@inlinable@inline(__always)
func*<Element: Numeric>(lhs: Dictionary<Int, Element>, rhs: Dictionary<Int, Element>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Int, Element>, Optional<(Int, Element)>>>, (Int, Element)> {
	if lhs.count < rhs.count {
		lhs.lazy.compactMap {
			if let rhs = rhs[$0] {
				.some(($0, $1 * rhs))
			} else {
				.none
			}
		}
	} else {
		rhs.lazy.compactMap {
			if let lhs = lhs[$0] {
				.some(($0, lhs * $1))
			} else {
				.none
			}
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
