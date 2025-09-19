//
//  Buffer+Vector.swift
//  MUSE
//
//  Created by Kota on 9/8/R7.
//
import protocol Accelerate.AccelerateBuffer
import protocol Accelerate.AccelerateMutableBuffer
import func Layout.capacity
import typealias Layout.MemoryStrategy
@dynamicMemberLookup
@frozen public struct VectorBuffer<R: Storage> where R.Index: Strideable, R.Index.Stride == Int, R.Element: MutScalar, R.SubSequence: Storage {
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
	@inlinable
	public subscript<T>(dynamicMember lookup: KeyPath<R, T>) -> T {
		data[keyPath: lookup]
	}
	@inlinable
	public subscript<T>(dynamicMember lookup: ReferenceWritableKeyPath<R, T>) -> T {
		_read {
			yield data[keyPath: lookup]
		}
		_modify {
			yield &data[keyPath: lookup]
		}
	}
}
extension VectorBuffer {
	@inlinable@inline(__always)
	var rawRange: Range<R.Index> {
		data.startIndex..<data.startIndex.advanced(by: count * inc)
	}
	@inlinable@inline(__always)
	var rawIndex: StrideTo<R.Index> {
		stride(from: data.startIndex, to: data.startIndex.advanced(by: count * inc), by: inc)
	}
}
extension VectorBuffer: Vector & Immediate {
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
	public func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
		([inc], {data})
	}
}
extension VectorBuffer: MutTensor & MutVector where R: MutableStorage, R.SubSequence: MutableStorage {
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
extension VectorBuffer {
	@inlinable
	public init(shape: (Int), stride: (Int), data memory: R) {
		precondition(capacity(alloc: [shape], stride: [stride]) <= memory.count)
		count = shape
		inc = stride
		data = memory
	}
	@inlinable@_transparent
	public init<Source>(_ source: Source, for layout: MemoryStrategy = .rowMajor) throws where Source: Immediate, Source.R == R {
		switch layout {
		case.rowMajor:
			let (stride, kernel) = try source(for: .rowMajor)
			count = source.shape.last ?? 1
			inc = stride.last ?? 0
			data = kernel()
		case.columnMajor:
			let (stride, kernel) = try source(for: .columnMajor)
			count = source.shape.first ?? 1
			inc = stride.first ?? 0
			data = kernel()
		}
	}
	@inlinable@_transparent
	public init<Source>(_ source: Source, for layout: MemoryStrategy = .rowMajor) async throws where Source: Tensor, Source.R == R {
		switch layout {
		case.rowMajor:
			let (stride, kernel) = try source(for: .rowMajor)
			async let result = kernel()
			count = source.shape.last ?? 1
			inc = stride.last ?? 0
			data = await result
		case.columnMajor:
			let (stride, kernel) = try source(for: .columnMajor)
			async let result = kernel()
			count = source.shape.first ?? 1
			inc = stride.first ?? 0
			data = await result
		}
	}
}
extension VectorBuffer: ExpressibleByArrayLiteral where R: RangeReplaceableCollection {
	@inlinable@_transparent
	public init<Source>(_ source: Source, for layout: MemoryStrategy = .rowMajor) throws where Source: Immediate, Source.R.Element == Element {
		switch layout {
		case.rowMajor:
			let (stride, kernel) = try source(for: .rowMajor)
			count = source.shape.last ?? 1
			inc = stride.last ?? 0
			data = kernel().withUnsafeBufferPointer(R.init)
		case.columnMajor:
			let (stride, kernel) = try source(for: .columnMajor)
			count = source.shape.first ?? 1
			inc = stride.first ?? 0
			data = kernel().withUnsafeBufferPointer(R.init)
		}
	}
	@inlinable@_transparent
	public init<Source>(_ source: Source, for layout: MemoryStrategy = .rowMajor) async throws where Source: Tensor, Source.R.Element == Element {
		switch layout {
		case.rowMajor:
			let (stride, kernel) = try source(for: .rowMajor)
			async let result = kernel()
			count = source.shape.last ?? 1
			inc = stride.last ?? 0
			data = await result.withUnsafeBufferPointer(R.init)
		case.columnMajor:
			let (stride, kernel) = try source(for: .columnMajor)
			async let result = kernel()
			count = source.shape.first ?? 1
			inc = stride.first ?? 0
			data = await result.withUnsafeBufferPointer(R.init)
		}
	}
	@inlinable@_transparent
	public init(shape: Int, with value: Element) {
		count = shape
		inc = 1
		data = .init(repeating: value, count: count)
	}
	@inlinable@_transparent
	public init(_ elements: some Collection<Element>) {
		count = elements.count
		inc = 1
		data = .init(elements)
	}
	@inlinable@_transparent
	public init(arrayLiteral elements: Element...) {
		self.init(elements)
	}
}
extension VectorBuffer: CustomStringConvertible {
	@inlinable@_transparent
	public var description: String {
		(0..<count).lazy.map { data[data.startIndex.advanced(by: $0 * inc)] }.description
	}
}
extension VectorBuffer: RandomAccessCollection {
	@inlinable@_transparent
	public var startIndex: Int {
		0
	}
	@inlinable@_transparent
	public var endIndex: Int {
		count
	}
}
public typealias VecBuf<T: MutScalar> = VectorBuffer<Array<T>>
