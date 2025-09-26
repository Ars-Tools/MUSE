//
//  Buffer+Vector.swift
//  MUSE
//
//  Created by Kota on 9/25/25.
//
import typealias Layout.MemoryStrategy
extension Buffer {
    @dynamicMemberLookup
    public struct Vector {
        public typealias Element = Storage.Element
        public typealias S = Buffer<Storage.SubSequence>.Vector
        public typealias T = Self
        public typealias U = Element
        public typealias V = Self
        public let count: Int
        public let inc: Int
        @usableFromInline
        private(set) var store: Storage
    }
}
extension Buffer.Vector {
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
extension Buffer.Vector: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Storage) {
        (zip([count], [inc]).compactMap { $0 != .zero ? .some($1) : .none }, {[store] in store})
    }
}
extension Buffer.Vector: Vector {
    @inlinable@inline(__always)
    public subscript(position: Int) -> Element {
        store[store.startIndex.advanced(by: position * inc)]
    }
    public subscript(bounds: some RangeExpression<Int>) -> Buffer<Storage.SubSequence>.Vector {
        let bounds = bounds.relative(to: 0..<count)
        let lower = store.startIndex.advanced(by: bounds.lowerBound * inc)
        let upper = lower.advanced(by: max(0, bounds.count - 1) * inc + 1)
        return.init(count: bounds.count, inc: inc, store: store[lower..<upper])
    }
}
extension Buffer.Vector: MutableTensor & MutableVector where Storage: MutableCollection {
    @inlinable@inline(__always)
    public subscript(position: Int) -> Element {
        _read {
            yield store[store.startIndex.advanced(by: position * inc)]
        }
        _modify {
            yield &store[store.startIndex.advanced(by: position * inc)]
        }
    }
    public subscript(bounds: some RangeExpression<Int>) -> Buffer<Storage.SubSequence>.Vector {
        get {
            let bounds = bounds.relative(to: 0..<count)
            let lower = store.startIndex.advanced(by: bounds.lowerBound * inc)
            let upper = lower.advanced(by: max(0, bounds.count - 1) * inc + 1)
            return.init(count: bounds.count, inc: inc, store: store[lower..<upper])
        }
        set {
            for (offset, element) in bounds.relative(to: 0..<count).enumerated() {
                store[store.startIndex.advanced(by: inc * element)] = newValue[offset]
            }
        }
    }
}
extension Buffer.Vector {
    @inlinable@inline(__always)@_transparent
    public init<Source: InstantTensor<Element>>(_ source: Source, for strategy: MemoryStrategy = .default) throws where Source.Storage == Storage {
        let (stride, kernel) = try source.evaluation(for: strategy)
        (count, inc) = switch strategy {
        case.rowMajor:
            (source.shape.last ?? 1, stride.last ?? 0)
        case.columnMajor:
            (source.shape.first ?? 1, stride.first ?? 0)
        }
        store = kernel()
    }
    @inlinable@inline(__always)@_transparent
    public init<Source: Tensor<Element>>(_ source: Source, for strategy: MemoryStrategy = .default) async throws where Source.Storage == Storage {
        let (stride, kernel) = try source.evaluation(for: strategy)
        async let result = kernel()
        (count, inc) = switch strategy {
        case.rowMajor:
            (source.shape.last ?? 1, stride.last ?? 0)
        case.columnMajor:
            (source.shape.first ?? 1, stride.first ?? 0)
        }
        store = await result
    }
}
extension Buffer.Vector: ExpressibleByArrayLiteral where Storage: RangeReplaceableCollection {
    @_disfavoredOverload
    @inlinable@inline(__always)@_transparent
    public init(_ source: any InstantTensor<Element>, for strategy: MemoryStrategy = .default) throws {
        let (stride, kernel) = try source.evaluation(for: strategy)
        (count, inc) = switch strategy {
        case.rowMajor:
            (source.shape.last ?? 1, stride.last ?? 0)
        case.columnMajor:
            (source.shape.first ?? 1, stride.first ?? 0)
        }
        store = .init(kernel())
    }
    @_disfavoredOverload
    @inlinable@inline(__always)@_transparent
    public init(_ source: any Tensor<Element>, for strategy: MemoryStrategy = .default) async throws {
        let (stride, kernel) = try source.evaluation(for: strategy)
        async let result = kernel()
        (count, inc) = switch strategy {
        case.rowMajor:
            (source.shape.last ?? 1, stride.last ?? 0)
        case.columnMajor:
            (source.shape.first ?? 1, stride.first ?? 0)
        }
        store = await.init(result)
    }
    @inlinable@inline(__always)@_transparent
    public init(arrayLiteral elements: Element...) {
        count = elements.count
        inc = 1
        store = .init(elements)
    }
}
extension Buffer.Vector: CustomStringConvertible {
    @inlinable@inline(__always)@_transparent
    public var description: String {
        (0..<count).lazy.map { store.startIndex.advanced(by: $0 * inc) }.map { store[$0] }.description
    }
}
public typealias VecBuf<Element: MutableScalar<Element>> = Buffer<Array<Element>>.Vector
