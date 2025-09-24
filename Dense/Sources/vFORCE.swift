//
//  vFORCE.swift
//  MUSE
//
//  Created by Kota on 9/22/25.
//
import Accelerate.vecLib.vForce
import protocol Numerics.ComplexNumber
import typealias Numerics.Complex64
import typealias Numerics.Complex128
import Darwin
@usableFromInline
enum vFORCE<Element: vFORCESuiteElement & ArithmeticElement & BitwiseCopyable & Sendable> {
    @usableFromInline typealias R = Array<Element>
}
public protocol vFORCESuiteElement: Numeric {
    static func fabs(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int)
    static func mags(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int)
    static func phas(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int)
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
extension vFORCESuiteElement where Self: ArithmeticElement & ExpressibleByFloatLiteral, FloatLiteralType: BinaryFloatingPoint {
    @inlinable@inline(__always)@_transparent
    public static func sinπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, ldx: IA, y: withUnsafePointer(to: Self(floatLiteral: .pi), \.self), z: B, ldz: IB, length: N)
        sin(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func cosπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, ldx: IA, y: withUnsafePointer(to: Self(floatLiteral: .pi), \.self), z: B, ldz: IB, length: N)
        cos(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func tanπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, ldx: IA, y: withUnsafePointer(to: Self(floatLiteral: .pi), \.self), z: B, ldz: IB, length: N)
        tan(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func pow(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int) {
        log(A, IA, C, IC, N)
        Mul(x: B, ldx: IB, y: C, ldy: IC, z: C, ldz: IC, length: N)
        exp(C, IC, C, IC, N)
    }
    public static func sqrt(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        log(A, IA, B, IB, N)
        Scale(x: B, ldx: IB, y: withUnsafePointer(to: Self(floatLiteral: 1 / 2.0), \.self), z: B, ldz: IB, length: N)
        exp(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func cbrt(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        log(A, IA, B, IB, N)
        Scale(x: B, ldx: IB, y: withUnsafePointer(to: Self(floatLiteral: 1 / 3.0), \.self), z: B, ldz: IB, length: N)
        exp(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func exp2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, ldx: IA, y: withUnsafePointer(to: Self(floatLiteral: .init(M_LOG2E)), \.self), z: B, ldz: IB, length: N)
        exp(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func log2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, ldx: IA, y: withUnsafePointer(to: Self(floatLiteral: .init(M_LN2)), \.self), z: B, ldz: IB, length: N)
        log(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func exp10(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, ldx: IA, y: withUnsafePointer(to: Self(floatLiteral: .init(M_LOG10E)), \.self), z: B, ldz: IB, length: N)
        exp(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func log10(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, ldx: IA, y: withUnsafePointer(to: Self(floatLiteral: .init(M_LN10)), \.self), z: B, ldz: IB, length: N)
        log(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func expm1(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        exp(A, IA, B, IB, N)
        Sub(x: B, ldx: IB, y: withUnsafePointer(to: Self(floatLiteral: 1), \.self), ldy: 0, z: B, ldz: IB, length: N)
    }
    @inlinable@inline(__always)@_transparent
    public static func log1p(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Add(x: B, ldx: IB, y: withUnsafePointer(to: Self(floatLiteral: 1), \.self), ldy: 0, z: B, ldz: IB, length: N)
        exp(A, IA, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func tan(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
            sin(A, IA, B, IB, N)
            cos(A, IA, $0.baseAddress.unsafelyUnwrapped, 1, N)
            Div(x: B, ldx: IB, y: $0.baseAddress.unsafelyUnwrapped, ldy: 1, z: B, ldz: IB, length: N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func tanh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
            sinh(A, IA, B, IB, N)
            cosh(A, IA, $0.baseAddress.unsafelyUnwrapped, 1, N)
            Div(x: B, ldx: IB, y: $0.baseAddress.unsafelyUnwrapped, ldy: 1, z: B, ldz: IB, length: N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func atan2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int) {
        Div(x: A, ldx: IA, y: B, ldy: IB, z: C, ldz: IC, length: N)
        atan(C, IC, C, IC, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func asinh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        FMA(x: A, ldx: IA, y: A, ldy: IA, z: withUnsafePointer(to: Self(floatLiteral:  1), \.self), ldz: 0, w: B, ldw: IB, length: N)
        sqrt(B, IB, B, IB, N)
        Add(x: B, ldx: IB, y: A, ldy: IA, z: B, ldz: IB, length: N)
        log(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func acosh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        FMA(x: A, ldx: IA, y: A, ldy: IA, z: withUnsafePointer(to: Self(floatLiteral: -1), \.self), ldz: 0, w: B, ldw: IB, length: N)
        sqrt(B, IB, B, IB, N)
        Add(x: B, ldx: IB, y: A, ldy: IA, z: B, ldz: IB, length: N)
        log(B, IB, B, IB, N)
    }
    @inlinable@inline(__always)@_transparent
    public static func atanh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
            Add(x: A, ldx: IA, y: withUnsafePointer(to: Self(floatLiteral: 1), \.self), ldy: 0, z: B, ldz: IB, length: N)
            Sub(x: A, ldx: IA, y: withUnsafePointer(to: Self(floatLiteral: 1), \.self), ldy: 0, z: $0.baseAddress.unsafelyUnwrapped, ldz: 0, length: N)
            Div(x: B, ldx: IB, y: $0.baseAddress.unsafelyUnwrapped, ldy: 1, z: B, ldz: IB, length: N)
            log(B, IB, B, IB, N)
            Scale(x: B, ldx: IB, y: withUnsafePointer(to: Self(floatLiteral: 0.5), \.self), z: B, ldz: IB, length: N)
        }
    }
}
extension Float32: vFORCESuiteElement {
    @inlinable@inline(__always)@_transparent
    static func `do`(_ A: UnsafePointer<Self>, _ IA: Int,
                     _ B: UnsafeMutablePointer<Self>, _ IB: Int,
                     _ N: Int,
                     _ function: @convention(c) (UnsafeMutablePointer<Self>, UnsafePointer<Self>, UnsafePointer<Int32>) -> Void) {
        switch (IA, IB) {
        case (0, 0):
            function(B, A, withUnsafePointer(to: 1 as Int32, \.self))
        case (1, 1):
            function(B, A, withUnsafePointer(to: Int32(N), \.self))
        case (var incx, 1):
            scopy_(withUnsafePointer(to: N, \.self), A, &incx, B, withUnsafePointer(to: 1, \.self))
            function(B, B, withUnsafePointer(to: Int32(N), \.self))
        case (1, var incy):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                function(w, A, withUnsafePointer(to: Int32(N), \.self))
                scopy_(withUnsafePointer(to: N, \.self), w, withUnsafePointer(to: 1, \.self), B, &incy)
            }
        case (var incx, var incy):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                scopy_(withUnsafePointer(to: N, \.self), A, &incx, w, withUnsafePointer(to: 1, \.self))
                function(w, w, withUnsafePointer(to: Int32(N), \.self))
                scopy_(withUnsafePointer(to: N, \.self), w, withUnsafePointer(to: 1, \.self), B, &incy)
            }
        }
    }
    @inlinable@inline(__always)@_transparent
    static func `do`(_ A: UnsafePointer<Self>, _ IA: Int,
                     _ B: UnsafePointer<Self>, _ IB: Int,
                     _ C: UnsafeMutablePointer<Self>, _ IC: Int,
                     _ N: Int,
                     _ function: @convention(c) (UnsafeMutablePointer<Self>, UnsafePointer<Self>, UnsafePointer<Self>, UnsafePointer<Int32>) -> Void) {
        switch (IA, IB, IC) {
        case (0, 0, 0):
            function(C, A, B, withUnsafePointer(to: 1 as Int32, \.self))
        case (1, 1, 1):
            function(C, A, B, withUnsafePointer(to: Int32(N), \.self))
        case (var incx, 1, 1):
            scopy_(withUnsafePointer(to: N, \.self), A, &incx, C,  withUnsafePointer(to: 1, \.self))
            function(C, C, B, withUnsafePointer(to: Int32(N), \.self))
        case (1, var incy, 1):
            scopy_(withUnsafePointer(to: N, \.self), B, &incy, C,  withUnsafePointer(to: 1, \.self))
            function(C, A, C, withUnsafePointer(to: Int32(N), \.self))
        case (1, 1, var incz):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                function(w, A, B, withUnsafePointer(to: Int32(N), \.self))
                scopy_(withUnsafePointer(to: N, \.self), w, withUnsafePointer(to: 1, \.self), C, &incz)
            }
        case (var incx, 1, var incz):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: 2 * N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                let x = w.advanced(by: N)
                scopy_(withUnsafePointer(to: N, \.self), A, &incx, x, withUnsafePointer(to: 1, \.self))
                function(w, x, B, withUnsafePointer(to: Int32(N), \.self))
                scopy_(withUnsafePointer(to: N, \.self), w, withUnsafePointer(to: 1, \.self), C, &incz)
            }
        case (1, var incy, var incz):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: 2 * N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                let y = w.advanced(by: N)
                scopy_(withUnsafePointer(to: N, \.self), B, &incy, y, withUnsafePointer(to: 1, \.self))
                function(w, A, y, withUnsafePointer(to: Int32(N), \.self))
                scopy_(withUnsafePointer(to: N, \.self), w, withUnsafePointer(to: 1, \.self), C, &incz)
            }
        case (var incx, var incy, var incz):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: 3 * N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                let x = w.advanced(by: 1 * N)
                let y = w.advanced(by: 2 * N)
                scopy_(withUnsafePointer(to: N, \.self), A, &incx, x, withUnsafePointer(to: 1, \.self))
                scopy_(withUnsafePointer(to: N, \.self), B, &incy, y, withUnsafePointer(to: 1, \.self))
                function(w, x, y, withUnsafePointer(to: Int32(N), \.self))
                scopy_(withUnsafePointer(to: N, \.self), w, withUnsafePointer(to: 1, \.self), C, &incz)
            }
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func fabs(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvfabsf)
    }
    @inlinable@inline(__always)@_transparent
    public static func mags(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        vDSP_vsq(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func phas(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        vDSP_vclr(B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func floor(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvfloorf)
    }
    @inlinable@inline(__always)@_transparent
    public static func round(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvnintf)
    }
    @inlinable@inline(__always)@_transparent
    public static func ceil(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvceilf)
    }
    @inlinable@inline(__always)@_transparent
    public static func sqrt(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvsqrtf)
    }
    @inlinable@inline(__always)@_transparent
    public static func cbrt(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvcbrtf)
    }
    @inlinable@inline(__always)@_transparent
    public static func exp(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvlogf)
    }
    @inlinable@inline(__always)@_transparent
    public static func log(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvexpf)
    }
    @inlinable@inline(__always)@_transparent
    public static func exp2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvexp2f)
    }
    @inlinable@inline(__always)@_transparent
    public static func log2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvlog2f)
    }
