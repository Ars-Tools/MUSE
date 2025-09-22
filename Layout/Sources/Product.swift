//
//  Product.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
@_disfavoredOverload
@inlinable@inline(__always)@_transparent
public func product<X, Y>(_ x: some Sequence<X>, _ y: some Sequence<Y>) -> some Sequence<(X, Y)> {
    x.lazy.flatMap { x in y.lazy.map {
        (x, $0)
    }}
}
@_disfavoredOverload
@inlinable@inline(__always)@_transparent
public func product<X, Y, Z>(_ x: some Sequence<X>, _ y: some Sequence<Y>, _ z: some Sequence<Z>) -> some Sequence<(X, Y, Z)> {
    x.lazy.flatMap { x in y.lazy.flatMap { y in z.lazy.map {
        (x, y, $0)
    }}}
}
@_disfavoredOverload
@inlinable@inline(__always)@_transparent
public func product<X, Y, Z, W>(_ x: some Sequence<X>, _ y: some Sequence<Y>, _ z: some Sequence<Z>, _ w: some Sequence<W>) -> some Sequence<(X, Y, Z, W)> {
    x.lazy.flatMap { x in y.lazy.flatMap { y in z.lazy.flatMap { z in w.lazy.map {
        (x, y, z, $0)
    }}}}
}
@inlinable@inline(__always)@_transparent
public func product<S: SIMDScalar>(_ x: some Sequence<S>, _ y: some Sequence<S>) -> some Sequence<SIMD2<S>> {
    x.lazy.flatMap { x in y.lazy.map { y in
        SIMD2(x, y)
    }}
}
@inlinable@inline(__always)@_transparent
public func product<S: SIMDScalar>(_ x: some Sequence<S>, _ y: some Sequence<S>, _ z: some Sequence<S>) -> some Sequence<SIMD3<S>> {
    x.lazy.flatMap { x in y.lazy.flatMap { y in z.lazy.map { z in
        SIMD3(x, y, z)
    }}}
}
@inlinable@inline(__always)@_transparent
public func product<S: SIMDScalar>(_ x: some Sequence<S>, _ y: some Sequence<S>, _ z: some Sequence<S>, _ w: some Sequence<S>) -> some Sequence<SIMD4<S>> {
	x.lazy.flatMap { x in y.lazy.flatMap { y in z.lazy.flatMap { z in
        w.lazy.map { w in SIMD4(x, y, z, w) }
    }}}
}
