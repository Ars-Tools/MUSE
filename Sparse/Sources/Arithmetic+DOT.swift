//
//  Arithmetic+DOT.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import protocol Dense.InstantTensor
import protocol Dense.Scalar
import protocol Dense.Matrix
import typealias Dense.Basic
import enum Layout.MemoryStrategy
import Auxiliary
extension Arithmetic {
    @usableFromInline
    @frozen enum DOT {
        @usableFromInline
        @frozen struct Inner<X: SparseVector<Element>, Y: SparseVector<Element>> {
            @usableFromInline typealias Storage = CollectionOfOne<Element>
            @usableFromInline let x: X
            @usableFromInline let y: Y
        }
        @usableFromInline
        @frozen struct Outer<LHS: SparseVector<Element>, RHS: SparseVector<Element>> {
            @usableFromInline typealias Storage = Array<Element>
            @usableFromInline typealias T = Outer<RHS.T, LHS.T>
            @usableFromInline typealias V = Arithmetic.MUL.Vector<LHS.S, RHS.S>
            @usableFromInline typealias S = Outer<LHS.S, RHS.S>
            @usableFromInline typealias U = Element
            @usableFromInline let lhs: LHS
            @usableFromInline let rhs: RHS
        }
        @usableFromInline
        @frozen struct DD<LHS: SparseMatrix<Element>, RHS: SparseMatrix<Element>> {
            @usableFromInline typealias Storage = Array<Element>
            @usableFromInline typealias U = Element
            @usableFromInline typealias S = DD<LHS.S, RHS.S>
            @usableFromInline let lhs: LHS
            @usableFromInline let rhs: RHS
        }
        @usableFromInline
        @frozen struct MV<LHS: SparseMatrix<Element>, RHS: SparseVector<Element>> {
            @usableFromInline typealias Storage = Array<Element>
            @usableFromInline typealias U = Element
            @usableFromInline typealias S = MV<LHS.S, RHS>
            @usableFromInline let lhs: LHS
            @usableFromInline let rhs: RHS
        }
        @usableFromInline
        @frozen struct VM<LHS: SparseVector<Element>, RHS: SparseMatrix<Element>> {
            @usableFromInline typealias Storage = Array<Element>
            @usableFromInline typealias U = Element
            @usableFromInline typealias S = VM<LHS, RHS.S>
            @usableFromInline let lhs: LHS
            @usableFromInline let rhs: RHS
        }
        @usableFromInline
        @frozen enum VV<X: SparseMatrix<Element>, Y: SparseMatrix<Element>> {
            case DD(X, Y)
            case MV(X, Y)
            case VM(X, Y)
        }
        @usableFromInline
        @frozen struct MM<LHS: SparseMatrix<Element>, RHS: SparseMatrix<Element>> {
            @usableFromInline typealias Storage = Array<Element>
            @usableFromInline typealias S = MM<LHS.S, RHS.S>
            @usableFromInline typealias T = MM<RHS.T, LHS.T>
            @usableFromInline typealias U = Element
            @usableFromInline typealias V = VV<LHS.S, RHS.S>
            @usableFromInline let lhs: LHS
            @usableFromInline let rhs: RHS
        }
    }
}
extension Arithmetic.DOT.Inner: Scalar & InstantTensor {
    @inlinable@inline(__always)
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> CollectionOfOne<Element>) {
        ([], {.init(x.coo • y.coo)})
    }
}
extension Arithmetic.DOT.Outer: SparseMatrix {
    @inlinable@inline(__always)
    var rows: Int { lhs.count }
    @inlinable@inline(__always)
    var cols: Int { rhs.count }
    @usableFromInline@inline(__always)
    var transpose: T {
        .init(lhs: rhs.transpose, rhs: lhs.transpose)
    }
    @usableFromInline@inline(__always)
    var diagonal: V {
        .init(lhs: lhs[0...], rhs: rhs[0...])
    }
    @inlinable@inline(__always)
    subscript(row: Int, col: Int) -> Element {
        lhs[row] * rhs[col]
    }
    @usableFromInline@inline(__always)
    subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .init(lhs: lhs[row...row], rhs: rhs[col])
    }
    @usableFromInline@inline(__always)
    subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .init(lhs: lhs[row], rhs: rhs[col...col])
    }
    @usableFromInline@inline(__always)
    subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        .init(lhs: lhs[row], rhs: rhs[col])
    }
    @inlinable@inline(__always)
    func lil(for layout: MemoryStrategy) -> (MemoryStrategy, Array<Optional<LazyMapSequence<Array<(Int, Element)>, (Int, Element)>>>) {
        switch layout {
        case.rowMajor:
            let r = Array(rhs.coo)
            return (.rowMajor, lhs.coo.reduce(into: Array<Optional<LazyMapSequence<Array<(Int, Element)>, (Int, Element)>>>(repeating: .none, count: lhs.count)) { a, x in
                a[x.0] = .some(r.lazy.map { ($0, $1 * x.1) })
            })
        case.columnMajor:
            let l = Array(lhs.coo)
            return (.columnMajor, rhs.coo.reduce(into: .init(repeating: .none, count: rhs.count)) { a, x in
                a[x.0] = .some(l.lazy.map { ($0, $1 * x.1) })
            })
        }
    }
}
extension Arithmetic.DOT.DD: SparseVector {
    @inlinable@inline(__always)
    var count: Int { min(lhs.rows, rhs.cols) }
    @inlinable@inline(__always)
    subscript(position: Int) -> Element {
        lhs[position, 0...] • rhs[0..., position]
    }
    @usableFromInline@inline(__always)
    subscript(bounds: some RangeExpression<Int>) -> S {
        .init(lhs: lhs[bounds, 0...], rhs: rhs[0..., bounds])
    }
    @inlinable@inline(__always)
    var coo: Array<(Int, Element)> {
        switch (lhs.lil(for: .rowMajor), rhs.lil(for: .columnMajor)) {
        case ((.rowMajor, let lhs), (.columnMajor, let rhs)):
            return zip(lhs, rhs).enumerated().compactMap {
                switch $1.0 • $1.1 {
                case.zero:
                    .none
                case let value:
                    .some(($0, value))
                }
            }
        case ((.columnMajor, let lhs), (.rowMajor, let rhs)):
            return zip(lhs, rhs).reduce(into: Dictionary<Int, Element>()) {
                let lhs = Dictionary(uniqueKeysWithValues: $1.0)
                $0.merge($1.1.compactMap {
                    switch lhs[$0, default: .zero] * $1 {
                    case.zero:
                        .none
                    case let v:
                        .some(($0, v))
                    }
                }, uniquingKeysWith: +)
            }.compactMap {
                $1 == .zero ? .none : .some(($0, $1))
            }
        case ((.columnMajor, let lhs), (.columnMajor, let rhs)):
            let lhs = lhs.map(Dictionary.init(uniqueKeysWithValues:))
            return rhs.enumerated().compactMap { idx, rhs in
                switch rhs.reduce(Element.zero, { $0 + lhs[$1.0][idx, default: .zero] * $1.1 }) {
                case.zero:
                    .none
                case let value:
                    .some((idx, value))
                }
            }
        case ((.rowMajor, let lhs), (.rowMajor, let rhs)):
            let rhs = rhs.map(Dictionary.init(uniqueKeysWithValues:))
            return lhs.enumerated().compactMap { idx, lhs in
                switch lhs.reduce(Element.zero, { $0 + rhs[$1.0][idx, default: .zero] * $1.1 }) {
                case.zero:
                    .none
                case let value:
                    .some((idx, value))
                }
            }
        }
    }
}
extension Arithmetic.DOT.MV: SparseVector {
    @inlinable@inline(__always)
    var count: Int {
        lhs.rows
    }
    @inlinable@inline(__always)
    subscript(position: Int) -> Element {
        lhs[position, 0...] • rhs
    }
    @usableFromInline@inline(__always)
    subscript(bounds: some RangeExpression<Int>) -> S {
        .init(lhs: lhs[bounds, 0...], rhs: rhs)
    }
    @inlinable@inline(__always)
    var coo: Array<(Int, Element)> {
        switch lhs.lil(for: .columnMajor) {
        case (.columnMajor, let lhs):
            return rhs.coo.reduce(into: Dictionary<Int, Element>()) { a, x in
                a.merge(lhs[x.0].lazy.map { ($0, $1 * x.1) }, uniquingKeysWith: +)
            }.compactMap {
                $1 == .zero ? .none : .some(($0, $1))
            }
        case (.rowMajor, let lhs):
            let rhs = rhs.coo
            return lhs.enumerated().compactMap {
                switch $0.1 • rhs {
                case.zero:
                    .none
                case let v:
                    .some(($0.0, v))
                }
            }
        }
    }
}
extension Arithmetic.DOT.VM: SparseVector {
    @inlinable@inline(__always)
    var count: Int { rhs.cols }
    @inlinable@inline(__always)
    subscript(position: Int) -> Element {
        lhs • rhs[0..., position]
    }
    @usableFromInline@inline(__always)
    subscript(bounds: some RangeExpression<Int>) -> S {
        .init(lhs: lhs, rhs: rhs[0..., bounds])
    }
    @inlinable@inline(__always)
    var coo: Array<(Int, Element)> {
        switch rhs.lil(for: .columnMajor) {
        case (.columnMajor, let rhs):
            let lhs = lhs.coo
            return rhs.enumerated().compactMap {
                switch lhs • $0.1 {
                case.zero:
                    .none
                case let v:
                    .some(($0.0, v))
                }
            }
        case (.rowMajor, let rhs):
            return lhs.coo.reduce(into: Dictionary<Int, Element>()) { a, x in
                a.merge(rhs[x.0].lazy.map { ($0, $1 * x.1) }, uniquingKeysWith: +)
            }.compactMap {
                $1 == .zero ? .none : .some(($0, $1))
            }
        }
    }
}
extension Arithmetic.DOT.VV: SparseVector {
    @usableFromInline typealias Storage = Array<Element>
    @usableFromInline typealias S = Arithmetic.DOT.VV<X.S, Y.S>
    @usableFromInline typealias U = Element
    @inlinable
    var count: Int {
        switch self {
        case.DD(let x, let y):
            min(x.rows, y.cols)
        case.MV(let x, _):
            x.rows
        case.VM(_, let y):
            y.cols
        }
    }
    @usableFromInline
    subscript(position: Int) -> U {
        switch self {
        case.DD(let x, let y):
            x[position, 0...] • y[0..., position]
        case.MV(let x, let y):
            x[position, 0...] • y[0..., 0]
        case.VM(let x, let y):
            x[0, 0...] • y[0..., position]
        }
    }
    @usableFromInline
    subscript(bounds: some RangeExpression<Int>) -> S {
        switch self {
        case.DD(let x, let y):
            .DD(x[bounds, 0...], y[0..., bounds])
        case.MV(let x, let y):
            .MV(x[bounds, 0...], y[0..., 0...])
        case.VM(let x, let y):
            .VM(x[0..., 0...], y[0..., bounds])
        }
    }
    @usableFromInline
    var coo: Array<(Int, Element)> {
        switch self {
        case.DD(let x, let y):
            Arithmetic.DOT.DD(lhs: x, rhs: y).coo
        case.MV(let x, let y):
            Arithmetic.DOT.MV(lhs: x, rhs: y[0..., 0]).coo
        case.VM(let x, let y):
            Arithmetic.DOT.VM(lhs: x[0..., 0], rhs: y).coo
        }
    }
}
extension Arithmetic.DOT.MM: SparseMatrix {
    @inlinable@inline(__always)
    var rows: Int { lhs.rows }
    @inlinable@inline(__always)
    var cols: Int { rhs.cols }
    @usableFromInline@inline(__always)
    var diagonal: V {
        .DD(lhs[0..., 0...], rhs[0..., 0...])
    }
    @usableFromInline@inline(__always)
    var transpose: T {
        .init(lhs: rhs.transpose, rhs: lhs.transpose)
    }
    @inlinable@inline(__always)
    subscript(row: Int, col: Int) -> Element {
        lhs[row, 0...] • rhs[0..., col]
    }
    @usableFromInline@inline(__always)
    subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .MV(lhs[row...row, 0...], rhs[0..., col])
    }
    @usableFromInline@inline(__always)
    subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .VM(lhs[row, 0...], rhs[0..., col...col])
    }
    @usableFromInline@inline(__always)
    subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
        .init(lhs: lhs[row, 0...], rhs: rhs[0..., col])
    }
    @inlinable@inline(__always)
    func lil(for strategy: MemoryStrategy) -> (MemoryStrategy, Array<LazyMapSequence<LazyFilterSequence<LazyMapSequence<Dictionary<Int, Element>, Optional<(Int, Element)>>>, (Int, Element)>>) {
        switch (strategy, lhs.lil(for: strategy), rhs.lil(for: strategy)) {
        case(.columnMajor, (.columnMajor, let lhs), (.columnMajor, let rhs)), (.rowMajor, (.columnMajor, let lhs), (.columnMajor, let rhs)):
            return (.columnMajor, rhs.parallelMap {
                unpack($0.reduce(into: Dictionary<Int, Element>()) { a, x in a.merge(lhs[x.0].lazy.map { ($0, $1 * x.1) }, uniquingKeysWith: +)})
            })
        case(.rowMajor, (.rowMajor, let lhs), (.rowMajor, let rhs)), (.columnMajor, (.rowMajor, let lhs), (.rowMajor, let rhs)):
            return (.rowMajor, lhs.parallelMap {
                unpack($0.reduce(into: Dictionary<Int, Element>()) { a, x in a.merge(rhs[x.0].lazy.map { ($0, $1 * x.1) }, uniquingKeysWith: +)})
            })
        case(.columnMajor, (.rowMajor, let lhs), (.columnMajor, let rhs)):
            let lhs = Sparse.transpose(lil: lhs, for: rhs.count)
            return (.columnMajor, rhs.parallelMap {
                unpack($0.reduce(into: Dictionary<Int, Element>()) { a, x in a.merge(lhs[x.0].lazy.map { ($0, $1 * x.1) }, uniquingKeysWith: +)})
            })
        case(.rowMajor, (.rowMajor, let lhs), (.columnMajor, let rhs)):
            let rhs = Sparse.transpose(lil: rhs, for: lhs.count)
            return (.rowMajor, lhs.parallelMap {
                unpack($0.reduce(into: Dictionary<Int, Element>()) { a, x in a.merge(rhs[x.0].lazy.map { ($0, $1 * x.1) }, uniquingKeysWith: +)})
            })
        case(.columnMajor, (.columnMajor, let lhs), (.rowMajor, let rhs)):
            return (.columnMajor, zip(lhs, rhs).reduce(into: Array<Dictionary<Int, Element>>(repeating: .init(), count: cols)) { a, t in
                for (col, val) in t.1 where val != .zero {
                    a[col].merge(t.0.lazy.map { (($0, $1 * val)) }, uniquingKeysWith: +)
                }
            }.map(unpack))
        case(.rowMajor, (.columnMajor, let lhs), (.rowMajor, let rhs)):
            return (.rowMajor, zip(lhs, rhs).reduce(into: Array<Dictionary<Int, Element>>(repeating: .init(), count: rows)) { a, t in
                for (row, val) in t.0 where val != .zero{
                    a[row].merge(t.1.lazy.map { (($0, $1 * val)) }, uniquingKeysWith: +)
                }
            }.map(unpack))
        }
    }
}
@_disfavoredOverload
@inlinable
public func •<Element: Numeric>(_ lhs: some SparseVector<Element>, _ rhs: some SparseVector<Element>) -> Element {
    precondition(lhs.count == rhs.count, "dot length should be same")
    return lhs.coo • rhs.coo
}
public func •<Element: Numeric>(_ lhs: some SparseMatrix<Element>, _ rhs: some SparseVector<Element>) -> some SparseVector<Element> {
    precondition(lhs.cols == rhs.count, "dot length should be same")
    return Arithmetic.DOT.MV(lhs: lhs, rhs: rhs)
}
public func •<Element: Numeric>(_ lhs: some SparseVector<Element>, _ rhs: some SparseMatrix<Element>) -> some SparseVector<Element> {
    precondition(lhs.count == rhs.rows, "dot length should be same")
    return Arithmetic.DOT.VM(lhs: lhs, rhs: rhs)
}
public func •<Element: Numeric>(_ lhs: some SparseMatrix<Element>, _ rhs: some SparseMatrix<Element>) -> some SparseMatrix<Element> {
    precondition(lhs.cols == rhs.rows, "dot length should be same")
    return Arithmetic.DOT.MM(lhs: lhs, rhs: rhs)
}
public func outer<Element: Numeric>(_ lhs: some SparseVector<Element>, _ rhs: some SparseVector<Element>) -> some SparseMatrix<Element> {
    Arithmetic<Element>.DOT.Outer(lhs: lhs, rhs: rhs)
}
