//
//  Extension+Collection.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
extension Collection {
    @inlinable@inline(__always)@_transparent
    func withUnsafePointerWithFallback<E, R>(_ body: (UnsafePointer<Element>) throws (E) -> R) rethrows -> R {
        try withContiguousStorageIfAvailable {
            try $0.baseAddress.map(body)
        }.flatMap(\.self) ?? body(Array(self))
    }
}
