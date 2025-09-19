//
//  Logical.swift
//  MUSE
//
//  Created by Kota on 9/12/R7.
//
import protocol Accelerate.AccelerateBuffer
import protocol Dense.Matrix
import func Layout.product
@usableFromInline
@frozen enum Logical {
	@usableFromInline typealias Element = Bool
}
extension Logical {
	@usableFromInline
	@frozen struct ANY {
		@usableFromInline let core: any SparseVector<Element>
	}
}
extension Logical.ANY: SparseVector {
	@usableFromInline typealias Element = Bool
	@usableFromInline typealias S = Self
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
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(core: core[bounds])
	}
	@usableFromInline
	var state: Set<Int> {
		core.state
	}
}
