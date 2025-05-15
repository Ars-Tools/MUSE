//
//  Narrowcast.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
@inlinable @inline(__always)
public func narrowcast(point: Int, shape: Int) -> Int {
	point % shape
}
@inlinable @inline(__always)
public func narrowcast(point: some BidirectionalCollection<Int>, shape: some BidirectionalCollection<Int>) -> Array<Int> {
	zip(point, shape).map(%)
}
@inlinable @inline(__always)
public func narrowcast(bounds: some RangeExpression<Int>, target: Int, source: Int) -> Range<Int> {
	let r = (0..<target)[bounds]
	return max(0, 0 - min(0, 0 - r.lowerBound) % source)..<min(source, source - max(0, source - r.upperBound) % source)
}
@inlinable @inline(__always)
public func narrowcast(ranges: some BidirectionalCollection<some RangeExpression<Int>>, target: some BidirectionalCollection<Int>, source: some BidirectionalCollection<Int>) -> Array<Range<Int>> {
	zip(ranges.enumerated()
		.reduce(into: target.map { Range(uncheckedBounds: (0, $0)) }) {
			$0[$1.offset] = $0[$1.offset][$1.element]
		}
		.reversed(),
		target.reversed(),
		source.reversed()
	).map(narrowcast).reversed()
}
