//
//  Concat+.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
import Testing
@testable import Layout
@Suite
struct ContractionTests {
	@Test
	func vecLHS() {
		let ((n, k), ldb, ldc, layout, offset) = contraction(lhs: 4, rhs: ([4,5], [1,4]), strategy: .rowMajor)
		#expect(n == 5)
		#expect(k == 4)
		#expect(ldb == (1, 4))
		#expect(ldc == (5, 1))
		#expect(layout == [5, 1])
		#expect(offset == [.zero])
	}
	@Test
	func verRHS() {
		let ((m, k), ldb, ldc, layout, offset) = contraction(lhs: ([4,5], [1,4]), rhs: 5, strategy: .rowMajor)
		#expect(m == 4)
		#expect(k == 5)
		#expect(ldb == (1, 4))
		#expect(ldc == (5, 1))
		#expect(layout == [5, 1])
		#expect(offset == [.zero])
	}
	@Test
	func dot1() {
		let ((m, n, k), ldA, ldB, ldC, layout, offset) = contraction(lhs: ([2,10], [1, 2]),
																	 rhs: ([10,3], [3, 1]),
																	 order: 1,
																	 strategy: .columnMajor)
		#expect(m == 2)
		#expect(n == 3)
		#expect(k.0 == 10)
		#expect(k.1 == [.zero])
		#expect(ldA == (1, 2))
		#expect(ldB == (3, 1))
		#expect(ldC == (1, 2))
		#expect(layout == [1, 2])
		#expect(offset == [.zero])
	}
	@Test
	func dot2() {
		let ((m, n, k), ldA, ldB, ldC, layout, offset) = contraction(lhs: ([5,3,10], [1,50, 5]),
																	 rhs: ([10,3,7], [1,10,30]),
																	 order: 2,
																	 strategy: .columnMajor)
		#expect((m, n) == (5, 7))
		#expect(k.0 * k.1.count == 30)
		#expect(ldA == (1,  5))
		#expect(ldB == (1, 30))
		#expect(ldC == (1,  5))
		#expect(layout == [1, 5])
		#expect(offset == [.zero])
	}
	@Test
	func outer() {
		let ((m, n, k), ldA, ldB, ldC, layout, offset) = contraction(lhs: ([5], [1]),
																	 rhs: ([7], [1]),
																	 order: 0,
																	 strategy: .columnMajor)
		#expect(m == 5)
		#expect(n == 7)
		#expect(k.0 == 1)
		#expect(k.1 == [.zero])
		#expect(ldA == (1, 0))
		#expect(ldB == (0, 1))
		#expect(ldC == (1, 5))
		#expect(layout == [1, 5])
		#expect(offset == [.zero])
	}
}
