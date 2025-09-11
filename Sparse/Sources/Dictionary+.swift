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
//@inlinable@inline(__always)
//func+<Element: Numeric>(lhs: Dictionary<Int, Element>, rhs: Dictionary<Int, Element>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Int, Element>, Optional<(Int, Element)>>>, (Int, Element)> {
//	return if lhs.count < rhs.count {
//		rhs.merging(lhs, uniquingKeysWith: +)
//			.lazy.compactMap {
//				$1 == .zero ? .none : .some(($0, $1))
//			}
//	} else {
//		lhs.merging(rhs, uniquingKeysWith: +)
//			.lazy.compactMap {
//				$1 == .zero ? .none : .some(($0, $1))
//			}
//	}
//}
//@inlinable@inline(__always)
//func-<Element: SignedNumeric>(lhs: some Sequence<(Int, Element)>, rhs: Dictionary<Int, Element>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Int, Element>, Optional<(Int, Element)>>>, (Int, Element)> {
//	rhs.mapValues(-).merging(lhs, uniquingKeysWith: +)
//		.lazy.compactMap {
//			$1 == .zero ? .none : .some(($0, $1))
//		}
//}
//@inlinable@inline(__always)
//func*<Element: Numeric>(lhs: Dictionary<Int, Element>, rhs: Dictionary<Int, Element>) -> LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Int, Element>, Optional<(Int, Element)>>>, (Int, Element)> {
//	if lhs.count < rhs.count {
//		lhs.lazy.compactMap {
//			if let rhs = rhs[$0] {
//				.some(($0, $1 * rhs))
//			} else {
//				.none
//			}
//		}
//	} else {
//		rhs.lazy.compactMap {
//			if let lhs = lhs[$0] {
//				.some(($0, lhs * $1))
//			} else {
//				.none
//			}
//		}
//	}
//}
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
