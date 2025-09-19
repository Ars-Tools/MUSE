//
//  DOT+M.swift
//  MUSE
//
//  Created by Kota on 9/18/R7.
//
import Layout
extension DOT {
	@usableFromInline
	struct DD<LHS: Matrix<Element>, RHS: Matrix<Element>> {
		@usableFromInline typealias R = Array<Element>
		@usableFromInline typealias S = DD<LHS.S, RHS.S>
		@usableFromInline typealias U = Inner<LHS.V, RHS.V>
		@usableFromInline let lhs: LHS
		@usableFromInline let rhs: RHS
	}
	@usableFromInline
	struct MM<LHS: Matrix<Element>, RHS: Matrix<Element>> {
		@usableFromInline typealias R = Array<Element>
		@usableFromInline typealias S = MM<LHS.S, RHS.S>
		@usableFromInline typealias T = MM<RHS.T, LHS.T>
		@usableFromInline typealias U = Inner<LHS.V, RHS.V>
		@usableFromInline typealias V = ANY<Element>.Vector
		@usableFromInline let lhs: LHS
		@usableFromInline let rhs: RHS
	}
}
extension DOT.DD: Vector {
	@inlinable
	var count: Int {
		min(lhs.rows, rhs.cols)
	}
	@usableFromInline
	subscript(position: Int) -> U {
		.init(lhs: lhs[position, 0...], rhs: rhs[position, 0...])
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[bounds, 0...], rhs: rhs[0..., bounds])
	}
	@inlinable
	func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
		let (xi, xk) = try lhs(for: strategy)
		let (yi, yk) = try lhs(for: strategy)
		precondition((xi.count, yi.count) == (2, 2))
		let xs = (xi.first ?? 1, xi.last ?? 1)
		let ys = (yi.first ?? 1, yi.last ?? 1)
		let zs = [1]
		let m = min(lhs.rows, rhs.cols)
		let n = broadcast(x: lhs.cols, y: rhs.rows)
		return (zs, { 
			await withUnsafePointer(xk(), yk()) { x, y in
				(0..<m).map {
					Element.Inner(n: n,
								  x: x.advanced(by: $0 * xs.0), ldx: xs.1,
								  y: y.advanced(by: $0 * ys.1), ldy: ys.0)
				}
			}
		})
	}
}
extension DOT.MM: Matrix {
	@inlinable
	var rows: Int {
		lhs.rows
	}
	@inlinable
	var cols: Int {
		rhs.cols
	}
	@usableFromInline
	var transpose: T {
		.init(lhs: rhs.transpose, rhs: lhs.transpose)
	}
	@usableFromInline
	var diagonal: V {
		.init(core: DOT.DD(lhs: lhs, rhs: rhs))
	}
	@usableFromInline
	subscript(row: Int, col: Int) -> U {
		.init(lhs: lhs[row, 0...], rhs: rhs[0..., col])
	}
	@usableFromInline
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(core: lhs[row, 0...] • rhs[0..., col])
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(core: lhs[row, 0...] • rhs[0..., col])
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[row, 0...], rhs: rhs[0..., col])
	}
	@inlinable
	func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
		let (xs, xk) = try lhs(for: strategy)
		let (ys, yk) = try rhs(for: strategy)
		let m = lhs.rows
		let n = rhs.cols
		let k = broadcast(x: lhs.cols, y: rhs.rows)
		let zs = strategy.stride(for: [m, n])
		let capacity = capacity(alloc: [m, n], stride: zs)
		precondition((xs.count, ys.count, zs.count) == (2, 2, 2))
		switch (matricise(size: xs), matricise(size: ys), matricise(size: zs)) {
		case (.some((1, let lda)), .some((1, let ldb)), .some((1, let ldc))):
			return (zs, {
				await withUnsafePointer(xk(), yk()) { x, y in
					.init(unsafeUninitializedCapacity: capacity) {
						let z = $0.baseAddress.unsafelyUnwrapped
						Element.GEMM(m: m, n: n, k: k,
									 α: 1,
									 a: x, lda: lda, opa: "N",
									 b: y, ldb: ldb, opb: "N",
									 β: 0,
									 c: z, ldc: ldc)
						$1 = $0.count
					}
				}
			})
		case (.some((let lda, 1)), .some((1, let ldb)), .some((1, let ldc))):
			return (zs, {
				await withUnsafePointer(xk(), yk()) { x, y in
					.init(unsafeUninitializedCapacity: capacity) {
						let z = $0.baseAddress.unsafelyUnwrapped
						Element.GEMM(m: m, n: n, k: k,
									 α: 1,
									 a: x, lda: lda, opa: "T",
									 b: y, ldb: ldb, opb: "N",
									 β: 0,
									 c: z, ldc: ldc)
						$1 = $0.count
					}
				}
			})
		case (.some((1, let lda)), .some((let ldb, 1)), .some((1, let ldc))):
			return (zs, {
				await withUnsafePointer(xk(), yk()) { x, y in
					.init(unsafeUninitializedCapacity: capacity) {
						let z = $0.baseAddress.unsafelyUnwrapped
						Element.GEMM(m: m, n: n, k: k,
									 α: 1,
									 a: x, lda: lda, opa: "N",
									 b: y, ldb: ldb, opb: "T",
									 β: 0,
									 c: z, ldc: ldc)
						$1 = $0.count
					}
				}
			})
		case (.some((let lda, 1)), .some((let ldb, 1)), .some((1, let ldc))):
			return (zs, {
				await withUnsafePointer(xk(), yk()) { x, y in
					.init(unsafeUninitializedCapacity: capacity) {
						let z = $0.baseAddress.unsafelyUnwrapped
						Element.GEMM(m: m, n: n, k: k,
									 α: 1,
									 a: x, lda: lda, opa: "T",
									 b: y, ldb: ldb, opb: "T",
									 β: 0,
									 c: z, ldc: ldc)
						$1 = $0.count
					}
				}
			})
		case (.some((1, let lda)), .some((1, let ldb)), .some((let ldc, 1))):
			return (zs, {
				await withUnsafePointer(xk(), yk()) { x, y in
					.init(unsafeUninitializedCapacity: capacity) {
						let z = $0.baseAddress.unsafelyUnwrapped
						Element.GEMM(m: n, n: m, k: k,
									 α: 1,
									 a: y, lda: ldb, opa: "T",
									 b: x, ldb: lda, opb: "T",
									 β: 0,
									 c: z, ldc: ldc)
						$1 = $0.count
					}
				}
			})
		case (.some((let lda, 1)), .some((1, let ldb)), .some((let ldc, 1))):
			return (zs, {
				await withUnsafePointer(xk(), yk()) { x, y in
					.init(unsafeUninitializedCapacity: capacity) {
						let z = $0.baseAddress.unsafelyUnwrapped
						Element.GEMM(m: n, n: m, k: k,
									 α: 1,
									 a: y, lda: ldb, opa: "T",
									 b: x, ldb: lda, opb: "N",
									 β: 0,
									 c: z, ldc: ldc)
						$1 = $0.count
					}
				}
			})
		case (.some((1, let lda)), .some((let ldb, 1)), .some((let ldc, 1))):
			return (zs, {
				await withUnsafePointer(xk(), yk()) { x, y in
					.init(unsafeUninitializedCapacity: capacity) {
						let z = $0.baseAddress.unsafelyUnwrapped
						Element.GEMM(m: n, n: m, k: k,
									 α: 1,
									 a: y, lda: ldb, opa: "N",
									 b: x, ldb: lda, opb: "T",
									 β: 0,
									 c: z, ldc: ldc)
						$1 = $0.count
					}
				}
			})
		case (.some((let lda, 1)), .some((let ldb, 1)), .some((let ldc, 1))):
			return (zs, {
				await withUnsafePointer(xk(), yk()) { x, y in
					.init(unsafeUninitializedCapacity: capacity) {
						let z = $0.baseAddress.unsafelyUnwrapped
						Element.GEMM(m: n, n: m, k: k,
									 α: 1,
									 a: y, lda: ldb, opa: "N",
									 b: x, ldb: lda, opb: "N",
									 β: 0,
									 c: z, ldc: ldc)
						$1 = $0.count
					}
				}
			})
		default:
			throw Error.invalidShape(self)
		}
	}
}
public func •<Element: BLASElement & ArithmeticElement>(_ lhs: some Matrix<Element>, _ rhs: some Matrix<Element>) -> some Matrix<Element> {
	DOT.MM(lhs: lhs, rhs: rhs)
}
