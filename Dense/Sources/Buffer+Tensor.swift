//
//  Buffer+Tensor.swift
//  MUSE
//
//  Created by Kota on 9/19/R7.
//
import protocol Accelerate.AccelerateBuffer
import protocol Accelerate.AccelerateMutableBuffer
import func Layout.capacity
import func Layout.flatten
import func Layout.concat
import func Layout.broadcast
import func Layout.offset
import func Layout.product
import typealias Layout.MemoryStrategy
@dynamicMemberLookup
@frozen public struct TensorBuffer<R: Storage> where R.Index: Strideable, R.Index.Stride == Int, R.Element: ScalarBuffer, R.SubSequence: Storage {
	public typealias Element = R.Element
	public typealias S = TensorBuffer<R.SubSequence>
	public typealias T = Self
	public typealias U = TensorBuffer<R.SubSequence>
	public typealias V = TensorBuffer<R.SubSequence>
	public let shape: Array<Int>
    @usableFromInline let order: MemoryStrategy
	@usableFromInline let pitch: Array<Int>
	@usableFromInline private(set) var store: R
}
extension TensorBuffer {
    @_disfavoredOverload
    @inlinable@inline(__always)
	public subscript<Λ>(dynamicMember lookup: KeyPath<R, Λ>) -> Λ {
		store[keyPath: lookup]
	}
    @_disfavoredOverload
    @inlinable@inline(__always)
	public subscript<Λ>(dynamicMember lookup: ReferenceWritableKeyPath<R, Λ>) -> Λ {
		_read {
			yield store[keyPath: lookup]
		}
		_modify {
			yield &store[keyPath: lookup]
		}
	}
}
// MARK: Scalar
extension TensorBuffer: InstantScalar {
    
}
// MARK: Vector
extension TensorBuffer: InstantVector {
    @inlinable@_transparent
    public var count: Int {
        switch order {
        case.rowMajor:
            shape.last ?? 1
        case.columnMajor:
            shape.first ?? 1
        }
    }
    public subscript(position: Int) -> U {
        switch order {
        case.rowMajor:
            self[[position..<position] + shape.dropFirst().map{0..<$0}]
        case.columnMajor:
            self[shape.dropLast().map{0..<$0} + [position..<position]]
        }
    }
    public subscript(bounds: some RangeExpression<Int>) -> S {
        switch order {
        case.rowMajor:
            self[shape.prefix(1).map{bounds.relative(to: 0..<$0)} + shape.dropFirst().map{0..<$0}]
        case.columnMajor:
            self[shape.dropLast().map{0..<$0} + shape.suffix(1).map{bounds.relative(to: 0..<$0)}]
        }
    }
}
// MARK: Matrix
extension TensorBuffer: InstantMatrix {
    @inlinable@_transparent
    public var rows: Int {
        switch order {
        case.rowMajor:
            shape.first ?? 1
        case.columnMajor:
            shape.dropLast().last ?? 1
        }
    }
    @inlinable@_transparent
    public var cols: Int {
        switch order {
        case.rowMajor:
            shape.dropFirst().first ?? 1
        case.columnMajor:
            shape.last ?? 1
        }
    }
    public subscript(row: Int, col: Int) -> U {
        switch order {
        case.rowMajor:
            self[[row..<row, col..<col] + shape.dropFirst(2).map{0..<$0}]
        case.columnMajor:
            self[shape.dropLast(2).map{0..<$0} + [row..<row, col..<col]]
        }
    }
    public subscript(row: Int, col: some RangeExpression<Int>) -> V {
        switch order {
        case.rowMajor:
            self[[row..<row, col.relative(to: 0..<cols)] + shape.dropFirst(2).map{0..<$0}]
        case.columnMajor:
            self[shape.dropLast(2).map{0..<$0} + [row..<row, col.relative(to: 0..<cols)]]
        }
    }
    public subscript(row: some RangeExpression<Int>, col: Int) -> V {
        switch order {
        case.rowMajor:
            self[[row.relative(to: 0..<rows), col..<col] + shape.dropFirst(2).map{0..<$0}]
        case.columnMajor:
            self[shape.dropLast(2).map{0..<$0} + [row.relative(to: 0..<rows), col..<col]]
        }
    }
    public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        switch order {
        case.rowMajor:
            self[[row.relative(to: 0..<rows), col.relative(to: 0..<cols)] + shape.dropFirst(2).map{0..<$0}]
        case.columnMajor:
            self[shape.dropLast(2).map{0..<$0} + [row.relative(to: 0..<rows), col.relative(to: 0..<cols)]]
        }
    }
}
// MARK: Tensor
extension TensorBuffer: InstantTensor {
	public var transpose: T {
        .init(shape: shape.reversed(), order: order.transpose, pitch: pitch.reversed(), store: store)
	}
	public var diagonal: V {
        .init(shape: [shape.min() ?? 1], order: order, pitch: [pitch.reduce(0, +)], store: store[store.startIndex...])
	}
	public subscript<P>(position: P) -> U where P: RandomAccessCollection, P.Index == Int, P.Element == Int {
        self[position.map{$0..<$0} + shape.dropFirst(position.count).map{0..<$0}]
	}
    public subscript<Q>(bounds: Q) -> S where Q: RandomAccessCollection, Q.Index == Int, Q.Element: RangeExpression, Q.Element.Bound == Int {
        precondition(bounds.count <= shape.count)
        let slice = zip(bounds, shape).map { $0.relative(to: 0..<$1) }
        let lower = zip(slice, pitch).reduce(store.startIndex) { $0.advanced(by: $1.0.lowerBound * $1.1) }
        let (pitch, shape) = zip(pitch, concat(slice.map { $0.count }, shape.dropFirst(slice.count)))
            .filter { $1 != 0 }
            .reduce(into: (Array<Int>(), Array<Int>())) {
                $0.0.append($1.0)
                $0.1.append($1.1)
            }
        let upper = lower.advanced(by: capacity(slice: shape, stride: pitch))
        return.init(shape: shape, order: order, pitch: pitch, store: store[lower..<upper])
    }
	public func evaluation(for strategy: MemoryStrategy) -> (Array<Int>, @Sendable () -> R) {
		(pitch, {store})
	}
}
// MARK: Scalar
extension TensorBuffer: MutableScalar where R: MutableStorage, R.SubSequence: MutableStorage {
    @inlinable@inline(__always)
    public subscript() -> Element {
        _read {
            yield store[store.startIndex]
        }
        _modify {
            yield &store[store.startIndex]
        }
    }
}
// MARK: Vector
extension TensorBuffer: MutableVector where R: MutableStorage, R.SubSequence: MutableStorage {
    public subscript(position: Int) -> U {
        get {
            switch order {
            case.rowMajor:
                self[[position..<position] + shape.dropFirst().map{0..<$0}]
            case.columnMajor:
                self[shape.dropLast().map{0..<$0} + [position..<position]]
            }
        }
        set {
            switch order {
            case.rowMajor:
                self[[position..<position] + shape.dropFirst().map{0..<$0}] = newValue
            case.columnMajor:
                self[shape.dropLast().map{0..<$0} + [position..<position]] = newValue
            }
        }
    }
    public subscript(bounds: some RangeExpression<Int>) -> S {
        get {
            switch order {
            case.rowMajor:
                self[shape.prefix(1).map{bounds.relative(to: 0..<$0)} + shape.dropFirst().map{0..<$0}]
            case.columnMajor:
                self[shape.dropLast().map{0..<$0} + shape.suffix(1).map{bounds.relative(to: 0..<$0)}]
            }
        }
        set {
            switch order {
            case.rowMajor:
                self[shape.prefix(1).map{bounds.relative(to: 0..<$0)} + shape.dropFirst().map{0..<$0}] = newValue
            case.columnMajor:
                self[shape.dropLast().map{0..<$0} + shape.suffix(1).map{bounds.relative(to: 0..<$0)}] = newValue
            }
        }
    }
}
// MARK: Matrix
extension TensorBuffer: MutableMatrix where R: MutableStorage, R.SubSequence: MutableStorage {
    public subscript(row: Int, col: Int) -> U {
        get {
            switch order {
            case.rowMajor:
                self[[row..<row, col..<col] + shape.dropFirst(2).map{0..<$0}]
            case.columnMajor:
                self[shape.dropLast(2).map{0..<$0} + [row..<row, col..<col]]
            }
        }
        set {
            switch order {
            case.rowMajor:
                self[[row..<row, col..<col] + shape.dropFirst(2).map{0..<$0}] = newValue
            case.columnMajor:
                self[shape.dropLast(2).map{0..<$0} + [row..<row, col..<col]] = newValue
            }
        }
    }
    public subscript(row: Int, col: some RangeExpression<Int>) -> V {
        get {
            switch order {
            case.rowMajor:
                self[[row..<row, col.relative(to: 0..<cols)] + shape.dropFirst(2).map{0..<$0}]
            case.columnMajor:
                self[shape.dropLast(2).map{0..<$0} + [row..<row, col.relative(to: 0..<cols)]]
            }
        }
        set {
            switch order {
            case.rowMajor:
                self[[row..<row, col.relative(to: 0..<cols)] + shape.dropFirst(2).map{0..<$0}] = newValue
            case.columnMajor:
                self[shape.dropLast(2).map{0..<$0} + [row..<row, col.relative(to: 0..<cols)]] = newValue
            }
        }
    }
    public subscript(row: some RangeExpression<Int>, col: Int) -> V {
        get {
            switch order {
            case.rowMajor:
                self[[row.relative(to: 0..<rows), col..<col] + shape.dropFirst(2).map{0..<$0}]
            case.columnMajor:
                self[shape.dropLast(2).map{0..<$0} + [row.relative(to: 0..<rows), col..<col]]
            }
        }
        set {
            switch order {
            case.rowMajor:
                self[[row.relative(to: 0..<rows), col..<col] + shape.dropFirst(2).map{0..<$0}] = newValue
            case.columnMajor:
                self[shape.dropLast(2).map{0..<$0} + [row.relative(to: 0..<rows), col..<col]] = newValue
            }
        }
    }
    public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        get {
            switch order {
            case.rowMajor:
                self[[row.relative(to: 0..<rows), col.relative(to: 0..<cols)] + shape.dropFirst(2).map{0..<$0}]
            case.columnMajor:
                self[shape.dropLast(2).map{0..<$0} + [row.relative(to: 0..<rows), col.relative(to: 0..<cols)]]
            }
        }
        set {
            switch order {
            case.rowMajor:
                self[[row.relative(to: 0..<rows), col.relative(to: 0..<cols)] + shape.dropFirst(2).map{0..<$0}] = newValue
            case.columnMajor:
                self[shape.dropLast(2).map{0..<$0} + [row.relative(to: 0..<rows), col.relative(to: 0..<cols)]] = newValue
            }
        }
    }
}
// MARK: Tensor
extension TensorBuffer: MutableTensor where R: MutableStorage, R.SubSequence: MutableStorage {
    public subscript<P>(position: P) -> U where P: RandomAccessCollection, P.Index == Int, P.Element == Int {
        get {
            switch order {
            case.rowMajor:
                self[position.map{$0..<$0} + shape.dropFirst(position.count).map{0..<$0}]
            case.columnMajor:
                self[shape.dropLast(position.count).map{0..<$0} + position.map{$0..<$0}]
            }
        }
        set {
            switch order {
            case.rowMajor:
                self[position.map{$0..<$0} + shape.dropFirst(position.count).map{0..<$0}] = newValue
            case.columnMajor:
                self[shape.dropLast(position.count).map{0..<$0} + position.map{$0..<$0}] = newValue
            }
        }
    }
    public subscript<Q>(bounds: Q) -> S where Q: RandomAccessCollection, Q.Index == Int, Q.Element: RangeExpression, Q.Element.Bound == Int {
        get {
            precondition(bounds.count <= shape.count)
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
                let upper = lower.advanced(by: capacity(slice: shape, stride: pitch))
                return.init(shape: shape, order: order, pitch: pitch, store: store[lower..<upper])
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
                return.init(shape: shape, order: order, pitch: pitch, store: store[lower..<upper])
            }
        }
        set {
            precondition(bounds.count <= shape.count)
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
                let (length, stride, offset) = flatten(shape: shape,
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
                let (length, stride, offset) = flatten(shape: shape,
                                                       xs: order.broadcast(target: shape, source: newValue.shape, stride: newValue.pitch),
                                                       ys: pitch)
                for (offset, cursor) in product(offset, 0..<length) {
                    store[lower.advanced(by: offset.y + stride.y * cursor)] = newValue.store[upper.advanced(by: offset.x + stride.x * cursor)]
                }
            }
        }
    }
}
extension TensorBuffer: CustomStringConvertible {
    @inlinable@_transparent
    func describing(depth: Int, start: R.Index, container: ArraySlice<(Int, Int)>) -> String {
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
    public var description: String {
        describing(depth: 1, start: store.startIndex, container: .init(zip(shape, pitch)))
    }
}
extension TensorBuffer {
    @inlinable@inline(__always)@_transparent
    public init<Source: InstantTensor>(_ source: Source, for strategy: MemoryStrategy = .default) throws where Source.R == R {
        shape = source.shape
        order = strategy
        (pitch, store) = switch try source.evaluation(for: order) {
        case (let stride, let kernel):
            (stride, kernel())
        }
    }
    @inlinable@inline(__always)@_transparent
    public init<Source: Tensor>(_ source: Source, for strategy: MemoryStrategy = .default) async throws where Source.R == R {
        shape = source.shape
        order = strategy
        (pitch, store) = switch try source.evaluation(for: order) {
        case (let stride, let kernel):
            (stride, await kernel())
        }
    }
}
extension TensorBuffer where R: RangeReplaceableCollection {
    @_disfavoredOverload
    public init(_ source: some InstantTensor<Element>, for strategy: MemoryStrategy = .default) throws {
        shape = source.shape
        order = strategy
        (pitch, store) = switch try source.evaluation(for: order) {
        case (let stride, let kernel):
            (stride, R(kernel()))
        }
    }
    @_disfavoredOverload
    @inlinable@inline(__always)@_transparent
    public init(_ source: some Tensor<Element>, for strategy: MemoryStrategy = .default) async throws {
        shape = source.shape
        order = strategy
        (pitch, store) = switch try source.evaluation(for: order) {
        case (let stride, let kernel):
            (stride, await R(kernel()))
        }
    }
    @inlinable@inline(__always)@_transparent
    public init(shape s: some Collection<Int>, for strategy: MemoryStrategy = .default, with value: Element) {
        shape = .init(s)
        order = strategy
        pitch = order.stride(for: shape)
        store = .init(repeating: value, count: capacity(alloc: shape, stride: pitch))
    }
}
extension TensorBuffer: ExpressibleByBooleanLiteral where R: RangeReplaceableCollection, Element == BooleanLiteralType {
    @inlinable@inline(__always)@_transparent
    public init(booleanLiteral value: Element) {
        shape = .init()
        order = .rowMajor
        pitch = .init()
        store = .init(repeating: value, count: 1)
    }
}
extension TensorBuffer: ExpressibleByIntegerLiteral where R: RangeReplaceableCollection, Element == IntegerLiteralType {
    @inlinable@inline(__always)@_transparent
    public init(integerLiteral value: Element) {
        shape = .init()
        order = .rowMajor
        pitch = .init()
        store = .init(repeating: value, count: 1)
    }
}
extension TensorBuffer: ExpressibleByFloatLiteral where R: RangeReplaceableCollection, Element == FloatLiteralType {
    @inlinable@inline(__always)@_transparent
    public init(floatLiteral value: Element) {
        shape = .init()
        order = .rowMajor
        pitch = .init()
        store = .init(repeating: value, count: 1)
    }
}
extension TensorBuffer: ExpressibleByArrayLiteral where R: RangeReplaceableCollection {
    @inlinable@inline(__always)@_transparent
    public init(arrayLiteral elements: Self...) {
        precondition(0 < elements.count, "empty tensor is not allowed")
        order = .rowMajor
        let count = elements.reduce([]) { [order] in
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
