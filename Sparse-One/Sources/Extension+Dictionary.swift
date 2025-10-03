//
//  Extension+Dictionary.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
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
func`repeat`<Λ, Element>(lil: Λ, count: (Int, Int)) -> LazySequence<FlattenSequence<LazyMapSequence<Repeated<LazyMapSequence<Λ, ChoiceSequence<Λ.Element, LazySequence<FlattenSequence<LazyMapSequence<Λ.Element, LazyMapSequence<EnumeratedSequence<Repeated<Element>>, (Int, Element)>>>>, (Int, Element)>>>, LazyMapSequence<Λ, ChoiceSequence<Λ.Element, LazySequence<FlattenSequence<LazyMapSequence<Λ.Element, LazyMapSequence<EnumeratedSequence<Repeated<Element>>, (Int, Element)>>>>, (Int, Element)>>>>> where Λ: Collection, Λ.Element: Sequence, Λ.Element.Element == (Int, Element) {
    repeatElement(lil.lazy.map {
        switch count.1 {
        case 1:
            ChoiceSequence<Λ.Element,
                           LazySequence<FlattenSequence<LazyMapSequence<Λ.Element, LazyMapSequence<EnumeratedSequence<Repeated<Element>>, (Int, Element)>>>>,
                           (Int, Element)>.A($0)
        case let count:
            ChoiceSequence<Λ.Element,
                           LazySequence<FlattenSequence<LazyMapSequence<Λ.Element, LazyMapSequence<EnumeratedSequence<Repeated<Element>>, (Int, Element)>>>>,
                           (Int, Element)>.B($0.lazy.flatMap { repeatElement($1, count: count).enumerated().lazy.map(\.self) })
        }
    }, count: count.0).lazy.flatMap(\.self)
}
@inlinable@inline(__always)
func`repeat`<Λ, Element>(lil: Λ, count: (Int, Int)) -> LazySequence<FlattenSequence<LazyMapSequence<Repeated<LazyMapSequence<Λ, ChoiceSequence<LazyMapSequence<Dictionary<Int, Element>, (Int, Element)>, LazySequence<FlattenSequence<LazyMapSequence<Dictionary<Int, Element>, LazyMapSequence<EnumeratedSequence<Repeated<Element>>, (Int, Element)>>>>, (Int, Element)>>>, LazyMapSequence<Λ, ChoiceSequence<LazyMapSequence<Dictionary<Int, Element>, (Int, Element)>, LazySequence<FlattenSequence<LazyMapSequence<Dictionary<Int, Element>, LazyMapSequence<EnumeratedSequence<Repeated<Element>>, (Int, Element)>>>>, (Int, Element)>>>>> where Λ: Collection, Λ.Element == Dictionary<Int, Element> {
    repeatElement(lil.lazy.map {
        switch count.1 {
        case 1:
            ChoiceSequence<LazyMapSequence<Dictionary<Int, Element>, (Int, Element)>,
                           LazySequence<FlattenSequence<LazyMapSequence<Dictionary<Int, Element>, LazyMapSequence<EnumeratedSequence<Repeated<Element>>, (Int, Element)>>>>,
                           (Int, Element)>.A($0.lazy.map(\.self))
        case let count:
            ChoiceSequence<LazyMapSequence<Dictionary<Int, Element>, (Int, Element)>,
                           LazySequence<FlattenSequence<LazyMapSequence<Dictionary<Int, Element>, LazyMapSequence<EnumeratedSequence<Repeated<Element>>, (Int, Element)>>>>,
                           (Int, Element)>.B($0.lazy.flatMap { repeatElement($1, count: count).enumerated().lazy.map(\.self) })
        }
    }, count: count.0).lazy.flatMap(\.self)
}
@_disfavoredOverload
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
@_disfavoredOverload
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
