//
//  Hungarian.swift
//  MUSE
//
//  Created by Kota on 9/2/R7.
//
// solve optima pair by using Hungarian method, cost is row-major-matrix
@inlinable@inline(__always)
func hungarian<C: Numeric & Comparable>(m: Int, n: Int, cost table: Array<C>, initial: C) -> Set<SIMD2<Int>> {
	assert(m == n)
	assert(m < .max)
	assert(n < .max)
	var table = table
	for c in 0..<n {
		let row = stride(from: c, to: c + m * n, by: n)
		let min = row.lazy.map { table[$0] }.min() ?? .zero
		for r in row {
			table[r] -= min
		}
	}
	for r in stride(from: 0, to: m * n, by: n) {
		let col = r..<r+n
		let min = table[col].min() ?? .zero
		for c in col {
			table[c] -= min
		}
	}
	while true {
		// Path
		var uv = Array<Int>(repeating: .max, count: m)
		var vu = Array<Int>(repeating: .max, count: n)
		for r in 0..<m {
			for c in 0..<n where table[r*n+c] == 0 && uv[r] == .max && vu[c] == .max {
				uv[r] = c
				vu[c] = r
			}
		}
		if n == Set(vu).count {
			return Set(uv.enumerated().map(SIMD2.init(x:y:)))
		} else {
			// Zero-Cover
			var queue = (
				row: ArraySlice(uv.enumerated().lazy.filter { $1 == .max }.map(\.offset)),
				col: ArraySlice(vu.enumerated().lazy.filter { $1 == .max }.map(\.offset))
			)
			var star = (
				row: Set<Int>(),
				col: Set<Int>()
			)
			while ![queue.row, queue.col].allSatisfy(\.isEmpty) {
				if let r = queue.row.popFirst(), !star.row.contains(r) {
					star.row.insert(r)
					for c in 0..<n where table[r*n+c] == .zero {
						queue.col.append(c)
					}
				}
				if let c = queue.col.popFirst(), !star.col.contains(c) {
					star.col.insert(c)
					for r in 0..<m where table[r*n+c] == .zero {
						queue.row.append(r)
					}
				}
			}
			// Modify
			var min = initial
			for r in 0..<m where !star.row.contains(r) {
				for c in 0..<n where !star.col.contains(c) {
					min = Swift.min(min, table[r*n+c])
				}
			}
			for r in 0..<m where !star.row.contains(r) {
				for c in 0..<n where !star.col.contains(c) {
					table[r*n+c] -= min
				}
			}
			for r in star.row {
				for c in star.col {
					table[r*n+c] += min
				}
			}
		}
	}
}
@inlinable
public func hungarian<T: FixedWidthInteger>(size: Int, cost table: Array<T>) -> Set<SIMD2<Int>> {
	hungarian(m: size, n: size, cost: table, initial: .max)
}
@inlinable
public func hungarian<T: FloatingPoint>(size: Int, cost table: Array<T>) -> Set<SIMD2<Int>> {
	hungarian(m: size, n: size, cost: table, initial: .infinity)
}
@inlinable
public func hungarian<U: Collection<S>, V: Collection<S>, S: SIMDScalar, T: FixedWidthInteger>(u: U, v: V, cost: Dictionary<SIMD2<S>, T>) -> Set<SIMD2<S>> where U.Index == Int, V.Index == Int {
	.init(hungarian(m: u.count, n: v.count, cost: Array<T>(unsafeUninitializedCapacity: u.count * v.count) {
		let w = v.count
		for (j, u) in u.enumerated() {
			for (k, v) in v.enumerated() {
				$0[j*w+k] = cost[.init(u, v)] ?? .max
			}
		}
		$1 = $0.count
	}, initial: .max).map {.init(u[$0.x], v[$0.y])})
}
@inlinable
public func hungarian<U: Collection<S>, V: Collection<S>, S: SIMDScalar, T: FloatingPoint>(u: U, v: V, cost: Dictionary<SIMD2<S>, T>) -> Set<SIMD2<S>> where U.Index == Int, V.Index == Int {
	.init(hungarian(m: u.count, n: v.count, cost: Array<T>(unsafeUninitializedCapacity: u.count * v.count) {
		let w = v.count
		for (j, u) in u.enumerated() {
			for (k, v) in v.enumerated() {
				$0[j*w+k] = cost[.init(u, v)] ?? .infinity
			}
		}
		$1 = $0.count
	}, initial: .infinity).map {.init(u[$0.x], v[$0.y])})
}
