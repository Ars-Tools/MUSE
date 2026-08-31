//
//  Graph+MinCostPair.swift
//  MUSE
//
//  Created by Kota on 8/30/26.
//
import typealias Dense.MatBuf
extension Graph {
    /// 計算量: O(n² 2ⁿ)
    /// メモリ: O(2ⁿ)
    @inlinable
    public static func Pair<
        Element: Numeric & Comparable
    >(
        table: MatBuf<Element>
    ) -> Set<SIMD2<Int>> {
        precondition(
            table.rows == table.cols,
            "table should be square"
        )

        let n = table.rows

        guard n != 0 else {
            return []
        }

        precondition(
            n.isMultiple(of: 2),
            "number of vertices should be even"
        )

        precondition(
            n < UInt64.bitWidth,
            "too many vertices for UInt64 bit mask"
        )

        var memo = Dictionary<UInt64, Element>()
        var choice = Dictionary<UInt64, Int>()

        @inline(__always)
        func bit(_ index: Int) -> UInt64 {
            1 << index
        }

        func solve(_ mask: UInt64) -> Element {
            guard mask != 0 else {
                return .zero
            }

            if let cached = memo[mask] {
                return cached
            }

            // 残っている最小番号の頂点を固定する。
            let row = mask.trailingZeroBitCount
            let remaining = mask & ~bit(row)

            var candidates = remaining
            var bestCost: Element?
            var bestColumn: Int?

            while candidates != 0 {
                let col = candidates.trailingZeroBitCount
                let next = remaining & ~bit(col)

                let cost =
                    table[row, col]
                    + solve(next)

                if bestCost.map({ cost < $0 }) ?? true {
                    bestCost = cost
                    bestColumn = col
                }

                // 最下位の1ビットを除去
                candidates &= candidates - 1
            }

            guard
                let bestCost,
                let bestColumn
            else {
                preconditionFailure(
                    "perfect pairing was not found"
                )
            }

            memo[mask] = bestCost
            choice[mask] = bestColumn

            return bestCost
        }

        let fullMask =
            (UInt64(1) << n) - 1

        _ = solve(fullMask)

        var result = Set<SIMD2<Int>>()
        result.reserveCapacity(n / 2)

        var mask = fullMask

        while mask != 0 {
            let row = mask.trailingZeroBitCount

            guard let col = choice[mask] else {
                preconditionFailure(
                    "failed to reconstruct pairing"
                )
            }

            result.insert(.init(row, col))

            mask &= ~bit(row)
            mask &= ~bit(col)
        }

        return result
    }
}
extension Graph {
    /// 一般グラフの最小重み完全マッチングを総当たりで求める。
    ///
    /// 検証専用。計算量は(n - 1)!!。
    @inlinable
    public static func bruteforcePairing<
        Element: Numeric & Comparable
    >(
        table: MatBuf<Element>
    ) -> Set<SIMD2<Int>> {
        precondition(
            table.rows == table.cols,
            "table should be square"
        )

        precondition(
            table.rows.isMultiple(of: 2),
            "number of vertices should be even"
        )

        func solve(
            _ indices: Array<Int>
        ) -> (
            cost: Element,
            pairs: Array<SIMD2<Int>>
        ) {
            guard let row = indices.first else {
                return (.zero, [])
            }

            var candidates = Array(indices.dropFirst())

            var bestCost: Element?
            var bestPairs = Array<SIMD2<Int>>()

            for offset in candidates.indices {
                let col = candidates.remove(at: offset)

                let tail = solve(candidates)
                let cost =
                    table[row, col]
                    + tail.cost

                if bestCost.map({ cost < $0 }) ?? true {
                    bestCost = cost
                    bestPairs = [
                        SIMD2(row, col)
                    ] + tail.pairs
                }

                candidates.insert(col, at: offset)
            }

            guard let bestCost else {
                preconditionFailure(
                    "perfect pairing was not found"
                )
            }

            return (
                bestCost,
                bestPairs
            )
        }

        return Set(
            solve(Array(0..<table.rows)).pairs
        )
    }
}
