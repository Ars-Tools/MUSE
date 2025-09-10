//
//  Buffer+Matrix.swift
//  MUSE
//
//  Created by Kota on 5/26/R7.
//
import typealias Layout.MemoryStrategy
import func Layout.offset
import func Layout.capacity
import func Layout.product
import protocol Accelerate.AccelerateMutableBuffer
@dynamicMemberLookup
@frozen public struct MatrixBuffer<R: RandomAccessCollection & MutableCollection & AccelerateMutableBuffer & Sendable> where R.Index: BinaryInteger, R.Index.Stride == Int, R.Element: MutScalar, R.SubSequence: AccelerateMutableBuffer & Sendable {
	public let rows: Int
	public let cols: Int
	@usableFromInline let ldr: Int
	@usableFromInline let ldc: Int
	@usableFromInline
	private(set) var data: R
}
extension MatrixBuffer {
	@inlinable
	public subscript<Λ>(dynamicMember lookup: KeyPath<R, Λ>) -> Λ {
		data[keyPath: lookup]
	}
	@inlinable
	public subscript<Λ>(dynamicMember lookup: ReferenceWritableKeyPath<R, Λ>) -> Λ {
		_read {
			yield data[keyPath: lookup]
		}
		_modify {
			yield &data[keyPath: lookup]
		}
	}
}
extension MatrixBuffer: MutMatrix {
	public typealias U = R.Element
	public typealias S = MatrixBuffer<R.SubSequence>
	public typealias V = VectorBuffer<R.SubSequence>
	public typealias T = Self
	public var diagonal: V {
		.init(count: min(rows, cols), inc: ldr + ldc, data: data[data.startIndex..<data.endIndex])
	}
	public var transpose: T {
		.init(rows: cols, cols: rows, ldr: ldc, ldc: ldr, data: data)
	}
	@inlinable
	public subscript(row: Int, col: Int) -> U {
		_read {
			yield data[data.startIndex.advanced(by: row * ldr + col * ldc)]
		}
		_modify {
			yield &data[data.startIndex.advanced(by: row * ldr + col * ldc)]
		}
	}
	public subscript(row: Int, col: some RangeExpression<Int>) -> V {
		get {
			let col = col.relative(to: 0..<cols)
			let idx = data.startIndex.advanced(by: row * ldr)
			return.init(count: col.count, inc: ldc, data: data[idx.advanced(by: col.lowerBound * ldc)..<idx.advanced(by: col.upperBound * ldc)])
		}
		set {
			let idx = data.startIndex.advanced(by: row * ldr)
			for col in col.relative(to: 0..<cols) {
				data[idx.advanced(by: col * ldc)] = newValue[col]
			}
		}
	}
	public subscript(row: some RangeExpression<Int>, col: Int) -> V {
		get {
			let row = row.relative(to: 0..<rows)
			let idx = data.startIndex.advanced(by: col * ldc)
			return.init(count: row.count, inc: ldr, data: data[idx.advanced(by: row.lowerBound * ldr)..<idx.advanced(by: row.upperBound * ldr)])
		}
		set {
			let idx = data.startIndex.advanced(by: col * ldc)
			for row in row.relative(to: 0..<rows) {
				data[idx.advanced(by: row * ldr)] = newValue[row]
			}
		}
	}
	public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		get {
			let row = row.relative(to: 0..<rows)
			let col = col.relative(to: 0..<cols)
			let lower = data.startIndex.advanced(by: offset(position: [row.lowerBound, col.lowerBound], stride: [ldr, ldc]))
			let upper = lower.advanced(by: capacity(slice: [row.count, col.count], stride: [ldr, ldc]))
			return.init(rows: row.count, cols: col.count, ldr: ldr, ldc: ldc, data: data[lower..<upper])
		}
		set {
			for (row, col) in product(row.relative(to: 0..<rows), col.relative(to: 0..<cols)) {
				data[data.startIndex.advanced(by: row * ldr + col * ldc)] = newValue[row, col]
			}
		}
	}
	@inlinable
	public func callAsFunction(for strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R) {
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
	@inlinable
	public init<Source>(_ source: Source, layout: MemoryStrategy = .rowMajor) async throws where Source: Matrix, Source.R == R {
		let (stride, result) = try source(for: layout)
		precondition(stride.count == 2)
		rows = source.rows
		cols = source.cols
		ldr = stride[0]
		ldc = stride[1]
		data = await result()
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
	@_disfavoredOverload
	@inlinable
	public init<Source>(_ source: Source, layout: MemoryStrategy = .rowMajor) async throws where Source: Matrix, Source.Element == Element {
		let (stride, result) = try source(for: layout)
		precondition(stride.count == 2)
		rows = source.rows
		cols = source.cols
		ldr = stride[0]
		ldc = stride[1]
		data = await result().withUnsafeBufferPointer(R.init)
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
public typealias MatBuf<T: MutScalar> = MatrixBuffer<Array<T>>
