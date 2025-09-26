//
//  Buffer+Matrix.swift
//  MUSE
//
//  Created by Kota on 9/25/25.
//
import typealias Layout.MemoryStrategy
import func Layout.product
extension Buffer {
    @dynamicMemberLookup
    public struct Matrix {
        public typealias Element = Storage.Element
        public typealias S = Buffer<Storage.SubSequence>.Matrix
        public typealias T = Self
        public typealias U = Element
        public typealias V = Buffer<Storage.SubSequence>.Vector
        public let rows: Int
        public let cols: Int
        public let ldr: Int
        public let ldc: Int
        @usableFromInline
        private(set) var store: Storage
    }
}
extension Buffer.Matrix {
    @_disfavoredOverload
    @inlinable@inline(__always)
    public subscript<R>(dynamicMember lookup: KeyPath<Storage, R>) -> R {
        store[keyPath: lookup]
    }
    @_disfavoredOverload
    @inlinable@inline(__always)
    public subscript<R>(dynamicMember lookup: ReferenceWritableKeyPath<Storage, R>) -> R {
        _read {
            yield store[keyPath: lookup]
        }
        _modify {
            yield &store[keyPath: lookup]
        }
    }
}
extension Buffer.Matrix: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Storage) {
        (zip([rows, cols], [ldr, ldc]).compactMap { $0 != .zero ? .some($1) : .none }, {[store] in store})
    }
}
extension Buffer.Matrix: Matrix {
    public var transpose: T {
        .init(rows: cols, cols: rows, ldr: ldc, ldc: ldr, store: store)
    }
    public var diagonal: V {
        .init(count: min(rows, cols), inc: ldr + ldc, store: store[store.startIndex...])
    }
    @inlinable@inline(__always)
    public subscript(row: Int, col: Int) -> Element {
        store[store.startIndex.advanced(by: row * ldr + col * ldc)]
    }
    public subscript(row: Int, col: some RangeExpression<Int>) -> V {
        let col = col.relative(to: 0..<cols)
        let lower = store.startIndex.advanced(by: row * ldr + col.lowerBound * ldc)
        let upper = lower.advanced(by: max(0, col.count - 1) * ldc + 1)
        return.init(count: col.count, inc: ldc, store: store[lower..<upper])
    }
    public subscript(row: some RangeExpression<Int>, col: Int) -> V {
        let row = row.relative(to: 0..<rows)
        let lower = store.startIndex.advanced(by: row.lowerBound * ldr + col * ldc)
        let upper = lower.advanced(by: max(0, row.count - 1) * ldr + 1)
        return.init(count: row.count, inc: ldr, store: store[lower..<upper])
    }
    public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        let row = row.relative(to: 0..<rows)
        let col = col.relative(to: 0..<cols)
        let lower = store.startIndex.advanced(by: row.lowerBound * ldr + col.lowerBound * ldc)
        let upper = lower.advanced(by: max(0, row.count - 1) * ldr + max(0, col.count - 1) * ldc + 1)
        return.init(rows: row.count, cols: col.count, ldr: ldr, ldc: ldc, store: store[lower..<upper])
    }
}
extension Buffer.Matrix: MutableTensor & MutableMatrix where Storage: MutableCollection {
    @inlinable@inline(__always)
    public subscript(row: Int, col: Int) -> Element {
        _read {
            yield store[store.startIndex.advanced(by: row * ldr + col * ldc)]
        }
        _modify {
            yield &store[store.startIndex.advanced(by: row * ldr + col * ldc)]
        }
    }
    public subscript(row: Int, col: some RangeExpression<Int>) -> V {
        get {
            let col = col.relative(to: 0..<cols)
            let lower = store.startIndex.advanced(by: row * ldr + col.lowerBound * ldc)
            let upper = lower.advanced(by: (col.count - 1) * ldc + 1)
            return.init(count: col.count, inc: ldc, store: store[lower..<upper])
        }
        set {
            for (offset, element) in col.relative(to: 0..<cols).enumerated() {
                store[store.startIndex.advanced(by: element * ldc)] = newValue[offset]
            }
        }
    }
    public subscript(row: some RangeExpression<Int>, col: Int) -> V {
        get {
            let row = row.relative(to: 0..<rows)
            let lower = store.startIndex.advanced(by: row.lowerBound * ldr + col * ldc)
            let upper = lower.advanced(by: (row.count - 1) * ldr + 1)
            return.init(count: row.count, inc: ldr, store: store[lower..<upper])
        }
        set {
            for (offset, element) in row.relative(to: 0..<rows).enumerated() {
                store[store.startIndex.advanced(by: element * ldr)] = newValue[offset]
            }
        }
    }
    public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        get {
            let row = row.relative(to: 0..<rows)
            let col = col.relative(to: 0..<cols)
            let lower = store.startIndex.advanced(by: row.lowerBound * ldr + col.lowerBound * ldc)
            let upper = lower.advanced(by: (row.count - 1) * ldr + (col.count - 1) * ldc + 1)
            return.init(rows: row.count, cols: col.count, ldr: ldr, ldc: ldc, store: store[lower..<upper])
        }
        set {
            for (row, col) in product(row.relative(to: 0..<rows).enumerated(), col.relative(to: 0..<cols).enumerated()) {
                store[store.startIndex.advanced(by: row.1 * ldr + col.1 * ldc)] = newValue[row.0, col.0]
            }
        }
    }
}
extension Buffer.Matrix {
    @inlinable
    public init<Source: InstantTensor<Element>>(_ source: Source, for strategy: MemoryStrategy = .default) throws where Source.Storage == Storage {
        let (stride, kernel) = try source.evaluation(for: strategy)
        (rows, cols, ldr, ldc) = switch strategy {
        case.rowMajor:
            (source.shape.dropLast().last ?? 1, source.shape.last ?? 1, stride.dropLast().last ?? 0, stride.last ?? 0)
        case.columnMajor:
            (source.shape.first ?? 1, source.shape.dropFirst().first ?? 1, stride.first ?? 0, stride.dropFirst().first ?? 0)
        }
        store = kernel()
    }
    @inlinable
    public init<Source: Tensor<Element>>(_ source: Source, for strategy: MemoryStrategy = .default) async throws where Source.Storage == Storage {
        let (stride, kernel) = try source.evaluation(for: strategy)
        async let result = kernel()
        (rows, cols, ldr, ldc) = switch strategy {
        case.rowMajor:
            (source.shape.dropLast().last ?? 1, source.shape.last ?? 1, stride.dropLast().last ?? 0, stride.last ?? 0)
        case.columnMajor:
            (source.shape.first ?? 1, source.shape.dropFirst().first ?? 1, stride.first ?? 0, stride.dropFirst().first ?? 0)
        }
        store = await result
    }
}
extension Buffer.Matrix: ExpressibleByArrayLiteral where Storage: RangeReplaceableCollection {
    @_disfavoredOverload
    public init(_ source: any InstantTensor<Element>, for strategy: MemoryStrategy = .default) throws {
        let (stride, kernel) = try source.evaluation(for: strategy)
        (rows, cols, ldr, ldc) = switch strategy {
        case.rowMajor:
            (source.shape.dropLast().last ?? 1, source.shape.last ?? 1, stride.dropLast().last ?? 0, stride.last ?? 0)
        case.columnMajor:
            (source.shape.first ?? 1, source.shape.dropFirst().first ?? 1, stride.first ?? 0, stride.dropFirst().first ?? 0)
        }
        store = .init(kernel())
    }
    @_disfavoredOverload
    public init(_ source: any Tensor<Element>, for strategy: MemoryStrategy = .default) async throws {
        let (stride, kernel) = try source.evaluation(for: strategy)
        async let result = kernel()
        (rows, cols, ldr, ldc) = switch strategy {
        case.rowMajor:
            (source.shape.dropLast().last ?? 1, source.shape.last ?? 1, stride.dropLast().last ?? 0, stride.last ?? 0)
        case.columnMajor:
            (source.shape.first ?? 1, source.shape.dropFirst().first ?? 1, stride.first ?? 0, stride.dropFirst().first ?? 0)
        }
        store = await.init(result)
    }
    @inlinable@inline(__always)@_transparent
    public init(shape: (Int, Int), for strategy: MemoryStrategy = .default, with value: Element) {
        (rows, cols) = shape
        (ldr, ldc) = switch strategy {
        case.rowMajor:
            (cols, 1)
        case.columnMajor:
            (1, rows)
        }
        store = .init(repeating: value, count: max(rows * ldr, cols * ldc))
    }
    @inlinable@inline(__always)@_transparent
    public init(rows vec: some Collection<some Collection<Element>>) {
        let counts = vec.map(\.count)
        rows = vec.count
        precondition(0 < rows, "empty matrix is not allowed")
        cols = counts.min() ?? 1
        ldr = cols
        ldc = 1
        store = .init(vec.lazy.flatMap { [ldr] in $0.prefix(ldr) })
    }
    @inlinable@inline(__always)@_transparent
    public init(cols vec: some Collection<some Collection<Element>>) {
        let counts = vec.map(\.count)
        cols = vec.count
        precondition(0 < cols, "empty matrix is not allowed")
        rows = counts.min() ?? 1
        ldc = rows
        ldr = 1
        store = .init(vec.lazy.flatMap { [ldc] in $0.prefix(ldc) })
    }
    @inlinable
    public init(arrayLiteral elements: Array<Element>...) {
        switch MemoryStrategy.default {
        case.rowMajor:
            self.init(rows: elements)
        case.columnMajor:
            self.init(cols: elements)
        }
    }
}
extension Buffer.Matrix: CustomStringConvertible {
    @inlinable@inline(__always)@_transparent
    public var description: String {
        "[" + (0..<rows).map {
            let idx = store.startIndex.advanced(by: $0 * ldr)
            return (0..<cols).map {
                store[idx.advanced(by: $0 * ldc)]
            }.description
        }.joined(separator: ",\r\n ") + "]"
    }
}
public typealias MatBuf<Element: MutableScalar<Element>> = Buffer<Array<Element>>.Matrix
