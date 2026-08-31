//
//  Graph+MaxBottleneck.swift
//  MUSE
//
//  Created by Kota on 8/31/26.
//
import typealias Dense.MatBuf
extension Graph {
    /// Finds a perfect pairing that maximises its minimum edge weight.
    ///
    /// `table` represents an undirected complete graph and is expected to be
    /// symmetric. Its diagonal is ignored. Larger weights are better.
    ///
    /// computation: O(n² 2ⁿ)
    /// workspace: O(2ⁿ)
    @inlinable
    public static func maximumBottleneckPairing<
        Element: Comparable
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
            if let cached = memo[mask] {
                return cached
            }

            // Fix the lowest numbered remaining vertex.
            let row = mask.trailingZeroBitCount
            let remaining = mask & ~bit(row)

            var candidates = remaining
            var bestWeight: Element?
            var bestColumn: Int?

            while candidates != 0 {
                let col = candidates.trailingZeroBitCount
                let next = remaining & ~bit(col)
                let edge = table[row, col]

                // The bottleneck of a pairing is its minimum edge weight.
                // Handling the final edge directly avoids requiring an
                // artificial +infinity identity from Element.
                let weight = next == 0
                    ? edge
                    : min(edge, solve(next))

                if bestWeight.map({ $0 < weight }) ?? true {
                    bestWeight = weight
                    bestColumn = col
                }

                candidates &= candidates - 1
            }

            guard
                let bestWeight,
                let bestColumn
            else {
                preconditionFailure(
                    "perfect pairing was not found"
                )
            }

            memo[mask] = bestWeight
            choice[mask] = bestColumn

            return bestWeight
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
