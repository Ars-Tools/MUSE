//
//  BLAS+V.swift
//  MUSE
//
//  Created by Kota on 9/18/R7.
//
import protocol Accelerate.AccelerateBuffer
import Layout
extension BLAS {
	@usableFromInline
    @frozen struct Inner<X: Vector<Element>, Y: Vector<Element>> {
		@usableFromInline let x: X
		@usableFromInline let y: Y
	}
	@usableFromInline
    @frozen struct Outer<X: Vector<Element>, Y: Vector<Element>> {
		@usableFromInline typealias R = Array<Element>
		@usableFromInline typealias S = Outer<X.S, Y.S>
		@usableFromInline typealias T = Outer<Y.T, X.T>
		@usableFromInline typealias U = Arithmetic<Element>.Mul<X.U, Y.U>
		@usableFromInline typealias V = Arithmetic<Element>.Mul<X.S, Y.S>
		@usableFromInline let x: X
		@usableFromInline let y: Y
	}
	@usableFromInline
    @frozen struct MV<X: Matrix<Element>, Y: Vector<Element>> {
		@usableFromInline typealias R = Array<Element>
		@usableFromInline typealias S = MV<X.S, Y>
		@usableFromInline typealias U = Inner<X.V, Y>
		@usableFromInline let x: X
		@usableFromInline let y: Y
	}
	@usableFromInline
    @frozen struct VM<X: Vector<Element>, Y: Matrix<Element>> {
		@usableFromInline typealias R = Array<Element>
		@usableFromInline typealias S = VM<X, Y.S>
		@usableFromInline typealias U = Inner<X, Y.V>
		@usableFromInline let x: X
		@usableFromInline let y: Y
	}
}
extension BLAS.Inner {
	@inlinable@inline(__always)@_transparent
	func evaluation(x: (Int, Int), y: (Int, Int)) -> @Sendable (X.R, Y.R) -> CollectionOfOne<Element> {
		let count = broadcast(x: x.0, y: y.0)
        let xs = x.1
        let ys = y.1
		return {
			withUnsafePointer($0, $1) {
                .init(Element.Inner(n: count, x: $0, ldx: xs, y: $1, ldy: ys))
			}
		}
	}
}
extension BLAS.Inner: Scalar {
    @inlinable@inline(__always)@_transparent
	func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> CollectionOfOne<Element>) {
        switch try (x.evaluation(for: strategy), y.evaluation(for: strategy)) {
        case ((let xs, let xm), (let ys, let ym)) where (xs.count, ys.count) == (1, 1):
            let zm = evaluation(x: (x.count, xs.last ?? 0), y: (y.count, ys.first ?? 0))
            return ([], {await zm(xm(), ym())})
        default:
            throw Error.unmatchShape(operation: #function, lhs: x.shape, rhs: y.shape)
		}
	}
}
extension BLAS.Inner: InstantTensor & InstantMatrix & InstantVector & InstantScalar where X: InstantVector, Y: InstantVector {
    @inlinable@inline(__always)@_transparent
	func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> CollectionOfOne<Element>) {
        switch try (x.evaluation(for: strategy), y.evaluation(for: strategy)) {
        case ((let xs, let xm), (let ys, let ym)) where (xs.count, ys.count) == (1, 1):
            let zm = evaluation(x: (x.count, xs.last ?? 0), y: (y.count, ys.first ?? 0))
			return ([], {zm(xm(), ym())})
        default:
            throw Error.unmatchShape(operation: #function, lhs: x.shape, rhs: y.shape)
		}
	}
}
extension BLAS.Outer: Matrix {
	@inlinable@inline(__always)@_transparent
	var rows: Int {
		x.count
	}
	@inlinable@inline(__always)@_transparent
	var cols: Int {
		y.count
	}
	@usableFromInline
	var transpose: T {
		.init(x: y.transpose, y: x.transpose)
	}
	@usableFromInline
	var diagonal: V {
        .init(x: x[0..<min(rows, cols)], y: y[0..<min(rows, cols)])
	}
	@usableFromInline
	subscript(row: Int, col: Int) -> U {
		.init(x: x[row], y: y[col])
	}
	@usableFromInline
	subscript(row: Int, col: some RangeExpression<Int>) -> V {
        .init(x: x[row...row], y: y[col])
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: Int) -> V {
        .init(x: x[row], y: y[col...col])
	}
	@usableFromInline
	subscript(row: some RangeExpression<Int>, col: some RangeExpression<Int>) -> S {
		.init(x: x[row], y: y[col])
	}
}
extension BLAS.Outer {
    @inlinable@inline(__always)@_transparent
	func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        let (xi, xk) = try x.evaluation(for: strategy)
        let (yi, yk) = try y.evaluation(for: strategy)
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
extension BLAS.Outer: InstantTensor & InstantMatrix where X: InstantVector, Y: InstantVector {
    @inlinable@inline(__always)@_transparent
	func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let (xi, xk) = try x.evaluation(for: strategy)
        let (yi, yk) = try y.evaluation(for: strategy)
		let xs = xi.reduce(1, *)
		let ys = yi.reduce(1, *)
		switch strategy {
		case.rowMajor:
			let zs = [cols, 1]
			let capacity = capacity(alloc: [rows, cols], stride: zs)
			return (zs, { [rows, cols] in
				withUnsafePointer(xk(), yk()) { x, y in
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
				withUnsafePointer(xk(), yk()) { x, y in
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
extension BLAS.MV: Vector {
    @inlinable@inline(__always)@_transparent
	var count: Int {
		x.rows
	}
	@usableFromInline
	subscript(position: Int) -> U {
		.init(x: x[position, 0...], y: y)
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(x: x[bounds, 0...], y: y)
	}
    @inlinable@inline(__always)@_transparent
	func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        let (xs, xk) = try x.evaluation(for: strategy)
        let (ys, yk) = try y.evaluation(for: strategy)
		precondition((xs.count, ys.count) == (2, 1))
		let inc = ys.reduce(1, *)
		let m = x.rows
		let n = x.cols
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
extension BLAS.MV: InstantTensor & InstantVector where X: InstantMatrix, Y: InstantVector {
    @inlinable@inline(__always)@_transparent
	func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let (xs, xk) = try x.evaluation(for: strategy)
        let (ys, yk) = try y.evaluation(for: strategy)
		precondition((xs.count, ys.count) == (2, 1))
		let inc = ys.reduce(1, *)
		let m = x.rows
		let n = x.cols
		switch (xs.first, xs.last) {
		case ((.some(1), .some(let lda))):
			return ([1], {
				withUnsafePointer(xk(), yk()) { x, y in
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
				withUnsafePointer(xk(), yk()) { x, y in
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
				withUnsafePointer(xk(), yk()) { x, y in
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
extension BLAS.VM: Vector {
    @inlinable@inline(__always)@_transparent
	var count: Int {
		y.cols
	}
	@usableFromInline
	subscript(position: Int) -> U {
		.init(x: x, y: y[0..., position])
	}
	@usableFromInline
	subscript(bounds: some RangeExpression<Int>) -> S {
		.init(x: x, y: y[0..., bounds])
	}
    @inlinable@inline(__always)@_transparent
	func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        let (xs, xk) = try x.evaluation(for: strategy)
        let (ys, yk) = try y.evaluation(for: strategy)
		precondition((xs.count, ys.count) == (1, 2))
		let inc = xs.reduce(1, *)
		let k = y.rows
		let n = y.cols
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
extension BLAS.VM: InstantTensor & InstantVector where X: InstantVector, Y: InstantMatrix {
    @inlinable@inline(__always)@_transparent
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        let (xs, xk) = try x.evaluation(for: strategy)
        let (ys, yk) = try y.evaluation(for: strategy)
        precondition((xs.count, ys.count) == (1, 2))
        let inc = xs.reduce(1, *)
        let k = y.rows
        let n = y.cols
        switch (ys.first, ys.last) {
        case ((.some(1), .some(let lda))):
            return ([1], {
                withUnsafePointer(xk(), yk()) { x, y in
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
                withUnsafePointer(xk(), yk()) { x, y in
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
                withUnsafePointer(xk(), yk()) { x, y in
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
    BLAS.Inner(x: lhs, y: rhs)
}
@_disfavoredOverload
public func •<Element: ArithmeticElement & BLASElement>(_ lhs: some Matrix<Element>, _ rhs: some Vector<Element>) -> some Vector<Element> {
    BLAS.MV(x: lhs, y: rhs)
}
@_disfavoredOverload
public func •<Element: ArithmeticElement & BLASElement>(_ lhs: some Vector<Element>, _ rhs: some Matrix<Element>) -> some Vector<Element> {
    BLAS.VM(x: lhs, y: rhs)
}
@_disfavoredOverload
public func outer<Element: ArithmeticElement & BLASElement>(_ lhs: some Vector<Element>, _ rhs: some Vector<Element>) -> some Matrix<Element> {
    BLAS.Outer(x: lhs, y: rhs)
}
@_disfavoredOverload
public func •<Element: ArithmeticElement & BLASElement>(_ lhs: some InstantVector<Element>, _ rhs: some InstantVector<Element>) -> some InstantScalar<Element> {
    BLAS.Inner(x: lhs, y: rhs)
}
@_disfavoredOverload
public func •<Element: ArithmeticElement & BLASElement>(_ lhs: some InstantMatrix<Element>, _ rhs: some InstantVector<Element>) -> some InstantVector<Element> {
    BLAS.MV(x: lhs, y: rhs)
}
@_disfavoredOverload
public func •<Element: ArithmeticElement & BLASElement>(_ lhs: some InstantVector<Element>, _ rhs: some InstantMatrix<Element>) -> some InstantVector<Element> {
    BLAS.VM(x: lhs, y: rhs)
}
@_disfavoredOverload
public func outer<Element: ArithmeticElement & BLASElement>(_ lhs: some InstantVector<Element>, _ rhs: some InstantVector<Element>) -> some InstantMatrix<Element> {
    BLAS.Outer(x: lhs, y: rhs)
}
