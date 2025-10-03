//
//  Buffer.swift
//  MUSE
//
//  Created by Kota on 9/25/25.
//
public enum Buffer<Storage> where Storage: Collection & Sendable, Storage.Index: Strideable, Storage.Index.Stride == Int, Storage.Element: MutableScalar<Storage.Element>, Storage.SubSequence: Sendable {
    public typealias U = Storage.Element
}
extension Collection {
    @inlinable@inline(__always)@_transparent
    func withUnsafePointerWithFallback<E, R>(_ body: (UnsafePointer<Element>) throws (E) -> R) rethrows -> R {
        try withContiguousStorageIfAvailable {
            try $0.baseAddress.map(body)
        }.flatMap(\.self) ?? body(Array(self))
    }
}
@inlinable@inline(__always)@_transparent
func withUnsafePointer<X, E, R>(_ x: some Collection<X>, _ body: (UnsafePointer<X>) throws (E) -> R) rethrows -> R {
    try x.withUnsafePointerWithFallback(body)
}
@inlinable@inline(__always)@_transparent
func withUnsafePointer<X, Y, E, R>(_ x: some Collection<X>, _ y: some Collection<Y>, _ body: (UnsafePointer<X>, UnsafePointer<Y>) throws (E) -> R) rethrows -> R {
    try x.withUnsafePointerWithFallback { x in
        try y.withUnsafePointerWithFallback { y in
            try body(x, y)
        }
    }
}
@inlinable@inline(__always)@_transparent
func withUnsafePointer<X, Y, Z, E, R>(_ x: some Collection<X>, _ y: some Collection<Y>, _ z: some Collection<Z>, _ body: (UnsafePointer<X>, UnsafePointer<Y>, UnsafePointer<Z>) throws (E) -> R) rethrows -> R {
    try x.withUnsafePointerWithFallback { x in
        try y.withUnsafePointerWithFallback { y in
            try z.withUnsafePointerWithFallback { z in
                try body(x, y, z)
            }
        }
    }
}
