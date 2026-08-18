//
//  vFORCE.swift
//  MUSE
//
//  Created by Kota on 8/18/26.
//
import MKL
import vFORCE
import typealias Numerics.Complex64
import typealias Numerics.Complex128
public protocol vFORCEElement: Numeric {
    static func fabs(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int)
    static func mags(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int)
    static func floor(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func round(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func ceil(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func sqrt(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func cbrt(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func exp(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func log(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func exp2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func log2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func exp10(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func log10(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func expm1(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func log1p(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func sinπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func cosπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func tanπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func sin(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func cos(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func tan(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func sinh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func cosh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func tanh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func asin(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func acos(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func atan(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func asinh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func acosh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func atanh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func atan2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int)
    static func fmod(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int)
    static func pow(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int)
}
extension vFORCEElement where Self: ArithmeticElement & ExpressibleByFloatLiteral, FloatLiteralType: BinaryFloatingPoint {
    @inlinable@inline(__always)@_transparent
    public static func sinπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, inc: IA, y: .init(floatLiteral: .pi), z: B, inc: IB, length: N)
        sin(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func cosπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, inc: IA, y: .init(floatLiteral: .pi), z: B, inc: IB, length: N)
        cos(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func tanπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, inc: IA, y: .init(floatLiteral: .pi), z: B, inc: IB, length: N)
        tan(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func pow(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int) {
        log(A, IA, C, IC, N)
        Mul(x: B, inc: IB, y: C, inc: IC, z: C, inc: IC, length: N)
        exp(C, IC, C, IC, N)
    }
    public static func sqrt(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        log(A, IA, B, IB, N)
        Scale(x: B, inc: IB, y: .init(floatLiteral: 1 / 2.0), z: B, inc: IB, length: N)
        exp(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func cbrt(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        log(A, IA, B, IB, N)
        Scale(x: B, inc: IB, y: .init(floatLiteral: 1 / 3.0), z: B, inc: IB, length: N)
        exp(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func exp2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, inc: IA, y: .init(floatLiteral: .init(M_LOG2E)), z: B, inc: IB, length: N)
        exp(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func log2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, inc: IA, y: .init(floatLiteral: .init(M_LN2)), z: B, inc: IB, length: N)
        log(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func exp10(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, inc: IA, y: .init(floatLiteral: .init(M_LOG10E)), z: B, inc: IB, length: N)
        exp(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func log10(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, inc: IA, y: .init(floatLiteral: .init(M_LN10)), z: B, inc: IB, length: N)
        log(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func expm1(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        exp(A, IA, B, IB, N)
        Sub(x: B, inc: IB, y: withUnsafePointer(to: Self(floatLiteral: 1), \.self), inc: 0, z: B, inc: IB, length: N)
    }
    @inlinable@inline(__always)@_transparent
    public static func log1p(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Add(x: B, inc: IB, y: withUnsafePointer(to: Self(floatLiteral: 1), \.self), inc: 0, z: B, inc: IB, length: N)
        exp(A, IA, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func tan(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
            sin(A, IA, B, IB, N)
            cos(A, IA, $0.baseAddress.unsafelyUnwrapped, 1, N)
            Div(x: B, inc: IB, y: $0.baseAddress.unsafelyUnwrapped, inc: 1, z: B, inc: IB, length: N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func tanh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
            sinh(A, IA, B, IB, N)
            cosh(A, IA, $0.baseAddress.unsafelyUnwrapped, 1, N)
            Div(x: B, inc: IB, y: $0.baseAddress.unsafelyUnwrapped, inc: 1, z: B, inc: IB, length: N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func atan2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int) {
        Div(x: A, inc: IA, y: B, inc: IB, z: C, inc: IC, length: N)
        atan(C, IC, C, IC, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func asinh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        FMA(x: A, inc: IA, y: A, inc: IA, z: withUnsafePointer(to: Self(floatLiteral:  1), \.self), inc: 0, w: B, inc: IB, length: N)
        sqrt(B, IB, B, IB, N)
        Add(x: B, inc: IB, y: A, inc: IA, z: B, inc: IB, length: N)
        log(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func acosh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        FMA(x: A, inc: IA, y: A, inc: IA, z: withUnsafePointer(to: Self(floatLiteral: -1), \.self), inc: 0, w: B, inc: IB, length: N)
        sqrt(B, IB, B, IB, N)
        Add(x: B, inc: IB, y: A, inc: IA, z: B, inc: IB, length: N)
        log(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func atanh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
            Add(x: A, inc: IA, y: withUnsafePointer(to: Self(floatLiteral: 1), \.self), inc: 0, z: B, inc: IB, length: N)
            Sub(x: A, inc: IA, y: withUnsafePointer(to: Self(floatLiteral: 1), \.self), inc: 0, z: $0.baseAddress.unsafelyUnwrapped, inc: 0, length: N)
            Div(x: B, inc: IB, y: $0.baseAddress.unsafelyUnwrapped, inc: 1, z: B, inc: IB, length: N)
            log(B, IB, B, IB, N)
            Scale(x: B, inc: IB, y: .init(floatLiteral: 0.5), z: B, inc: IB, length: N)
        }
    }
}
extension Float32: vFORCEElement {
    @inlinable@inline(__always)@_transparent
    static func `do`(_ A: UnsafePointer<Self>, _ IA: Int,
                     _ B: UnsafeMutablePointer<Self>, _ IB: Int,
                     _ N: Int,
                     _ function: @convention(c) (UnsafePointer<Self>, UnsafeMutablePointer<Self>, Int) -> Void) {
        switch (IA, IB) {
        case (0, 0):
            function(A, B, 1)
        case (1, 1):
            function(A, B, N)
        case (let incx, 1):
            Copy(x: A, inc: incx, y: B, inc: 1, length: N)
            function(B, B, N)
        case (1, let incy):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
                function(A, $0.baseAddress.unsafelyUnwrapped, N)
                Copy(x: $0.baseAddress.unsafelyUnwrapped, inc: 1, y: B, inc: incy, length: N)
            }
        case (let incx, let incy):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
                Copy(x: A, inc: incx, y: $0.baseAddress.unsafelyUnwrapped, inc: 1, length: N)
                function($0.baseAddress.unsafelyUnwrapped, $0.baseAddress.unsafelyUnwrapped, N)
                Copy(x: $0.baseAddress.unsafelyUnwrapped, inc: 1, y: B, inc: incy, length: N)
            }
        }
    }
    @inlinable@inline(__always)@_transparent
    static func `do`(_ A: UnsafePointer<Self>, _ IA: Int,
                     _ B: UnsafePointer<Self>, _ IB: Int,
                     _ C: UnsafeMutablePointer<Self>, _ IC: Int,
                     _ N: Int,
                     _ function: @convention(c) (UnsafePointer<Self>, UnsafePointer<Self>, UnsafeMutablePointer<Self>, Int) -> Void) {
        switch (IA, IB, IC) {
        case (0, 0, 0):
            function(A, B, C, 1)
        case (1, 1, 1):
            function(A, B, C, N)
        case (let incx, 1, 1):
            Copy(x: A, inc: incx, y: C, inc: 1, length: N)
            function(C, B, C, N)
        case (1, let incy, 1):
            Copy(x: B, inc: incy, y: C, inc: 1, length: N)
            function(A, C, C, N)
        case (1, 1, let incz):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
                function(A, B, $0.baseAddress.unsafelyUnwrapped, N)
                Copy(x: $0.baseAddress.unsafelyUnwrapped, inc: 1, y: C, inc: incz, length: N)
            }
        case (let incx, 1, let incz):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: 2 * N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                let x = w.advanced(by: N)
                Copy(x: A, inc: incx, y: x, inc: 1, length: N)
                function(x, B, w, N)
                Copy(x: w, inc: 1, y: C, inc: incz, length: N)
            }
        case (1, let incy, let incz):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: 2 * N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                let y = w.advanced(by: N)
                Copy(x: B, inc: incy, y: y, inc: 1, length: N)
                function(A, y, w, N)
                Copy(x: w, inc: 1, y: C, inc: incz, length: N)
            }
        case (let incx, let incy, let incz):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: 3 * N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                let x = w.advanced(by: 1 * N)
                let y = w.advanced(by: 2 * N)
                Copy(x: A, inc: incx, y: x, inc: 1, length: N)
                Copy(x: B, inc: incy, y: y, inc: 1, length: N)
                function(x, y, w, N)
                Copy(x: w, inc: 1, y: C, inc: incz, length: N)
            }
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func fabs(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvfabs)
    }
    @inlinable@inline(__always)@_transparent
    public static func mags(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        vDSP_vsq(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func floor(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvfloor)
    }
    @inlinable@inline(__always)@_transparent
    public static func round(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvnint)
    }
    @inlinable@inline(__always)@_transparent
    public static func ceil(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvceil)
    }
    @inlinable@inline(__always)@_transparent
    public static func sqrt(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvsqrt)
    }
    @inlinable@inline(__always)@_transparent
    public static func cbrt(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvcbrt)
    }
    @inlinable@inline(__always)@_transparent
    public static func exp(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvexp)
    }
    @inlinable@inline(__always)@_transparent
    public static func log(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvlog)
    }
    @inlinable@inline(__always)@_transparent
    public static func exp2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvexp2)
    }
    @inlinable@inline(__always)@_transparent
    public static func log2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvlog2)
    }
//    @inlinable@inline(__always)@_transparent
//    public static func exp10(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
//        `do`(A, IA, B, IB, N, vvexp10)
//    }
    @inlinable@inline(__always)@_transparent
    public static func log10(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvlog10)
    }
    @inlinable@inline(__always)@_transparent
    public static func expm1(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvexpm1)
    }
    @inlinable@inline(__always)@_transparent
    public static func log1p(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvlog1p)
    }
    @inlinable@inline(__always)@_transparent
    public static func sinπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvsinpi)
    }
    @inlinable @inline(__always)
    public static func cosπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvcospi)
    }
    @inlinable@inline(__always)@_transparent
    public static func tanπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvtanpi)
    }
    @inlinable@inline(__always)@_transparent
    public static func sin(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvsin)
    }
    @inlinable@inline(__always)@_transparent
    public static func cos(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvcos)
    }
    @inlinable@inline(__always)@_transparent
    public static func tan(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvtan)
    }
    @inlinable@inline(__always)@_transparent
    public static func sinh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvsinh)
    }
    @inlinable @inline(__always)
    public static func cosh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvcosh)
    }
    @inlinable @inline(__always)
    public static func tanh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvtanh)
    }
    @inlinable@inline(__always)@_transparent
    public static func asin(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvasin)
    }
    @inlinable@inline(__always)@_transparent
    public static func acos(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvacos)
    }
    @inlinable@inline(__always)@_transparent
    public static func atan(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvatan)
    }
    @inlinable@inline(__always)@_transparent
    public static func asinh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvasinh)
    }
    @inlinable@inline(__always)@_transparent
    public static func acosh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvacosh)
    }
    @inlinable@inline(__always)@_transparent
    public static func atanh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvatanh)
    }
    @inlinable@inline(__always)@_transparent
    public static func atan2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int) {
        `do`(A, IA, B, IB, C, IC, N, vvatan2)
    }
    @inlinable@inline(__always)@_transparent
    public static func fmod(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int) {
        `do`(A, IA, B, IB, C, IC, N, vvfmod)
    }
    @inlinable@inline(__always)@_transparent
    public static func pow(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int) {
        `do`(A, IA, B, IB, C, IC, N, vvpow)
    }
}
extension Float64: vFORCEElement {
    @inlinable@inline(__always)@_transparent
    static func `do`(_ A: UnsafePointer<Self>, _ IA: Int,
                     _ B: UnsafeMutablePointer<Self>, _ IB: Int,
                     _ N: Int,
                     _ function: @convention(c) (UnsafePointer<Self>, UnsafeMutablePointer<Self>, Int) -> Void) {
        switch (IA, IB) {
        case (0, 0):
            function(A, B, 1)
        case (1, 1):
            function(A, B, N)
        case (let incx, 1):
            Copy(x: A, inc: incx, y: B, inc: 1, length: N)
            function(B, B, N)
        case (1, let incy):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
                function(A, $0.baseAddress.unsafelyUnwrapped, N)
                Copy(x: $0.baseAddress.unsafelyUnwrapped, inc: 1, y: B, inc: incy, length: N)
            }
        case (let incx, let incy):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
                Copy(x: A, inc: incx, y: $0.baseAddress.unsafelyUnwrapped, inc: 1, length: N)
                function($0.baseAddress.unsafelyUnwrapped, $0.baseAddress.unsafelyUnwrapped, N)
                Copy(x: $0.baseAddress.unsafelyUnwrapped, inc: 1, y: B, inc: incy, length: N)
            }
        }
    }
    @inlinable@inline(__always)@_transparent
    static func `do`(_ A: UnsafePointer<Self>, _ IA: Int,
                     _ B: UnsafePointer<Self>, _ IB: Int,
                     _ C: UnsafeMutablePointer<Self>, _ IC: Int,
                     _ N: Int,
                     _ function: @convention(c) (UnsafePointer<Self>, UnsafePointer<Self>, UnsafeMutablePointer<Self>, Int) -> Void) {
        switch (IA, IB, IC) {
        case (0, 0, 0):
            function(A, B, C, 1)
        case (1, 1, 1):
            function(A, B, C, N)
        case (let incx, 1, 1):
            Copy(x: A, inc: incx, y: C, inc: 1, length: N)
            function(C, B, C, N)
        case (1, let incy, 1):
            Copy(x: B, inc: incy, y: C, inc: 1, length: N)
            function(A, C, C, N)
        case (1, 1, let incz):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
                function(A, B, $0.baseAddress.unsafelyUnwrapped, N)
                Copy(x: $0.baseAddress.unsafelyUnwrapped, inc: 1, y: C, inc: incz, length: N)
            }
        case (let incx, 1, let incz):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: 2 * N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                let x = w.advanced(by: N)
                Copy(x: A, inc: incx, y: x, inc: 1, length: N)
                function(x, B, w, N)
                Copy(x: w, inc: 1, y: C, inc: incz, length: N)
            }
        case (1, let incy, let incz):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: 2 * N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                let y = w.advanced(by: N)
                Copy(x: B, inc: incy, y: y, inc: 1, length: N)
                function(A, y, w, N)
                Copy(x: w, inc: 1, y: C, inc: incz, length: N)
            }
        case (let incx, let incy, let incz):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: 3 * N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                let x = w.advanced(by: 1 * N)
                let y = w.advanced(by: 2 * N)
                Copy(x: A, inc: incx, y: x, inc: 1, length: N)
                Copy(x: B, inc: incy, y: y, inc: 1, length: N)
                function(x, y, w, N)
                Copy(x: w, inc: 1, y: C, inc: incz, length: N)
            }
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func fabs(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvfabs)
    }
    @inlinable@inline(__always)@_transparent
    public static func mags(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        vDSP_vsqD(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func floor(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvfloor)
    }
    @inlinable@inline(__always)@_transparent
    public static func round(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvnint)
    }
    @inlinable@inline(__always)@_transparent
    public static func ceil(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvceil)
    }
    @inlinable@inline(__always)@_transparent
    public static func sqrt(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvsqrt)
    }
    @inlinable@inline(__always)@_transparent
    public static func cbrt(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvcbrt)
    }
    @inlinable@inline(__always)@_transparent
    public static func exp(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvexp)
    }
    @inlinable@inline(__always)@_transparent
    public static func log(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvlog)
    }
    @inlinable@inline(__always)@_transparent
    public static func exp2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvexp2)
    }
    @inlinable@inline(__always)@_transparent
    public static func log2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvlog2)
    }
