//
//  Buffer+Tensor.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import Accelerate.vecLib
extension Buffer {
    @dynamicMemberLookup
    @frozen public struct Tensor {
        public typealias Element = Storage.Element
        public typealias S = Buffer<Storage.SubSequence>.Tensor
        public typealias T = Self
        public typealias U = Buffer<Storage.SubSequence>.Tensor
        public typealias V = Buffer<Storage.SubSequence>.Tensor
        public let shape: Array<Int>
        @usableFromInline let pitch: Array<Int>
        @usableFromInline private(set) var store: Storage
    }
}
extension Buffer.Tensor {
    @_disfavoredOverload
    @inlinable@inline(__always)
    public subscript<R>(dynamicMember lookup: KeyPath<Storage, R>) -> R {
        store[keyPath: lookup]
    }
    @_disfavoredOverload
    @inlinable@inline(__always)
    public subscript<R>(dynamicMember lookup: ReferenceWritableKeyPath<Storage, R>) -> R {
        _read {
            yield store[keyPath: lookup]
        }
        _modify {
            yield &store[keyPath: lookup]
        }
    }
}
extension Buffer.Tensor: InstantScalar {
    
}
extension Buffer.Tensor: InstantVector {
    @inlinable@inline(__always)
    public var count: Int {
        switch MemoryStrategy.default {
        case.rowMajor:
            shape.last ?? 1
        case.columnMajor:
            shape.first ?? 1
        }
    }
    @inlinable@inline(__always)
    public subscript(position: Int) -> U {
        self[[position]]
    }
    @inlinable@inline(__always)
    public subscript(bounds: some RangeExpression<Int>) -> S {
        self[[bounds]]
    }
}
extension Buffer.Tensor: InstantMatrix {
    @inlinable@inline(__always)
    public var rows: Int {
        switch MemoryStrategy.default {
        case.rowMajor:
            shape.dropLast().last ?? 1
        case.columnMajor:
            shape.first ?? 1
        }
    }
    @inlinable@inline(__always)
    public var cols: Int {
        switch MemoryStrategy.default {
        case.rowMajor:
            shape.last ?? 1
        case.columnMajor:
            shape.dropFirst().first ?? 1
        }
    }
    @inlinable@inline(__always)
    public subscript(row: Int, col: Int) -> U {
        self[[row, col]]
    }
    @inlinable@inline(__always)
    public subscript(row: Int, col: some RangeExpression<Int>) -> V {
        self[[row..<row, col.relative(to: 0..<cols)]]
    }
    @inlinable@inline(__always)
    public subscript(row: some RangeExpression<Int>, col: Int) -> V {
        self[[row.relative(to: 0..<rows), col..<col]]
    }
    @inlinable@inline(__always)
    public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        self[[row.relative(to: 0..<rows), col.relative(to: 0..<cols)]]
    }
}
extension Buffer.Tensor: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Storage) {
        (zip(shape, pitch).compactMap { $0 != .zero ? .some($1) : .none }, {[store] in store})
    }
    @inline(__always)
    public var transpose: T {
        .init(shape: shape.reversed(), pitch: pitch.reversed(), store: store)
    }
    @inline(__always)
    public var diagonal: V {
        .init(shape: shape.sorted(by: >).suffix(1), pitch: .init(arrayLiteral: pitch.reduce(0, +)), store: store[store.startIndex...])
    }
    @inlinable@inline(__always)
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        self[position.map{$0..<$0}]
    }
    @inline(__always)
    public subscript<Q>(bounds: Q) -> S where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        precondition(bounds.count <= shape.count)
        switch MemoryStrategy.default {
        case.rowMajor:
            let slice = zip(bounds, shape.prefix(bounds.count)).map { $0.relative(to: 0..<$1) }
            let lower = zip(slice, pitch).reduce(store.startIndex) { $0.advanced(by: $1.0.lowerBound * $1.1) }
            let (pitch, shape) = zip(pitch, concat(slice.map(\.count), shape.dropFirst(slice.count)))
                .filter { $1 != 0 }
                .reduce(into: (Array<Int>(), Array<Int>())) {
                    $0.0.append($1.0)
                    $0.1.append($1.1)
                }
            let upper = lower.advanced(by: capacity(slice: shape, stride: pitch))
            return.init(shape: shape, pitch: pitch, store: store[lower..<upper])
        case.columnMajor:
            let slice = zip(bounds, shape.suffix(bounds.count)).map { $0.relative(to: 0..<$1) }
            let lower = zip(slice, pitch).reduce(store.startIndex) { $0.advanced(by: $1.0.lowerBound * $1.1) }
            let (pitch, shape) = zip(pitch, concat(shape.dropLast(slice.count), slice.map(\.count)))
                .filter { $1 != 0 }
                .reduce(into: (Array<Int>(), Array<Int>())) {
                    $0.0.append($1.0)
                    $0.1.append($1.1)
                }
            let upper = lower.advanced(by: capacity(slice: shape, stride: pitch))
            return.init(shape: shape, pitch: pitch, store: store[lower..<upper])
        }
    }
}
extension Buffer.Tensor: MutableTensor where Storage: MutableCollection {
    @inline(__always)
    public subscript<P>(position: P) -> U where P : RandomAccessCollection, P.Element == Int, P.Index : Strideable, P.Index.Stride == Int {
        _read {
            yield self[position.map{$0..<$0}]
        }
        _modify {
            yield &self[position.map{$0..<$0}]
        }
    }
    @inline(__always)
    public subscript<Q>(bounds: Q) -> Buffer<Storage.SubSequence>.Tensor where Q : RandomAccessCollection, Q.Element : RangeExpression, Q.Index : Strideable, Q.Element.Bound == Int, Q.Index.Stride == Int {
        get {
            precondition(bounds.count <= shape.count)
            let order = MemoryStrategy.default
            switch order {
            case.rowMajor:
                let bounds = zip(bounds, shape.prefix(bounds.count)).map { $0.relative(to: 0..<$1) }
                let lower = zip(bounds, pitch).reduce(store.startIndex) { $0.advanced(by: $1.0.lowerBound * $1.1) }
                let (pitch, shape) = zip(pitch, concat(bounds.map(\.count), shape.dropFirst(bounds.count)))
                    .filter { $1 != 0 }
                    .reduce(into: (Array<Int>(), Array<Int>())) {
                        $0.0.append($1.0)
                        $0.1.append($1.1)
                    }
                let upper = lower.advanced(by: capacity(slice: shape, stride: pitch))
                return.init(shape: shape, pitch: pitch, store: store[lower..<upper])
            case.columnMajor:
                let bounds = zip(bounds, shape.suffix(bounds.count)).map { $0.relative(to: 0..<$1) }
                let lower = zip(bounds, pitch).reduce(store.startIndex) { $0.advanced(by: $1.0.lowerBound * $1.1) }
                let (pitch, shape) = zip(pitch, concat(shape.dropLast(bounds.count), bounds.map(\.count)))
                    .filter { $1 != 0 }
                    .reduce(into: (Array<Int>(), Array<Int>())) {
                        $0.0.append($1.0)
                        $0.1.append($1.1)
                    }
                let upper = lower.advanced(by: capacity(slice: shape, stride: pitch))
                return.init(shape: shape, pitch: pitch, store: store[lower..<upper])
            }
        }
        set {
            precondition(bounds.count <= shape.count)
            let order = MemoryStrategy.default
            switch order {
            case.rowMajor:
                let slice = zip(bounds, shape.prefix(bounds.count)).map { $0.relative(to: 0..<$1) }
                let lower = zip(slice, pitch).reduce(store.startIndex) { $0.advanced(by: $1.0.lowerBound * $1.1) }
                let (pitch, shape) = zip(pitch, concat(slice.map(\.count), shape.dropFirst(slice.count)))
                    .filter { $1 != 0 }
                    .reduce(into: (Array<Int>(), Array<Int>())) {
                        $0.0.append($1.0)
                        $0.1.append($1.1)
                    }
                let upper = newValue.store.startIndex
                let (length, stride, offset) = order.flatten(shape: shape,
                                                             xs: order.broadcast(target: shape, source: newValue.shape, stride: newValue.pitch),
                                                             ys: pitch)
                for (offset, cursor) in product(offset, 0..<length) {
                    store[lower.advanced(by: offset.y + stride.y * cursor)] = newValue.store[upper.advanced(by: offset.x + stride.x * cursor)]
                }
            case.columnMajor:
                let slice = zip(bounds, shape.suffix(bounds.count)).map { $0.relative(to: 0..<$1) }
                let lower = zip(slice, pitch).reduce(store.startIndex) { $0.advanced(by: $1.0.lowerBound * $1.1) }
                let (pitch, shape) = zip(pitch, concat(shape.dropLast(slice.count), slice.map(\.count)))
                    .filter { $1 != 0 }
                    .reduce(into: (Array<Int>(), Array<Int>())) {
                        $0.0.append($1.0)
                        $0.1.append($1.1)
                    }
                let upper = newValue.store.startIndex
                let (length, stride, offset) = order.flatten(shape: shape,
                                                             xs: order.broadcast(target: shape, source: newValue.shape, stride: newValue.pitch),
                                                             ys: pitch)
                for (offset, cursor) in product(offset, 0..<length) {
                    store[lower.advanced(by: offset.y + stride.y * cursor)] = newValue.store[upper.advanced(by: offset.x + stride.x * cursor)]
                }
            }
        }
    }
}
extension Buffer.Tensor: CustomStringConvertible {
    @inlinable@inline(__always)@_transparent
    func describing(depth: Int, start: Storage.Index, container: ArraySlice<(Int, Int)>) -> String {
        switch container.first {
        case.some((let length, let stride)) where 1 < container.count:
            "[" + (0..<length).map {
                describing(depth: depth + 1, start: start.advanced(by: $0 * stride), container: container.dropFirst())
            }.joined(separator: ",\r\n" + repeatElement(" ", count: depth).joined()) + "]"
        case.some((let length, let stride)):
            (0..<length).map { store[start.advanced(by: $0 * stride)] }.description
        case.none:
            store.first.map { "\($0)" } ?? "()"
        }
    }
    @inlinable@_transparent
    public var description: String {
        describing(depth: 1, start: store.startIndex, container: .init(zip(shape, pitch)))
    }
}
extension Buffer.Tensor {
    @inlinable@_transparent
    public init<Source: InstantTensor>(_ source: Source, for strategy: MemoryStrategy = .default) throws where Source.Storage == Storage {
        let (stride, kernel) = try source.evaluation(for: strategy)
        shape = source.shape
        pitch = stride
        store = kernel()
    }
    @inlinable@_transparent
    public init<Source: Tensor>(_ source: Source, for strategy: MemoryStrategy = .default) async throws where Source.Storage == Storage {
        let (stride, kernel) = try source.evaluation(for: strategy)
        async let result = kernel()
        shape = source.shape
        pitch = stride
        store = await result
    }
}
extension Buffer.Tensor where Storage: RangeReplaceableCollection {
    @inlinable@_transparent
    public init(_ source: any InstantTensor<Element>, for strategy: MemoryStrategy = .default) throws {
        let (stride, kernel) = try source.evaluation(for: strategy)
        shape = source.shape
        pitch = stride
        store = .init(kernel())
    }
    @inlinable@_transparent
    public init(_ source: any Tensor<Element>, for strategy: MemoryStrategy = .default) async throws {
        let (stride, kernel) = try source.evaluation(for: strategy)
        async let result = kernel()
        shape = source.shape
        pitch = stride
        store = await.init(result)
    }
    @inlinable@_transparent
    public init(shape s: some Collection<Int>, for strategy: MemoryStrategy = .default, with value: Element) {
        shape = .init(s)
        pitch = strategy.stride(for: shape)
        store = .init(repeating: value, count: capacity(alloc: shape, stride: pitch))
    }
}
extension Buffer.Tensor: ExpressibleByBooleanLiteral where Storage: RangeReplaceableCollection, Element == BooleanLiteralType {
    @inlinable@_transparent
    public init(booleanLiteral value: Element) {
        shape = .init()
        pitch = .init()
        store = .init(repeating: value, count: 1)
    }
}
extension Buffer.Tensor: ExpressibleByIntegerLiteral where Storage: RangeReplaceableCollection, Element == IntegerLiteralType {
    @inlinable@_transparent
    public init(integerLiteral value: Element) {
        shape = .init()
        pitch = .init()
        store = .init(repeating: value, count: 1)
    }
}
extension Buffer.Tensor: ExpressibleByFloatLiteral where Storage: RangeReplaceableCollection, Element == FloatLiteralType {
    @inlinable@_transparent
    public init(floatLiteral value: Element) {
        shape = .init()
        pitch = .init()
        store = .init(repeating: value, count: 1)
    }
}
extension Buffer.Tensor: ExpressibleByArrayLiteral where Storage: RangeReplaceableCollection {
    @inlinable@_transparent
    public init(arrayLiteral elements: Buffer<Storage>.Tensor...) {
        precondition(0 < elements.count, "empty tensor is not allowed")
        let order = MemoryStrategy.default
        let count = elements.reduce([]) {
            order.broadcast(x: $0, y: $1.shape)
        }
        let total = count.reduce(1, *)
        shape = [elements.count] + count
        pitch = order.stride(for: shape)
        store = .init(elements.flatMap {
            repeatElement($0.store, count: total / $0.store.count).flatMap(\.self)
        })
    }
}
public typealias NDArray<Element: MutableScalar<Element>> = Buffer<Array<Element>>.Tensor
