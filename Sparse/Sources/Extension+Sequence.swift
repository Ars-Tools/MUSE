//
//  Extension+Sequence.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
extension LazyMapSequence: @retroactive @unchecked Sendable {}
extension Optional: @retroactive IteratorProtocol where Wrapped: IteratorProtocol {
    public mutating func next() -> Optional<Wrapped.Element> {
        self?.next()
    }
}
extension Optional: @retroactive Sequence where Wrapped: Sequence {
    public func makeIterator() -> Optional<Wrapped.Iterator> {
        self?.makeIterator()
    }
}
//@usableFromInline
//@frozen struct OptionalSequence<Wrapped: Sequence>: RawRepresentable {
//    @usableFromInline typealias RawValue = Optional<Wrapped>
//    @usableFromInline let rawValue: Optional<Wrapped>
//    @usableFromInline
//    init(rawValue: Optional<Wrapped>) {
//        self.rawValue = rawValue
//    }
//}
//extension OptionalSequence: Sequence, @unchecked Sendable {
//    @usableFromInline typealias Element = Wrapped.Element
//    @usableFromInline
//    @frozen struct Iterator: IteratorProtocol & RawRepresentable {
//        @usableFromInline
//        typealias RawValue = Optional<Wrapped.Iterator>
//        @usableFromInline
//        var rawValue: RawValue
//        @inlinable
//        mutating func next() -> Optional<Wrapped.Element> {
//            rawValue?.next()
//        }
//        @inlinable
//        init(rawValue: RawValue) {
//            self.rawValue = rawValue
//        }
//    }
//    @inlinable
//    func makeIterator() -> Iterator {
//        .init(rawValue: rawValue?.makeIterator())
//    }
//}
@usableFromInline
enum ChoiceIterator<A: IteratorProtocol<Element>, B: IteratorProtocol<Element>, Element> {
    case A(A)
    case B(B)
}
extension ChoiceIterator: IteratorProtocol {
    @inlinable
    mutating func next() -> Optional<Element> {
        switch self {
        case.A(var A):
            defer { self = .A(A) }
            return A.next()
        case.B(var B):
            defer { self = .B(B) }
            return B.next()
        }
    }
}
@usableFromInline
enum ChoiceSequence<A: Sequence<Element>, B: Sequence<Element>, Element> {
    case A(A)
    case B(B)
}
extension ChoiceSequence: Sequence {
    @inlinable
    func makeIterator() -> ChoiceIterator<A.Iterator, B.Iterator, Element> {
        switch self {
        case.A(let A):.A(A.makeIterator())
        case.B(let B):.B(B.makeIterator())
        }
    }
}
