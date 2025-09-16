//
//  Flatten.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
extension Array where Element == (Int) {
	@inlinable @inline(__always)
	func flatten(length: Int, stride: Element) -> Self {
		(0..<length).flatMap {
			let v0 = $0 &* stride
			return lazy.map { ($0 + v0) }
		}
	}
}
extension Array where Element == SIMD2<Int> {
	@inlinable @inline(__always)
	func flatten(length: Int, stride: Element) -> Self {
		(0..<length).flatMap {
			let v0 = $0 &* stride
			return lazy.map { $0 &+ v0 }
		}
	}
}
extension Array where Element == SIMD3<Int> {
	@inlinable @inline(__always)
	func flatten(length: Int, stride: Element) -> Self {
		(0..<length).flatMap {
			let v0 = $0 &* stride
			return lazy.map { $0 &+ v0 }
		}
	}
}
extension Array where Element == SIMD4<Int> {
	@inlinable @inline(__always)
	func flatten(length: Int, stride: Element) -> Self {
		(0..<length).flatMap {
			let xs = $0 &* stride
			return lazy.map { $0 &+ xs }
		}
	}
}
extension Array where Element == (Int, Int) {
	@inlinable @inline(__always)
	func flatten(length: Int, stride: Element) -> Self {
		(0..<length).flatMap {
			let v0 = $0 * stride.0
			let v1 = $0 * stride.1
			return lazy.map { ($0 + v0, $1 + v1) }
		}
	}
}
extension Array where Element == (Int, Int, Int) {
	@inlinable @inline(__always)
	func flatten(length: Int, stride: Element) -> Self {
		(0..<length).flatMap {
			let v0 = $0 * stride.0
			let v1 = $0 * stride.1
			let v2 = $0 * stride.2
			return lazy.map { ($0 + v0, $1 + v1, $2 + v2) }
		}
	}
}
extension Array where Element == (Int, Int, Int, Int) {
	@inline(__always)
	@inlinable
	func flatten(length: Int, stride: Element) -> Self {
		(0..<length).flatMap {
			let v0 = $0 * stride.0
			let v1 = $0 * stride.1
			let v2 = $0 * stride.2
			let v3 = $0 * stride.3
			return lazy.map { ($0 + v0, $1 + v1, $2 + v2, $3 + v3) }
		}
	}
}
@inlinable
@inline(__always)
func flatten(result: (Int, (Int), Array<(Int)>), source: (Int, (Int))) -> (Int, (Int), Array<(Int)>) {
	source.1 == (result.0 * result.1) ?
	(result.0 * source.0, result.1, result.2) :
	(result.0, result.1, result.2.flatten(length: source.0, stride: source.1))
}
@inlinable @inline(__always)
func flatten(result: (Int, (Int, Int), Array<(Int, Int)>), source: (Int, (Int, Int))) -> (Int, (Int, Int), Array<(Int, Int)>) {
	source.1 == (result.0 * result.1.0, result.0 * result.1.1) ?
	(result.0 * source.0, result.1, result.2) :
	(result.0, result.1, result.2.flatten(length: source.0, stride: source.1))
}
@inlinable @inline(__always)
func flatten(result: (Int, (Int, Int, Int), Array<(Int, Int, Int)>), source: (Int, (Int, Int, Int))) -> (Int, (Int, Int, Int), Array<(Int, Int, Int)>) {
	source.1 == (result.0 * result.1.0, result.0 * result.1.1, result.0 * result.1.2) ?
	(result.0 * source.0, result.1, result.2) :
	(result.0, result.1, result.2.flatten(length: source.0, stride: source.1))
}
@inlinable @inline(__always)
func flatten(result: (Int, (Int, Int, Int, Int), Array<(Int, Int, Int, Int)>), source: (Int, (Int, Int, Int, Int))) -> (Int, (Int, Int, Int, Int), Array<(Int, Int, Int, Int)>) {
	source.1 == (result.0 * result.1.0, result.0 * result.1.1, result.0 * result.1.2, result.0 * result.1.3) ?
	(result.0 * source.0, result.1, result.2) :
	(result.0, result.1, result.2.flatten(length: source.0, stride: source.1))
}
@inlinable @inline(__always)
func flatten(result: (Int, SIMD2<Int>, Array<SIMD2<Int>>), source: (Int, SIMD2<Int>)) -> (Int, SIMD2<Int>, Array<SIMD2<Int>>) {
	switch source.1 {
	case.zero:
		result
	case result.0 &* result.1:
		(result.0 &* source.0, result.1, result.2)
	default:
		(result.0, result.1, product(result.2, (0..<source.0).map{$0&*source.1}).map(&+))
	}
//	source.1 == result.0 &* result.1 ?
//	(result.0 * source.0, result.1, result.2) :
//	(result.0, result.1, result.2.flatten(length: source.0, stride: source.1))
}
@inlinable @inline(__always)
func flatten(result: (Int, SIMD3<Int>, Array<SIMD3<Int>>), source: (Int, SIMD3<Int>)) -> (Int, SIMD3<Int>, Array<SIMD3<Int>>) {
	switch source.1 {
	case.zero:
		result
	case result.0 &* result.1:
		(result.0 &* source.0, result.1, result.2)
	default:
		(result.0, result.1, product(result.2, (0..<source.0).map{$0&*source.1}).map(&+))
	}
//	source.1 == result.0 &* result.1 ?
//	(result.0 * source.0, result.1, result.2) :
//	(result.0, result.1, result.2.flatten(length: source.0, stride: source.1))
}
@inlinable @inline(__always)
func flatten(result: (Int, SIMD4<Int>, Array<SIMD4<Int>>), source: (Int, SIMD4<Int>)) -> (Int, SIMD4<Int>, Array<SIMD4<Int>>) {
	switch source.1 {
	case.zero:
		result
	case result.0 &* result.1:
		(result.0 &* source.0, result.1, result.2)
	default:
		(result.0, result.1, product(result.2, (0..<source.0).map{$0&*source.1}).map(&+))
	}
//	source.1 == result.0 &* result.1 ?
//	(result.0 * source.0, result.1, result.2) :
//	(result.0, result.1, result.2.flatten(length: source.0, stride: source.1))
}
@inlinable @inline(__always)
public func flatten(shape: some BidirectionalCollection<Int>,
					xs: some BidirectionalCollection<Int>) -> (Int, (Int), Array<(Int)>) {
	let layout = zip(shape.reversed(), xs.reversed())
		.filter { 0 < $1 }
		.sorted { $0.1 < $1.1 }
	let (length, stride) = layout.first ?? (1, (0))
	return layout.dropFirst().reduce((length, stride, [(0)]), flatten)
}
@inlinable @inline(__always)
public func flatten(shape: some BidirectionalCollection<Int>,
					xs: some BidirectionalCollection<Int>,
					ys: some BidirectionalCollection<Int>) -> (Int, SIMD2<Int>, Array<SIMD2<Int>>) {
	let layout = zip(shape.reversed(), zip(xs.reversed(), ys.reversed()))
		.filter { 0 < $1.y }
		.sorted { $0.1.y < $1.1.y }
	let (length, stride) = layout.first ?? (1, SIMD2<Int>())
	return layout.dropFirst().reduce((length, stride, [SIMD2<Int>()]), flatten)
}
@inlinable @inline(__always)
public func flatten(shape: some BidirectionalCollection<Int>,
					xs: some BidirectionalCollection<Int>,
					ys: some BidirectionalCollection<Int>,
					zs: some BidirectionalCollection<Int>) -> (Int, SIMD3<Int>, Array<SIMD3<Int>>) {
	let layout = zip(shape.reversed(), zip(xs.reversed(), ys.reversed(), zs.reversed()))
		.filter { 0 < $1.z }
		.sorted { $0.1.z < $1.1.z }
	let (length, stride) = layout.first ?? (1, SIMD3<Int>())
	return layout.dropFirst().reduce((length, stride, [SIMD3<Int>()]), flatten)
}
@inlinable @inline(__always)
public func flatten(shape: some BidirectionalCollection<Int>,
					xs: some BidirectionalCollection<Int>,
					ys: some BidirectionalCollection<Int>,
					zs: some BidirectionalCollection<Int>,
					ws: some BidirectionalCollection<Int>) -> (Int, SIMD4<Int>, Array<SIMD4<Int>>) {
	let layout = zip(shape.reversed(), zip(xs.reversed(), ys.reversed(), zs.reversed(), ws.reversed()))
		.filter { 0 < $1.w }
		.sorted { $0.1.w < $1.1.w }
	let (length, stride) = layout.first ?? (1, SIMD4<Int>())
	return layout.dropFirst().reduce((length, stride, [SIMD4<Int>()]), flatten)
}
