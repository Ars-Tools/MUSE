//
//  Storage+ROV.swift
//  MUSE
//
//  Created by Kota on 9/9/R7.
//
import protocol Accelerate.AccelerateBuffer
import protocol Dense.Scalar
import protocol Dense.MutScalar
extension LazyMapSequence: @retroactive @unchecked Sendable {}
@usableFromInline
@frozen struct SOV<Element: SparseScalar<Element>, COO: Sequence<(Int, Element)> & Sendable> {
	@usableFromInline let count: Int
	@usableFromInline let coo: COO
}
extension SOV: SparseVector {
	@usableFromInline typealias U = Element
	@usableFromInline typealias R = Array<Element>
	@inlinable
	subscript(position: Int) -> Element {
		coo.first {
			$0 == position && $1 != .zero
		}.map(\.1) ?? .zero
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> SOV<Element, LazyMapSequence<LazyFilterSequence<LazyMapSequence<COO, Optional<(Int, Element)>>>, (Int, Element)>> {
		let bounds = bounds.relative(to: 0..<count)
		return.init(count: bounds.count, coo: coo.lazy.compactMap {
			switch ($0, $1) {
			case (bounds, let v) where v != .zero:
				.some(($0 - bounds.lowerBound, $1))
			default:
				.none
			}
		})
	}
}
