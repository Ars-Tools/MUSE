//
//  DOT+V.swift
//  MUSE
//
//  Created by Kota on 9/18/R7.
//
import protocol Accelerate.AccelerateBuffer
import Layout
extension DOT {
	@usableFromInline
	struct Inner<LHS: Vector<Element>, RHS: Vector<Element>> {
		@usableFromInline let lhs: LHS
		@usableFromInline let rhs: RHS
	}
	@usableFromInline
	struct Outer<LHS: Vector<Element>, RHS: Vector<Element>> {
		@usableFromInline typealias R = Array<Element>
		@usableFromInline typealias S = Outer<LHS.S, RHS.S>
		@usableFromInline typealias T = Outer<RHS.T, LHS.T>
		@usableFromInline typealias U = Arithmetic<Element>.Mul<LHS.U, RHS.U>
		@usableFromInline typealias V = ANY<Element>.Vector
		@usableFromInline let lhs: LHS
		@usableFromInline let rhs: RHS
	}
	@usableFromInline
	struct MV<LHS: Matrix<Element>, RHS: Vector<Element>> {
		@usableFromInline typealias R = Array<Element>
		@usableFromInline typealias S = MV<LHS.S, RHS>
		@usableFromInline typealias U = Inner<LHS.V, RHS>
		@usableFromInline let lhs: LHS
		@usableFromInline let rhs: RHS
	}
	@usableFromInline
	struct VM<LHS: Vector<Element>, RHS: Matrix<Element>> {
		@usableFromInline typealias R = Array<Element>
		@usableFromInline typealias S = VM<LHS, RHS.S>
		@usableFromInline typealias U = Inner<LHS, RHS.V>
		@usableFromInline let lhs: LHS
		@usableFromInline let rhs: RHS
	}
}
extension DOT.Inner: Scalar {
	@inlinable
	func callAsFunction(for strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> CollectionOfOne<Element>) {
		let (xi, xk) = try lhs(for: strategy)
		let (yi, yk) = try rhs(for: strategy)
		let count = broadcast(x: lhs.count, y: rhs.count)
		let xs = xi.reduce(1, *)
		let ys = yi.reduce(1, *)
		return ([1], {
			await withUnsafePointer(xk(), yk()) {
				.init(Element.Inner(n: count, x: $0, ldx: xs, y: $1, ldy: ys))
			}
		})
	}
}
extension DOT.Outer: Matrix {
	@inlinable
	var rows: Int {
		lhs.count
	}
	@inlinable
	var cols: Int {
		rhs.count
	}
	@usableFromInline
	var transpose: T {
		.init(lhs: rhs.transpose, rhs: lhs.transpose)
	}
	@usableFromInline
	var diagonal: V {
		.init(core: lhs[..<min(rows, cols)] * rhs[..<min(rows, cols)])
	}
	@usableFromInline
	subscript(row: Int, col: Int) -> U {
		.init(lhs: lhs[row], rhs: rhs[col])
	}
	@usableFromInline
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
		.init(core: lhs[row] * rhs[col])
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
		.init(core: rhs[col] * lhs[row])
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[row], rhs: rhs[col])
	}
	@inlinable
	func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
		let (xi, xk) = try lhs(for: strategy)
		let (yi, yk) = try rhs(for: strategy)
		let xs = xi.reduce(1, *)
		let ys = yi.reduce(1, *)
		switch strategy {
		case.rowMajor:
			let zs = [cols, 1]
			let capacity = capacity(alloc: [rows, cols], stride: zs)
			return (zs, { [rows, cols] in
				await withUnsafePointer(xk(), yk()) { x, y in
					.init(unsafeUninitializedCapacity: capacity) {
						Element.Outer(m: rows, n: cols,
									  α: 1,
									  x: y, ldx: ys,
									  y: x, ldy: xs,
									  β: 0,
									  a: $0.baseAddress.unsafelyUnwrapped,
									  lda: cols)
						$1 = $0.count
					}
				}
			})
		case.columnMajor:
			let zs = [1, rows]
			let capacity = capacity(alloc: [rows, cols], stride: zs)
			return (zs, { [rows, cols] in
				await withUnsafePointer(xk(), yk()) { x, y in
					.init(unsafeUninitializedCapacity: capacity) {
						Element.Outer(m: rows, n: cols,
									  α: 1,
									  x: x, ldx: xs,
									  y: y, ldy: ys,
									  β: 0,
									  a: $0.baseAddress.unsafelyUnwrapped,
									  lda: rows)
						$1 = $0.count
					}
				}
			})
		}
	}
}
extension DOT.MV: Vector {
	@inlinable
	var count: Int {
		lhs.rows
	}
	@usableFromInline
	subscript(position: Int) -> U {
		.init(lhs: lhs[position, 0...], rhs: rhs)
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(lhs: lhs[bounds, 0...], rhs: rhs)
	}
	@inlinable
	func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
		let (xs, xk) = try lhs(for: strategy)
		let (ys, yk) = try rhs(for: strategy)
		precondition((xs.count, ys.count) == (2, 1))
		let inc = ys.reduce(1, *)
		let m = lhs.rows
		let n = lhs.cols
		switch (xs.first, xs.last) {
		case ((.some(1), .some(let lda))):
			return ([1], {
				await withUnsafePointer(xk(), yk()) { x, y in
					.init(unsafeUninitializedCapacity: m) {
						let z = $0.baseAddress.unsafelyUnwrapped
						Element.GEMV(m: m, n: n,
									 α: 1,
									 a: x, lda: lda, opa: "N",
									 x: y, ldx: inc,
									 β: 0,
									 y: z, ldy: 1)
						$1 = $0.count
					}
				}
			})
		case ((.some(let lda), .some(1))):
			return ([1], {
				await withUnsafePointer(xk(), yk()) { x, y in
					.init(unsafeUninitializedCapacity: m) {
						let z = $0.baseAddress.unsafelyUnwrapped
						Element.GEMV(m: n, n: m,
									 α: 1,
									 a: x, lda: lda, opa: "T",
									 x: y, ldx: inc,
									 β: 0,
									 y: z, ldy: 1)
						$1 = $0.count
					}
				}
			})
		case (.some(let ldr), .some(let ldc)):
			return ([1], {
				await withUnsafePointer(xk(), yk()) { x, y in
					Element.withUnsafeTemporary(gather: [m, n], source: [ldr, ldc], target: [1, m], memory: x) { x in
						.init(unsafeUninitializedCapacity: m) {
							let z = $0.baseAddress.unsafelyUnwrapped
							Element.GEMV(m: m, n: n,
										 α: 1,
										 a: x, lda: m, opa: "N",
										 x: y, ldx: inc,
										 β: 0,
										 y: z, ldy: 1)
							$1 = $0.count
						}
					}
				}
			})
		default:
			throw Error.invalidShape(self)
		}
	}
}
extension DOT.VM: Vector {
	@inlinable
	var count: Int {
		rhs.cols
	}
	@usableFromInline
	subscript(position: Int) -> U {
		.init(lhs: lhs, rhs: rhs[0..., position])
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(lhs: lhs, rhs: rhs[0..., bounds])
	}
	@inlinable
	func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
		let (xs, xk) = try lhs(for: strategy)
		let (ys, yk) = try rhs(for: strategy)
		precondition((xs.count, ys.count) == (1, 2))
		let inc = xs.reduce(1, *)
		let k = rhs.rows
		let n = rhs.cols
		switch (ys.first, ys.last) {
		case ((.some(1), .some(let lda))):
			return ([1], {
				await withUnsafePointer(xk(), yk()) { x, y in
					.init(unsafeUninitializedCapacity: n) {
						let z = $0.baseAddress.unsafelyUnwrapped
						Element.GEMV(m: k, n: n,
									 α: 1,
									 a: y, lda: lda, opa: "T",
									 x: x, ldx: inc,
									 β: 0,
									 y: z, ldy: 1)
						$1 = $0.count
					}
				}
			})
		case ((.some(let lda), .some(1))):
			return ([1], {
				await withUnsafePointer(xk(), yk()) { x, y in
					.init(unsafeUninitializedCapacity: n) {
						let z = $0.baseAddress.unsafelyUnwrapped
						Element.GEMV(m: n, n: k,
									 α: 1,
									 a: y, lda: lda, opa: "N",
									 x: x, ldx: inc,
									 β: 0,
									 y: z, ldy: 1)
						$1 = $0.count
					}
				}
			})
		case (.some(let ldr), .some(let ldc)):
			return ([1], {
				await withUnsafePointer(xk(), yk()) { x, y in
					Element.withUnsafeTemporary(gather: [k, n], source: [ldr, ldc], target: [n, 1], memory: x) { x in
						.init(unsafeUninitializedCapacity: n) {
							let z = $0.baseAddress.unsafelyUnwrapped
							Element.GEMV(m: k, n: n,
										 α: 1,
										 a: y, lda: n, opa: "T",
										 x: x, ldx: inc,
										 β: 0,
										 y: z, ldy: 1)
							$1 = $0.count
						}
					}
				}
			})
		default:
			throw Error.invalidShape(self)
		}
	}
}
@_disfavoredOverload
public func •<Element: ArithmeticElement & BLASElement>(_ lhs: some Vector<Element>, _ rhs: some Vector<Element>) -> some Scalar<Element> {
	DOT.Inner(lhs: lhs, rhs: rhs)
}
@_disfavoredOverload
public func •<Element: ArithmeticElement & BLASElement>(_ lhs: some Matrix<Element>, _ rhs: some Vector<Element>) -> some Vector<Element> {
	DOT.MV(lhs: lhs, rhs: rhs)
}
@_disfavoredOverload
public func •<Element: ArithmeticElement & BLASElement>(_ lhs: some Vector<Element>, _ rhs: some Matrix<Element>) -> some Vector<Element> {
	DOT.VM(lhs: lhs, rhs: rhs)
}
@_disfavoredOverload
public func outer<Element: ArithmeticElement & BLASElement>(_ lhs: some Vector<Element>, _ rhs: some Vector<Element>) -> some Matrix<Element> {
	DOT.Outer(lhs: lhs, rhs: rhs)
}
