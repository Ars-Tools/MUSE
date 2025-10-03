//
//  LINALG+QR.swift
//  MUSE
//
//  Created by Kota on 10/4/25.
//
import protocol Dense.Matrix
extension LINALG {
    public static func QR(_ a: some SparseMatrix<Element>, ε: Element.Magnitude = .ulpOfOne) -> (some SparseMatrix<Element>, some SparseMatrix<Element>){
        precondition(a.rows <= a.cols)
        var q = LIL<Element>(identity: a.rows, for: .rowMajor)
        var r = LIL(a, for: .columnMajor)
        for col in r.store.indices.dropLast() {
            assert(q.major == .rowMajor)
            assert(r.major == .columnMajor)
            var u = r[col..., col]
            switch u[0].sign {
            case.plus:
                u[0] += norm(u)
            case.minus:
                u[0] -= norm(u)
            }
            switch normSquared(u) {
            case ...(.ulpOfOne):
                continue
            case let n:assert(.ulpOfOne < n)
                var h = LIL<Element>(major: .columnMajor, count: r.count, store: .init(repeating: .init(), count: r.count))
                let p = LIL<Element>(identity: u.count, for: .columnMajor) - (2 / n) * outer(u, u)
                h[0..<col, 0..<col] = .init(identity: col, for: .columnMajor)
                h[col..., col...] = .init(p)
                q = LIL(q • h.transpose, for: .rowMajor)
                r = LIL(h • r, for: .columnMajor)
                r[(col+1)..., col] = .init(shape: u.count, [])
            }
        }
        return (q, r)
    }
}
