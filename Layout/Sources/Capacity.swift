//
//  Capacity.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
@inlinable@inline(__always)@_transparent
public func capacity<T: BinaryInteger>(alloc shape: some BidirectionalCollection<T>, stride: some BidirectionalCollection<T>) -> T {
	zip(shape.reversed(), stride.reversed()).lazy.map(*).reduce(1, max)
}
@inlinable@inline(__always)@_transparent
public func capacity<T: BinaryInteger>(slice shape: some BidirectionalCollection<T>, stride: some BidirectionalCollection<T>) -> T {
	zip(shape.reversed(), stride.reversed()).reduce(1) { $0 + ( $1.0 - 1 ) * $1.1 }
}
@inlinable@inline(__always)@_transparent
public func offset<T: BinaryInteger>(position offset: some BidirectionalCollection<T>, stride: some BidirectionalCollection<T>) -> T {
	zip(offset.reversed(), stride.reversed()).lazy.map(*).reduce(0, +)
}
