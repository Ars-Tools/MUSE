//
//  Protocol+Matrix.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
@_exported import typealias Layout.MemoryStrategy
import protocol Dense.Matrix
import protocol Dense.InstantMatrix
import protocol Dense.MutableMatrix
public protocol SparseMatrix<Element>: InstantMatrix where S: SparseMatrix<Element>, T: SparseMatrix<Element>, U == Element, V: SparseVector<Element> {
    associatedtype LIL: RandomAccessCollection where LIL.Index == Int, LIL.Element: Sequence, LIL.Element.Element == (Int, Element)
    @inlinable func lil(for layout: MemoryStrategy) -> (MemoryStrategy, LIL)
    @inlinable var entry: Set<SIMD2<Int>> { get }
}
public protocol MutableSparseMatrix<Element>: MutableMatrix & SparseMatrix where S: MutableSparseMatrix<Element>, T: MutableSparseMatrix<Element>, U == Element, V: MutableSparseVector<Element> {
    @inlinable init(shape: (Int, Int), _ nonzero: some Sequence<(SIMD2<Int>, Element)>)
}
extension SparseMatrix where Element: Numeric {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch lil(for: strategy) {
        case(.rowMajor, let lil):
            let ldr = max(1, cols)
            let (layout, memory) = (zip([rows, cols], [ldr, 1]).compactMap { 0 < $0 ? .some($1) : .none }, lil.enumerated().reduce(into: Array<Element>(repeating: .zero, count: lil.count * ldr)) {
                for (col, val) in $1.1 {
                    $0[$1.0*ldr+col] = val
                }
            })
            return (layout, {memory})
        case(.columnMajor, let lil):
            let ldc = max(1, rows)
            let (layout, memory) = (zip([rows, cols], [1, ldc]).compactMap { 0 < $0 ? .some($1) : .none }, lil.enumerated().reduce(into: Array<Element>(repeating: .zero, count: lil.count * ldc)) {
                for (row, val) in $1.1 {
                    $0[$1.0*ldc+row] = val
                }
            })
            return (layout, {memory})
        }
    }
    @inlinable@inline(__always)@_transparent
    public var entry: Set<SIMD2<Int>> {
        switch lil(for: .rowMajor) {
        case(.rowMajor, let lil):
                .init(lil.enumerated().lazy.flatMap { row, col in
                    col.lazy.compactMap {
                        $1 != .zero ? .some(SIMD2<Int>(row, $0)) : .none
                    }
                })
        case(.columnMajor, let lil):
                .init(lil.enumerated().lazy.flatMap { col, row in
                    row.lazy.compactMap {
                        $1 != .zero ? .some(SIMD2<Int>($0, col)) : .none
                    }
                })
        }
    }
    @inlinable@inline(__always)@_transparent
    public var description: String {
        switch (rows, cols) {
        case (0, 0):
            .init(describing: lil(for: .columnMajor).1.flatMap(\.self).first.map(\.1) ?? .zero)
        case (0, let count):
            switch lil(for: .rowMajor) {
            case (.rowMajor, let lil):
                lil.flatMap(\.self).reduce(into: Array<Element>(repeating: .zero, count: count)) {
                    $0[$1.0] = $1.1
                }.description
            case (.columnMajor, let lil):
                lil.enumerated().reduce(into: Array<Element>(repeating: .zero, count: count)) {
                    for (row, val) in $1.1 where row == .zero {
                        $0[$1.0] = val
                    }
                }.description
            }
        case (let count, 0):
            switch lil(for: .columnMajor) {
            case (.rowMajor, let lil):
                lil.enumerated().reduce(into: Array<Element>(repeating: .zero, count: count)) {
                    for (row, val) in $1.1 where row == .zero {
                        $0[$1.0] = val
                    }
                }.description
            case (.columnMajor, let lil):
                lil.flatMap(\.self).reduce(into: Array<Element>(repeating: .zero, count: count)) {
                    $0[$1.0] = $1.1
                }.description
            }
        default:
            switch lil(for: .rowMajor) {
            case(.rowMajor, let lil):
                "[" + lil.lazy.map { row in
                    row.reduce(into: Array<Element>(repeating: .zero, count: cols)) {
                        $0[$1.0] = $1.1
                    }.description
                }.joined(separator: ",\r\n ") + "]"
            case(.columnMajor, let lil):
                "[" + Sparse.transpose(lil: lil, for: rows).lazy.map { row in
                    row.reduce(into: Array<Element>(repeating: .zero, count: cols)) {
                        $0[$1.0] = $1.1
                    }.description
                }.joined(separator: ",\r\n ") + "]"
            }
        }
    }
}
extension SparseMatrix where Element == Bool {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch strategy {
        case.rowMajor:
            let ldr = max(1, cols)
            let (layout, result) = (zip([rows, cols], [ldr, 1]).compactMap { 0 < $0 ? .some($1) : .none },
                                    entry.reduce(into: Array<Element>(repeating: false, count: max(1, rows) * ldr)) {
                $0[$1.x*ldr+$1.y] = true
            })
            return (layout, {result})
        case.columnMajor:
            let ldc = max(1, rows)
            let (layout, result) = (zip([rows, cols], [1, ldc]).compactMap { 0 < $0 ? .some($1) : .none },
                                    entry.reduce(into: Array<Element>(repeating: false, count: max(1, cols) * ldc)) {
                $0[$1.x+ldc*$1.y] = true
            })
            return (layout, {result})
        }
    }
    @inlinable@inline(__always)@_transparent
    public func lil(for layout: MemoryStrategy) -> (MemoryStrategy, LazyMapSequence<Array<Set<Int>>, LazyMapSequence<Set<Int>, (Int, Element)>>) {
        switch layout {
        case.rowMajor:
            (.rowMajor, entry.reduce(into: Array<Set<Int>>(repeating: .init(), count: max(1, rows))) {
                $0[$1.x].insert($1.y)
            }.lazy.map { $0.lazy.map { ($0, true) } })
        case.columnMajor:
            (.columnMajor, entry.reduce(into: Array<Set<Int>>(repeating: .init(), count: max(1, cols))) {
                $0[$1.y].insert($1.x)
            }.lazy.map { $0.lazy.map { ($0, true) } })
        }
    }
    @inlinable@inline(__always)@_transparent
    public var description: String {
        switch (rows, cols) {
        case (0, 0):
            .init(describing: lil(for: .columnMajor).1.flatMap(\.self).first.map(\.1) ?? false)
        case (0, let count):
            switch lil(for: .rowMajor) {
            case (.rowMajor, let lil):
                lil.flatMap(\.self).reduce(into: Array<Element>(repeating: false, count: count)) {
                    $0[$1.0] = $1.1
                }.description
            case (.columnMajor, let lil):
                lil.enumerated().reduce(into: Array<Element>(repeating: false, count: count)) {
                    for (row, val) in $1.1 where row == .zero {
                        $0[$1.0] = val
                    }
                }.description
            }
        case (let count, 0):
            switch lil(for: .columnMajor) {
            case (.rowMajor, let lil):
                lil.enumerated().reduce(into: Array<Element>(repeating: false, count: count)) {
                    for (row, val) in $1.1 where row == .zero {
                        $0[$1.0] = val
                    }
                }.description
            case (.columnMajor, let lil):
                lil.flatMap(\.self).reduce(into: Array<Element>(repeating: false, count: count)) {
                    $0[$1.0] = $1.1
                }.description
            }
        default:
            switch lil(for: .rowMajor) {
            case(.rowMajor, let lil):
                "[" + lil.lazy.map { row in
                    row.reduce(into: Array<Element>(repeating: false, count: cols)) {
                        $0[$1.0] = $1.1
                    }.description
                }.joined(separator: ",\r\n ") + "]"
            case(.columnMajor, let lil):
                "[" + Sparse.transpose(lil: lil, for: rows).lazy.map { row in
                    row.reduce(into: Array<Element>(repeating: false, count: cols)) {
                        $0[$1.0] = $1.1
                    }.description
                }.joined(separator: ",\r\n ") + "]"
            }
        }
    }
}
extension MutableSparseMatrix {
    @inlinable
    public init(diagonal vector: some Collection<Element>) {
        self.init(shape: (vector.count, vector.count), vector.enumerated().lazy.map { (SIMD2(repeating: $0), $1) })
    }
    @_disfavoredOverload
    @inlinable
    public init(diagonal vector: Element...) {
        self.init(diagonal: vector)
    }
    @inlinable
    public init(diagonal vector: some SparseVector<Element>) {
        self.init(shape: (vector.count, vector.count), vector.coo.lazy.map { (SIMD2(repeating: $0), $1) })
    }
    @inlinable
    public init(_ vector: some SparseVector<Element>, for strategy: MemoryStrategy) {
        switch strategy {
        case.rowMajor:
            self.init(shape: (1, vector.count), vector.coo.lazy.map { (SIMD2<Int>(0, $0), $1) })
        case.columnMajor:
            self.init(shape: (vector.count, 1), vector.coo.lazy.map { (SIMD2<Int>($0, 0), $1) })
        }
    }
}
extension MutableSparseMatrix where Element: Numeric {
    @inlinable
    public init(identity count: Int) {
        self.init(diagonal: repeatElement(1 as Element, count: count))
    }
}
extension MutableSparseMatrix where Element == Bool {
    @inlinable
    public init(identity count: Int) {
        self.init(diagonal: repeatElement(true, count: count))
    }
}
public enum Matrix<Element: MutableSparseScalar<Element>> {}
