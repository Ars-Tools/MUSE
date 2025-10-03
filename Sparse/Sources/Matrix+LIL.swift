//
//  Matrix+LIL.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import protocol Dense.Matrix
import typealias Layout.MemoryStrategy
extension Matrix where Element: Numeric {
    @dynamicMemberLookup
    @usableFromInline@frozen struct LIL {
        @usableFromInline typealias S = LIL
        @usableFromInline typealias T = LIL
        @usableFromInline typealias U = Element
    //    @usableFromInline typealias V = COV<Element, LazyMapSequence<LazyFilterSequence<LazyMapSequence<EnumeratedSequence<ArraySlice<Dictionary<Int, Element>>>, Optional<(Int, Element)>>>, (Int, Element)>>
        @usableFromInline typealias V = Vector<Element>.DOK
        @usableFromInline let major: MemoryStrategy
        @usableFromInline let count: Int
        @usableFromInline var store: Array<Dictionary<Int, Element>>
    }
}
extension Matrix.LIL {
    @inlinable
    subscript<Λ>(dynamicMember lookup: KeyPath<Array<Dictionary<Int, Element>>, Λ>) -> Λ {
        _read {
            yield store[keyPath: lookup]
        }
    }
    @inlinable
    subscript<Λ>(dynamicMember lookup: ReferenceWritableKeyPath<Array<Dictionary<Int, Element>>, Λ>) -> Λ {
        _read {
            yield store[keyPath: lookup]
        }
        _modify {
            yield &store[keyPath: lookup]
        }
    }
}
extension Matrix.LIL: MutableSparseMatrix {
    @inlinable
    var rows: Int {
        switch major {
        case.rowMajor:
            store.count
        case.columnMajor:
            count
        }
    }
    @inlinable
    var cols: Int {
        switch major {
        case.rowMajor:
            count
        case.columnMajor:
            store.count
        }
    }
    @usableFromInline
    var transpose: T {
        .init(major: major.transpose, count: count, store: store)
    }
    @usableFromInline
    var diagonal: V {
        get {
            .init(count: min(count, store.count), store: .init(uniqueKeysWithValues: store.prefix(min(store.count, count)).enumerated().lazy.compactMap {
                switch $1[$0] {
                case.none,.some(.zero):
                    .none
                case.some(let v):
                    .some(($0, v))
                }
            }))
        }
        set {
            for index in store.indices {
                store[index].removeValue(forKey: index)
            }
            for (key, val) in newValue.store where val != .zero {
                store[key].updateValue(val, forKey: key)
            }
        }
    }
    @usableFromInline
    subscript(row: Int, col: Int) -> Element {
        get {
            switch major {
            case.rowMajor:
                store[row][col, default: .zero]
            case.columnMajor:
                store[col][row, default: .zero]
            }
        }
        set {
            switch major {
            case.rowMajor:
                store[row].updateValue(newValue, forKey: col)
            case.columnMajor:
                store[col].updateValue(newValue, forKey: row)
            }
        }
    }
    @usableFromInline
    subscript(row: Int, col: some RangeExpression<Int>) -> V {
        get {
            switch major {
            case.rowMajor:
                let col = col.relative(to: 0..<count)
                return.init(count: col.count, store: .init(uniqueKeysWithValues: store[row].compactMap {
                    col ~= $0 && .zero != $1 ? .some(($0 &- col.lowerBound, $1)) : .none
                }))
            case.columnMajor:
                let col = col.relative(to: store)
                return.init(count: col.count, store: .init(uniqueKeysWithValues: store[col].enumerated().lazy.compactMap {
                    switch $1[row] {
                    case.none,.some(.zero):
                        .none
                    case.some(let v):
                        .some(($0 &- col.lowerBound, v))
                    }
                }))
            }
        }
        set {
            switch major {
            case.rowMajor:
                let col = col.relative(to: 0..<count)
                for key in store[row].keys where col ~= key {
                    store[row].removeValue(forKey: key)
                }
                store[row].merge(newValue.store.lazy.map {
                    (($0 &+ col.lowerBound, $1))
                }, uniquingKeysWith: +)
            case.columnMajor:
                let col = col.relative(to: store)
                for idx in col {
                    store[idx].removeValue(forKey: row)
                }
                for (key, val) in newValue.store where val != .zero {
                    store[key &+ col.lowerBound].updateValue(val, forKey: row)
                }
            }
        }
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: Int) -> V {
        get {
            switch major {
            case.rowMajor:
                let row = row.relative(to: store)
                return.init(count: row.count, store: .init(uniqueKeysWithValues: store[row].enumerated().lazy.compactMap {
                    switch $1[col] {
                    case.none,.some(.zero):
                        .none
                    case.some(let v):
                        .some(($0 &- row.lowerBound, v))
                    }
                }))
            case.columnMajor:
                let row = row.relative(to: 0..<count)
                return.init(count: row.count, store: .init(uniqueKeysWithValues: store[col].compactMap {
                    row ~= $0 && .zero != $1 ? .some(($0 &- row.lowerBound, $1)) : .none
                }))
            }
        }
        set {
            switch major {
            case.rowMajor:
                let row = row.relative(to: store)
                for idx in row {
                    store[idx].removeValue(forKey: col)
                }
                for (key, val) in newValue.store where val != .zero {
                    store[key &+ row.lowerBound].updateValue(val, forKey: col)
                }
            case.columnMajor:
                let row = row.relative(to: 0..<count)
                for key in store[col].keys where row ~= key {
                    store[col].removeValue(forKey: key)
                }
                store[col].merge(newValue.store.lazy.map {
                    (($0 &+ row.lowerBound, $1))
                }, uniquingKeysWith: +)
            }
        }
    }
    @usableFromInline
    subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        get {
            switch major {
            case.rowMajor:
                let row = row.relative(to: store)
                let col = col.relative(to: 0..<count)
                return.init(major: major, count: col.count, store: store[row].map {
                    .init(uniqueKeysWithValues: $0.lazy.compactMap {
                        col ~= $0 ? .some(($0 &- col.lowerBound, $1)) : .none
                    })
                })
            case.columnMajor:
                let row = row.relative(to: 0..<count)
                let col = col.relative(to: store)
                return.init(major: major, count: row.count, store: store[col].map {
                    .init(uniqueKeysWithValues: $0.lazy.compactMap {
                        row ~= $0 ? .some(($0 &- row.lowerBound, $1)) : .none
                    })
                })
            }
        }
        set {
            switch major {
            case.rowMajor:
                let row = row.relative(to: store)
                let col = col.relative(to: 0..<count)
                for idx in row {
                    for key in store[idx].keys where col ~= key {
                        store[idx].removeValue(forKey: key)
                    }
                }
                switch newValue.major {
                case.rowMajor:
                    for (idx, vec) in newValue.store.enumerated() {
                        store[idx &+ row.lowerBound].merge(vec.lazy.map {
                            (($0 &+ col.lowerBound, $1))
                        }, uniquingKeysWith: +)
                    }
                case.columnMajor:
                    for (idx, vec) in newValue.store.enumerated() {
                        for (key, val) in vec where val != .zero {
                            store[key].updateValue(val, forKey: idx &+ row.lowerBound)
                        }
                    }
                }
            case.columnMajor:
                let row = row.relative(to: 0..<count)
                let col = col.relative(to: store)
                for idx in col {
                    for key in store[idx].keys where row ~= key {
                        store[idx].removeValue(forKey: key)
                    }
                }
                switch newValue.major {
                case.rowMajor:
                    for (idx, vec) in newValue.store.enumerated() {
                        for (key, val) in vec where val != .zero {
                            store[key].updateValue(val, forKey: idx &+ col.lowerBound)
                        }
                    }
                case.columnMajor:
                    for (idx, vec) in newValue.store.enumerated() {
                        store[idx &+ col.lowerBound].merge(vec.lazy.map {
                            (($0 &+ row.lowerBound, $1))
                        }, uniquingKeysWith: +)
                    }
                }
            }
        }
    }
    @usableFromInline
    func lil(for layout: MemoryStrategy) -> (MemoryStrategy, Array<LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Int, Element>, Optional<(Int, Element)>>>, (Int, Element)>>) {
        switch major {
        case.rowMajor:
            (.rowMajor, store.map(unpack))
        case.columnMajor:
            (.columnMajor, store.map(unpack))
        }
    }
}
extension Matrix.LIL {
    @inlinable
    init(shape: (Int, Int), _ nonzero: some Sequence<(SIMD2<Int>, Element)>) {
        count = shape.0
        major = .default
        store = nonzero.reduce(into: .init(repeating: .init(), count: shape.1)) {
            $0[$1.0.y].updateValue($1.1, forKey: $1.0.x)
        }
    }
}
extension Matrix.LIL {
    @inlinable
    init(diagonal vector: some SparseVector<Element>, for layout: MemoryStrategy) {
        count = vector.count
        major = layout
        store = vector.coo.reduce(into: .init(repeating: .init(), count: count)) {
            $0[$1.0].updateValue($1.1, forKey: $1.0)
        }
    }
    @usableFromInline
    init(identity count: Int, for layout: MemoryStrategy) {
        self.init(diagonal: Vector<Element>.COV(count: count, coo: repeatElement(1 as Element, count: count).enumerated().lazy.map(\.self)), for: layout)
    }
    @inlinable
    init(identity count: Int) {
        self.init(identity: count, for: .columnMajor)
    }
}
extension Matrix.LIL {
    @inlinable
    init(_ source: some SparseMatrix<Element>, for layout: MemoryStrategy) {
        switch source.lil(for: layout) {
        case (layout, let lil):
            major = layout
            count = switch major {
            case.rowMajor:
                source.cols
            case.columnMajor:
                source.rows
            }
            store = lil.map(Dictionary.init(uniqueKeysWithValues:))
        case (.rowMajor, let lil):
            assert(layout == .columnMajor)
            major = layout
            count = lil.count
            store = lil.enumerated().reduce(into: .init(repeating: .init(), count: source.cols)) {
                for (key, val) in $1.1 where val != .zero {
                    $0[key].updateValue(val, forKey: $1.0)
                }
            }
        case (.columnMajor, let lil):
            assert(layout == .rowMajor)
            major = layout
            count = lil.count
            store = lil.enumerated().reduce(into: .init(repeating: .init(), count: source.rows)) {
                for (key, val) in $1.1 where val != .zero {
                    $0[key].updateValue(val, forKey: $1.0)
                }
            }
        }
    }
    @inlinable
    init(_ source: some SparseMatrix<Element>) {
        switch source.lil(for: .default) {
        case (.rowMajor, let lil):
            major = .rowMajor
            count = source.cols
            store = lil.map(Dictionary<Int, Element>.init(uniqueKeysWithValues:))
        case (.columnMajor, let lil):
            major = .columnMajor
            count = source.rows
            store = lil.map(Dictionary<Int, Element>.init(uniqueKeysWithValues:))
        }
    }
}
extension Matrix.LIL: CustomStringConvertible {}
typealias LIL<Element: MutableSparseScalar<Element> & Numeric> = Matrix<Element>.LIL
