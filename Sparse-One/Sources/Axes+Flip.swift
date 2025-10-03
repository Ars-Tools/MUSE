//
//  Axes+Flip.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import protocol Dense.Matrix
import typealias Layout.MemoryStrategy
extension Axes {
    @usableFromInline
    @frozen struct FlipMatrix<Source: SparseMatrix<Element>> {
        @usableFromInline typealias Storage = Array<Element>
        @usableFromInline typealias S = FlipMatrix<Source.S>
        @usableFromInline typealias T = FlipMatrix<Source.T>
        @usableFromInline typealias U = Element
        @usableFromInline typealias V = COV<Element, LazyMapSequence<Range<Int>, (Int, Element)>>
        @usableFromInline let source: Source
        @usableFromInline let axis: MemoryStrategy
    }
}
extension Axes.FlipMatrix: SparseMatrix {
    @usableFromInline var rows: Int { source.rows }
    @usableFromInline var cols: Int { source.cols }
    @usableFromInline
    var transpose: T {
        .init(source: source.transpose, axis: axis.transpose)
    }
    @usableFromInline
    var diagonal: V {
        switch axis {
        case.rowMajor:
            .init(count: min(rows, cols), coo: (0..<min(rows, cols)).lazy.map {
                ($0, source[rows - $0 - 1, $0])
            })
        case.columnMajor:
            .init(count: min(rows, cols), coo: (0..<min(rows, cols)).lazy.map {
                ($0, source[$0, cols - $0 - 1])
            })
        }
    }
    @usableFromInline
    subscript(row: Int, col: Int) -> Element {
        switch axis {
        case.rowMajor:
            source[rows - row - 1, col]
        case.columnMajor:
            source[row, cols - col - 1]
        }
    }
    @usableFromInline
    subscript(row: Int, col: some RangeExpression<Int>) -> V {
        let col = col.relative(to: 0..<cols)
        return switch axis {
        case.rowMajor:
            .init(count: col.count, coo: col.lazy.map {
                ($0, source[rows - row - 1, $0])
            })
        case.columnMajor:
            .init(count: col.count, coo: col.lazy.map {
                ($0, source[row, cols - $0 - 1])
            })
        }
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: Int) -> V {
        let row = row.relative(to: 0..<rows)
        return switch axis {
        case.rowMajor:
            .init(count: row.count, coo: row.lazy.map {
                ($0, source[rows - $0 - 1, col])
            })
        case.columnMajor:
            .init(count: row.count, coo: row.lazy.map {
                ($0, source[$0, cols - col - 1])
            })
        }
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        let row = row.relative(to: 0..<rows)
        let col = col.relative(to: 0..<cols)
        return switch axis {
        case.rowMajor:
            .init(source: source[rows - row.upperBound - 1 ..< rows - row.lowerBound - 1, col], axis: axis)
        case.columnMajor:
            .init(source: source[row, cols - col.upperBound - 1 ..< cols - col.lowerBound - 1], axis: axis)
        }
    }
    @usableFromInline
    func lil(for layout: MemoryStrategy) -> (MemoryStrategy, Array<LazyMapSequence<Source.LIL.Element, (Int, Element)>>) {
        switch (axis, source.lil(for: layout)) {
        case (.rowMajor, (.rowMajor, let lil)):
            (.rowMajor, lil.reversed().map { $0.lazy.map { ($0, $1) } })
        case (.columnMajor, (.columnMajor, let lil)):
            (.columnMajor, lil.reversed().map { $0.lazy.map { ($0, $1) } })
        case (.rowMajor, (.columnMajor, let lil)):
            (.columnMajor, lil.map { $0.lazy.map { (rows - $0 - 1, $1) } })
        case (.columnMajor, (.rowMajor, let lil)):
            (.rowMajor, lil.map { $0.lazy.map { (cols - $0 - 1, $1) } })
        }
    }
}
public func flip<Element: Numeric>(_ source: some SparseMatrix<Element>, axis: MemoryStrategy) -> some SparseMatrix<Element> {
    Axes.FlipMatrix(source: source, axis: axis)
}
