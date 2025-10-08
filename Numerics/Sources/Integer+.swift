//
//  Integer+.swift
//  MUSE
//
//  Created by Kota on 5/15/R7.
//
@_disfavoredOverload
@inlinable@inline(__always)@_transparent
public func mod<T: BinaryInteger>(_ x: T, _ y: T) -> T {
	y == 0 ? 0 : x % y
}
@_disfavoredOverload
@inlinable@inline(__always)@_transparent
public func div<T: BinaryInteger>(_ x: T, _ y: T) -> T {
	y == 0 ? 0 : x / y
}
@_disfavoredOverload
@inlinable@inline(__always)@_transparent
public func abs<T: BinaryInteger>(_ x: T) -> T { // obtain magnitude without any typecast
	x < 0 ? ~x + 1 : x
}
@_disfavoredOverload
@inlinable@inline(__always)
public func gcd<T: BinaryInteger>(_ x: T, _ y: T) -> T {
	y == 0 ? x : gcd(y, x % y)
}
@_disfavoredOverload
@inlinable@inline(__always)@_transparent
public func lcm<T: BinaryInteger>(_ x: T, _ y: T) -> T {
	switch gcd(x, y) {
	case 0: // i.e. lcm(0, 0)
		0
	case let z:
		( x / z ) * ( y / z ) * z // avoid overflow
	}
}
extension BinaryInteger {
    @inlinable@inline(__always)@_transparent
	public var squareRoot: Self {
		1 < self ? sequence(state: self / 2) { s in
			let t = ( s + self / s ) / 2
			defer {
				s = t
			}
			return (s, t)
		}.first(where: <=).unsafelyUnwrapped.0 : self
	}
    @inlinable@inline(__always)@_transparent
	public static var Prime: some Sequence<Self> {
		sequence(state: Array<Self>()) { state in
			let prime = sequence(first: (state.last ?? 1) + 1) {
				$0 + 1
			}.first { value in
				let limit = value.squareRoot + 1
				return state
					.prefix { $0 <= limit }
					.allSatisfy { value % $0 != 0 }
			}
			if let prime {
				state.append(prime)
			}
			return prime
		}
	}
    @inlinable@inline(__always)@_transparent
	public static var Fibonacci: some Sequence<Self> {
		sequence(first: ((0, 1) as (Self, Self))) {
			($1, $0 + $1)
		}.lazy.map(\.0)
	}
}
