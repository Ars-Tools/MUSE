//
//  Buffer+Vector.swift
//  MUSE
//
//  Created by Kota on 9/8/R7.
//
import protocol Accelerate.AccelerateMutableBuffer
import func Layout.capacity
import typealias Layout.MemoryStrategy
public struct VectorBuffer<R: RandomAccessCollection & MutableCollection & AccelerateMutableBuffer & Sendable> where R.Index: BinaryInteger, R.Index.Stride == Int, R.Element: MutScalar, R.SubSequence == R {
	public typealias U = R.Element
	public let count: Int
	public let inc: Int
	@usableFromInline
	private(set) var data: R
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
	@inlinable
	public subscript(position: Int) -> Element {
		_read {
			yield data[data.startIndex.advanced(by: position * inc)]
		}
		_modify {
			yield &data[data.startIndex.advanced(by: position * inc)]
		}
	}
	public subscript(bounds: some RangeExpression<Int>) -> VectorBuffer<R> {
		get {
			let range = bounds.relative(to: 0..<count)
			return.init(count: range.count, inc: inc, data: data[data.startIndex.advanced(by: range.lowerBound * inc)..<data.startIndex.advanced(by: range.upperBound * inc)])
		}
		set {
			let range = bounds.relative(to: 0..<count)
			for (offset, element) in stride(from: data.startIndex.advanced(by: range.lowerBound * inc), to: data.startIndex.advanced(by: range.upperBound * inc), by: inc).enumerated() {
				data[element] = newValue[offset]
			}
		}
	}
	@inlinable
	public func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, () async -> R) {
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
}
extension VectorBuffer: ExpressibleByArrayLiteral where R: RangeReplaceableCollection {
	@inlinable
	public init(shape: Int) {
		count = shape
		inc = 1
		data = .init(repeating: .zero, count: count)
	}
	@inlinable
	public init(arrayLiteral elements: Element...) {
		count = elements.count
		inc = 1
		data = .init(elements)
	}
}
extension VectorBuffer: CustomStringConvertible {
	@inlinable
	public var description: String {
		(0..<count).lazy.map { data[data.startIndex.advanced(by: $0 * inc)] }.description
	}
}
public typealias VecBuf<T: MutScalar> = VectorBuffer<ArraySlice<T>>
