//
//  LINALG+LU.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import typealias Dense.LAPACK
extension LAPACK.LU where Element: SparseScalar<Element> {
    public typealias P = CCS<Element>
    public var p: P {
        .init(rows: ipivot.count,
              cols: ipivot.count,
              colStart: .init(0...ipivot.count),
              rowIndex: ipivot.enumerated().reduce(into: Array(0..<Int32(ipivot.count))) { $0.swapAt($1.0, $1.1-1) },
              valArray: .init(repeating: 1, count: ipivot.count))
    }
}
