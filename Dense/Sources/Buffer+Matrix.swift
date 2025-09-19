//
//  Buffer+Matrix.swift
//  MUSE
//
//  Created by Kota on 5/26/R7.
//
import protocol Accelerate.AccelerateBuffer
import protocol Accelerate.AccelerateMutableBuffer
import typealias Layout.MemoryStrategy
import func Layout.offset
import func Layout.capacity
import func Layout.product
@dynamicMemberLookup
@frozen public struct MatrixBuffer<R: Storage> where R.Index: Strideable, R.Index.Stride == Int, R.Element: MutScalar, R.SubSequence: Storage {
	public typealias Element = R.Element
	public typealias S = MatrixBuffer<R.SubSequence>
	public typealias T = Self
	public typealias U = Element
	public typealias V = VectorBuffer<R.SubSequence>
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
extension MatrixBuffer: Matrix & Immediate {
	public var diagonal: VectorBuffer<R.SubSequence> {
		.init(count: min(rows, cols), inc: ldr + ldc, data: data[data.startIndex..<data.endIndex])
	}
	public var transpose: Self {
		.init(rows: cols, cols: rows, ldr: ldc, ldc: ldr, data: data)
	}
	@inlinable@inline(__always)
	public subscript(row: Int, col: Int) -> R.Element {
		data[data.startIndex.advanced(by: row * ldr + col * ldc)]
	}
	public subscript(row: Int, col: some RangeExpression<Int>) -> V {
		let col = col.relative(to: 0..<cols)
		let lower = data.startIndex.advanced(by: row * ldr + col.lowerBound * ldc)
		let upper = lower.advanced(by: capacity(slice: [1, col.count], stride: [ldr, ldc]))
		return.init(count: col.count, inc: ldc, data: data[lower..<upper])
	}
	public subscript(row: some RangeExpression<Int>, col: Int) -> V {
		let row = row.relative(to: 0..<rows)
		let lower = data.startIndex.advanced(by: col * ldc + row.lowerBound * ldr)
		let upper = lower.advanced(by: capacity(slice: [row.count, 1], stride: [ldr, ldc]))
		return.init(count: row.count, inc: ldr, data: data[lower..<upper])
	}
	public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		let row = row.relative(to: 0..<rows)
		let col = col.relative(to: 0..<cols)
		let lower = data.startIndex.advanced(by: offset(position: [row.lowerBound, col.lowerBound], stride: [ldr, ldc]))
		let upper = lower.advanced(by: capacity(slice: [row.count, col.count], stride: [ldr, ldc]))
		return.init(rows: row.count, cols: col.count, ldr: ldr, ldc: ldc, data: data[lower..<upper])
	}
	@inlinable
	public func callAsFunction(for strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
		([ldr, ldc], {data})
	}
}
extension MatrixBuffer: MutTensor & MutMatrix where R: MutableStorage, R.SubSequence: MutableStorage {
	public typealias U = R.Element
	public typealias S = MatrixBuffer<R.SubSequence>
	public typealias V = VectorBuffer<R.SubSequence>
	public typealias T = Self
	public var diagonal: V {
		get {
			.init(count: min(rows, cols), inc: ldr + ldc, data: data[data.startIndex..<data.endIndex])
		}
		set {
			for index in 0..<min(rows, cols) {
				data[data.startIndex.advanced(by: index * (ldr + ldc))] = newValue[index]
			}
		}
	}
	public var transpose: T {
		.init(rows: cols, cols: rows, ldr: ldc, ldc: ldr, data: data)
	}
	@inlinable@inline(__always)
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
			let lower = data.startIndex.advanced(by: row * ldr + col.lowerBound * ldc)
			let upper = lower.advanced(by: capacity(slice: [1, col.count], stride: [ldr, ldc]))
			return.init(count: col.count, inc: ldc, data: data[lower..<upper])
		}
		set {
			let idx = data.startIndex.advanced(by: row * ldr)
			for col in col.relative(to: 0..<cols) {
				data[idx.advanced(by: col * ldc)] = newValue.data[newValue.data.startIndex.advanced(by: col * newValue.inc)]
			}
		}
	}
	public subscript(row: some RangeExpression<Int>, col: Int) -> V {
		get {
			let row = row.relative(to: 0..<rows)
			let lower = data.startIndex.advanced(by: col * ldc + row.lowerBound * ldr)
			let upper = lower.advanced(by: capacity(slice: [row.count, 1], stride: [ldr, ldc]))
			return.init(count: row.count, inc: ldr, data: data[lower..<upper])
		}
		set {
			let idx = data.startIndex.advanced(by: col * ldc)
			for row in row.relative(to: 0..<rows) {
				data[idx.advanced(by: row * ldr)] = newValue.data[newValue.data.startIndex.advanced(by: col * newValue.inc)]
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
			for (row, col) in product(row.relative(to: 0..<rows).enumerated(), col.relative(to: 0..<cols).enumerated()) {
				data[data.startIndex.advanced(by: row.1 * ldr + col.1 * ldc)] = newValue[row.0, col.0]
			}
		}
	}
}
extension MatrixBuffer {
	@inlinable
	public init<Source>(_ source: Source, for layout: MemoryStrategy = .rowMajor) async throws where Source: Tensor, Source.R == R {
		switch layout {
		case.rowMajor:
			let (stride, kernel) = try source(for: .rowMajor)
			async let result = kernel()
			rows = source.shape.dropLast().last ?? 1
			cols = source.shape.last ?? 1
			ldr = stride.dropLast().last ?? 0
			ldc = stride.last ?? 0
			data = await result
		case.columnMajor:
			let (stride, kernel) = try source(for: .columnMajor)
			async let result = kernel()
			rows = source.shape.first ?? 1
			cols = source.shape.dropFirst().first ?? 1
			ldr = stride.first ?? 0
			ldc = stride.dropFirst().first ?? 0
			data = await result
		}
	}
	@inlinable
	public init<Source>(_ source: Source, for layout: MemoryStrategy = .rowMajor) throws where Source: Immediate, Source.R == R {
		switch layout {
		case.rowMajor:
			let (stride, kernel) = try source(for: .rowMajor)
			rows = source.shape.dropLast().last ?? 1
			cols = source.shape.last ?? 1
			ldr = stride.dropLast().last ?? 0
			ldc = stride.last ?? 0
			data = kernel()
		case.columnMajor:
			let (stride, kernel) = try source(for: .columnMajor)
			rows = source.shape.first ?? 1
			cols = source.shape.dropFirst().first ?? 1
			ldr = stride.first ?? 0
			ldc = stride.dropFirst().first ?? 0
			data = kernel()
		}
	}
	@inlinable
	public init(shape: (Int, Int), stride: (Int, Int), data memory: R) {
		precondition(capacity(alloc: [shape.0, shape.1], stride: [stride.0, stride.1]) <= memory.count)
		(rows, cols) = shape
		(ldr, ldc) = stride
		data = memory
	}
}
extension MatrixBuffer: ExpressibleByArrayLiteral where R: RangeReplaceableCollection {
	@inlinable
	public init<Source>(_ source: Source, for layout: MemoryStrategy = .rowMajor) async throws where Source: Tensor, Source.R.Element == Element {
		switch layout {
		case.rowMajor:
			let (stride, kernel) = try source(for: .rowMajor)
			async let result = kernel()
			rows = source.shape.dropLast().last ?? 1
			cols = source.shape.last ?? 1
			ldr = stride.dropLast().last ?? 0
			ldc = stride.last ?? 0
			data = await result.withUnsafeBufferPointer(R.init)
		case.columnMajor:
			let (stride, kernel) = try source(for: .columnMajor)
			async let result = kernel()
			rows = source.shape.first ?? 1
			cols = source.shape.dropFirst().first ?? 1
			ldr = stride.first ?? 0
			ldc = stride.dropFirst().first ?? 0
			data = await result.withUnsafeBufferPointer(R.init)
		}
	}
	@inlinable
	public init<Source>(_ source: Source, for layout: MemoryStrategy = .rowMajor) throws where Source: Immediate, Source.R.Element == Element {
		switch layout {
		case.rowMajor:
			let (stride, kernel) = try source(for: .rowMajor)
			rows = source.shape.dropLast().last ?? 1
			cols = source.shape.last ?? 1
			ldr = stride.dropLast().last ?? 0
			ldc = stride.last ?? 0
			data = kernel().withUnsafeBufferPointer(R.init)
		case.columnMajor:
			let (stride, kernel) = try source(for: .columnMajor)
			rows = source.shape.first ?? 1
			cols = source.shape.dropFirst().first ?? 1
			ldr = stride.first ?? 0
			ldc = stride.dropFirst().first ?? 0
			data = kernel().withUnsafeBufferPointer(R.init)
		}
	}
	@inlinable
	public init(shape: (Int, Int), for layout: MemoryStrategy = .rowMajor, with value: Element) {
		(rows, cols) = shape
		(ldr, ldc) = switch layout {
		case.rowMajor:
			(cols, 1)
		case.columnMajor:
			(1, rows)
		}
		data = .init(repeating: value, count: capacity(alloc: [rows, cols], stride: [ldr, ldc]))
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
public typealias MatBuf<T: MutScalar> = MatrixBuffer<Array<T>>
