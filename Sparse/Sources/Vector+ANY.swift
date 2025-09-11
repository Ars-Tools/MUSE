//
//  Vector+ANY.swift
//  MUSE
//
//  Created by Kota on 9/10/R7.
//
import protocol Accelerate.AccelerateBuffer
import protocol Dense.MutScalar
@usableFromInline
@frozen struct ANY<Element: SparseScalar<Element>> {
	@usableFromInline let core: any SparseVector<Element>
}
extension ANY: SparseVector {
	@usableFromInline typealias R = Array<Element>
	@usableFromInline typealias U = Element
	@usableFromInline
	var count: Int {
		core.count
	}
	@usableFromInline
	subscript(position: Int) -> Element {
		core[position]
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> ANY<Element> {
		.init(core: core[bounds])
	}
	@usableFromInline
	var coo: AnySequence<(Int, Element)> {
		.init(core.coo)
	}
}
