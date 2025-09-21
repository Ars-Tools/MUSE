//
//  DOT+M.swift
//  MUSE
//
//  Created by Kota on 9/18/R7.
//
import Layout
extension DOT {
	@usableFromInline
    @frozen struct DD<X: Matrix<Element>, Y: Matrix<Element>> {
		@usableFromInline typealias R = Array<Element>
		@usableFromInline typealias S = DD<X.S, Y.S>
		@usableFromInline typealias U = Inner<X.V, Y.V>
		@usableFromInline let x: X
		@usableFromInline let y: Y
	}
    @usableFromInline
    @frozen enum VV<X: Matrix<Element>, Y: Matrix<Element>> {
        case DD(X, Y)
        case MV(X, Y)
        case VM(X, Y)
    }
	@usableFromInline
    @frozen struct MM<X: Matrix<Element>, Y: Matrix<Element>> {
		@usableFromInline typealias R = Array<Element>
		@usableFromInline typealias S = MM<X.S, Y.S>
		@usableFromInline typealias T = MM<Y.T, X.T>
		@usableFromInline typealias U = Inner<X.V, Y.V>
        @usableFromInline typealias V = VV<X.S, Y.S>
		@usableFromInline let x: X
		@usableFromInline let y: Y
	}
}
extension DOT.DD: Vector {
	@inlinable
	var count: Int {
		min(x.rows, y.cols)
	}
	@usableFromInline
	subscript(position: Int) -> U {
        .init(x: x[position, 0...], y: y[0..., position])
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(x: x[bounds, 0...], y: y[0..., bounds])
	}
	@inlinable
	func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        let (xi, xk) = try x.evaluation(for: strategy)
        let (yi, yk) = try y.evaluation(for: strategy)
		precondition((xi.count, yi.count) == (2, 2))
		let xs = (xi.first ?? 1, xi.last ?? 1)
		let ys = (yi.first ?? 1, yi.last ?? 1)
		let zs = [1]
		let m = min(x.rows, y.cols)
		let n = broadcast(x: x.cols, y: y.rows)
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
extension DOT.DD: InstantTensor & InstantVector where X: InstantMatrix, Y: InstantMatrix {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let (xi, xk) = try x.evaluation(for: strategy)
        let (yi, yk) = try y.evaluation(for: strategy)
        precondition((xi.count, yi.count) == (2, 2))
        let xs = (xi.first ?? 1, xi.last ?? 1)
        let ys = (yi.first ?? 1, yi.last ?? 1)
        let zs = [1]
        let m = min(x.rows, y.cols)
        let n = broadcast(x: x.cols, y: y.rows)
        return (zs, {
            withUnsafePointer(xk(), yk()) { x, y in
                (0..<m).map {
                    Element.Inner(n: n,
                                  x: x.advanced(by: $0 * xs.0), ldx: xs.1,
                                  y: y.advanced(by: $0 * ys.1), ldy: ys.0)
                }
            }
        })
    }
}
extension DOT.VV: Vector {
    @usableFromInline typealias R = Array<Element>
    @usableFromInline typealias S = DOT.VV<X.S, Y.S>
    @usableFromInline typealias U = DOT.Inner<X.V, Y.V>
    @inlinable
    var count: Int {
        switch self {
        case.DD(let x, let y):
            min(x.rows, y.cols)
        case.MV(let x, _):
            x.rows
        case.VM(_, let y):
            y.cols
        }
    }
    @usableFromInline
    subscript(position: Int) -> U {
        switch self {
        case.DD(let x, let y):
            .init(x: x[position, 0...], y: y[0..., position])
        case.MV(let x, let y):
            .init(x: x[position, 0...], y: y[0..., 0])
        case.VM(let x, let y):
            .init(x: x[0, 0...], y: y[0..., position])
        }
    }
    @usableFromInline
    subscript(bounds: some RangeExpression<Int>) -> S {
        switch self {
        case.DD(let x, let y):
            .DD(x[bounds, 0...], y[0..., bounds])
        case.MV(let x, let y):
            .MV(x[bounds, 0...], y[0..., 0...])
        case.VM(let x, let y):
            .VM(x[0..., 0...], y[0..., bounds])
        }
    }
    @usableFromInline
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch self {
        case.DD(let x, let y):
            try DOT.DD(x: x, y: y).evaluation(for: strategy)
        case.MV(let x, let y):
            try DOT.MV(x: x, y: y[0..., 0]).evaluation(for: strategy)
        case.VM(let x, let y):
            try DOT.VM(x: x[0, 0...], y: y).evaluation(for: strategy)
        }
    }
}
extension DOT.VV: InstantTensor & InstantVector where X: InstantMatrix, Y: InstantMatrix {
    @usableFromInline
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch self {
        case.DD(let x, let y):
            try DOT.DD(x: x, y: y).evaluation(for: strategy)
        case.MV(let x, let y):
            try DOT.MV(x: x, y: y[0..., 0]).evaluation(for: strategy)
        case.VM(let x, let y):
            try DOT.VM(x: x[0, 0...], y: y).evaluation(for: strategy)
        }
    }
}
extension DOT.MM: Matrix {
	@inlinable
	var rows: Int {
		x.rows
	}
	@inlinable
	var cols: Int {
		y.cols
	}
	@usableFromInline
	var transpose: T {
		.init(x: y.transpose, y: x.transpose)
	}
	@usableFromInline
	var diagonal: V {
        .DD(x[0..., 0...], y[0..., 0...])
	}
	@usableFromInline
	subscript(row: Int, col: Int) -> U {
		.init(x: x[row, 0...], y: y[0..., col])
	}
	@usableFromInline
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .VM(x[row...row, 0...], y[0..., col])
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .MV(x[row, 0...], y[0..., col...col])
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(x: x[row, 0...], y: y[0..., col])
	}
	@inlinable
	func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        let (xs, xk) = try x.evaluation(for: strategy)
        let (ys, yk) = try y.evaluation(for: strategy)
		let m = x.rows
		let n = y.cols
		let k = broadcast(x: x.cols, y: y.rows)
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
extension DOT.MM: InstantTensor & InstantMatrix where X: InstantMatrix, Y: InstantMatrix {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let (xs, xk) = try x.evaluation(for: strategy)
        let (ys, yk) = try y.evaluation(for: strategy)
        let m = x.rows
        let n = y.cols
        let k = broadcast(x: x.cols, y: y.rows)
        let zs = strategy.stride(for: [m, n])
        let capacity = capacity(alloc: [m, n], stride: zs)
        precondition((xs.count, ys.count, zs.count) == (2, 2, 2))
        switch (matricise(size: xs), matricise(size: ys), matricise(size: zs)) {
        case (.some((1, let lda)), .some((1, let ldb)), .some((1, let ldc))):
            return (zs, {
                withUnsafePointer(xk(), yk()) { x, y in
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
                withUnsafePointer(xk(), yk()) { x, y in
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
                withUnsafePointer(xk(), yk()) { x, y in
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
                withUnsafePointer(xk(), yk()) { x, y in
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
                withUnsafePointer(xk(), yk()) { x, y in
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
                withUnsafePointer(xk(), yk()) { x, y in
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
                withUnsafePointer(xk(), yk()) { x, y in
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
                withUnsafePointer(xk(), yk()) { x, y in
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
    DOT.MM(x: lhs, y: rhs)
}
public func •<Element: BLASElement & ArithmeticElement>(_ lhs: some InstantMatrix<Element>, _ rhs: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    DOT.MM(x: lhs, y: rhs)
}
