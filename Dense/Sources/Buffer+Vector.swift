//
//  Buffer+Vector.swift
//  MUSE
//
//  Created by Kota on 9/8/R7.
//
import protocol Accelerate.AccelerateMutableBuffer
import func Layout.capacity
import typealias Layout.MemoryStrategy
@dynamicMemberLookup
@frozen public struct VectorBuffer<R: RandomAccessCollection & MutableCollection & AccelerateMutableBuffer & Sendable> where R.Index: BinaryInteger, R.Index.Stride == Int, R.Element: MutScalar, R.SubSequence: AccelerateMutableBuffer & Sendable {
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
extension VectorBuffer: MutVector {
	public typealias U = R.Element
	public typealias S = VectorBuffer<R.SubSequence>
	public typealias V = Self
	public typealias T = Self
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
	@inlinable
	public func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R) {
		([inc], {data})
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
	@inlinable
	public init<Source>(_ source: Source, layout: MemoryStrategy = .rowMajor) async throws where Source: Vector, Source.R == R {
		let (stride, result) = try source(for: layout)
		precondition(stride.count == 1)
		count = source.count
		inc = stride[0]
		data = await result()
	}
}
extension VectorBuffer: ExpressibleByArrayLiteral where R: RangeReplaceableCollection {
	@inlinable
	public init(shape: Int, with value: Element) {
		count = shape
		inc = 1
		data = .init(repeating: value, count: count)
	}
	@inlinable
	public init(_ elements: some Collection<Element>) {
		count = elements.count
		inc = 1
		data = .init(elements)
	}
	@inlinable
	public init(arrayLiteral elements: Element...) {
		self.init(elements)
	}
	@inlinable
	public init<Source>(_ source: Source, layout: MemoryStrategy = .rowMajor) async throws where Source: Vector, Source.Element == Element {
		let (stride, result) = try source(for: layout)
		precondition(stride.count == 1)
		count = source.count
		inc = stride[0]
		data = await result().withUnsafeBufferPointer(R.init)
	}
	
}
extension VectorBuffer: CustomStringConvertible {
	@inlinable
	public var description: String {
		(0..<count).lazy.map { data[data.startIndex.advanced(by: $0 * inc)] }.description
	}
}
public typealias VecBuf<T: MutScalar> = VectorBuffer<Array<T>>
