//
//  Broadcast.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
@inlinable@inline(__always)@_transparent
public func broadcast<T: BinaryInteger>(x: T, y: T) -> T {
	switch (x, y) {
	case(1, 1):
		1
	case(let x, 1):
		x
	case(1, let y):
		y
	case let(x, y):
		min(x, y)
	}
}
@inlinable@inline(__always)@_transparent
public func broadcast<T: BinaryInteger>(x: T, y: T, z: T) -> T {
	switch (x, y, z) {
	case(1, 1, 1):
		1
	case(let x, 1, 1):
		x
	case(1, let y, 1):
		y
	case(1, 1, let z):
		z
	case(let x, let y, 1):
		min(x, y)
	case(let x, 1, let z):
		min(x, z)
	case(1, let y, let z):
		min(y, z)
	case let(x, y, z):
		min(x, y, z)
	}
}
@inlinable@inline(__always)@_transparent
public func broadcast<T: BinaryInteger>(lhs: some Collection<T>, rhs: some Collection<T>) -> Array<T> {
	let count = max(lhs.count, rhs.count)
	return zip(concat(repeatElement(1, count: count - lhs.count), lhs),
			   concat(repeatElement(1, count: count - rhs.count), rhs))
	.map(broadcast(x:y:))
}
@inlinable@inline(__always)@_transparent
public func broadcast<T: BinaryInteger>(a: some Collection<T>, b: some Collection<T>, c: some Collection<T>) -> Array<T> {
	let count = max(a.count, b.count, c.count)
	return zip(concat(repeatElement(1, count: count - a.count), a),
			   concat(repeatElement(1, count: count - b.count), b),
			   concat(repeatElement(1, count: count - c.count), c))
	.map(broadcast(x:y:z:))
}
@inlinable@inline(__always)@_transparent
public func broadcast<T: BinaryInteger>(target: T, source: T, stride: T) -> T {
	min(1, source / max(1, target)) * stride
}
@inlinable@inline(__always)@_transparent
public func broadcast<T: BinaryInteger>(target: some Collection<T>, source: some Collection<T>, stride: some Collection<T>) -> Array<T> {
	zip(target,
		concat(repeatElement(1, count: target.count - source.count), source),
		concat(repeatElement(0, count: target.count - stride.count), stride))
	.map(broadcast(target:source:stride:))
}
