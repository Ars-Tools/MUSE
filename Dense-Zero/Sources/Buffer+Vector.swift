//
//  Buffer+Vector.swift
//  MUSE
//
//  Created by Kota on 9/8/R7.
//
import protocol Accelerate.AccelerateBuffer
import protocol Accelerate.AccelerateMutableBuffer
import typealias Layout.MemoryStrategy
import func Layout.capacity
@dynamicMemberLookup
@frozen public struct VectorBuffer<R: Storage> where R.Index: Strideable, R.Index.Stride == Int, R.Element: ScalarBuffer, R.SubSequence: Storage {
	public typealias Element = R.Element
	public typealias S = VectorBuffer<R.SubSequence>
	public typealias T = Self
	public typealias U = Element
	public typealias V = Self
	public let count: Int
	public let inc: Int
	@usableFromInline
	private(set) var data: R
}
extension VectorBuffer {
    @_disfavoredOverload
    @inlinable@inline(__always)
    public subscript<T>(dynamicMember lookup: KeyPath<R, T>) -> T {
		data[keyPath: lookup]
	}
    @_disfavoredOverload
    @inlinable@inline(__always)
	public subscript<T>(dynamicMember lookup: ReferenceWritableKeyPath<R, T>) -> T {
		_read {
			yield data[keyPath: lookup]
		}
		_modify {
			yield &data[keyPath: lookup]
		}
	}
}
extension VectorBuffer: InstantVector {
	@inlinable
	public subscript(position: Int) -> U {
		data[data.startIndex.advanced(by: position * inc)]
	}
	public subscript(bounds: some RangeExpression<Int>) -> S {
		let range = bounds.relative(to: 0..<count)
		let lower = data.startIndex.advanced(by: range.lowerBound * inc)
		let upper = lower.advanced(by: range.count * inc)
		return.init(count: range.count, inc: inc, data: data[lower..<upper])
	}
	@inlinable
	public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
		([inc], {data})
	}
}
extension VectorBuffer: MutableTensor & MutableVector where R: MutableStorage, R.SubSequence: MutableStorage {
	@inlinable
	public subscript(position: Int) -> U {
		_read {
			yield data[data.startIndex.advanced(by: position * inc)]
		}
		_modify {
			yield &data[data.startIndex.advanced(by: position * inc)]
		}
	}
	public subscript(bounds: some RangeExpression<Int>) -> S {
		get {
			let range = bounds.relative(to: 0..<count)
			let lower = data.startIndex.advanced(by: range.lowerBound * inc)
			let upper = lower.advanced(by: range.count * inc)
			return.init(count: range.count, inc: inc, data: data[lower..<upper])
		}
		set {
			let range = bounds.relative(to: 0..<count)
			for (offset, element) in range.enumerated() {
				data[data.startIndex.advanced(by: element * inc)] = newValue[offset]
			}
		}
	}
}
// MARK: Zero-Cost Initializers
extension VectorBuffer {
	@inlinable@inline(__always)@_transparent
	public init(shape: (Int), stride: (Int), data memory: R) {
		precondition(capacity(alloc: [shape], stride: [stride]) <= memory.count)
		count = shape
		inc = stride
		data = memory
	}
    @inlinable@inline(__always)@_transparent
	public init<Source>(_ source: Source, as strategy: MemoryStrategy = .rowMajor) throws where Source: InstantTensor, Source.R == R {
		switch strategy {
		case.rowMajor:
            let (stride, kernel) = try source.evaluation(for: .rowMajor)
			count = source.shape.last ?? 1
			inc = stride.last ?? 0
			data = kernel()
		case.columnMajor:
			let (stride, kernel) = try source.evaluation(for: .columnMajor)
			count = source.shape.first ?? 1
			inc = stride.first ?? 0
			data = kernel()
		}
	}
    @inlinable@inline(__always)@_transparent
	public init<Source>(_ source: Source, as strategy: MemoryStrategy = .rowMajor) async throws where Source: Tensor, Source.R == R {
		switch strategy {
		case.rowMajor:
			let (stride, kernel) = try source.evaluation(for: .rowMajor)
			async let result = kernel()
			count = source.shape.last ?? 1
			inc = stride.last ?? 0
			data = await result
		case.columnMajor:
            let (stride, kernel) = try source.evaluation(for: .columnMajor)
			async let result = kernel()
			count = source.shape.first ?? 1
			inc = stride.first ?? 0
			data = await result
		}
	}
}
// MARK: Type-specified Initializers
extension VectorBuffer: ExpressibleByArrayLiteral where R: RangeReplaceableCollection {
    @_disfavoredOverload
    @inlinable@inline(__always)@_transparent
    public init(_ source: some Tensor<Element>, for strategy: MemoryStrategy = .rowMajor) async throws {
        switch strategy {
        case.rowMajor:
            let (stride, kernel) = try source.evaluation(for: .rowMajor)
            async let result = kernel()
            count = source.shape.last ?? 1
            inc = stride.last ?? 0
            data = await R(result)
        case.columnMajor:
            let (stride, kernel) = try source.evaluation(for: .columnMajor)
            async let result = kernel()
            count = source.shape.first ?? 1
            inc = stride.first ?? 0
            data = await.init(result)
        }
    }
    @_disfavoredOverload
    @inlinable@inline(__always)@_transparent
    public init(_ source: some InstantTensor<Element>, for strategy: MemoryStrategy = .rowMajor) throws {
		switch strategy {
		case.rowMajor:
            let (stride, kernel) = try source.evaluation(for: .rowMajor)
			count = source.shape.last ?? 1
			inc = stride.last ?? 0
			data = .init(kernel())
		case.columnMajor:
			let (stride, kernel) = try source.evaluation(for: .columnMajor)
			count = source.shape.first ?? 1
			inc = stride.first ?? 0
            data = .init(kernel())
		}
	}
    @inlinable@inline(__always)@_transparent
	public init(shape: Int, with value: Element) {
		count = shape
		inc = 1
		data = .init(repeating: value, count: count)
	}
    @inlinable@inline(__always)@_transparent
	public init(_ elements: some Collection<Element>) {
		count = elements.count
        precondition(0 < count, "empty vector is not allowed")
		inc = 1
		data = .init(elements)
	}
    @inlinable@inline(__always)@_transparent
	public init(arrayLiteral elements: Element...) {
		self.init(elements)
	}
}
// MARK: StringConvertible
extension VectorBuffer: CustomStringConvertible {
    @inlinable@inline(__always)@_transparent
	public var description: String {
		(0..<count).lazy.map { data[data.startIndex.advanced(by: $0 * inc)] }.description
	}
}
// MARK: Misc Protocols
extension VectorBuffer: RandomAccessCollection {
    @inlinable@inline(__always)@_transparent
    public var startIndex: Int {
		0
	}
    @inlinable@inline(__always)@_transparent
	public var endIndex: Int {
		count
	}
}
// MARK: typealias
public typealias VecBuf<T: ScalarBuffer> = VectorBuffer<Array<T>>
