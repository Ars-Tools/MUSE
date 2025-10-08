//
//  Rational+String.swift
//  MUSE
//
//  Created by Kota on 5/15/R7.
//
import RegexBuilder
extension RationalNumber {
    @inlinable@inline(__always)@_transparent
	public var description: String {
		switch factor {
		case (0, 0):
			"NaN"
		case (0..., 0):
			"+Inf"
		case (...0, 0):
			"-Inf"
		case (let n,  1):
			"\(n)"
		case (let n, -1):
			"\(~n + 1)"
		case let (n, d):
			"\(n)/\(d)"
		}
	}
}
extension RationalNumber where IntegerLiteralType: FixedWidthInteger {
    @inlinable@inline(__always)@_transparent
	public init?(_ string: String) {
		let parser = Regex {
			Anchor.startOfLine
			ZeroOrMore {
				.whitespace
			}
			Capture {
				Optionally {
					"-"
				}
				OneOrMore {
					.digit
				}
			} transform: { IntegerLiteralType($0, radix: 10) }
			Optionally {
				ZeroOrMore {
					.whitespace
				}
				"/"
				ZeroOrMore {
					.whitespace
				}
				Capture {
					Optionally {
						"-"
					}
					OneOrMore {
						.digit
					}
				}
			}
			Anchor.endOfLine
		}
		guard let match = string.firstMatch(of: parser), let numerator = match.output.1 else { return nil }
		self.init(numerator: numerator, denominator: match.output.2.flatMap { .init($0) } ?? 1)
	}
}
