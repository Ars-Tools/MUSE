//
//  Matrix+MSK.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import protocol Dense.Matrix
import typealias Layout.MemoryStrategy
import func simd.simd_reduce_min
@dynamicMemberLookup
@frozen public struct MSK {
    public typealias Element = Bool
    public let rows: Int
    public let cols: Int
    private(set) public var entry: Set<SIMD2<Int>>
}
extension MSK {
    @inlinable
    public subscript<R>(dynamicMember lookup: KeyPath<Set<SIMD2<Int>>, R>) -> R {
        entry[keyPath: lookup]
    }
    @inlinable
    public subscript<R>(dynamicMember lookup: ReferenceWritableKeyPath<Set<SIMD2<Int>>, R>) -> R {
        _read {
            yield entry[keyPath: lookup]
        }
        _modify {
            yield &entry[keyPath: lookup]
        }
    }
}
extension MSK {
    public typealias S = Self
    public typealias T = Self
    public typealias U = Element
    public typealias V = VSK
    public var diagonal: V {
        .init(count: min(rows, cols), entry: .init(entry.lazy.compactMap {
            $0.x == $0.y ? .some(simd_reduce_min($0)) : .none
        }))
    }
    public var transpose: T {
        .init(rows: cols, cols: rows, entry: .init(entry.lazy.map { .init($0.y, $0.x) }))
    }
    public subscript(row: Int, col: Int) -> U {
        get {
            entry.contains(.init(row, col))
        }
        set {
            if newValue {
                entry.insert(.init(row, col))
            } else {
                entry.remove(.init(row, col))
            }
        }
    }
    public subscript(row: Int, col: some RangeExpression<Int>) -> V {
        get {
            let col = col.relative(to: 0..<cols)
            return.init(count: col.count, entry: .init(entry.lazy.compactMap {
                switch ($0.x, $0.y) {
                case (row, col):
                    .some($0.y &- col.lowerBound)
                default:
                    .none
                }
            }))
        }
        set {
            let col = col.relative(to: 0..<cols)
            entry.subtract(entry.filter { col.contains($0.y) })
            for index in newValue.entry {
                entry.insert(.init(row, index &+ col.lowerBound))
            }
        }
    }
    public subscript(row: some RangeExpression<Int>, col: Int) -> V {
        get {
            let row = row.relative(to: 0..<rows)
            return.init(count: row.count, entry: .init(entry.lazy.compactMap {
                switch ($0.x, $0.y) {
                case (row, col):
                    .some($0.x &- row.lowerBound)
                default:
                    .none
                }
            }))
        }
        set {
            let row = row.relative(to: 0..<rows)
            entry.subtract(entry.filter { row.contains($0.x) })
            for index in newValue.entry {
                entry.insert(.init(index &+ row.lowerBound, col))
            }
        }
    }
    public subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        get {
            let row = row.relative(to: 0..<rows)
            let col = col.relative(to: 0..<cols)
            return.init(rows: row.count, cols: col.count, entry: .init(entry.lazy.compactMap {
                switch ($0.x, $0.y) {
                case (row, col):
                    .some($0 &- .init(row.lowerBound, col.lowerBound))
                default:
                    .none
                }
            }))
        }
        set {
            let row = row.relative(to: 0..<rows)
            let col = col.relative(to: 0..<cols)
            entry.subtract(entry.filter {
                switch ($0.x, $0.y) {
                case (row, col):
                    true
                default:
                    false
                }
            })
            for index in newValue.entry {
                entry.insert(index &+ .init(row.lowerBound, col.lowerBound))
            }
        }
    }
}
extension MSK: MutableSparseMatrix {
    public init(shape: (Int, Int)) {
        (rows, cols) = shape
        entry = .init()
    }
    public init(shape: (Int, Int), _ nonzero: some Sequence<(SIMD2<Int>, Element)>) {
        (rows, cols) = shape
        entry = nonzero.reduce(into: .init()) {
            if $1.1 {
                $0.insert($1.0)
            }
        }
    }
}
extension MSK {
    public init(_ source: some SparseMatrix) {
        rows = source.rows
        cols = source.cols
        entry = source.entry
    }
}
extension MSK: CustomStringConvertible {}
