//
//  Graph+MinCostFlow.swift
//  MUSE
//
//  Created by Kota on 9/16/R7.
//
import protocol Accelerate.AccelerateBuffer
import typealias Foundation.KeyPathComparator
import protocol Dense.MutMatrix
import typealias Dense.MatBuf
extension Graph {
	public static func SuccessiveShortestPath<K: Hashable, F: Numeric & Comparable, C: Numeric & Comparable>(source: K,
																											 target: K,
																											 demand d: F,
																											 weight g: Dictionary<K, Dictionary<K, (F, C)>>) -> Dictionary<K, Dictionary<K, F>> {
		var f = Dictionary<K, Dictionary<K, F>>()
		var p = Dictionary<K, C>()
		var q = d
		while .zero < q {
			let r = g.reduce(into: (f: Dictionary<K, Dictionary<K, F>>(), c: Dictionary<K, Dictionary<K, C>>())) {
				let (s, e) = $1
				for (t, (u, v)) in e {
					if f[s, default: .init()][t, default: .zero] < u {
						$0.0[s, default: .init()][t] = u - f[s, default: .init()][t, default: .zero]
						$0.1[s, default: .init()][t] = max(0, v + p[t, default: .zero] - p[s, default: .zero])
//						assert($0.1[s, default: .init()][t, default: .zero] >= .zero)
					}
					if 0 < f[s, default: .init()][t, default: .zero] {
						$0.0[t, default: .init()][s] = f[s, default: .init()][t, default: .zero]
						$0.1[t, default: .init()][s] = max(0, p[s, default: .zero] - p[t, default: .zero] - v)
//						assert($0.1[t, default: .init()][s, default: .zero] >= .zero)
					}
				}
			}
			let (score, route) = Graph.Djikstra(source: source, target: target, weight: r.c)
			for (key, val) in score where val != .zero {
				p[key, default: .zero] -= val
			}
			let limit = zip(route.dropLast(), route.dropFirst()).reduce(q) {
				min($0, r.f[$1.0, default: .init()][$1.1, default: .zero])
			}
			for (s, t) in zip(route.dropLast(), route.dropFirst()) {
				f[s, default: .init()][t, default: .zero] += min(limit, g[s, default: .init()][t, default: (.zero, .zero)].0 - f[s, default: .init()][t, default: .zero])
				f[t, default: .init()][s, default: .zero] -= min(limit, f[t, default: .init()][s, default: .zero])
			}
			q -= limit
		}
		return f.compactMapValues {
			switch Dictionary<K, F>(uniqueKeysWithValues: $0.lazy.filter { $1 != .zero }) {
			case let e where e.isEmpty:
				.none
			case let e:
				.some(e)
			}
		}
	}
}
extension Graph {
	public static func Match<Element: Numeric & Comparable>(table: MatBuf<Element>) -> Set<SIMD2<Int>> {
		precondition(table.rows == table.cols, "table should be square")
		let n = max(table.rows, table.cols)
		let s = 2 * n + 0
		let t = 2 * n + 1
		let e = (0..<n).reduce(into: [s: Dictionary<Int, (Int, Element)>(uniqueKeysWithValues: repeatElement(Element.zero, count: n).enumerated().lazy.map { ($0, (1, $1)) })]) {
			$0[$1] = .init(uniqueKeysWithValues: table[$1, 0...].enumerated().lazy.map { ($0 + n, (1, $1)) })
			$0[$1+n] = .init(dictionaryLiteral: (t, (1, .zero)))
		}
		let f = SuccessiveShortestPath(source: s,
									   target: t,
									   demand: n,
									   weight: e)
		return.init((0..<n).compactMap { k in
			f[k].flatMap { $0.sorted(using: KeyPathComparator(\.value)).first }.map { .init(k, $0.key - n) }
		})
	}
}
extension Graph {
	@inlinable@inline(__always)@_transparent
	public static func bruteforceAssignment<Element: Numeric & Comparable>(table: MatBuf<Element>) -> Set<SIMD2<Int>> {
		func permutation(head: Array<Int>, tail: Set<Int>) -> Array<Int> {
			tail.lazy.map {
				permutation(head: head + [$0], tail: tail.subtracting([$0]))
			}.min {
				$0.enumerated().reduce(Element.zero) {
					$0 + table[$1.0, $1.1]
				}
				<
				$1.enumerated().reduce(Element.zero) {
					$0 + table[$1.0, $1.1]
				}
			} ?? head
		}
		precondition(table.rows == table.cols, "table should be square")
		let n = max(table.rows, table.cols)
		return.init(permutation(head: .init(), tail: .init(0..<n)).enumerated().lazy.map(SIMD2<Int>.init(x:y:)))
	}

}
