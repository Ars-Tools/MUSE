//
//  Buffer+Matrix.swift
//  MUSE
//
//  Created by Kota on 5/26/R7.
//
import typealias Layout.MemoryStrategy
import func Layout.offset
import func Layout.capacity
import protocol Accelerate.AccelerateMutableBuffer
public struct MatrixBuffer<R: RandomAccessCollection & MutableCollection & AccelerateMutableBuffer & Sendable> where R.Index: BinaryInteger, R.Index.Stride == Int, R.Element: MutScalar, R.SubSequence == R {
	public typealias Element = R.Element
	public let rows: Int
	public let cols: Int
	@usableFromInline let ldr: Int
	@usableFromInline let ldc: Int
	@usableFromInline
	private(set) var data: R
}
extension MatrixBuffer: MutMatrix {
	public typealias S = Self
	public typealias T = Self
	public typealias U = R.Element
	public typealias V = VectorBuffer<R>
	@inlinable
	public subscript(row: Int, col: Int) -> R.Element {
		_read {
			yield data[data.startIndex.advanced(by: row * ldr + col * ldc)]
		}
		_modify {
			yield &data[data.startIndex.advanced(by: row * ldr + col * ldc)]
		}
	}
	public subscript(row: Int, col: some RangeExpression<Int>) -> VectorBuffer<R> {
		get {
			let col = col.relative(to: 0..<cols)
			let idx = data.startIndex.advanced(by: row * ldr)
			return.init(count: col.count, inc: ldc, data: data[idx.advanced(by: col.lowerBound * ldc)..<idx.advanced(by: col.upperBound * ldc)])
		}
		set {
			fatalError()
		}
	}
	public subscript(row: some RangeExpression<Int>, col: Int) -> VectorBuffer<R> {
		get {
			let row = row.relative(to: 0..<rows)
			let idx = data.startIndex.advanced(by: col * ldc)
			return.init(count: row.count, inc: ldr, data: data[idx.advanced(by: row.lowerBound * ldr)..<idx.advanced(by: row.upperBound * ldr)])
		}
		set {
			fatalError()
		}
	}
	public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> MatrixBuffer<R> {
		get {
			let row = row.relative(to: 0..<rows)
			let col = col.relative(to: 0..<cols)
			let lower = data.startIndex.advanced(by: offset(position: [row.lowerBound, col.lowerBound], stride: [ldr, ldc]))
			let upper = lower.advanced(by: capacity(slice: [row.count, col.count], stride: [ldr, ldc]))
			return.init(rows: row.count, cols: col.count, ldr: ldr, ldc: ldc, data: data[lower..<upper])
		}
		set {
			fatalError()
		}
	}
	public var diagonal: VectorBuffer<R> {
		.init(count: min(rows, cols), inc: ldr + ldc, data: data)
	}
	public var transpose: MatrixBuffer<R> {
		.init(rows: cols, cols: rows, ldr: ldc, ldc: ldr, data: data)
	}
	@inlinable
	public func callAsFunction(for strategy: Layout.MemoryStrategy) throws -> (Array<Int>, () async -> R) {
		([ldr, ldc], {data})
	}
}
extension MatrixBuffer {
	@inlinable
	public init(shape: (Int, Int), stride: (Int, Int), data buffer: R) {
		precondition(capacity(alloc: [shape.0, shape.1], stride: [stride.0, stride.1]) <= buffer.count)
		(rows, cols) = shape
		(ldr, ldc) = stride
		data = buffer
	}
}
extension MatrixBuffer: ExpressibleByArrayLiteral where R: RangeReplaceableCollection {
	@inlinable
	public init(shape: (Int, Int), layout: MemoryStrategy = .rowMajor) {
		(rows, cols) = shape
		(ldr, ldc) = switch layout {
		case.rowMajor:
			(cols, 1)
		case.columnMajor:
			(1, rows)
		}
		data = .init(repeating: .zero, count: capacity(alloc: [rows, cols], stride: [ldr, ldc]))
	}
	@inlinable
	public init(rows vec: some Collection<some Collection<Element>>) {
		let counts = vec.map(\.count)
		rows = vec.count
		cols = counts.min() ?? 0
		ldr = cols
		ldc = 1
		data = .init(vec.lazy.flatMap { [ldr] in $0.prefix(ldr) })
	}
	@inlinable
	public init(cols vec: some Collection<some Collection<Element>>) {
		let counts = vec.map(\.count)
		cols = vec.count
		rows = counts.min() ?? 0
		ldc = rows
		ldr = 1
		data = .init(vec.lazy.flatMap { [ldc] in $0.prefix(ldc) })
	}
	@inlinable
	public init(arrayLiteral elements: Array<Element>...) {
		self.init(rows: elements)
	}
}
extension MatrixBuffer: CustomStringConvertible {
	public var description: String {
		"[" + (0..<rows).map {
			let idx = data.startIndex.advanced(by: $0 * ldr)
			return (0..<cols).map {
				data[idx.advanced(by: $0 * ldc)]
			}.description
		}.joined(separator: ",\r\n ") + "]"
	}
}
public typealias MatBuf<T: MutScalar> = MatrixBuffer<ArraySlice<T>>
