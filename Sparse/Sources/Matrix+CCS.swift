//
//  Matrix+CCS.swift
//  MUSE
//
//  Created by Kota on 9/9/R7.
//
import protocol Dense.Matrix
import protocol Dense.MutScalar
import typealias Layout.MemoryStrategy
@frozen public struct CCS<Element> where Element: SparseScalar<Element> {
	public let rows: Int
	public let cols: Int
	@usableFromInline let colStart: Array<Int>
	@usableFromInline let rowIndex: Array<Int32>
	@usableFromInline let valArray: Array<Element>
}
extension CCS {
	@inlinable
	func coo(at col: Int) -> Zip2Sequence<LazyMapSequence<ArraySlice<Int32>, Int>, ArraySlice<Element>> {
		zip(rowIndex[colStart[col]..<colStart[col+1]].lazy.map(Int.init), valArray[colStart[col]..<colStart[col+1]])
	}
}
extension CCS: SparseMatrix {
	public typealias S = CCS<Element>
	public typealias T = CRS<Element>
	public typealias V = SPV<Element>
	public typealias U = Element
	public typealias R = Array<Element>
	public var diagonal: V {
		.init(count: min(rows, cols), store: .init(uniqueKeysWithValues: (0..<min(rows, cols)).flatMap { col in
			coo(at: col).filter { $0.0 == col }
		}))
	}
	public var transpose: T {
		.init(rows: cols, cols: rows, rowStart: colStart, colIndex: rowIndex, valArray: valArray)
	}
	@inlinable
	public subscript(row: Int, col: Int) -> U {
		coo(at: col).first { $0.0 == row }.map(\.1) ?? .zero
	}
	public subscript(row: Int, col: some RangeExpression<Int>) -> V {
		let col = col.relative(to: 0..<cols)
		return.init(count: col.count, store: .init(uniqueKeysWithValues: col.enumerated().lazy.flatMap { idx, col in
			coo(at: col).lazy.compactMap {
				$0 == row ? .some((idx, $1)) : .none
			}
		}))
	}
	public subscript(row: some RangeExpression<Int>, col: Int) -> V {
		let row = row.relative(to: 0..<rows)
		return.init(count: row.count, store: .init(uniqueKeysWithValues: coo(at: col).compactMap {
			switch ($0, $1) {
			case (row, let v) where v != .zero:
				.some(($0 - row.lowerBound, v))
			default:
				.none
			}
		}))
	}
	public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		let row = row.relative(to: 0..<rows)
		let col = col.relative(to: 0..<cols)
		return.init(shape: (row.count, col.count), col.enumerated().lazy.flatMap { idx, col in
			coo(at: col).lazy.compactMap {
				row ~= $0 && $1 != .zero ? .some((SIMD2($0 - row.lowerBound, idx), $1)) : .none
			}
		})
	}
}
extension CCS {
	public typealias LIL = LazyMapSequence<Range<Int>, Zip2Sequence<LazyMapSequence<ArraySlice<Int32>, Int>, ArraySlice<Element>>>
	@inlinable
	public func lil(for layout: MemoryStrategy) -> (MemoryStrategy, LIL) {
		(.columnMajor, (0..<cols).lazy.map(coo(at:)))
	}
}
extension CCS {
	@inlinable
	public init(shape: (Int, Int), _ source: some Sequence<(SIMD2<Int>, Element)>) {
		(rows, cols) = shape
		(colStart, rowIndex, valArray) = source.reduce(into: Array<Dictionary<Int, Element>>(repeating: .init(), count: cols)) {
			$0[$1.0.y].updateValue($1.1, forKey: $1.0.x)
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
		(colStart, rowIndex, valArray) = switch source.lil(for: .columnMajor) {
		case (.rowMajor, let lil):
			Sparse.transpose(lil: lil, for: cols).reduce(into: (Array<Int>(arrayLiteral: 0), Array<Int32>(), Array<Element>())) {
				for (idx, val) in $1 where val != .zero {
					$0.2.append(val)
					$0.1.append(.init(idx))
				}
				$0.0.append(max($0.1.count, $0.2.count))
			}
		case (.columnMajor, let lil):
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
	public init(cols lil: some Collection<some Collection<Element>>, ε: Element.Magnitude = .zero) {
		rows = lil.lazy.map(\.count).min() ?? .zero
		cols = lil.count
		precondition(0 < rows)
		precondition(0 < cols)
		(colStart, rowIndex, valArray) = lil.reduce(into: (Array<Int>(arrayLiteral: 0), Array<Int32>(), Array<Element>())) {
			for (col, val) in $1.enumerated() where ε < val.magnitude {
				$0.2.append(val)
				$0.1.append(.init(col))
			}
			$0.0.append($0.1.count)
		}
	}
}
extension CCS: ExpressibleByArrayLiteral {
	@inlinable
	public init(arrayLiteral elements: Array<Element>...) {
		self.init(cols: elements)
	}
}
extension CCS {
	@inlinable
	public init(_ source: some Matrix<Element>, ε: Element.Magnitude = .zero) async throws {
		let (layout, result) = try source(for: .columnMajor)
		precondition(layout.count == 2)
		let ldr = layout[0]
		let ldc = layout[1]
		rows = source.rows
		cols = source.cols
		(colStart, rowIndex, valArray) = await result().withUnsafeBufferPointer { [rows, cols] buffer in
			(0..<cols).reduce(into: (Array<Int>(arrayLiteral: 0), Array<Int32>(), Array<Element>())) {
				for si in 0..<rows where ε < buffer[si * ldr + $1 * ldc].magnitude {
					$0.2.append(buffer[si * ldr + $1 * ldc])
					$0.1.append(.init(si))
				}
				$0.0.append($0.1.count)
			}
		}
	}
}
extension CCS: CustomStringConvertible {}
