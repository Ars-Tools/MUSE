//
//  Matrix+CCS.swift
//  MUSE
//
//  Created by Kota on 9/9/R7.
//
import protocol Dense.Matrix
import protocol Dense.InstantMatrix
import typealias Layout.MemoryStrategy
@frozen public struct CCS<Element: SparseScalar<Element> & Numeric> {
	public let rows: Int
	public let cols: Int
	@usableFromInline private(set) var colStart: Array<Int>
	@usableFromInline private(set) var rowIndex: Array<Int32>
	@usableFromInline private(set) var valArray: Array<Element>
}
extension CCS {
	@inlinable
	func coo(at col: Int) -> Zip2Sequence<LazyMapSequence<ArraySlice<Int32>, Int>, ArraySlice<Element>> {
		zip(rowIndex[colStart[col]..<colStart[col+1]].lazy.map(Int.init), valArray[colStart[col]..<colStart[col+1]])
	}
	@inlinable
	mutating func alt(change: (inout Array<Dictionary<Int32, Element>>) throws -> Void) rethrows {
		var lil = (0..<cols).map {
			Dictionary(uniqueKeysWithValues: zip(rowIndex[colStart[$0]..<colStart[$0+1]], valArray[colStart[$0]..<colStart[$0+1]]))
		}
		try change(&lil)
		(colStart, rowIndex, valArray) = lil.reduce(into: (Array<Int>(arrayLiteral: 0), Array<Int32>(), Array<Element>())) {
			for (row, val) in $1 where val != .zero {
				$0.2.append(val)
				$0.1.append(.init(row))
			}
			assert($0.1.count == $0.2.count)
			$0.0.append($0.1.count)
		}
	}
}
extension CCS: MutableSparseMatrix {
    public typealias R = Array<Element>
	public typealias S = CCS<Element>
	public typealias T = CRS<Element>
	public typealias U = Element
	public typealias V = SPV<Element>
	public var transpose: T {
		.init(rows: cols, cols: rows, rowStart: colStart, colIndex: rowIndex, valArray: valArray)
	}
	public var diagonal: V {
		get {
			.init(count: min(rows, cols), store: .init(uniqueKeysWithValues: (0..<min(rows, cols)).flatMap { col in
				coo(at: col).filter { $0.0 == col }
			}))
		}
		set {
			alt { [rows, cols] in
				for index in 0..<min(rows, cols) {
					$0[index].removeValue(forKey: .init(index))
				}
				for (index, value) in newValue.store where value != .zero {
					$0[index].updateValue(value, forKey: .init(index))
				}
			}
		}
	}
	@inlinable
	public subscript(row: Int, col: Int) -> U {
		get {
			coo(at: col).first { $0.0 == row }.map(\.1) ?? .zero
		}
		set {
			alt {
				$0[col].updateValue(newValue, forKey: .init(row))
			}
		}
	}
	public subscript(row: Int, col: some RangeExpression<Int>) -> V {
		get {
			let col = col.relative(to: 0..<cols)
			return.init(count: col.count, store: .init(uniqueKeysWithValues: col.enumerated().lazy.flatMap { idx, col in
				coo(at: col).lazy.compactMap {
					$0 == row ? .some((idx, $1)) : .none
				}
			}))
		}
		set {
			let col = col.relative(to: 0..<cols)
			alt {
				for col in col {
					$0[col].removeValue(forKey: .init(row))
				}
				for (idx, val) in newValue.store where val != .zero {
					$0[idx &- col.lowerBound].updateValue(val, forKey: .init(row))
				}
			}
		}
	}
	public subscript(row: some RangeExpression<Int>, col: Int) -> V {
		get {
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
		set {
			let row = row.relative(to: 0..<rows)
			alt {
				for row in row {
					$0[col].removeValue(forKey: .init(row))
				}
				for (idx, val) in newValue.store where val != .zero {
					$0[col].updateValue(val, forKey: .init(idx &- row.lowerBound))
				}
			}
		}
	}
	public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		get {
			let row = row.relative(to: 0..<rows)
			let col = col.relative(to: 0..<cols)
			return.init(shape: (row.count, col.count), col.enumerated().lazy.flatMap { idx, col in
				coo(at: col).lazy.compactMap {
					row ~= $0 && $1 != .zero ? .some((SIMD2($0 - row.lowerBound, idx), $1)) : .none
				}
			})
		}
		set {
			let row = row.relative(to: 0..<rows)
			let col = col.relative(to: 0..<cols)
			alt {
				for col in col {
					for row in row {
						$0[col].removeValue(forKey: .init(row))
					}
				}
				for (idx, col) in col.enumerated() {
					$0[col].merge(zip((newValue.rowIndex[newValue.colStart[idx]..<newValue.colStart[idx+1]]).lazy.map { $0 &+ .init(row.lowerBound) },
									  (newValue.valArray[newValue.colStart[idx]..<newValue.colStart[idx+1]])), uniquingKeysWith: +)
				}
			}
		}
	}
}
extension CCS {
	public typealias LIL = LazyMapSequence<Range<Int>, Zip2Sequence<LazyMapSequence<ArraySlice<Int32>, Int>, ArraySlice<Element>>>
	@inlinable
	public func lil(for layout: MemoryStrategy) -> (MemoryStrategy, LIL) {
		(.columnMajor, (0..<cols).lazy.map(coo(at:)))
	}
    @inlinable
    init(lil: some Collection<some Sequence<(Int, Element)>>, count: Int) {
        rows = count
        cols = lil.count
        (colStart, rowIndex, valArray) = lil.reduce(into: (Array<Int>(arrayLiteral: 0), Array<Int32>(), Array<Element>())) {
            for (idx, val) in $1 where val != .zero {
                $0.2.append(val)
                $0.1.append(.init(idx))
            }
            $0.0.append(max($0.1.count, $0.2.count))
        }
    }
}
extension CCS {
	@inlinable
	public init(shape: (Int, Int)) {
		(rows, cols) = shape
		precondition([rows, cols].allSatisfy { .zero < $0 }, "size should be greater than 0")
        colStart = .init(repeating: .zero, count: cols + 1)
		rowIndex = .init()
		valArray = .init()
	}
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
    public init(_ source: some InstantMatrix<Element>, ε: Element.Magnitude) async throws {
        rows = source.rows
        cols = source.cols
        let (layout, source) = try source.evaluation(for: .columnMajor)
        let result = source()
        precondition(layout.count == 2)
        let ldr = layout[0]
        let ldc = layout[1]
        (colStart, rowIndex, valArray) = result.withUnsafeBufferPointer { [rows, cols] buffer in
            (0..<cols).reduce(into: (Array<Int>(arrayLiteral: 0), Array<Int32>(), Array<Element>())) {
                for si in 0..<rows where ε < buffer[si * ldr + $1 * ldc].magnitude {
                    $0.2.append(buffer[si * ldr + $1 * ldc])
                    $0.1.append(.init(si))
                }
                $0.0.append($0.1.count)
            }
        }
    }
	@_disfavoredOverload
	@inlinable
	public init(_ source: some Matrix<Element>, ε: Element.Magnitude) async throws {
		rows = source.rows
		cols = source.cols
        let (layout, source) = try source.evaluation(for: .columnMajor)
		async let result = source()
		precondition(layout.count == 2)
		let ldr = layout[0]
		let ldc = layout[1]
		(colStart, rowIndex, valArray) = await result.withUnsafeBufferPointer { [rows, cols] buffer in
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