//    @inlinable@inline(__always)@_transparent
//    public static func exp10(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
//        `do`(A, IA, B, IB, N, vvexp10)
//    }
    @inlinable@inline(__always)@_transparent
    public static func log10(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvlog10)
    }
    @inlinable@inline(__always)@_transparent
    public static func expm1(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvexpm1)
    }
    @inlinable@inline(__always)@_transparent
    public static func log1p(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvlog1p)
    }
    @inlinable@inline(__always)@_transparent
    public static func sinπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvsinpi)
    }
    @inlinable @inline(__always)
    public static func cosπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvcospi)
    }
    @inlinable@inline(__always)@_transparent
    public static func tanπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvtanpi)
    }
    @inlinable@inline(__always)@_transparent
    public static func sin(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvsin)
    }
    @inlinable@inline(__always)@_transparent
    public static func cos(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvcos)
    }
    @inlinable@inline(__always)@_transparent
    public static func tan(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvtan)
    }
    @inlinable@inline(__always)@_transparent
    public static func sinh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvsinh)
    }
    @inlinable @inline(__always)
    public static func cosh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvcosh)
    }
    @inlinable @inline(__always)
    public static func tanh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvtanh)
    }
    @inlinable@inline(__always)@_transparent
    public static func asin(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvasin)
    }
    @inlinable@inline(__always)@_transparent
    public static func acos(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvacos)
    }
    @inlinable@inline(__always)@_transparent
    public static func atan(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvatan)
    }
    @inlinable@inline(__always)@_transparent
    public static func asinh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvasinh)
    }
    @inlinable@inline(__always)@_transparent
    public static func acosh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvacosh)
    }
    @inlinable@inline(__always)@_transparent
    public static func atanh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvatanh)
    }
    @inlinable@inline(__always)@_transparent
    public static func atan2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int) {
        `do`(A, IA, B, IB, C, IC, N, vvatan2)
    }
    @inlinable@inline(__always)@_transparent
    public static func fmod(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int) {
        `do`(A, IA, B, IB, C, IC, N, vvfmod)
    }
    @inlinable@inline(__always)@_transparent
    public static func pow(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int) {
        `do`(A, IA, B, IB, C, IC, N, vvpow)
    }
}
extension Complex64: vFORCEElement {
    @inlinable@inline(__always)@_transparent
    public static func fabs(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        vDSP_abs(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func mags(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        vDSP_mags(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func floor(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        FloatLiteralType.floor(.init(.init(A)).advanced(by: 0), 2 * IA, .init(.init(B)).advanced(by: 0), 2 * IB, N)
        FloatLiteralType.floor(.init(.init(A)).advanced(by: 1), 2 * IA, .init(.init(B)).advanced(by: 1), 2 * IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func round(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        FloatLiteralType.round(.init(.init(A)).advanced(by: 0), 2 * IA, .init(.init(B)).advanced(by: 0), 2 * IB, N)
        FloatLiteralType.round(.init(.init(A)).advanced(by: 1), 2 * IA, .init(.init(B)).advanced(by: 1), 2 * IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func ceil(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        FloatLiteralType.ceil(.init(.init(A)).advanced(by: 0), 2 * IA, .init(.init(B)).advanced(by: 0), 2 * IB, N)
        FloatLiteralType.ceil(.init(.init(A)).advanced(by: 1), 2 * IA, .init(.init(B)).advanced(by: 1), 2 * IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func sqrt(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 6 * N) {
            let edx = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let edy = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let edz = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            let edw = $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N)
            let edr = $0.baseAddress.unsafelyUnwrapped.advanced(by: 4 * N)
            let edi = $0.baseAddress.unsafelyUnwrapped.advanced(by: 5 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, edr, edi, 1, N)
            vDSP_hypot(edr, 1, edi, 1, edx, 1, N)
            vDSP_abs(edr, 1, edy, 1, N)
            vDSP_addsub(edx, 1, edy, 1, edx, 1, edy, 1, N)
            vDSP_mul(edx, 1, 0.5, edx, 1, 2 * N)
            vvsqrt(edx, edx, 2 * N)
            vDSP_fill(0.5, edz, 1, N)
            vvcopysign(edz, edr, edz, N)
            vDSP_add(edz, 1, 0.5, edz, 1, N)
            vDSP_fma(edz, 1, -1, 1, edw, 1, N)
            vDSP_vmma(edx, 1, edw, 1, edy, 1, edz, 1, edr, 1, .init(N))
            vvcopysign(edr, edi, edr, N)
            vDSP_vmma(edy, 1, edw, 1, edx, 1, edz, 1, edi, 1, .init(N))
            vDSP_ztoc(edi, edr, 1, .init(mutating: B.pointer(to: \.rawValue).unsafelyUnwrapped), IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func exp(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        FloatLiteralType.exp(.init(.init(A)), 2 * IA, .init(.init(B)), 2 * IB, N)
        if A != B {
            FloatLiteralType.Copy(x: .init(.init(A)).advanced(by: 1) as UnsafePointer<Magnitude>, inc: 2 * IA,
                                  y: .init(.init(B)).advanced(by: 1) as UnsafeMutablePointer<Magnitude>, inc: 2 * IB,
                                  length: N)
        }
        vDSP_rect(B.pointer(to: \.rawValue).unsafelyUnwrapped, IB,
                  .init(mutating: B.pointer(to: \.rawValue).unsafelyUnwrapped), IB,
                  N)
    }
    @inlinable@inline(__always)@_transparent
    public static func log(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        vDSP_polar(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA,
                   .init(mutating: B.pointer(to: \.rawValue).unsafelyUnwrapped), IB,
                   N)
        FloatLiteralType.log(.init(.init(B)), 2 * IB,
                             .init(.init(B)), 2 * IB,
                             N)
    }
    @inlinable@inline(__always)@_transparent
    public static func sin(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            let edx = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N) // sin(x)
            let edy = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N) // cosh(y)
            let edz = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N) // cos(x)
            let edw = $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N) // sinh(y)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, edx, edy, 1, N)
            vvsincos(edx, edx, edz, N)
            vvsinh(edy, edw, N)
            vvcosh(edy, edy, N)
            vDSP_mul(edx, 1, edy, 1, .init(.init(B)).advanced(by: 0), 2 * IB, N)
            vDSP_mul(edz, 1, edw, 1, .init(.init(B)).advanced(by: 1), 2 * IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func cos(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            let edx = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N) // cos(x)
            let edy = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N) // cosh(y)
            let edz = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N) // sin(x)
            let edw = $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N) // sinh(y)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, edx, edy, 1, N)
            vDSP_neg(edx, 1, edx, 1, N)
            vvsincos(edx, edz, edx, N)
            vvsinh(edy, edw, N)
            vvcosh(edy, edy, N)
            vDSP_mul(edx, 1, edy, 1, .init(.init(B)).advanced(by: 0), 2 * IB, N)
            vDSP_mul(edz, 1, edw, 1, .init(.init(B)).advanced(by: 1), 2 * IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func tan(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            let edx = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let edy = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let edz = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            let edw = $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, edx, edy, 1, N)
            vDSP_mul(edx, 1, 2, edx, 1, 2 * N)
            vvsincos(edx, edz, edw, N)
            vvcosh(edy, edx, N)
            vvsinh(edy, edy, N)
            vDSP_add(edx, 1, edw, 1, edw, 1, N) // cos(2r) + cosh(2i)
            vDSP_div(edz, 1, edw, 1, .init(.init(B)).advanced(by: 0), 2 * IB, N)
            vDSP_div(edy, 1, edw, 1, .init(.init(B)).advanced(by: 1), 2 * IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func sinh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            let edx = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let edy = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let edz = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            let edw = $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, edx, edy, 1, N)
            vvsincos(edy, edw, edz, N)
            vvcosh(edx, edy, N)
            vvsinh(edx, edx, N)
            vDSP_mul(edx, 1, edz, 1, .init(.init(B)).advanced(by: 0), 2 * IB, .init(N))
            vDSP_mul(edy, 1, edw, 1, .init(.init(B)).advanced(by: 1), 2 * IB, .init(N))
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func cosh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            let edx = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let edy = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let edz = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            let edw = $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, edx, edy, 1, N)
            vvsincos(edy, edw, edz, N)
            vvsinh(edx, edy, N)
            vvcosh(edx, edx, N)
            vDSP_mul(edx, 1, edz, 1, .init(.init(B)).advanced(by: 0), 2 * IB, .init(N))
            vDSP_mul(edy, 1, edw, 1, .init(.init(B)).advanced(by: 1), 2 * IB, .init(N))
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func tanh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            let edx = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let edy = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let edz = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            let edw = $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, edx, edy, 1, N)
            vDSP_mul(edx, 1, 2, edx, 1, 2 * N)
            vvsincos(edy, edw, edz, N)
            vvsinh(edx, edy, N)
            vvcosh(edx, edx, N)
            vDSP_add(edx, 1, edz, 1, edz, 1, N)
            vDSP_div(edy, 1, edz, 1, .init(.init(B)).advanced(by: 0), 2 * IB, .init(N))
            vDSP_div(edw, 1, edz, 1, .init(.init(B)).advanced(by: 1), 2 * IB, .init(N))
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func asin(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: FloatLiteralType.self, capacity: 3 * N) {
            let x = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let y = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let z = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, x, z, 1, N)
            vDSP_add(x, 1, -1, y, 1, N)
            vDSP_add(x, 1,  1, x, 1, N)
            vDSP_hypot(x, 1, z, 1, x, 1, N)
            vDSP_hypot(y, 1, z, 1, y, 1, N)
            vDSP_addsub(x, 1, y, 1, y, 1, x, 1, N)
            vDSP_mul(x, 1, 0.5, x, 1, 2 * N)
            vvasin(x, x, N)
            vvacosh(y, y, N)
            vvcopysign(y, z, y, N)
            vDSP_ztoc(x, y, 1, .init(mutating: B.pointer(to: \.rawValue).unsafelyUnwrapped), IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func acos(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: FloatLiteralType.self, capacity: 3 * N) {
            let x = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let y = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let z = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, x, z, 1, N)
            vDSP_add(x, 1, -1, y, 1, N)
            vDSP_add(x, 1,  1, x, 1, N)
            vDSP_hypot(x, 1, z, 1, x, 1, N)
            vDSP_hypot(y, 1, z, 1, y, 1, N)
            vDSP_addsub(x, 1, y, 1, y, 1, x, 1, N)
            vDSP_mul(x, 1, 0.5, x, 1, 2 * N)
            vvacos(x, x, N)
            vvacosh(y, y, N)
            vvcopysign(y, z, y, N)
            vDSP_neg(y, 1, y, 1, N)
            vDSP_ztoc(x, y, 1, .init(mutating: B.pointer(to: \.rawValue).unsafelyUnwrapped), IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func atan(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: FloatLiteralType.self, capacity: 4 * N) {
            let x = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let y = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let z = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, x, y, 1, N)
            vDSP_hypot_zsq(x, y, 1, z, 1, N)
            vDSP_fma(z, 1,  0.5, 0.5, z, 1, N)
            vDSP_div(y, 1, z, 1, y, 1, N)
            vvatanh(y, y, N)
            vDSP_fma(z, 1, -1.0, 1.0, z, 1, N)
            vvatan2(x, z, x, N)
            vDSP_mul(x, 1, 0.5, .init(.init(B)).advanced(by: 0), 2 * IB, N)
            vDSP_mul(y, 1, 0.5, .init(.init(B)).advanced(by: 1), 2 * IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func asinh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: FloatLiteralType.self, capacity: 3 * N) {
            let x = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let y = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let z = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, z, x, 1, N)
            vDSP_add(x, 1, -1, y, 1, N)
            vDSP_add(x, 1,  1, x, 1, N)
            vDSP_hypot(x, 1, z, 1, x, 1, N)
            vDSP_hypot(y, 1, z, 1, y, 1, N)
            vDSP_addsub(x, 1, y, 1, y, 1, x, 1, N)
            vDSP_mul(x, 1, 0.5, x, 1, 2 * N)
            vvasin(x, x, N)
            vvacosh(y, y, N)
            vvcopysign(y, z, y, N)
            vDSP_ztoc(y, x, 1, .init(mutating: B.pointer(to: \.rawValue).unsafelyUnwrapped), IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func acosh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: FloatLiteralType.self, capacity: 3 * N) {
            let x = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let y = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let z = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, x, z, 1, N)
            vDSP_add(x, 1, -1, y, 1, N)
            vDSP_add(x, 1,  1, x, 1, N)
            vDSP_hypot(x, 1, z, 1, x, 1, N)
            vDSP_hypot(y, 1, z, 1, y, 1, N)
            vDSP_addsub(x, 1, y, 1, x, 1, y, 1, N)
            vDSP_mul(x, 1, 0.5, x, 1, 2 * N)
            vvacosh(x, x, N)
            vvacos(y, y, N)
            vvcopysign(y, z, y, N)
            vDSP_ztoc(x, y, 1, .init(mutating: B.pointer(to: \.rawValue).unsafelyUnwrapped), IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func atanh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: FloatLiteralType.self, capacity: 4 * N) {
            let x = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let y = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let z = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, y, x, 1, N)
            vDSP_hypot_zsq(x, y, 1, z, 1, N)
            vDSP_fma(z, 1,  0.5, 0.5, z, 1, N)
            vDSP_div(y, 1, z, 1, y, 1, N)
            vvatanh(y, y, N)
            vDSP_fma(z, 1, -1.0, 1.0, z, 1, N)
            vvatan2(x, z, x, N)
            vDSP_mul(y, 1, 0.5, .init(.init(B)).advanced(by: 0), 2 * IB, N)
            vDSP_mul(x, 1, 0.5, .init(.init(B)).advanced(by: 1), 2 * IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func fmod(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int) {
        FloatLiteralType.fmod(.init(.init(A)).advanced(by: 0), 2 * IA,
                              .init(.init(B)).advanced(by: 0), 2 * IB,
                              .init(.init(C)).advanced(by: 0), 2 * IC,
                              N)
        FloatLiteralType.fmod(.init(.init(A)).advanced(by: 1), 2 * IA,
                              .init(.init(B)).advanced(by: 1), 2 * IB,
                              .init(.init(C)).advanced(by: 1), 2 * IC, N)
    }
}
extension Complex128: vFORCEElement {
    @inlinable@inline(__always)@_transparent
    public static func fabs(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        vDSP_abs(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func mags(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        vDSP_mags(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func floor(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        FloatLiteralType.floor(.init(.init(A)).advanced(by: 0), 2 * IA, .init(.init(B)).advanced(by: 0), 2 * IB, N)
        FloatLiteralType.floor(.init(.init(A)).advanced(by: 1), 2 * IA, .init(.init(B)).advanced(by: 1), 2 * IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func round(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        FloatLiteralType.round(.init(.init(A)).advanced(by: 0), 2 * IA, .init(.init(B)).advanced(by: 0), 2 * IB, N)
        FloatLiteralType.round(.init(.init(A)).advanced(by: 1), 2 * IA, .init(.init(B)).advanced(by: 1), 2 * IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func ceil(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        FloatLiteralType.ceil(.init(.init(A)).advanced(by: 0), 2 * IA, .init(.init(B)).advanced(by: 0), 2 * IB, N)
        FloatLiteralType.ceil(.init(.init(A)).advanced(by: 1), 2 * IA, .init(.init(B)).advanced(by: 1), 2 * IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func sqrt(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 6 * N) {
            let edx = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let edy = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let edz = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            let edw = $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N)
            let edr = $0.baseAddress.unsafelyUnwrapped.advanced(by: 4 * N)
            let edi = $0.baseAddress.unsafelyUnwrapped.advanced(by: 5 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, edr, edi, 1, N)
            vDSP_hypot(edr, 1, edi, 1, edx, 1, N)
            vDSP_abs(edr, 1, edy, 1, N)
            vDSP_addsub(edx, 1, edy, 1, edx, 1, edy, 1, N)
            vDSP_mul(edx, 1, 0.5, edx, 1, 2 * N)
            vvsqrt(edx, edx, 2 * N)
            vDSP_fill(0.5, edz, 1, N)
            vvcopysign(edz, edr, edz, N)
            vDSP_add(edz, 1, 0.5, edz, 1, N)
            vDSP_fma(edz, 1, -1, 1, edw, 1, N)
            vDSP_vmmaD(edx, 1, edw, 1, edy, 1, edz, 1, edr, 1, .init(N))
            vvcopysign(edr, edi, edr, N)
            vDSP_vmmaD(edy, 1, edw, 1, edx, 1, edz, 1, edi, 1, .init(N))
            vDSP_ztoc(edi, edr, 1, .init(mutating: B.pointer(to: \.rawValue).unsafelyUnwrapped), IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func exp(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        FloatLiteralType.exp(.init(.init(A)), 2 * IA, .init(.init(B)), 2 * IB, N)
        if A != B {
            FloatLiteralType.Copy(x: .init(.init(A)).advanced(by: 1) as UnsafePointer<Magnitude>, inc: 2 * IA,
                                  y: .init(.init(B)).advanced(by: 1) as UnsafeMutablePointer<Magnitude>, inc: 2 * IB,
                                  length: N)
        }
        vDSP_rect(B.pointer(to: \.rawValue).unsafelyUnwrapped, IB,
                  .init(mutating: B.pointer(to: \.rawValue).unsafelyUnwrapped), IB,
                  N)
    }
    @inlinable@inline(__always)@_transparent
    public static func log(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        vDSP_polar(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA,
                   .init(mutating: B.pointer(to: \.rawValue).unsafelyUnwrapped), IB,
                   N)
        FloatLiteralType.log(.init(.init(B)), 2 * IB,
                             .init(.init(B)), 2 * IB,
                             N)
    }
    @inlinable@inline(__always)@_transparent
    public static func sin(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            let edx = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N) // sin(x)
            let edy = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N) // cosh(y)
            let edz = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N) // cos(x)
            let edw = $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N) // sinh(y)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, edx, edy, 1, N)
            vvsincos(edx, edx, edz, N)
            vvsinh(edy, edw, N)
            vvcosh(edy, edy, N)
            vDSP_mul(edx, 1, edy, 1, .init(.init(B)).advanced(by: 0), 2 * IB, N)
            vDSP_mul(edz, 1, edw, 1, .init(.init(B)).advanced(by: 1), 2 * IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func cos(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            let edx = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N) // cos(x)
            let edy = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N) // cosh(y)
            let edz = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N) // sin(x)
            let edw = $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N) // sinh(y)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, edx, edy, 1, N)
            vDSP_neg(edx, 1, edx, 1, N)
            vvsincos(edx, edz, edx, N)
            vvsinh(edy, edw, N)
            vvcosh(edy, edy, N)
            vDSP_mul(edx, 1, edy, 1, .init(.init(B)).advanced(by: 0), 2 * IB, N)
            vDSP_mul(edz, 1, edw, 1, .init(.init(B)).advanced(by: 1), 2 * IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func tan(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            let edx = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let edy = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let edz = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            let edw = $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, edx, edy, 1, N)
            vDSP_mul(edx, 1, 2, edx, 1, 2 * N)
            vvsincos(edx, edz, edw, N)
            vvcosh(edy, edx, N)
            vvsinh(edy, edy, N)
            vDSP_add(edx, 1, edw, 1, edw, 1, N) // cos(2r) + cosh(2i)
            vDSP_div(edz, 1, edw, 1, .init(.init(B)).advanced(by: 0), 2 * IB, N)
            vDSP_div(edy, 1, edw, 1, .init(.init(B)).advanced(by: 1), 2 * IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func sinh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            let edx = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let edy = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let edz = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            let edw = $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, edx, edy, 1, N)
            vvsincos(edy, edw, edz, N)
            vvcosh(edx, edy, N)
            vvsinh(edx, edx, N)
            vDSP_mul(edx, 1, edz, 1, .init(.init(B)).advanced(by: 0), 2 * IB, .init(N))
            vDSP_mul(edy, 1, edw, 1, .init(.init(B)).advanced(by: 1), 2 * IB, .init(N))
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func cosh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            let edx = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let edy = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let edz = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            let edw = $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, edx, edy, 1, N)
            vvsincos(edy, edw, edz, N)
            vvsinh(edx, edy, N)
            vvcosh(edx, edx, N)
            vDSP_mul(edx, 1, edz, 1, .init(.init(B)).advanced(by: 0), 2 * IB, .init(N))
            vDSP_mul(edy, 1, edw, 1, .init(.init(B)).advanced(by: 1), 2 * IB, .init(N))
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func tanh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            let edx = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let edy = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let edz = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            let edw = $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, edx, edy, 1, N)
            vDSP_mul(edx, 1, 2, edx, 1, 2 * N)
            vvsincos(edy, edw, edz, N)
            vvsinh(edx, edy, N)
            vvcosh(edx, edx, N)
            vDSP_add(edx, 1, edz, 1, edz, 1, N)
            vDSP_div(edy, 1, edz, 1, .init(.init(B)).advanced(by: 0), 2 * IB, .init(N))
            vDSP_div(edw, 1, edz, 1, .init(.init(B)).advanced(by: 1), 2 * IB, .init(N))
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func asin(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: FloatLiteralType.self, capacity: 3 * N) {
            let x = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let y = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let z = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, x, z, 1, N)
            vDSP_add(x, 1, -1, y, 1, N)
            vDSP_add(x, 1,  1, x, 1, N)
            vDSP_hypot(x, 1, z, 1, x, 1, N)
            vDSP_hypot(y, 1, z, 1, y, 1, N)
            vDSP_addsub(x, 1, y, 1, y, 1, x, 1, N)
            vDSP_mul(x, 1, 0.5, x, 1, 2 * N)
            vvasin(x, x, N)
            vvacosh(y, y, N)
            vvcopysign(y, z, y, N)
            vDSP_ztoc(x, y, 1, .init(mutating: B.pointer(to: \.rawValue).unsafelyUnwrapped), IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func acos(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: FloatLiteralType.self, capacity: 3 * N) {
            let x = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let y = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let z = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, x, z, 1, N)
            vDSP_add(x, 1, -1, y, 1, N)
            vDSP_add(x, 1,  1, x, 1, N)
            vDSP_hypot(x, 1, z, 1, x, 1, N)
            vDSP_hypot(y, 1, z, 1, y, 1, N)
            vDSP_addsub(x, 1, y, 1, y, 1, x, 1, N)
            vDSP_mul(x, 1, 0.5, x, 1, 2 * N)
            vvacos(x, x, N)
            vvacosh(y, y, N)
            vvcopysign(y, z, y, N)
            vDSP_neg(y, 1, y, 1, N)
            vDSP_ztoc(x, y, 1, .init(mutating: B.pointer(to: \.rawValue).unsafelyUnwrapped), IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func atan(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: FloatLiteralType.self, capacity: 4 * N) {
            let x = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let y = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let z = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, x, y, 1, N)
            vDSP_hypot_zsq(x, y, 1, z, 1, N)
            vDSP_fma(z, 1,  0.5, 0.5, z, 1, N)
            vDSP_div(y, 1, z, 1, y, 1, N)
            vvatanh(y, y, N)
            vDSP_fma(z, 1, -1.0, 1.0, z, 1, N)
            vvatan2(x, z, x, N)
            vDSP_mul(x, 1, 0.5, .init(.init(B)).advanced(by: 0), 2 * IB, N)
            vDSP_mul(y, 1, 0.5, .init(.init(B)).advanced(by: 1), 2 * IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func asinh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: FloatLiteralType.self, capacity: 3 * N) {
            let x = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let y = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let z = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, z, x, 1, N)
            vDSP_add(x, 1, -1, y, 1, N)
            vDSP_add(x, 1,  1, x, 1, N)
            vDSP_hypot(x, 1, z, 1, x, 1, N)
            vDSP_hypot(y, 1, z, 1, y, 1, N)
            vDSP_addsub(x, 1, y, 1, y, 1, x, 1, N)
            vDSP_mul(x, 1, 0.5, x, 1, 2 * N)
            vvasin(x, x, N)
            vvacosh(y, y, N)
            vvcopysign(y, z, y, N)
            vDSP_ztoc(y, x, 1, .init(mutating: B.pointer(to: \.rawValue).unsafelyUnwrapped), IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func acosh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: FloatLiteralType.self, capacity: 3 * N) {
            let x = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let y = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let z = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, x, z, 1, N)
            vDSP_add(x, 1, -1, y, 1, N)
            vDSP_add(x, 1,  1, x, 1, N)
            vDSP_hypot(x, 1, z, 1, x, 1, N)
            vDSP_hypot(y, 1, z, 1, y, 1, N)
            vDSP_addsub(x, 1, y, 1, x, 1, y, 1, N)
            vDSP_mul(x, 1, 0.5, x, 1, 2 * N)
            vvacosh(x, x, N)
            vvacos(y, y, N)
            vvcopysign(y, z, y, N)
            vDSP_ztoc(x, y, 1, .init(mutating: B.pointer(to: \.rawValue).unsafelyUnwrapped), IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func atanh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: FloatLiteralType.self, capacity: 4 * N) {
            let x = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N)
            let y = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N)
            let z = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N)
            vDSP_ctoz(A.pointer(to: \.rawValue).unsafelyUnwrapped, IA, y, x, 1, N)
            vDSP_hypot_zsq(x, y, 1, z, 1, N)
            vDSP_fma(z, 1,  0.5, 0.5, z, 1, N)
            vDSP_div(y, 1, z, 1, y, 1, N)
            vvatanh(y, y, N)
            vDSP_fma(z, 1, -1.0, 1.0, z, 1, N)
            vvatan2(x, z, x, N)
            vDSP_mul(y, 1, 0.5, .init(.init(B)).advanced(by: 0), 2 * IB, N)
            vDSP_mul(x, 1, 0.5, .init(.init(B)).advanced(by: 1), 2 * IB, N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func fmod(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int) {
        FloatLiteralType.fmod(.init(.init(A)).advanced(by: 0), 2 * IA,
                              .init(.init(B)).advanced(by: 0), 2 * IB,
                              .init(.init(C)).advanced(by: 0), 2 * IC,
                              N)
        FloatLiteralType.fmod(.init(.init(A)).advanced(by: 1), 2 * IA,
                              .init(.init(B)).advanced(by: 1), 2 * IB,
                              .init(.init(C)).advanced(by: 1), 2 * IC, N)
    }
}
