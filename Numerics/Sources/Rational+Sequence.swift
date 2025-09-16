//
//  Rational+Sequence.swift
//  MUSE
//
//  Created by Kota on 5/15/R7.
//
extension Sequence {
	public func foldr<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result {
		try withoutActuallyEscaping(nextPartialResult) { nextPartialResult in
			try reduce({$0} as (Result) throws -> Result) { (partialResult, element) in
				{ try partialResult(nextPartialResult($0, element)) }
			} (initialResult)
		}
	}
	public func foldr<Result>(into result: Result, _ updateAccumulatingResult: (inout Result, Element) throws -> ()) rethrows -> Result {
		try reversed().reduce(into: result, updateAccumulatingResult)
	}
}
extension RationalNumber { // Rational number from continued fraction sequence
	@inline(__always)
	@inlinable
	public init(continuedFraction sequence: some Sequence<IntegerLiteralType>) {
		self = sequence.foldr(Self.zero) {
			Self($1) + ( $0.isNormal ? $0.inverse : 0 )
		}
	}
	@inline(__always)
	@inlinable
	public init(continuedFraction sequence: some Sequence<(IntegerLiteralType, IntegerLiteralType)>) {
		self = sequence.foldr(Self.zero) {
			Self($1.0) + Self($1.1) / ( $0.isNormal ? $0 : 1 )
		}
	}
}
