//
//  Graph+PriorityQueue.swift
//  MUSE
//
//  Created by Kota on 8/30/26.
//
import typealias Foundation.KeyPathComparator
extension Graph {
    @usableFromInline
    struct PriorityQueue<Score: Comparable, Element> {
        @usableFromInline
        private(set) var sorted: Array<Array<(Score, Element)>>
        @usableFromInline
        private(set) var unscented: Array<(Score, Element)>
    }
}
extension Graph.PriorityQueue {
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
            switch ($0.1.last, $1.1.last) {
            case(.some(let x), .some(let y)):
                x.0 < y.0
            default:
                fatalError()
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
