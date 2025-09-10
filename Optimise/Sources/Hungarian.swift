//
//  Hungarian.swift
//  MUSE
//
//  Created by Kota on 9/2/R7.
//
// solve optima pair by using Hungarian method, cost is row-major-matrix





@inlinable@inline(__always)
func hungarian<C: Numeric & Comparable>(m: Int, n: Int, cost table: Array<C>) -> Set<SIMD2<Int>> {
	assert(m == n)
	assert(m < .max)
	assert(n < .max)
	var table = table
	for r in stride(from: 0, to: m * n, by: n) {
		let col = r..<r+n
		let min = table[col].min() ?? .zero
		for c in col {
			table[c] -= min
		}
	}
	for c in 0..<n {
		let row = stride(from: c, to: c + m * n, by: n)
		let min = row.lazy.map { table[$0] }.min() ?? .zero
		for r in row {
			table[r] -= min
		}
	}
	while true {
		let na = Int.min
		var uv = Array<Int>(repeating: na, count: m)
		var vu = Array<Int>(repeating: na, count: n)
		do {
			var queue = ArraySlice<Int>(0..<m)
			while let r = queue.popLast() {
				uv[r] = na
				for c in 0..<n where table[r*n+c] == .zero {
					if vu[c] == na {
						uv[r] = c
						vu[c] = r
						break
					} else {
						queue.append(vu[c])
						uv[vu[c]] = na
					}
					
				}
			}
		}
		
		var queue = ArraySlice<Int>(uv.enumerated().filter { $1 != na }.map(\.0))
		// Arg Path
		var cover = (
			row: Set<Int>(0..<m),
			col: Set<Int>()
		)
		while let r = queue.popFirst() {
			cover.row.remove(r)
			for c in 0..<n where table[r*n+c] <= .zero && !cover.col.contains(c) {
				cover.col.insert(c)
				if vu[c] == na {
					uv[r] = c
					vu[c] = r
				} else {
					queue.append(vu[c])
					uv[vu[c]] = na
					uv[r] = c
					vu[c] = r
				}
			}
		}
		let extra = (
			row: Set(0..<m).subtracting(cover.row),
			col: Set(0..<n).subtracting(cover.col)
		)
		// Cost Table
		var min = Optional<C>.none
		for r in extra.row {
			for c in extra.col {
				min = Swift.min(min ?? table[r*n+c], table[r*n+c])
			}
		}
		guard let min else {
			assert(!uv.contains(na))
			return Set(uv.enumerated().map(SIMD2.init(x:y:)))
		}
		for r in extra.row {
			for c in extra.col {
				table[r*n+c] -= min
			}
		}
		for r in cover.row {
			for c in cover.col {
				table[r*n+c] += min
			}
		}
	}
}
@inlinable
public func hungarian<C: Numeric & Comparable>(size: Int, cost table: Array<C>) -> Set<SIMD2<Int>> {
	hungarian(m: size, n: size, cost: table)
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
	}).map {.init(u[$0.x], v[$0.y])})
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
	}).map {.init(u[$0.x], v[$0.y])})
}
// solve optima pair by brute-force, cost is row-major-matrix, to validate other algorithms
@inlinable
func bruteforceAssignment<C: Numeric & Comparable>(size: Int, cost table: Array<C>) -> Set<SIMD2<Int>> {
	func permutation(head: Array<Int>, tail: Set<Int>) -> Array<Int> {
		tail.lazy.map {
			permutation(head: head + [$0], tail: tail.subtracting([$0]))
		}.min {
//			assert($0.count == size)
//			assert($1.count == size)
			$0.enumerated().reduce(C.zero) {
				$0 + table[$1.0 * size + $1.1]
			}
			<
			$1.enumerated().reduce(C.zero) {
				$0 + table[$1.0 * size + $1.1]
			}
		} ?? head
	}
	return.init(permutation(head: .init(), tail: .init(0..<size)).enumerated().lazy.map(SIMD2<Int>.init(x:y:)))
}
