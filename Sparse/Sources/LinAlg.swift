//
//  LinAlg.swift
//  MUSE
//
//  Created by Kota on 9/12/R7.
//
import typealias Foundation.KeyPathComparator
import protocol Dense.Matrix
import func simd.fma
@usableFromInline
@frozen enum LinAlg<Element: BinaryFloatingPoint> {}
extension LinAlg {
	@inlinable
	static func normSquared(_ vector: some SparseVector<Element>) -> Element {
		vector.coo.lazy.reduce(.zero) { fma($1.1, $1.1, $0) }
	}
	public static func norm(_ vector: some SparseVector<Element>) -> Element {
		normSquared(vector).squareRoot()
	}
	public static func det(_ a: some SparseMatrix<Element>) -> Element {
		precondition(a.rows == a.cols, "matrix should be square")
		var H = LIL(hessenberg(a), for: .rowMajor)
		var d = H.store[0][0, default: .zero]
		for row in H.store.indices.dropFirst() {
			let t = H.store[row]
			if case.some(let λ) = t[row-1], .ulpOfOne < λ.magnitude {
				let s = H.store[row-1]
				assert(s[row-1, default: .zero].magnitude != .zero)
				H.store[row] = .init(uniqueKeysWithValues: (-λ / s[row-1, default: .zero]) * s + t)
			}
			d *= H.store[row][row, default: .zero]
		}
		return d
	}
	public static func hessenberg(_ a: some SparseMatrix<Element>) -> some SparseMatrix<Element> {
		precondition(a.rows == a.cols, "matrix should be square")
		var r = LIL(a, for: .columnMajor)
		for col in r.store.indices.dropLast(2) {
			assert(r.major == .columnMajor)
			var u = r[(col+1)..., col]
			switch u[0].sign {
			case.plus:
				u[0] += norm(u)
			case.minus:
				u[0] -= norm(u)
			}
			assert(normSquared(u).sign == .plus)
			switch normSquared(u) {
			case ...(.ulpOfOne):
				continue
			case let n:assert(.ulpOfOne < n)
				var h = LIL<Element>(major: .columnMajor, store: .init(repeating: .init(), count: r.count), count: r.count)
				let p = LIL<Element>(identity: u.count, for: .columnMajor) - ( 2 / n ) * outer(u, u)
				h[..<(col+1), ..<(col+1)] = .init(identity: col+1, for: .columnMajor)
				h[(col+1)..., (col+1)...] = .init(p)
				r = LIL(h • r • h.transpose, for: .columnMajor)
				r[(col+2)..., col] = .init(shape: u.count, [])
			}
		}
		return r
	}
}
