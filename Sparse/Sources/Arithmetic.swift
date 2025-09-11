//
//  Arithmetic.swift
//  MUSE
//
//  Created by Kota on 9/11/R7.
//
import typealias Layout.MemoryStrategy
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
