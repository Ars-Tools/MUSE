//
//  BLAS+GEMM.swift
//  MUSE
//
//  Created by Kota on 9/12/R7.
//
extension BLAS {
	@usableFromInline
	@frozen struct GEMM<Element, LHS: Matrix<Element>, RHS: Matrix<Element>> {
		@usableFromInline let lhs: LHS
		@usableFromInline let rhs: RHS
	}
}
