//
//  Matrix+COO.swift
//  MUSE
//
//  Created by Kota on 9/9/R7.
//
import protocol Dense.MutScalar
import typealias Layout.MemoryStrategy
import func Layout.product
@frozen public struct COO<Element> where Element: SparseScalar<Element> {
	public let rows: Int
	public let cols: Int
	@usableFromInline private(set) var rowIndex: Array<Int32>
	@usableFromInline private(set) var colIndex: Array<Int32>
	@usableFromInline private(set) var valArray: Array<Element>
}
extension COO {
	@inlinable
	var indices: LazyMapSequence<Zip2Sequence<Array<Int32>, Array<Int32>>, (Int, Int)> {
		zip(rowIndex, colIndex).lazy.map { (.init($0), .init($1)) }
	}
	@inlinable
	func firstIndex(of position: SIMD2<Int>) -> Optional<Int> {
		Array(indices.map(SIMD2<Int>.init(x:y:))).firstIndex(of: position)
	}
}
extension COO: MutSparseMatrix {
	public typealias R = Array<Element>
	public typealias S = Self
	public typealias T = Self
	public typealias U = Element
	public typealias V = SPV<Element>
	public var transpose: T {
		.init(rows: cols, cols: rows, rowIndex: colIndex, colIndex: rowIndex, valArray: valArray)
	}
	public var diagonal: V {
		get {
			.init(count: min(rows, cols), store: .init(uniqueKeysWithValues: indices.enumerated().compactMap {
				$1.0 == $1.1 ? .some((.init(min($1.0, $1.1)), valArray[$0])) : .none
			}))
		}
		set {
			for (index, value) in newValue.coo {
				self[index, index] = value
			}
		}
	}
	@inlinable
	public subscript(row: Int, col: Int) -> U {
		get {
			firstIndex(of: .init(row, col)).map {
				valArray[$0]
			} ?? .zero
		}
		set {
			switch (firstIndex(of: .init(row, col)), newValue) {
			case (.some(let index), .zero):
				rowIndex.remove(at: index)
				colIndex.remove(at: index)
				valArray.remove(at: index)
			case (.some(let index), let v):
				valArray[index] = v
			case (.none, .zero):
				break
			case (.none, let v):
				rowIndex.append(.init(row))
				colIndex.append(.init(col))
				valArray.append(v)
			}
		}
	}
	public subscript(row: Int, col: some RangeExpression<Int>) -> V {
		get {
			let col = col.relative(to: 0..<cols)
			let found = indices.enumerated().compactMap {
				switch $1 {
				case (row, col):
					.some($0)
				default:
					.none
				}
			}
			return.init(count: col.count, store: .init(uniqueKeysWithValues: found.map {
				(.init(colIndex[$0]) &- col.lowerBound, valArray[$0])
			}))
		}
		set {
			let col = col.relative(to: 0..<cols)
			(rowIndex, colIndex, valArray) = zip(zip(rowIndex, colIndex), valArray).reduce(into: (Array<Int32>(), Array<Int32>(), Array<Element>())) {
				guard row ~= .init($1.0.0), col ~= .init($1.0.1) else {
					$0.0.append($1.0.0)
					$0.1.append($1.0.1)
					$0.2.append($1.1)
					return
				}
			}
			for (offset, element) in col.enumerated() {
				rowIndex.append(.init(row))
				colIndex.append(.init(element))
				valArray.append(newValue[offset])
			}
		}
	}
	public subscript(row: some RangeExpression<Int>, col: Int) -> V {
		get {
			let row = row.relative(to: 0..<rows)
			let found = indices.enumerated().compactMap {
				switch $1 {
				case (row, col):
					.some($0)
				default:
					.none
				}
			}
			return.init(count: row.count, store: .init(uniqueKeysWithValues: found.map {
				(.init(rowIndex[$0]) &- row.lowerBound, valArray[$0])
			}))
		}
		set {
			let row = row.relative(to: 0..<rows)
			(rowIndex, colIndex, valArray) = zip(zip(rowIndex, colIndex), valArray).reduce(into: (Array<Int32>(), Array<Int32>(), Array<Element>())) {
				guard row ~= .init($1.0.0), col ~= .init($1.0.1) else {
					$0.0.append($1.0.0)
					$0.1.append($1.0.1)
					$0.2.append($1.1)
					return
				}
			}
			for (offset, element) in row.enumerated() {
				rowIndex.append(.init(element))
				colIndex.append(.init(col))
				valArray.append(newValue[offset])
			}
		}
	}
	public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		get {
			let row = row.relative(to: 0..<rows)
			let col = col.relative(to: 0..<cols)
			return.init(shape: (row.count, col.count), indices.enumerated().compactMap {
				switch $1 {
				case (row, col):
					.some((SIMD2<Int>(.init(rowIndex[$0]), .init(colIndex[$0])) &- SIMD2<Int>(row.lowerBound, col.lowerBound), valArray[$0]))
				default:
					.none
				}
			})
		}
		set {
			let row = row.relative(to: 0..<rows)
			let col = col.relative(to: 0..<cols)
			(rowIndex, colIndex, valArray) = zip(zip(rowIndex, colIndex), valArray).reduce(into: (Array<Int32>(), Array<Int32>(), Array<Element>())) {
				guard row ~= .init($1.0.0), col ~= .init($1.0.1) else {
					$0.0.append($1.0.0)
					$0.1.append($1.0.1)
					$0.2.append($1.1)
					return
				}
			}
			for (row, col) in product(row.enumerated(), col.enumerated()) {
				rowIndex.append(.init(row.1))
				colIndex.append(.init(col.1))
				valArray.append(newValue[row.0, col.0])
			}
		}
	}
}
extension COO {
	public typealias LIL = Array<LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Int, Element>, Optional<(Int, Element)>>>, (Int, Element)>>
	public func lil(for layout: MemoryStrategy) -> (MemoryStrategy, LIL) {
		switch layout {
		case.rowMajor:
			(.rowMajor, valArray.enumerated().reduce(into: Array<Dictionary<Int, Element>>(repeating: .init(), count: rows)) {
				$0[.init(rowIndex[$1.0])].updateValue($1.1, forKey: .init(colIndex[$1.0]))
			}.map(unpack))
		case.columnMajor:
			(.columnMajor, valArray.enumerated().reduce(into: Array<Dictionary<Int, Element>>(repeating: .init(), count: cols)) {
				$0[.init(colIndex[$1.0])].updateValue($1.1, forKey: .init(rowIndex[$1.0]))
			}.map(unpack))
		}
	}
}
extension COO {
	@inlinable
	public init(shape: (Int, Int), _ nonzero: some Sequence<(SIMD2<Int>, Element)>) {
		(rows, cols) = shape
		rowIndex = .init()
		colIndex = .init()
		valArray = .init()
		for (c, v) in nonzero where v != .zero {
			rowIndex.append(.init(c.x))
			colIndex.append(.init(c.y))
			valArray.append(v)
		}
	}
	@inlinable
	public init(rows source: some Collection<some Collection<Element>>) {
		let rows = source.count
		let cols = source.map(\.count).min() ?? .zero
		precondition([rows, cols].allSatisfy { .zero < $0 }, "size should be greater than 0")
		self.init(shape: (rows, cols), source.enumerated().lazy.flatMap { row, col in
			col.enumerated().lazy.map { (SIMD2<Int>(row, $0), $1) }
		})
	}
	@inlinable
	public init(cols source: some Collection<some Collection<Element>>) {
		let rows = source.map(\.count).min() ?? .zero
		let cols = source.count
		precondition([rows, cols].allSatisfy { .zero < $0 }, "size should be greater than 0")
		self.init(shape: (rows, cols), source.enumerated().lazy.flatMap { col, row in
			row.enumerated().lazy.map { (SIMD2<Int>($0, col), $1) }
		})
	}
	@inlinable
	public init(_ source: some SparseMatrix<Element>) {
		(rows, cols) = (source.rows, source.cols)
		rowIndex = .init()
		colIndex = .init()
		valArray = .init()
		switch source.lil(for: .rowMajor) {
		case(.rowMajor, let lil):
			for (row, col) in lil.enumerated() {
				for (col, val) in col where val != .zero {
					rowIndex.append(.init(row))
					colIndex.append(.init(col))
					valArray.append(val)
				}
			}
		case(.columnMajor, let lil):
			for (col, row) in lil.enumerated() {
				for (row, val) in row where val != .zero {
					rowIndex.append(.init(row))
					colIndex.append(.init(col))
					valArray.append(val)
				}
			}
		}
	}
}
extension COO: ExpressibleByArrayLiteral {
	@_disfavoredOverload
	@inlinable
	public init(arrayLiteral elements: Array<Element>...) {
		self.init(rows: elements)
	}
}
extension COO: CustomStringConvertible {}
