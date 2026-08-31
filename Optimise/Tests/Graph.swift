//
//  Graph.swift
//  MUSE
//
//  Created by Kota on 9/16/R7.
//
import Testing
import typealias Dense.MatBuf
@testable import Optimise
@Suite
struct GraphTestCases {
	@Test
	func priorityQueue() {
		var queue = Graph.PriorityQueue<Int, String>()
		queue.insert(element: "A", as: 1)
		#expect(queue.popMin().map(\.1) == "A")
		queue.insert(element: "E", as: 5)
		queue.insert(element: "D", as: 4)
		queue.insert(element: "B", as: 2)
		#expect(queue.popMin().map(\.1) == "B")
		queue.insert(element: "C", as: 3)
		#expect(queue.popMin().map(\.1) == "C")
		#expect(queue.popMin().map(\.1) == "D")
		queue.insert(element: "F", as: 6)
		#expect(queue.popMin().map(\.1) == "E")
		#expect(queue.popMin().map(\.1) == "F")
	}
	@Test
	func djikstraST() {
		let graph = [
			0: [(1, 91), (2, 3), (3, 98), (4, 46), (8, 96), (11, 76)],
			1: [(0, 42), (3, 69), (4, 27), (6, 16), (7, 55), (8, 20), (9, 69), (10, 41)],
			2: [(1, 22), (3, 41), (5, 93), (6, 64), (7, 44), (8, 94), (10, 28), (11, 65)],
			3: [(4, 2), (5, 21), (6, 98), (7, 88)],
			4: [(2, 17), (3, 38), (8, 74), (10, 86)],
			5: [(1, 60), (2, 6), (4, 48), (6, 35), (10, 73), (11, 76)],
			6: [(1, 16), (2, 80), (3, 65), (5, 93)],
			7: [(3, 53), (4, 24), (9, 90), (10, 69), (11, 24)],
			8: [(1, 75), (5, 24), (10, 17)],
			9: [(0, 55), (5, 4), (11, 4)],
			10: [(4, 8), (6, 11)],
			11: [(4, 34), (8, 7)]
		]
		#expect(Graph.Djikstra(source: 4, target: 9, weight: graph.mapValues(Dictionary.init(uniqueKeysWithValues:))).1 == [4, 2, 1, 9])
		#expect(Graph.Djikstra(source: 4, target: 9, weight: graph.mapValues(Dictionary.init(uniqueKeysWithValues:))).map(\.0) == [4, 2, 1, 9])
	}
	@Test(arguments: 4..<9)
	func minCostMatch(n: Int) {
		let rows = repeatElement(n, count: n).map {
			repeatElement(1 ... 4096, count: $0).lazy.map(Int.random(in:))
		}
		let m = MatBuf(rows: rows)
		let p = Graph.Match(table: m)
		#expect(p == Graph.bruteforceAssignment(table: m))
	}
	@Test
	func minCostFlow() {
		let e = Graph.SuccessiveShortestPath(source: "s", target: "t", demand: 4, weight: [
//			1: [2: (30, 3), 3: (60, 9)],
//			2: [3: (40, 5), 4: (50, 7)],
//			3: [4: (20, 8), 5: (50, 6)],
//			4: [5: (60, 7)]
			"s": ["a": (2, 2), "c": (7, 4)],
			"a": ["b": (4, 6), "c": (2, 1)],
			"b": ["t": (7, 2)],
			"c": ["b": (1, 6), "d": (6, 2)],
			"d": ["b": (3, 2), "t": (2, 7)]
		])
		#expect(e["s", default: .init()].reduce(0) { $0 + $1.value } == 4)
		#expect(e.reduce(0) { $0 + $1.value.filter { $0.key == "t" }.reduce(0) { $0 + $1.1 } } == 4)
	}
    @Test(arguments: [2, 4, 6, 8, 10, 12])
    func minimumWeightPairing(n: Int) {
        for _ in 0..<16 {
            var rows = Array(
                repeating: Array(
                    repeating: 0,
                    count: n
                ),
                count: n
            )

            // 一般無向グラフなので対称コスト行列を作る。
            for row in 0..<n {
                for col in (row + 1)..<n {
                    let cost = Int.random(
                        in: 1...4096
                    )

                    rows[row][col] = cost
                    rows[col][row] = cost
                }
            }

            let table = MatBuf(rows: rows)

            let result = Graph.Pair(
                table: table
            )

            let expected =
                Graph.bruteforcePairing(
                    table: table
                )

            func totalCost(
                _ pairs: Set<SIMD2<Int>>
            ) -> Int {
                pairs.reduce(0) {
                    $0 + table[$1.x, $1.y]
                }
            }

            // 同率解を考慮して総コストを比較
            #expect(
                totalCost(result)
                ==
                totalCost(expected)
            )

            // n個の頂点からn/2組
            #expect(result.count == n / 2)

            // すべての頂点がちょうど1回現れる
            let vertices = result.flatMap {
                [$0.x, $0.y]
            }

            #expect(vertices.count == n)
            #expect(Set(vertices).count == n)
            #expect(Set(vertices) == Set(0..<n))

            // Pairは上三角形式で返す
            #expect(
                result.allSatisfy {
                    $0.x < $0.y
                }
            )
        }
    }
}
