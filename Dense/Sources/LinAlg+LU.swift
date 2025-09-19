//
//  LinAlg+LU.swift
//  MUSE
//
//  Created by Kota on 9/19/R7.
//
import protocol Accelerate.AccelerateBuffer
import func Layout.flatten
extension LinAlg {
	public struct LU {
		@usableFromInline let m: Int
		@usableFromInline let n: Int
		@usableFromInline let system: Array<Element>
		@usableFromInline let ipivot: Array<Int>
	}
}
extension LinAlg.LU {
	public init<R>(decompose x: MatrixBuffer<R>) throws where R.Element == Element {
		m = x.rows
		n = x.cols
		let (length, stride, offset) = flatten(shape: [m, n], xs: [x.ldr, x.ldc], ys: [1, m])
		var a = Array<Element>(unsafeUninitializedCapacity: m * n) {
			let y = $0.baseAddress.unsafelyUnwrapped
			withUnsafePointer(x.data) { x in
				for offset in offset {
					Element.Copy(x: x.advanced(by: offset.x), ldx: stride.x,
								 y: y.advanced(by: offset.y), ldy: stride.y,
								 length: length)
				}
			}
			$1 = $0.count
		}
		var p = Array<Int>(repeating: .zero, count: n)
		switch Element.GETRF(m: m, n: n,
							 a: &a, lda: m,
							 p: &p) {
		case.zero:
			break
		case let status:
			throw Error.numericalError(tensor: x, status: status, operation: "getrf@\(#function)")
		}
		system = a
		ipivot = p
	}
}
extension LinAlg.LU {
	public var det: Element {
		ipivot.enumerated().reduce(1 as Element) {
			($1.0 == $1.1 ? $0 : -$0) * system[$1.1 * n + $1.1]
		}
	}
}
extension LinAlg.LU where Element: MutScalar {
	public var inv: MatrixBuffer<Array<Element>> {
		precondition(m == n, "inv requires square matrix")
		var system = system
		let status = Element.GETRI(n: n,
								   a: &system, lda: m,
								   p: ipivot)
		assert(status == 0)
		return.init(shape: (m, n), stride: (1, m), data: system)
	}
}
extension LinAlg.LU {
	public func solve<R>(rhs: VectorBuffer<R>) where R.Element == Element {
		
	}
	public func solve<R>(rhs: MatrixBuffer<R>) where R.Element == Element {
		
	}
}

extension LinAlg {
	public static func Det<R>(_ x: MatrixBuffer<R>) throws -> Element where R.Element == Element {
		precondition(x.rows == x.cols)
		let n = min(x.rows, x.cols)
		let (length, stride, offset) = flatten(shape: [n, n], xs: [x.ldc, x.ldc], ys: [1, n])
		var system = withUnsafePointer(x.data) { x in
			Array<Element>(unsafeUninitializedCapacity: n * n) {
				let y = $0.baseAddress.unsafelyUnwrapped
				for offset in offset {
					Element.Copy(x: x.advanced(by: offset.x), ldx: stride.x,
								 y: y.advanced(by: offset.y), ldy: stride.y,
								 length: length)
				}
				$1 = $0.count
			}
		}
		var ipivot = Array<Int>(repeating: .zero, count: n)
		switch Element.GETRF(m: n, n: n,
							 a: &system, lda: n,
							 p: &ipivot) {
		case.zero:
			break
		case let status:
			throw Error.numericalError(tensor: x, status: status, operation: "getrf@\(#function)")
		}
		return ipivot.enumerated().reduce(1 as Element) {
			($1.0 == $1.1 ? $0 : 0 - $0) * system[$1.1 * n + $1.1]
		}
	}
	public static func Det(_ x: some Matrix<Element>) async throws -> Element where Element: MutScalar {
		try Det(await MatrixBuffer(x, for: .columnMajor))
	}
	public static func Inv<R>(_ x: MatrixBuffer<R>) throws -> MatrixBuffer<Array<Element>> where R.Element == Element {
		precondition(x.rows == x.cols)
		let n = min(x.rows, x.cols)
		let (length, stride, offset) = flatten(shape: [n, n], xs: [x.ldr, x.ldc], ys: [1, n])
		var system = withUnsafePointer(x.data) { x in
			Array<Element>(unsafeUninitializedCapacity: n * n) {
				let y = $0.baseAddress.unsafelyUnwrapped
				for offset in offset {
					Element.Copy(x: x.advanced(by: offset.x), ldx: stride.x,
								 y: y.advanced(by: offset.y), ldy: stride.y,
								 length: length)
				}
				$1 = $0.count
			}
		}
		var ipivot = Array<Int>(repeating: .zero, count: n)
		switch Element.GETRF(m: n, n: n,
							 a: &system, lda: n,
							 p: &ipivot) {
		case.zero:
			break
		case let status:
			throw Error.numericalError(tensor: x, status: status, operation: "getrf@\(#function)")
		}
		switch Element.GETRI(n: n,
							 a: &system, lda: n,
							 p: &ipivot) {
		case.zero:
			break
		case let status:
			throw Error.numericalError(tensor: x, status: status, operation: "getri@\(#function)")
		}
		return.init(shape: (n, n), stride: (1, n), data: system)
	}
	public static func Inv(_ x: some Matrix<Element>) async throws -> MatrixBuffer<Array<Element>> {
		try Inv(await MatrixBuffer(x, for: .columnMajor))
	}
}
