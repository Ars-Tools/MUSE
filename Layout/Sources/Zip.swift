//
//  Zip.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
@_disfavoredOverload
@inlinable@inline(__always)@_transparent
public func zip<X, Y, Z>(_ x: some Sequence<X>, _ y: some Sequence<Y>, _ z: some Sequence<Z>) -> some Sequence<(X, Y, Z)> {
	sequence(state: (x.makeIterator(), y.makeIterator(), z.makeIterator())) {
		switch ($0.0.next(), $0.1.next(), $0.2.next()) {
		case(.some(let x), .some(let y), .some(let z)):
			.some((x, y, z))
		default:
			.none
		}
	}
}
@_disfavoredOverload
@inlinable@inline(__always)@_transparent
public func zip<X, Y, Z, W>(_ x: some Sequence<X>, _ y: some Sequence<Y>, _ z: some Sequence<Z>, _ w: some Sequence<W>) -> some Sequence<(X, Y, Z, W)> {
	sequence(state: (x.makeIterator(), y.makeIterator(), z.makeIterator(), w.makeIterator())) {
		switch ($0.0.next(), $0.1.next(), $0.2.next(), $0.3.next()) {
		case(.some(let x), .some(let y), .some(let z), .some(let w)):
			.some((x, y, z, w))
		default:
			.none
		}
	}
}
@inlinable@inline(__always)@_transparent
public func zip<S: SIMDScalar>(_ x: some Sequence<S>, _ y: some Sequence<S>) -> some Sequence<SIMD2<S>> {
	sequence(state: (x.makeIterator(), y.makeIterator())) {
		switch ($0.0.next(), $0.1.next()) {
		case(.some(let x), .some(let y)):
			.some(.init(x, y))
		default:
			.none
		}
	}
}
@inlinable@inline(__always)@_transparent
public func zip<S: SIMDScalar>(_ x: some Sequence<S>, _ y: some Sequence<S>, _ z: some Sequence<S>) -> some Sequence<SIMD3<S>> {
	sequence(state: (x.makeIterator(), y.makeIterator(), z.makeIterator())) {
		switch ($0.0.next(), $0.1.next(), $0.2.next()) {
		case(.some(let x), .some(let y), .some(let z)):
			.some(.init(x, y, z))
		default:
			.none
		}
	}
}
@inlinable@inline(__always)@_transparent
public func zip<S: SIMDScalar>(_ x: some Sequence<S>, _ y: some Sequence<S>, _ z: some Sequence<S>, _ w: some Sequence<S>) -> some Sequence<SIMD4<S>> {
	sequence(state: (x.makeIterator(), y.makeIterator(), z.makeIterator(), w.makeIterator())) {
		switch ($0.0.next(), $0.1.next(), $0.2.next(), $0.3.next()) {
		case(.some(let x), .some(let y), .some(let z), .some(let w)):
			.some(.init(x, y, z, w))
		default:
			.none
		}
	}
}
