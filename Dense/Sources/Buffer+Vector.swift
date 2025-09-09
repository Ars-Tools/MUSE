//
//  Buffer+Vector.swift
//  MUSE
//
//  Created by Kota on 9/8/R7.
//
import protocol Accelerate.AccelerateMutableBuffer
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
extension VectorBuffer: ExpressibleByArrayLiteral where R: RangeReplaceableCollection {
	public init(arrayLiteral elements: R.Element...) {
		self.init(count: elements.count, inc: 1, data: .init(elements))
	}
}
extension VectorBuffer: CustomStringConvertible {
	@inlinable
	public var description: String {
		rawIndex.lazy.map { data[$0] }.description
	}
}
public typealias VecBuf<T: MutScalar> = VectorBuffer<ArraySlice<T>>
