//
//  Stride.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
@inlinable
@inline(__always)
public func stride<T: BinaryInteger>(last shape: some Sequence<T>) -> Array<T> {
	stride(first: shape.reversed()).reversed()
}
@inlinable
@inline(__always)
public func stride<T: BinaryInteger>(first shape: some Sequence<T>) -> Array<T> {
	Array(sequence(state: (1 as T, shape.makeIterator())) { state in
		switch state.1.next() {
		case.some(let value):
			defer {
				state.0 *= value
			}
			return state.0
		case.none:
			return.none
		}
	})
}
@inlinable @inline(__always)
public func stride<S: FixedWidthInteger>(from start: SIMD2<S>, to end: SIMD2<S>, by step: SIMD2<S>) -> some Sequence<SIMD2<S>> {
	sequence(first: start) {
		all($0 .< end) ? .some($0 &+ step) : .none
	}
}
@inlinable @inline(__always)
public func stride<S: FixedWidthInteger>(from start: SIMD3<S>, to end: SIMD3<S>, by step: SIMD3<S>) -> some Sequence<SIMD3<S>> {
	sequence(first: start) {
		all($0 .< end) ? .some($0 &+ step) : .none
	}
}
@inlinable @inline(__always)
public func stride<S: FixedWidthInteger>(from start: SIMD4<S>, to end: SIMD4<S>, by step: SIMD4<S>) -> some Sequence<SIMD4<S>> {
	sequence(first: start) {
		all($0 .< end) ? .some($0 &+ step) : .none
	}
}
