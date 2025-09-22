//
//  vFORCE.swift
//  MUSE
//
//  Created by Kota on 9/22/25.
//
import Accelerate.vecLib.vForce
@usableFromInline
enum vFORCE<Element: vFORCESuiteElement & ArithmeticElement & BitwiseCopyable & Sendable> {
    @usableFromInline typealias R = Array<Element>
}
public protocol vFORCESuiteElement {
    static func fabs(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func floor(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func ceil(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func sqrt(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func cbrt(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func exp(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func log(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func exp2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func log2(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
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
    public static func fabs(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvfabsf)
    }
    @inlinable@inline(__always)@_transparent
    public static func floor(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvfloorf)
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
    public static func fabs(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvfabs)
    }
    @inlinable@inline(__always)@_transparent
    public static func floor(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        `do`(A, IA, B, IB, N, vvfloor)
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
