//
//  Graph+List.swift
//  MUSE
//
//  Created by Kota on 8/30/26.
//
extension Graph {
    @usableFromInline // Linked-List to share parent nodes
    indirect enum List<Element> {
        case root(Element)
        case node(Element, parent: Self)
    }
}
extension Graph.List where Element: Comparable {
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
extension Graph.List {
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
