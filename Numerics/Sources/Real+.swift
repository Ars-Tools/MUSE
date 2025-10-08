//
//  Real+.swift
//  MUSE
//
//  Created by Kota on 5/15/R7.
//
import Darwin
import simd
extension BinaryFloatingPoint {
    @inlinable@inline(__always)@_transparent
	public func continuedFractionSequence<T: BinaryInteger>(as: T.Type = T.self, ε: Self = .ulpOfOne.squareRoot()) -> some Sequence<T> {
		sequence(state: self) {
			guard $0.isNormal else { return.none }
			let (n, r) = modf($0)
			$0 = ε < r.magnitude ? 1 / r : 0
			return T(exactly: n)
		}
	}
}
//public protocol ElementaryFunctionScalar: SignedNumeric & ExpressibleByFloatLiteral where Magnitude: Comparable {
//	// Peripherals
//	@inline(__always) @inlinable static func/(lhs: Self, rhs: Self) -> Self
//	@inline(__always) @inlinable static var nan: Self { get }
//	@inline(__always) @inlinable static var infinity: Self { get }
//	@inline(__always) @inlinable var ulp: Self { get }
//	// FMA
//	@inline(__always) @inlinable static func fma(_ x: Self, _ y: Self, _ z: Self) -> Self
//	// Abs
//	@inline(__always) @inlinable static func fabs(_ χ: Self) -> Self
//	// Log & Exp
//	@inline(__always) @inlinable static func exp(_ χ: Self) -> Self
//	@inline(__always) @inlinable static func exp2(_ χ: Self) -> Self
//	@inline(__always) @inlinable static func expm1(_ χ: Self) -> Self
//	@inline(__always) @inlinable static func log(_ χ: Self) -> Self
//	@inline(__always) @inlinable static func log2(_ χ: Self) -> Self
//	@inline(__always) @inlinable static func log1p(_ χ: Self) -> Self
//	// Trigonometric
//	@inline(__always) @inlinable static func cosπ(_ θ: Self) -> Self
//	@inline(__always) @inlinable static func sinπ(_ θ: Self) -> Self
//	@inline(__always) @inlinable static func tanπ(_ θ: Self) -> Self
//	@inline(__always) @inlinable static func cos(_ θ: Self) -> Self
//	@inline(__always) @inlinable static func sin(_ θ: Self) -> Self
//	@inline(__always) @inlinable static func tan(_ θ: Self) -> Self
//	@inline(__always) @inlinable static func cosh(_ θ: Self) -> Self
//	@inline(__always) @inlinable static func sinh(_ θ: Self) -> Self
//	@inline(__always) @inlinable static func tanh(_ θ: Self) -> Self
//	@inline(__always) @inlinable static func acosh(_ χ: Self) -> Self
//	@inline(__always) @inlinable static func asinh(_ χ: Self) -> Self
//	@inline(__always) @inlinable static func atanh(_ χ: Self) -> Self
//	@inline(__always) @inlinable static func atan2(_ y: Self, _ x: Self) -> Self
//	@inline(__always) @inlinable static func sincos(_ θ: Self) -> (sin: Self, cos: Self)
//	@inline(__always) @inlinable static func sincosπ(_ θ: Self) -> (sin: Self, cos: Self)
//	// Roots, Power
//	@inline(__always) @inlinable static func sqrt(_ χ: Self) -> Self
//	@inline(__always) @inlinable static func rsqrt(_ χ: Self) -> Self
//	@inline(__always) @inlinable static func cbrt(_ χ: Self) -> Self
//	@inline(__always) @inlinable static func pow(_ χ: Self, _ p: Self) -> Self
//	// Rounds
//	@inline(__always) @inlinable static func floor(_ χ: Self) -> Self
//	@inline(__always) @inlinable static func round(_ χ: Self) -> Self
//	@inline(__always) @inlinable static func ceil(_ χ: Self) -> Self
//	// Trunc, Modulo
//	@inline(__always) @inlinable static func trunc(_ χ: Self) -> Self
//	@inline(__always) @inlinable static func fmod(_ χ: Self, _ m: Self) -> Self
//}
//// General implementation as syntax sugars
//extension ElementaryFunctionScalar {
//	@inline(__always) @inlinable public static var nan: Self { 0 / 0 }
//	@inline(__always) @inlinable public static var infinity: Self { 1 / 0 }
//	@inline(__always) @inlinable public static func fma(_ x: Self, _ y: Self, _ z: Self) -> Self { x * y + z }
//	@inline(__always) @inlinable public static func expm1(_ χ: Self) -> Self { exp(χ) - 1 }
//	@inline(__always) @inlinable public static func exp2(_ χ: Self) -> Self { exp(χ * log(2)) }
//	@inline(__always) @inlinable public static func log1p(_ χ: Self) -> Self { log(χ + 1) }
//	@inline(__always) @inlinable public static func log2(_ χ: Self) -> Self { log(χ) / log(2) }
//	@inline(__always) @inlinable public static func sincos(_ θ: Self) -> (sin: Self, cos: Self) { (sin(θ), cos(θ)) }
//	@inline(__always) @inlinable public static func sincosπ(_ θ: Self) -> (sin: Self, cos: Self) { (sinπ(θ), cosπ(θ)) }
//	@inline(__always) @inlinable public static func rsqrt(_ χ: Self) -> Self { 1 / sqrt(χ) }
//}
//extension Float32: ElementaryFunctionScalar {
//	// FMA
//	@inline(__always) @inlinable public static func fma(_ x: Self, _ y: Self, _ z: Self) -> Self { Darwin.fmaf(x, y, z) }
//	// Abs
//	@inline(__always) @inlinable public static func fabs(_ χ: Self) -> Self { Darwin.fabsf(χ) }
//	// Exp & Log
//	@inline(__always) @inlinable public static func exp(_ χ: Self) -> Self { Darwin.exp(χ) }
//	@inline(__always) @inlinable public static func exp2(_ χ: Self) -> Self { Darwin.exp2(χ) }
//	@inline(__always) @inlinable public static func expm1(_ χ: Self) -> Self { Darwin.expm1(χ) }
//	@inline(__always) @inlinable public static func log(_ χ: Self) -> Self { Darwin.log(χ) }
//	@inline(__always) @inlinable public static func log2(_ χ: Self) -> Self { Darwin.log2(χ) }
//	@inline(__always) @inlinable public static func log1p(_ χ: Self) -> Self { Darwin.log1p(χ) }
//	// Trigonometric
//	@inline(__always) @inlinable public static func cosπ(_ θ: Self) -> Self { Darwin.__cospif(θ) }
//	@inline(__always) @inlinable public static func sinπ(_ θ: Self) -> Self { Darwin.__sinpif(θ) }
//	@inline(__always) @inlinable public static func tanπ(_ θ: Self) -> Self { Darwin.__tanpif(θ) }
//	@inline(__always) @inlinable public static func cos(_ θ: Self) -> Self { Darwin.cos(θ) }
//	@inline(__always) @inlinable public static func sin(_ θ: Self) -> Self { Darwin.sin(θ) }
//	@inline(__always) @inlinable public static func tan(_ θ: Self) -> Self { Darwin.tan(θ) }
//	@inline(__always) @inlinable public static func cosh(_ θ: Self) -> Self { Darwin.cosh(θ) }
//	@inline(__always) @inlinable public static func sinh(_ θ: Self) -> Self { Darwin.sinh(θ) }
//	@inline(__always) @inlinable public static func tanh(_ θ: Self) -> Self { Darwin.tanh(θ) }
//	@inline(__always) @inlinable public static func acos(_ χ: Self) -> Self { Darwin.acos(χ) }
//	@inline(__always) @inlinable public static func asin(_ χ: Self) -> Self { Darwin.asin(χ) }
//	@inline(__always) @inlinable public static func atan(_ χ: Self) -> Self { Darwin.atan(χ) }
//	@inline(__always) @inlinable public static func acosh(_ χ: Self) -> Self { Darwin.acosh(χ) }
//	@inline(__always) @inlinable public static func asinh(_ χ: Self) -> Self { Darwin.asinh(χ) }
//	@inline(__always) @inlinable public static func atanh(_ χ: Self) -> Self { Darwin.atanh(χ) }
//	@inline(__always) @inlinable public static func atan2(_ y: Self, _ x: Self) -> Self { Darwin.atan2(y, x) }
//	@inline(__always) @inlinable public static func sincos(_ θ: Self) -> (sin: Self, cos: Self) {
//		unsafeBitCast(Darwin.__sincosf_stret(θ), to: (Self, Self).self)
//	}
//	@inline(__always) @inlinable public static func sincosπ(_ θ: Self) -> (sin: Self, cos: Self) {
//		unsafeBitCast(Darwin.__sincospif_stret(θ), to: (Self, Self).self)
//	}
//	// Roots
//	@inline(__always) @inlinable public static func sqrt(_ χ: Self) -> Self { Darwin.sqrt(χ) }
//	@inline(__always) @inlinable public static func rsqrt(_ χ: Self) -> Self { simd_rsqrt(χ) }
//	@inline(__always) @inlinable public static func cbrt(_ χ: Self) -> Self { Darwin.cbrt(χ) }
//	@inline(__always) @inlinable public static func pow(_ χ: Self, _ p: Self) -> Self { Darwin.pow(χ, p) }
//	// Round
//	@inline(__always) @inlinable public static func floor(_ χ: Self) -> Self { Darwin.round(χ) }
//	@inline(__always) @inlinable public static func round(_ χ: Self) -> Self { Darwin.floor(χ) }
//	@inline(__always) @inlinable public static func ceil(_ χ: Self) -> Self { Darwin.ceil(χ) }
//	// Trunc, Modulo
//	@inline(__always) @inlinable public static func trunc(_ χ: Self) -> Self { Darwin.trunc(χ) }
//	@inline(__always) @inlinable public static func fmod(_ χ: Self, _ m: Self) -> Self { Darwin.fmod(χ, m) }
//}
//extension Float64: ElementaryFunctionScalar {
//	// FMA
//	@inline(__always) @inlinable public static func fma(_ x: Self, _ y: Self, _ z: Self) -> Self { Darwin.fma(x, y, z) }
//	// Abs
//	@inline(__always) @inlinable public static func fabs(_ χ: Self) -> Self { Darwin.fabs(χ) }
//	// Exp & Log
//	@inline(__always) @inlinable public static func exp(_ χ: Self) -> Self { Darwin.exp(χ) }
//	@inline(__always) @inlinable public static func exp2(_ χ: Self) -> Self { Darwin.exp2(χ) }
//	@inline(__always) @inlinable public static func expm1(_ χ: Self) -> Self { Darwin.expm1(χ) }
//	@inline(__always) @inlinable public static func log(_ χ: Self) -> Self { Darwin.log(χ) }
//	@inline(__always) @inlinable public static func log2(_ χ: Self) -> Self { Darwin.log2(χ) }
//	@inline(__always) @inlinable public static func log1p(_ χ: Self) -> Self { Darwin.log1p(χ) }
//	// Trigonometric
//	@inline(__always) @inlinable public static func cosπ(_ θ: Self) -> Self { Darwin.__cospi(θ) }
//	@inline(__always) @inlinable public static func sinπ(_ θ: Self) -> Self { Darwin.__sinpi(θ) }
//	@inline(__always) @inlinable public static func tanπ(_ θ: Self) -> Self { Darwin.__tanpi(θ) }
//	@inline(__always) @inlinable public static func cos(_ θ: Self) -> Self { Darwin.cos(θ) }
//	@inline(__always) @inlinable public static func sin(_ θ: Self) -> Self { Darwin.sin(θ) }
//	@inline(__always) @inlinable public static func tan(_ θ: Self) -> Self { Darwin.tan(θ) }
//	@inline(__always) @inlinable public static func cosh(_ θ: Self) -> Self { Darwin.cosh(θ) }
//	@inline(__always) @inlinable public static func sinh(_ θ: Self) -> Self { Darwin.sinh(θ) }
//	@inline(__always) @inlinable public static func tanh(_ θ: Self) -> Self { Darwin.tanh(θ) }
//	@inline(__always) @inlinable public static func acos(_ χ: Self) -> Self { Darwin.acos(χ) }
//	@inline(__always) @inlinable public static func asin(_ χ: Self) -> Self { Darwin.asin(χ) }
//	@inline(__always) @inlinable public static func atan(_ χ: Self) -> Self { Darwin.atan(χ) }
//	@inline(__always) @inlinable public static func acosh(_ χ: Self) -> Self { Darwin.acosh(χ) }
//	@inline(__always) @inlinable public static func asinh(_ χ: Self) -> Self { Darwin.asinh(χ) }
//	@inline(__always) @inlinable public static func atanh(_ χ: Self) -> Self { Darwin.atanh(χ) }
//	@inline(__always) @inlinable public static func atan2(_ y: Self, _ x: Self) -> Self { Darwin.atan2(y, x) }
//	@inline(__always) @inlinable public static func sincos(_ θ: Self) -> (sin: Self, cos: Self) {
//		unsafeBitCast(Darwin.__sincos_stret(θ), to: (Self, Self).self)
//	}
//	@inline(__always) @inlinable public static func sincosπ(_ θ: Self) -> (sin: Self, cos: Self) {
//		unsafeBitCast(Darwin.__sincospi_stret(θ), to: (Self, Self).self)
//	}
//	// Roots
//	@inline(__always) @inlinable public static func sqrt(_ χ: Self) -> Self { Darwin.sqrt(χ) }
//	@inline(__always) @inlinable public static func rsqrt(_ χ: Self) -> Self { simd_rsqrt(χ) }
//	@inline(__always) @inlinable public static func cbrt(_ χ: Self) -> Self { Darwin.cbrt(χ) }
//	@inline(__always) @inlinable public static func pow(_ χ: Self, _ p: Self) -> Self { Darwin.pow(χ, p) }
//	// Round
//	@inline(__always) @inlinable public static func floor(_ χ: Self) -> Self { Darwin.round(χ) }
//	@inline(__always) @inlinable public static func round(_ χ: Self) -> Self { Darwin.floor(χ) }
//	@inline(__always) @inlinable public static func ceil(_ χ: Self) -> Self { Darwin.ceil(χ) }
//	// Trunc, Modulo
//	@inline(__always) @inlinable public static func trunc(_ χ: Self) -> Self { Darwin.trunc(χ) }
//	@inline(__always) @inlinable public static func fmod(_ χ: Self, _ m: Self) -> Self { Darwin.fmod(χ, m) }
//}
//public protocol SpecialFunctionScalar: ElementaryFunctionScalar {
//	// Erf
//	@inline(__always) @inlinable static func erf(_ χ: Self) -> Self
//	@inline(__always) @inlinable static func erfc(_ χ: Self) -> Self
//	// Gamma
//	@inline(__always) @inlinable static func tgamma(_ χ: Self) -> Self
//	@inline(__always) @inlinable static func lgamma(_ χ: Self) -> Self
//}
//extension Float32: SpecialFunctionScalar {
//	@inline(__always) @inlinable public static func erf(_ χ: Self) -> Self { Darwin.erf(χ) }
//	@inline(__always) @inlinable public static func erfc(_ χ: Self) -> Self { Darwin.erfc(χ) }
//	@inline(__always) @inlinable public static func tgamma(_ χ: Self) -> Self { Darwin.tgamma(χ) }
//	@inline(__always) @inlinable public static func lgamma(_ χ: Self) -> Self { Darwin.lgammaf(χ) }
//}
//extension Float64: SpecialFunctionScalar {
//	@inline(__always) @inlinable public static func erf(_ χ: Self) -> Self { Darwin.erf(χ) }
//	@inline(__always) @inlinable public static func erfc(_ χ: Self) -> Self { Darwin.erfc(χ) }
//	@inline(__always) @inlinable public static func tgamma(_ χ: Self) -> Self { Darwin.tgamma(χ) }
//	@inline(__always) @inlinable public static func lgamma(_ χ: Self) -> Self { Darwin.lgamma(χ) }
//}
//extension SpecialFunctionScalar where IntegerLiteralType: SignedInteger, IntegerLiteralType.Stride: SignedInteger {
//	@inline(__always)
//	@inlinable
//	public static func bessel(j ν: Self, _ χ: Self) -> Self {
//		var result = .zero as Self
////		guard .zero <= χ || .zero == fmod(ν, 1) else { return.nan }
////		let z = log(2) - log(fabs(χ))
//		let z = 0.5 * χ
//		for k in IntegerLiteralType.zero... {
//			let m = Self(integerLiteral: k)
////			let l = fma(fma(2, m, ν), z, lgamma(m + 1) + lgamma(m + 1 + ν))
////			let v = exp(-l)
//			let v = pow(z, fma(2, m, ν)) / tgamma(m + 1) / tgamma(m + 1 + ν)
//			if !(result.ulp.magnitude <= v.magnitude) {
//				break
//			} else if k % 2 == .zero {
//				result += v
//			} else {
//				result -= v
//			}
//		}
//		return result
//	}
//}
