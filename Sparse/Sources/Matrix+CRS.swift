//
//  Matrix+CRS.swift
//  MUSE
//
//  Created by Kota on 9/9/R7.
//
import protocol Dense.Matrix
import protocol Dense.MutScalar
import typealias Layout.MemoryStrategy
@frozen public struct CRS<Element> where Element: SparseScalar<Element> {
	public let rows: Int
	public let cols: Int
	@usableFromInline let rowStart: Array<Int>
	@usableFromInline let colIndex: Array<Int32>
	@usableFromInline let valArray: Array<Element>
}
extension CRS {
	@inlinable
	func coo(at row: Int) -> Zip2Sequence<LazyMapSequence<ArraySlice<Int32>, Int>, ArraySlice<Element>> {
		zip(colIndex[rowStart[row]..<rowStart[row+1]].lazy.map(Int.init), valArray[rowStart[row]..<rowStart[row+1]])
	}
}
extension CRS: MutSparseMatrix {
	public typealias R = Array<Element>
	public typealias S = CRS<Element>
	public typealias T = CCS<Element>
	public typealias U = Element
	public typealias V = SPV<Element>
	public var transpose: T {
		.init(rows: cols, cols: rows, colStart: rowStart, rowIndex: colIndex, valArray: valArray)
	}
	public var diagonal: V {
		get {
			.init(count: min(rows, cols), store: .init(uniqueKeysWithValues: (0..<min(rows, cols)).flatMap { row in
				coo(at: row).filter { $0.0 == row }
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
			coo(at: row).first { $0.0 == col }.map(\.1) ?? .zero
		}
		set {
			assertionFailure("not implemented")
		}
	}
	public subscript(row: Int, col: some RangeExpression<Int>) -> V {
		get {
			let col = col.relative(to: 0..<cols)
			return.init(count: col.count, store: .init(uniqueKeysWithValues: coo(at: row).compactMap {
				switch ($0, $1) {
				case (col, let v) where v != .zero:
					.some(($0 - col.lowerBound, v))
				default:
					.none
				}
			}))
		}
		set {
			assertionFailure("not implemented")
		}
	}
	public subscript(row: some RangeExpression<Int>, col: Int) -> V {
		get {
			let row = row.relative(to: 0..<rows)
			return.init(count: row.count, store: .init(uniqueKeysWithValues: row.enumerated().lazy.flatMap { idx, row in
				coo(at: row).lazy.compactMap {
					$0 == col ? .some((idx, $1)) : .none
				}
			}))
		}
		set {
			assertionFailure("not implemented")
		}
	}
	public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		get {
			let row = row.relative(to: 0..<rows)
			let col = col.relative(to: 0..<cols)
			return.init(shape: (row.count, col.count), row.enumerated().lazy.flatMap { idx, row in
				coo(at: row).lazy.compactMap {
					col ~= $0 && $1 != .zero ? .some((SIMD2(idx, $0 - col.lowerBound), $1)) : .none
				}
			})
		}
		set {
			assertionFailure("not implemented")
		}
	}
}
extension CRS {
	public typealias LIL = LazyMapSequence<Range<Int>, Zip2Sequence<LazyMapSequence<ArraySlice<Int32>, Int>, ArraySlice<Element>>>
	@inlinable
	public func lil(for layout: MemoryStrategy) -> (MemoryStrategy, LIL) {
		(.rowMajor, (0..<rows).lazy.map(coo(at:)))
	}
}
extension CRS {
	@inlinable
	public init(shape: (Int, Int), _ source: some Sequence<(SIMD2<Int>, Element)>) {
		(rows, cols) = shape
		(rowStart, colIndex, valArray) = source.reduce(into: Array<Dictionary<Int, Element>>(repeating: .init(), count: rows)) {
			$0[$1.0.x].updateValue($1.1, forKey: $1.0.y)
		}.reduce(into: (Array<Int>(arrayLiteral: 0), Array<Int32>(), Array<Element>())) {
			for (idx, val) in $1 where val != .zero {
				$0.2.append(val)
				$0.1.append(.init(idx))
			}
			$0.0.append(max($0.1.count, $0.2.count))
		}
	}
	@inlinable
	public init(_ source: some SparseMatrix<Element>) {
		rows = source.rows
		cols = source.cols
		(rowStart, colIndex, valArray) = switch source.lil(for: .rowMajor) {
		case (.columnMajor, let lil):
			Sparse.transpose(lil: lil, for: rows).reduce(into: (Array<Int>(arrayLiteral: 0), Array<Int32>(), Array<Element>())) {
				for (idx, val) in $1 where val != .zero {
					$0.2.append(val)
					$0.1.append(.init(idx))
				}
				$0.0.append(max($0.1.count, $0.2.count))
			}
		case (.rowMajor, let lil):
			lil.reduce(into: (Array<Int>(arrayLiteral: 0), Array<Int32>(), Array<Element>())) {
				for (col, val) in $1 where val != .zero {
					$0.2.append(val)
					$0.1.append(.init(col))
				}
				$0.0.append($0.1.count)
			}
		}
	}
	@inlinable
	public init(rows lil: some Collection<some Collection<Element>>, ε: Element.Magnitude = .zero) {
		rows = lil.count
		cols = lil.lazy.map(\.count).min() ?? .zero
		precondition(0 < rows)
		precondition(0 < cols)
		(rowStart, colIndex, valArray) = lil.reduce(into: (Array<Int>(arrayLiteral: 0), Array<Int32>(), Array<Element>())) {
			for (col, val) in $1.enumerated() where ε < val.magnitude {
				$0.2.append(val)
				$0.1.append(.init(col))
			}
			$0.0.append($0.1.count)
		}
	}
}
extension CRS: ExpressibleByArrayLiteral {
	@inlinable
	public init(arrayLiteral elements: Array<Element>...) {
		self.init(rows: elements)
	}
}
extension CRS {
	@_disfavoredOverload
	@inlinable
	public init(_ source: some Matrix<Element>, ε: Element.Magnitude) async throws {
		let (layout, result) = try source(for: .columnMajor)
		precondition(layout.count == 2)
		let ldr = layout[0]
		let ldc = layout[1]
		rows = source.rows
		cols = source.cols
		(rowStart, colIndex, valArray) = await result().withUnsafeBufferPointer { [rows, cols] buffer in
			(0..<rows).reduce(into: (Array<Int>(arrayLiteral: 0), Array<Int32>(), Array<Element>())) {
				for si in 0..<cols where ε < buffer[$1 * ldr + si * ldc].magnitude {
					$0.2.append(buffer[$1 * ldr + si * ldc])
					$0.1.append(.init(si))
				}
				$0.0.append($0.1.count)
			}
		}
	}
}
extension CRS: CustomStringConvertible {}