//    @inlinable@inline(__always)@_transparent
//    public static func exp10(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
//        `do`(A, IA, B, IB, N, vvexp10f)
//    }
    @inlinable@inline(__always)@_transparent
    public static func log10(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvlog10f)
    }
    @inlinable@inline(__always)@_transparent
    public static func expm1(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvexpm1f)
    }
    @inlinable@inline(__always)@_transparent
    public static func log1p(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvlog1pf)
    }
    @inlinable@inline(__always)@_transparent
    public static func sinπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvsinpif)
    }
    @inlinable @inline(__always)
    public static func cosπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvcospif)
    }
    @inlinable@inline(__always)@_transparent
    public static func tanπ(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvtanpif)
    }
    @inlinable@inline(__always)@_transparent
    public static func sin(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvsinf)
    }
    @inlinable@inline(__always)@_transparent
    public static func cos(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvcosf)
    }
    @inlinable@inline(__always)@_transparent
    public static func tan(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvtanf)
    }
    @inlinable@inline(__always)@_transparent
    public static func sinh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvsinhf)
    }
    @inlinable @inline(__always)
    public static func cosh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvcoshf)
    }
    @inlinable @inline(__always)
    public static func tanh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvtanhf)
    }
    @inlinable@inline(__always)@_transparent
    public static func asin(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvasinf)
    }
    @inlinable@inline(__always)@_transparent
    public static func acos(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvacosf)
    }
    @inlinable@inline(__always)@_transparent
    public static func atan(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvatanf)
    }
    @inlinable@inline(__always)@_transparent
    public static func asinh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvasinhf)
    }
    @inlinable@inline(__always)@_transparent
    public static func acosh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvacoshf)
    }
    @inlinable@inline(__always)@_transparent
    public static func atanh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvatanhf)
    }
    @inlinable@inline(__always)@_transparent
    public static func atan2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int) {
        `do`(A, IA, B, IB, C, IC, N, vvatan2f)
    }
    @inlinable@inline(__always)@_transparent
    public static func fmod(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int) {
        `do`(A, IA, B, IB, C, IC, N, vvfmodf)
    }
    @inlinable@inline(__always)@_transparent
    public static func pow(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int) {
        `do`(A, IA, B, IB, C, IC, N, vvpowf)
    }
}
extension Float64: vFORCESuiteElement {
    @inlinable@inline(__always)@_transparent
    static func `do`(_ A: UnsafePointer<Self>, _ IA: Int,
                     _ B: UnsafeMutablePointer<Self>, _ IB: Int,
                     _ N: Int,
                     _ function: @convention(c) (UnsafeMutablePointer<Self>, UnsafePointer<Self>, UnsafePointer<Int32>) -> Void) {
        switch (IA, IB) {
        case (0, 0):
            function(B, A, withUnsafePointer(to: 1 as Int32, \.self))
        case (1, 1):
            function(B, A, withUnsafePointer(to: Int32(N), \.self))
        case (var incx, 1):
            dcopy_(withUnsafePointer(to: N, \.self), A, &incx, B, withUnsafePointer(to: 1, \.self))
            function(B, B, withUnsafePointer(to: Int32(N), \.self))
        case (1, var incy):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                function(w, A, withUnsafePointer(to: Int32(N), \.self))
                dcopy_(withUnsafePointer(to: N, \.self), w, withUnsafePointer(to: 1, \.self), B, &incy)
            }
        case (var incx, var incy):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                dcopy_(withUnsafePointer(to: N, \.self), A, &incx, w, withUnsafePointer(to: 1, \.self))
                function(w, w, withUnsafePointer(to: Int32(N), \.self))
                dcopy_(withUnsafePointer(to: N, \.self), w, withUnsafePointer(to: 1, \.self), B, &incy)
            }
        }
    }
    @inlinable@inline(__always)@_transparent
    static func `do`(_ A: UnsafePointer<Self>, _ IA: Int,
                     _ B: UnsafePointer<Self>, _ IB: Int,
                     _ C: UnsafeMutablePointer<Self>, _ IC: Int,
                     _ N: Int,
                     _ function: @convention(c) (UnsafeMutablePointer<Self>, UnsafePointer<Self>, UnsafePointer<Self>, UnsafePointer<Int32>) -> Void) {
        switch (IA, IB, IC) {
        case (0, 0, 0):
            function(C, A, B, withUnsafePointer(to: 1 as Int32, \.self))
        case (1, 1, 1):
            function(C, A, B, withUnsafePointer(to: Int32(N), \.self))
        case (var incx, 1, 1):
            dcopy_(withUnsafePointer(to: N, \.self), A, &incx, C,  withUnsafePointer(to: 1, \.self))
            function(C, C, B, withUnsafePointer(to: Int32(N), \.self))
        case (1, var incy, 1):
            dcopy_(withUnsafePointer(to: N, \.self), B, &incy, C,  withUnsafePointer(to: 1, \.self))
            function(C, A, C, withUnsafePointer(to: Int32(N), \.self))
        case (1, 1, var incz):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                function(w, A, B, withUnsafePointer(to: Int32(N), \.self))
                dcopy_(withUnsafePointer(to: N, \.self), w, withUnsafePointer(to: 1, \.self), C, &incz)
            }
        case (var incx, 1, var incz):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: 2 * N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                let x = w.advanced(by: N)
                dcopy_(withUnsafePointer(to: N, \.self), A, &incx, x, withUnsafePointer(to: 1, \.self))
                function(w, x, B, withUnsafePointer(to: Int32(N), \.self))
                dcopy_(withUnsafePointer(to: N, \.self), w, withUnsafePointer(to: 1, \.self), C, &incz)
            }
        case (1, var incy, var incz):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: 2 * N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                let y = w.advanced(by: N)
                dcopy_(withUnsafePointer(to: N, \.self), B, &incy, y, withUnsafePointer(to: 1, \.self))
                function(w, A, y, withUnsafePointer(to: Int32(N), \.self))
                dcopy_(withUnsafePointer(to: N, \.self), w, withUnsafePointer(to: 1, \.self), C, &incz)
            }
        case (var incx, var incy, var incz):
            withUnsafeTemporaryAllocation(of: Self.self, capacity: 3 * N) {
                let w = $0.baseAddress.unsafelyUnwrapped
                let x = w.advanced(by: 1 * N)
                let y = w.advanced(by: 2 * N)
                dcopy_(withUnsafePointer(to: N, \.self), A, &incx, x, withUnsafePointer(to: 1, \.self))
                dcopy_(withUnsafePointer(to: N, \.self), B, &incy, y, withUnsafePointer(to: 1, \.self))
                function(w, x, y, withUnsafePointer(to: Int32(N), \.self))
                dcopy_(withUnsafePointer(to: N, \.self), w, withUnsafePointer(to: 1, \.self), C, &incz)
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
    public static func phas(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        vDSP_vclrD(B, IB, .init(N))
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
        `do`(A, IA, B, IB, N, vvlog)
    }
    @inlinable@inline(__always)@_transparent
    public static func log(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvexp)
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
    @inlinable@inline(__always)@_transparent
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
    @inlinable@inline(__always)@_transparent
    public static func cosh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvcosh)
    }
    @inlinable@inline(__always)@_transparent
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
extension Complex64: vFORCESuiteElement {
    @inlinable@inline(__always)@_transparent
    public static func fabs(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        var z = SplitComplex(realp: .init(.init(A)).advanced(by: 0),
                             imagp: .init(.init(B)).advanced(by: 1))
        vDSP_zvabs(&z, 2 * IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func mags(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        var z = SplitComplex(realp: .init(.init(A)).advanced(by: 0),
                             imagp: .init(.init(B)).advanced(by: 1))
        vDSP_zvmags(&z, 2 * IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func phas(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        var z = SplitComplex(realp: .init(.init(A)).advanced(by: 0),
                             imagp: .init(.init(B)).advanced(by: 1))
        vDSP_zvphas(&z, 2 * IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func floor(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        if (IA, IB) == (1, 1) {
            vvfloorf(.init(.init(B)), .init(.init(A)), withUnsafePointer(to: Int32(2 * N), \.self))
        } else if IB == 1 {
            ccopy_(withUnsafePointer(to: N, \.self),
                   .init(.init(A)), withUnsafePointer(to: IA, \.self),
                   .init(.init(B)), withUnsafePointer(to: IB, \.self))
            vvfloorf(.init(.init(B)), .init(.init(A)), withUnsafePointer(to: Int32(2 * N), \.self))
        } else {
            withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 2 * N) {
                var z = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N),
                                     imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N))
                vDSP_ctoz(.init(.init(A)), 2 * IA, &z, 1, .init(N))
                vvfloorf($0.baseAddress.unsafelyUnwrapped, $0.baseAddress.unsafelyUnwrapped, withUnsafePointer(to: Int32(2 * N), \.self))
                vDSP_ztoc(&z, 1, .init(.init(B)), 2 * IB, .init(N))
            }
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func round(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        if (IA, IB) == (1, 1) {
            vvnintf(.init(.init(B)), .init(.init(A)), withUnsafePointer(to: Int32(2 * N), \.self))
        } else if IB == 1 {
            ccopy_(withUnsafePointer(to: N, \.self),
                   .init(.init(A)), withUnsafePointer(to: IA, \.self),
                   .init(.init(B)), withUnsafePointer(to: IB, \.self))
            vvnintf(.init(.init(B)), .init(.init(A)), withUnsafePointer(to: Int32(2 * N), \.self))
        } else {
            withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 2 * N) {
                var z = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N),
                                     imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N))
                vDSP_ctoz(.init(.init(A)), 2 * IA, &z, 1, .init(N))
                vvnintf($0.baseAddress.unsafelyUnwrapped, $0.baseAddress.unsafelyUnwrapped, withUnsafePointer(to: Int32(2 * N), \.self))
                vDSP_ztoc(&z, 1, .init(.init(B)), 2 * IB, .init(N))
            }
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func ceil(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        if (IA, IB) == (1, 1) {
            vvceilf(.init(.init(B)), .init(.init(A)), withUnsafePointer(to: Int32(2 * N), \.self))
        } else if IB == 1 {
            ccopy_(withUnsafePointer(to: N, \.self),
                   .init(.init(A)), withUnsafePointer(to: IA, \.self),
                   .init(.init(B)), withUnsafePointer(to: IB, \.self))
            vvceilf(.init(.init(B)), .init(.init(A)), withUnsafePointer(to: Int32(2 * N), \.self))
        } else {
            withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 2 * N) {
                var z = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N),
                                     imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N))
                vDSP_ctoz(.init(.init(A)), 2 * IA, &z, 1, .init(N))
                vvceilf($0.baseAddress.unsafelyUnwrapped, $0.baseAddress.unsafelyUnwrapped, withUnsafePointer(to: Int32(2 * N), \.self))
                vDSP_ztoc(&z, 1, .init(.init(B)), 2 * IB, .init(N))
            }
        }
    }
    @inlinable//@inline(__always)@_transparent // crash swiftc
    public static func exp(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: N) {
            cblas_scopy(N, .init(.init(A)), 2 * IA, $0.baseAddress, 1)
            vvexpf($0.baseAddress.unsafelyUnwrapped, $0.baseAddress.unsafelyUnwrapped, withUnsafePointer(to: Int32(N), \.self))
            cblas_scopy(N, $0.baseAddress, 1, .init(.init(B)), 2 * IB)
            cblas_scopy(N, .init(.init(A)).advanced(by: 1), 2 * IA, .init(.init(B)).advanced(by: 1), 2 * IB)
            vDSP_rect(.init(.init(B)), 2 * IB, .init(.init(B)), 2 * IB, .init(N))
        }
    }
    @inlinable//@inline(__always)@_transparent // crash swiftc
    public static func log(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: N) {
            vDSP_polar(.init(.init(A)), 2 * IA, .init(.init(B)), 2 * IB, .init(N))
            cblas_scopy(N, B.withMemoryRebound(to: Magnitude.self, capacity: 2 * IB * N, \.self), 2 * IB, $0.baseAddress, 1)
            vvlogf($0.baseAddress.unsafelyUnwrapped, $0.baseAddress.unsafelyUnwrapped, withUnsafePointer(to: Int32(N), \.self))
            cblas_scopy(N, $0.baseAddress, 1, B.withMemoryRebound(to: Magnitude.self, capacity: 2 * IB * N, \.self), 2 * IB)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func sin(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            var Z = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N),
                                 imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N))
            vDSP_ctoz(.init(.init(A)), 2 * IA, &Z, 1, .init(N))
            vvsincosf($0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N),
                      $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N),
                      $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), withUnsafePointer(to: Int32(N), \.self))
            vvcoshf($0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N),
                    $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), withUnsafePointer(to: Int32(N), \.self))
            vvsinhf($0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N),
                    $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), withUnsafePointer(to: Int32(N), \.self))
            vDSP_vmul($0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N), 1,
                      $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), 1,
                      .init(.init(B)).advanced(by: 0), 2 * IB, .init(N))
            vDSP_vmul($0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N), 1,
                      $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), 1,
                      .init(.init(B)).advanced(by: 1), 2 * IB, .init(N))
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func cos(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            var Z = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N),
                                 imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N))
            vDSP_ctoz(.init(.init(A)), 2 * IA, &Z, 1, .init(N))
            vDSP_vneg($0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), 1,
                      $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), 1, .init(N))
            vvsincosf($0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N),
                      $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N),
                      $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), withUnsafePointer(to: Int32(N), \.self))
            vvcoshf($0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N),
                    $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), withUnsafePointer(to: Int32(N), \.self))
            vvsinhf($0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N),
                    $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), withUnsafePointer(to: Int32(N), \.self))
            vDSP_vmul($0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N), 1,
                      $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), 1,
                      .init(.init(B)).advanced(by: 0), 2 * IB, .init(N))
            vDSP_vmul($0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N), 1,
                      $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), 1,
                      .init(.init(B)).advanced(by: 1), 2 * IB, .init(N))
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func sinh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            var Z = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N),
                                 imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N))
            vDSP_ctoz(.init(.init(A)), 2 * IA, &Z, 1, .init(N))
            vvsincosf($0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N),
                      $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N),
                      $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), withUnsafePointer(to: Int32(N), \.self))
            vvsinhf($0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N),
                    $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), withUnsafePointer(to: Int32(N), \.self))
            vvcoshf($0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N),
                    $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), withUnsafePointer(to: Int32(N), \.self))
            vDSP_vmul($0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N), 1,
                      $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), 1,
                      .init(.init(B)).advanced(by: 0), 2 * IB, .init(N))
            vDSP_vmul($0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N), 1,
                      $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), 1,
                      .init(.init(B)).advanced(by: 1), 2 * IB, .init(N))
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func cosh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            var Z = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N),
                                 imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N))
            vDSP_ctoz(.init(.init(A)), 2 * IA, &Z, 1, .init(N))
            vvsincosf($0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N),
                      $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N),
                      $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), withUnsafePointer(to: Int32(N), \.self))
            vvcoshf($0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N),
                    $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), withUnsafePointer(to: Int32(N), \.self))
            vvsinhf($0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N),
                    $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), withUnsafePointer(to: Int32(N), \.self))
            vDSP_vmul($0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N), 1,
                      $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), 1,
                      .init(.init(B)).advanced(by: 0), 2 * IB, .init(N))
            vDSP_vmul($0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N), 1,
                      $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), 1,
                      .init(.init(B)).advanced(by: 1), 2 * IB, .init(N))
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func asin(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, ldx: IA, y: withUnsafePointer(to: -1 as Self, \.self), z: B, ldz: IB, length: N)
        FMA(x: A, ldx: IA, y: B, ldy: IB, z: withUnsafePointer(to: 1 as Self, \.self), ldz: 0, w: B, ldw: IB, length: N)
        sqrt(B, IB, B, IB, N)
        FMA(x: withUnsafePointer(to: Self(real: 0, imag: 1), \.self), ldx: 0, y: A, ldy: IA, z: B, ldz: IB, w: B, ldw: IB, length: N)
        log(B, IB, B, IB, N)
        Scale(x: B, ldx: IB, y: withUnsafePointer(to: Self(real: 0, imag: -1), \.self), z: B, ldz: IB, length: N)
    }
    @inlinable@inline(__always)@_transparent
    public static func acos(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, ldx: IA, y: withUnsafePointer(to: -1 as Self, \.self), z: B, ldz: IB, length: N)
        FMA(x: A, ldx: IA, y: B, ldy: IB, z: withUnsafePointer(to: 1 as Self, \.self), ldz: 0, w: B, ldw: IB, length: N)
        sqrt(B, IB, B, IB, N)
        FMA(x: withUnsafePointer(to: Self(real: 0, imag: 1), \.self), ldx: 0, y: B, ldy: IB, z: A, ldz: IA, w: B, ldw: IB, length: N)
        log(B, IB, B, IB, N)
        Scale(x: B, ldx: IB, y: withUnsafePointer(to: Self(real: 0, imag: -1), \.self), z: B, ldz: IB, length: N)
    }
    @inlinable@inline(__always)@_transparent
    public static func atan(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
            Add(x: withUnsafePointer(to: Self.i, \.self), ldx: 0, y: A, ldy: IA, z: B, ldz: IB, length: N)
            Sub(x: withUnsafePointer(to: Self.i, \.self), ldx: 0, y: A, ldy: IA, z: $0.baseAddress.unsafelyUnwrapped, ldz: 1, length: N)
            Div(x: B, ldx: IB, y: $0.baseAddress.unsafelyUnwrapped, ldy: 1, z: B, ldz: IB, length: N)
            log(B, IB, B, IB, N)
            Scale(x: B, ldx: IB, y: withUnsafePointer(to: Self(real: 0, imag: 0.5), \.self), z: B, ldz: IB, length: N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func fmod(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int) {
        if (IA, IB, IC) == (1, 1, 1) {
            vvfmodf(.init(.init(C)), .init(.init(A)), .init(.init(B)), withUnsafePointer(to: Int32(N), \.self))
        } else {
            withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
                var x = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N),
                                     imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N))
                var y = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N),
                                     imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N))
                vDSP_ctoz(.init(.init(A)), 2 * IA, &x, 1, .init(N))
                vDSP_ctoz(.init(.init(B)), 2 * IB, &y, 1, .init(N))
                vvfmodf($0.baseAddress.unsafelyUnwrapped,
                        $0.baseAddress.unsafelyUnwrapped,
                        $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N),
                        withUnsafePointer(to: Int32(2 * N), \.self))
                vDSP_ztoc(&x, 1, .init(.init(C)), 2 * IC, .init(N))
            }
        }
    }
}
extension Complex128: vFORCESuiteElement {
    @inlinable@inline(__always)@_transparent
    public static func fabs(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        var z = SplitComplex(realp: .init(.init(A)).advanced(by: 0),
                             imagp: .init(.init(B)).advanced(by: 1))
        vDSP_zvabsD(&z, 2 * IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func mags(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        var z = SplitComplex(realp: .init(.init(A)).advanced(by: 0),
                             imagp: .init(.init(B)).advanced(by: 1))
        vDSP_zvmagsD(&z, 2 * IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func phas(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Magnitude>, _ IB: Int, _ N: Int) {
        var z = SplitComplex(realp: .init(.init(A)).advanced(by: 0),
                             imagp: .init(.init(B)).advanced(by: 1))
        vDSP_zvphasD(&z, 2 * IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func floor(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        if (IA, IB) == (1, 1) {
            vvfloor(.init(.init(B)), .init(.init(A)), withUnsafePointer(to: Int32(2 * N), \.self))
        } else if IB == 1 {
            zcopy_(withUnsafePointer(to: N, \.self),
                   .init(.init(A)), withUnsafePointer(to: IA, \.self),
                   .init(.init(B)), withUnsafePointer(to: IB, \.self))
            vvfloor(.init(.init(B)), .init(.init(A)), withUnsafePointer(to: Int32(2 * N), \.self))
        } else {
            withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 2 * N) {
                var z = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N),
                                     imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N))
                vDSP_ctozD(.init(.init(A)), 2 * IA, &z, 1, .init(N))
                vvfloor($0.baseAddress.unsafelyUnwrapped, $0.baseAddress.unsafelyUnwrapped, withUnsafePointer(to: Int32(2 * N), \.self))
                vDSP_ztocD(&z, 1, .init(.init(B)), 2 * IB, .init(N))
            }
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func round(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        if (IA, IB) == (1, 1) {
            vvnint(.init(.init(B)), .init(.init(A)), withUnsafePointer(to: Int32(2 * N), \.self))
        } else if IB == 1 {
            zcopy_(withUnsafePointer(to: N, \.self),
                   .init(.init(A)), withUnsafePointer(to: IA, \.self),
                   .init(.init(B)), withUnsafePointer(to: IB, \.self))
            vvnint(.init(.init(B)), .init(.init(A)), withUnsafePointer(to: Int32(2 * N), \.self))
        } else {
            withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 2 * N) {
                var z = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N),
                                     imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N))
                vDSP_ctozD(.init(.init(A)), 2 * IA, &z, 1, .init(N))
                vvnint($0.baseAddress.unsafelyUnwrapped, $0.baseAddress.unsafelyUnwrapped, withUnsafePointer(to: Int32(2 * N), \.self))
                vDSP_ztocD(&z, 1, .init(.init(B)), 2 * IB, .init(N))
            }
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func ceil(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        if (IA, IB) == (1, 1) {
            vvceil(.init(.init(B)), .init(.init(A)), withUnsafePointer(to: Int32(2 * N), \.self))
        } else if IB == 1 {
            zcopy_(withUnsafePointer(to: N, \.self),
                   .init(.init(A)), withUnsafePointer(to: IA, \.self),
                   .init(.init(B)), withUnsafePointer(to: IB, \.self))
            vvceil(.init(.init(B)), .init(.init(A)), withUnsafePointer(to: Int32(2 * N), \.self))
        } else {
            withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 2 * N) {
                var z = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N),
                                     imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N))
                vDSP_ctozD(.init(.init(A)), 2 * IA, &z, 1, .init(N))
                vvceil($0.baseAddress.unsafelyUnwrapped, $0.baseAddress.unsafelyUnwrapped, withUnsafePointer(to: Int32(2 * N), \.self))
                vDSP_ztocD(&z, 1, .init(.init(B)), 2 * IB, .init(N))
            }
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func exp(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: N) {
            cblas_dcopy(N, .init(.init(A)), 2 * IA, $0.baseAddress, 1)
            vvexp($0.baseAddress.unsafelyUnwrapped, $0.baseAddress.unsafelyUnwrapped, withUnsafePointer(to: Int32(N), \.self))
            cblas_dcopy(N, $0.baseAddress, 1, .init(.init(B)), 2 * IB)
            cblas_dcopy(N, .init(.init(A)).advanced(by: 1), 2 * IA, .init(.init(B)).advanced(by: 1), 2 * IB)
            vDSP_rectD(.init(.init(B)), 2 * IB, .init(.init(B)), 2 * IB, .init(N))
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func log(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: N) {
            vDSP_polarD(.init(.init(A)), 2 * IA, .init(.init(B)), 2 * IB, .init(N))
            cblas_dcopy(N, B.withMemoryRebound(to: Magnitude.self, capacity: 2 * IB * N, \.self), 2 * IB, $0.baseAddress, 1)
            vvlog($0.baseAddress.unsafelyUnwrapped, $0.baseAddress.unsafelyUnwrapped, withUnsafePointer(to: Int32(N), \.self))
            cblas_dcopy(N, $0.baseAddress, 1, B.withMemoryRebound(to: Magnitude.self, capacity: 2 * IB * N, \.self), 2 * IB)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func sin(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            var Z = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N),
                                 imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N))
            vDSP_ctozD(.init(.init(A)), 2 * IA, &Z, 1, .init(N))
            vvsincos($0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N),
                     $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N),
                     $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), withUnsafePointer(to: Int32(N), \.self))
            vvcosh($0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N),
                   $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), withUnsafePointer(to: Int32(N), \.self))
            vvsinh($0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N),
                   $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), withUnsafePointer(to: Int32(N), \.self))
            vDSP_vmulD($0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N), 1,
                       $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), 1,
                       .init(.init(B)).advanced(by: 0), 2 * IB, .init(N))
            vDSP_vmulD($0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N), 1,
                       $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), 1,
                       .init(.init(B)).advanced(by: 1), 2 * IB, .init(N))
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func cos(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            var Z = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N),
                                 imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N))
            vDSP_ctozD(.init(.init(A)), 2 * IA, &Z, 1, .init(N))
            vDSP_vnegD($0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), 1,
                       $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), 1, .init(N))
            vvsincos($0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N),
                     $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N),
                     $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), withUnsafePointer(to: Int32(N), \.self))
            vvcosh($0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N),
                   $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), withUnsafePointer(to: Int32(N), \.self))
            vvsinh($0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N),
                   $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), withUnsafePointer(to: Int32(N), \.self))
            vDSP_vmulD($0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N), 1,
                       $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), 1,
                       .init(.init(B)).advanced(by: 0), 2 * IB, .init(N))
            vDSP_vmulD($0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N), 1,
                       $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), 1,
                       .init(.init(B)).advanced(by: 1), 2 * IB, .init(N))
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func sinh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            var Z = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N),
                                 imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N))
            vDSP_ctozD(.init(.init(A)), 2 * IA, &Z, 1, .init(N))
            vvsincos($0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N),
                     $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N),
                     $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), withUnsafePointer(to: Int32(N), \.self))
            vvsinh($0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N),
                   $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), withUnsafePointer(to: Int32(N), \.self))
            vvcosh($0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N),
                   $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), withUnsafePointer(to: Int32(N), \.self))
            vDSP_vmulD($0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N), 1,
                       $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), 1,
                       .init(.init(B)).advanced(by: 0), 2 * IB, .init(N))
            vDSP_vmulD($0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N), 1,
                       $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), 1,
                       .init(.init(B)).advanced(by: 1), 2 * IB, .init(N))
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func cosh(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
            var Z = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N),
                                 imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N))
            vDSP_ctozD(.init(.init(A)), 2 * IA, &Z, 1, .init(N))
            vvsincos($0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N),
                     $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N),
                     $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), withUnsafePointer(to: Int32(N), \.self))
            vvcosh($0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N),
                   $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), withUnsafePointer(to: Int32(N), \.self))
            vvsinh($0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N),
                   $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), withUnsafePointer(to: Int32(N), \.self))
            vDSP_vmulD($0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N), 1,
                       $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N), 1,
                       .init(.init(B)).advanced(by: 0), 2 * IB, .init(N))
            vDSP_vmulD($0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N), 1,
                       $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N), 1,
                       .init(.init(B)).advanced(by: 1), 2 * IB, .init(N))
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func asin(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, ldx: IA, y: withUnsafePointer(to: -1 as Self, \.self), z: B, ldz: IB, length: N)
        FMA(x: A, ldx: IA, y: B, ldy: IB, z: withUnsafePointer(to: 1 as Self, \.self), ldz: 0, w: B, ldw: IB, length: N)
        sqrt(B, IB, B, IB, N)
        FMA(x: withUnsafePointer(to: Self(real: 0, imag: 1), \.self), ldx: 0, y: A, ldy: IA, z: B, ldz: IB, w: B, ldw: IB, length: N)
        log(B, IB, B, IB, N)
        Scale(x: B, ldx: IB, y: withUnsafePointer(to: Self(real: 0, imag: -1), \.self), z: B, ldz: IB, length: N)
    }
    @inlinable@inline(__always)@_transparent
    public static func acos(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        Scale(x: A, ldx: IA, y: withUnsafePointer(to: -1 as Self, \.self), z: B, ldz: IB, length: N)
        FMA(x: A, ldx: IA, y: B, ldy: IB, z: withUnsafePointer(to: 1 as Self, \.self), ldz: 0, w: B, ldw: IB, length: N)
        sqrt(B, IB, B, IB, N)
        FMA(x: withUnsafePointer(to: Self(real: 0, imag: 1), \.self), ldx: 0, y: B, ldy: IB, z: A, ldz: IA, w: B, ldw: IB, length: N)
        log(B, IB, B, IB, N)
        Scale(x: B, ldx: IB, y: withUnsafePointer(to: Self(real: 0, imag: -1), \.self), z: B, ldz: IB, length: N)
    }
    @inlinable@inline(__always)@_transparent
    public static func atan(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        withUnsafeTemporaryAllocation(of: Self.self, capacity: N) {
            Add(x: withUnsafePointer(to: Self.i, \.self), ldx: 0, y: A, ldy: IA, z: B, ldz: IB, length: N)
            Sub(x: withUnsafePointer(to: Self.i, \.self), ldx: 0, y: A, ldy: IA, z: $0.baseAddress.unsafelyUnwrapped, ldz: 1, length: N)
            Div(x: B, ldx: IB, y: $0.baseAddress.unsafelyUnwrapped, ldy: 1, z: B, ldz: IB, length: N)
            log(B, IB, B, IB, N)
            Scale(x: B, ldx: IB, y: withUnsafePointer(to: Self(real: 0, imag: 0.5), \.self), z: B, ldz: IB, length: N)
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func fmod(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafePointer<Self>, _ IB: Int, _ C: UnsafeMutablePointer<Self>, _ IC: Int, _ N: Int) {
        if (IA, IB, IC) == (1, 1, 1) {
            vvfmodf(.init(.init(C)), .init(.init(A)), .init(.init(B)), withUnsafePointer(to: Int32(N), \.self))
        } else {
            withUnsafeTemporaryAllocation(of: Magnitude.self, capacity: 4 * N) {
                var x = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 0 * N),
                                     imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 1 * N))
                var y = SplitComplex(realp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N),
                                     imagp: $0.baseAddress.unsafelyUnwrapped.advanced(by: 3 * N))
                vDSP_ctozD(.init(.init(A)), 2 * IA, &x, 1, .init(N))
                vDSP_ctozD(.init(.init(B)), 2 * IB, &y, 1, .init(N))
                vvfmod($0.baseAddress.unsafelyUnwrapped,
                       $0.baseAddress.unsafelyUnwrapped,
                       $0.baseAddress.unsafelyUnwrapped.advanced(by: 2 * N),
                       withUnsafePointer(to: Int32(2 * N), \.self))
                vDSP_ztocD(&x, 1, .init(.init(C)), 2 * IC, .init(N))
            }
        }
    }
}
