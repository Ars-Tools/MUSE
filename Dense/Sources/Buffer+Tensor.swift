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
import func Layout.product
import typealias Layout.MemoryStrategy
@dynamicMemberLookup
@frozen public struct TensorBuffer<R: Storage> where R.Index: Strideable, R.Index.Stride == Int, R.Element: MutScalar, R.SubSequence: Storage {
	public typealias Element = R.Element
	public typealias S = TensorBuffer<R.SubSequence>
	public typealias T = Self
	public typealias U = Element
	public typealias V = VectorBuffer<R.SubSequence>
	public let shape: Array<Int>
	@usableFromInline let pitch: Array<Int>
	@usableFromInline private(set) var store: R
}
extension TensorBuffer {
	@inlinable
	public subscript<Λ>(dynamicMember lookup: KeyPath<R, Λ>) -> Λ {
		store[keyPath: lookup]
	}
	@inlinable
	public subscript<Λ>(dynamicMember lookup: ReferenceWritableKeyPath<R, Λ>) -> Λ {
		_read {
			yield store[keyPath: lookup]
		}
		_modify {
			yield &store[keyPath: lookup]
		}
	}
}
extension TensorBuffer: Tensor & Immediate {
	public var transpose: T {
		.init(shape: shape.reversed(), pitch: pitch.reversed(), store: store)
	}
	public var diagonal: V {
		.init(shape: shape.min() ?? 0, stride: pitch.reduce(0, +), data: store[store.startIndex..<store.endIndex])
	}
	@_disfavoredOverload
	public subscript<P>(position: P) -> U where P: RandomAccessCollection, P.Index == Int, P.Element == Int {
		store[zip(pitch, position).reduce(store.startIndex) { $0.advanced(by: $1.0 * $1.1) }]
	}
	public subscript<Q>(bounds: Q) -> S where Q: RandomAccessCollection, Q.Index == Int, Q.Element: RangeExpression, Q.Element.Bound == Int {
		let bounds = zip(bounds, shape).map { $0.relative(to: 0..<$1) }
		let lower = zip(pitch, bounds).reduce(store.startIndex) { $0.advanced(by: $1.0 * $1.1.lowerBound) }
		let (pitch, shape) = zip(pitch, concat(bounds.map { $0.count }, shape.dropFirst(bounds.count)))
			.filter { $1 != 0 }
			.reduce(into: (Array<Int>(), Array<Int>())) {
				$0.0.append($1.0)
				$0.1.append($1.1)
			}
		let upper = lower.advanced(by: capacity(slice: shape, stride: pitch))
		return.init(shape: shape, pitch: pitch, store: store[lower..<upper])
	}
	public func callAsFunction(for strategy: MemoryStrategy) -> (Array<Int>, @Sendable () -> R) {
		(zip(shape, pitch).compactMap { $0 == .zero ? .none : .some($1) }, {store})
	}
}
extension TensorBuffer: MutTensor where R: MutableStorage, R.SubSequence: MutableStorage {
	@_disfavoredOverload
	public subscript<P>(position: P) -> U where P: RandomAccessCollection, P.Index == Int, P.Element == Int {
		get {
			store[zip(pitch, position).reduce(store.startIndex) { $0.advanced(by: $1.0 * $1.1) }]
		}
		set {
			store[zip(pitch, position).reduce(store.startIndex) { $0.advanced(by: $1.0 * $1.1) }] = newValue
		}
	}
	public subscript<Q>(bounds: Q) -> S where Q: RandomAccessCollection, Q.Index == Int, Q.Element: RangeExpression, Q.Element.Bound == Int {
		get {
			let bounds = zip(bounds, shape).map { $0.relative(to: 0..<$1) }
			let lower = zip(pitch, bounds).reduce(store.startIndex) { $0.advanced(by: $1.0 * $1.1.lowerBound) }
			let (pitch, shape) = zip(pitch, concat(bounds.map { $0.count }, shape.dropFirst(bounds.count)))
				.filter { $1 != 0 }
				.reduce(into: (Array<Int>(), Array<Int>())) {
					$0.0.append($1.0)
					$0.1.append($1.1)
				}
			let upper = lower.advanced(by: capacity(slice: shape, stride: pitch))
			return.init(shape: shape, pitch: pitch, store: store[lower..<upper])
		}
		set {
			let bounds = zip(bounds, shape).map { $0.relative(to: 0..<$1) }
			let lower = zip(pitch, bounds).reduce(store.startIndex) { $0.advanced(by: $1.0 * $1.1.lowerBound) }
			let upper = newValue.store.startIndex
			let (pitch, shape) = zip(pitch, concat(bounds.map { $0.count }, shape.dropFirst(bounds.count)))
				.filter { $1 != 0 }
				.reduce(into: (Array<Int>(), Array<Int>())) {
					$0.0.append($1.0)
					$0.1.append($1.1)
				}
			let (length, stride, offset) = flatten(shape: shape,
												   xs: broadcast(target: shape, source: newValue.shape, stride: newValue.pitch),
												   ys: pitch)
			for (offset, cursor) in product(offset, 0..<length) {
				store[lower.advanced(by: offset.y + stride.y * cursor)] = newValue.store[upper.advanced(by: offset.x + stride.x * cursor)]
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
	@inlinable
	public init<Source: Immediate>(_ source: Source, for layout: MemoryStrategy) throws where Source.R == R {
		shape = source.shape
		(pitch, store) = switch try source(for: layout) {
		case (let stride, let kernel):
			(stride, kernel())
		}
	}
	@_disfavoredOverload
	@inlinable
	public init<Source: Tensor>(_ source: Source, for layout: MemoryStrategy) async throws where Source.R == R {
		shape = source.shape
		(pitch, store) = switch try source(for: layout) {
		case (let stride, let kernel):
			(stride, await kernel())
		}
	}
}
extension TensorBuffer where R: RangeReplaceableCollection {
	@inlinable
	public init(shape specify: some Sequence<Int>, for layout: MemoryStrategy = .rowMajor, with value: Element) {
		shape = .init(specify)
		pitch = layout.stride(for: shape)
		store = .init(repeating: value, count: capacity(alloc: shape, stride: pitch))
	}
	@_disfavoredOverload
	@inlinable
	public init<Source: Tensor>(_ source: Source, for layout: MemoryStrategy = .rowMajor) async throws where Source.R.Element == Element {
		shape = source.shape
		(pitch, store) = switch try source(for: layout) {
		case (let stride, let kernel):
			(stride, await kernel().withUnsafeBufferPointer(R.init))
		}
	}
}
