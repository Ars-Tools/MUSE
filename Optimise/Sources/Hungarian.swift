//
//  Hungarian.swift
//  MUSE
//
//  Created by Kota on 9/2/R7.
//
// solve optima pair by using Hungarian method, cost is row-major-matrix
@inlinable@inline(__always)
func hungarian<V: SIMDScalar & Hashable, C: Numeric & Comparable>(u: some Collection<V>, v: some Collection<V>, cost: Dictionary<SIMD2<V>, C>, initial: C) -> Set<SIMD2<V>> {
	let U = Array(u)
	let V = Array(v)
	let m = U.count
	let n = V.count
	assert(m == n)
	assert(m < .max)
	assert(n < .max)
	var table = Array<C>(unsafeUninitializedCapacity: m * n) {
		for (j, u) in U.enumerated() {
			for (k, v) in V.enumerated() {
				$0[j*n+k] = cost[.init(u, v)] ?? initial
			}
		}
		$1 = $0.count
	}
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
		if m == Set(uv).count, n == Set(vu).count {
			return.init(uv.enumerated().lazy.map {.init(U[$0], V[$1])})
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
					table[r*n+c] += 2 * min
				}
			}
		}
	}
}
public func hungarian<V: SIMDScalar, C: FixedWidthInteger>(u: some Collection<V>, v: some Collection<V>, cost: Dictionary<SIMD2<V>, C>) -> Set<SIMD2<V>> {
	hungarian(u: u, v: v, cost: cost, initial: .max)
}
public func hungarian<V: SIMDScalar, C: FloatingPoint>(u: some Collection<V>, v: some Collection<V>, cost: Dictionary<SIMD2<V>, C>) -> Set<SIMD2<V>> {
	hungarian(u: u, v: v, cost: cost, initial: .infinity)
}
