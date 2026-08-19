//
//  Arithmetic.swift
//  MUSE
//
//  Created by Kota on 8/18/26.
//
import MKL
import func BLAS.copy
import typealias Numerics.Complex64
import typealias Numerics.Complex128
public protocol ArithmeticElement: Numeric {
    @inlinable@inline(__always)
    static func Zero(x: UnsafeMutablePointer<Self>, inc: Int, length: Int)
    @inlinable@inline(__always)
    static func Fill(x: Self, y: UnsafeMutablePointer<Self>, inc: Int, length: Int)
    @inlinable@inline(__always)
    static func Copy(x: UnsafePointer<Self>, inc: Int, y: UnsafeMutablePointer<Self>, inc: Int, length: Int)
    @inlinable@inline(__always)
    static func Scale(x: UnsafePointer<Self>, inc: Int, y: Self, z: UnsafeMutablePointer<Self>, inc: Int, length: Int)
    @inlinable@inline(__always)
    static func Neg(x: UnsafePointer<Self>, inc: Int, y: UnsafeMutablePointer<Self>, inc: Int, length: Int)
    @inlinable@inline(__always)
    static func Mul(x: UnsafePointer<Self>, inc: Int, y: UnsafePointer<Self>, inc: Int, z: UnsafeMutablePointer<Self>, inc: Int, length: Int)
    @inlinable@inline(__always)
    static func Div(x: UnsafePointer<Self>, inc: Int, y: UnsafePointer<Self>, inc: Int, z: UnsafeMutablePointer<Self>, inc: Int, length: Int)
    @inlinable@inline(__always)
    static func Add(x: UnsafePointer<Self>, inc: Int, y: UnsafePointer<Self>, inc: Int, z: UnsafeMutablePointer<Self>, inc: Int, length: Int)
    @inlinable@inline(__always)
    static func Sub(x: UnsafePointer<Self>, inc: Int, y: UnsafePointer<Self>, inc: Int, z: UnsafeMutablePointer<Self>, inc: Int, length: Int)
    @inlinable@inline(__always)
    static func FMA(x: UnsafePointer<Self>, inc: Int, y: UnsafePointer<Self>, inc: Int, z: UnsafePointer<Self>, inc: Int, w: UnsafeMutablePointer<Self>, inc: Int, length: Int)
}
extension ArithmeticElement where Self: SignedNumeric {
    @inlinable@inline(__always)@_transparent
    public static func Neg(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        Scale(x: x, inc: incx, y: -1, z: y, inc: incy, length: length)
    }
}
extension ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Zero(x: UnsafeMutablePointer<Self>, inc: Int, length: Int) {
        Fill(x: .zero, y: x, inc: inc, length: length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Fill(x: Self, y: UnsafeMutablePointer<Self>, inc: Int, length: Int) {
        for index in 0..<length {
            y[index * inc] = x
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        for index in 0..<length {
            y[index * incy] = x[index * incx]
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func Scale(x: UnsafePointer<Self>, inc incx: Int, y: Self, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        for index in 0..<length {
            z[index * incz] = x[index * incx] * y
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func Add(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        for index in 0..<length {
            z[index * incz] = x[index * incx] + y[index * incy]
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func Sub(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        for index in 0..<length {
            z[index * incz] = x[index * incx] - y[index * incy]
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func Mul(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        for index in 0..<length {
            z[index * incz] = x[index * incx] * y[index * incy]
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func FMA(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafePointer<Self>, inc incz: Int, w: UnsafeMutablePointer<Self>, inc incw: Int, length: Int) {
        for index in 0..<length {
            w[index * incw] = x[index * incx] * y[index * incy] + z[index * incz]
        }
    }
}
extension Float16: ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        for index in 0..<length {
            z[index * incz] = x[index * incx] / y[index * incy]
        }
    }
}
extension Int32: ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_vdivi(y, .init(incy), x, .init(incx), z, .init(incz), .init(length))
    }
}
extension Int64: ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        for index in 0..<length {
            z[index * incz] = x[index * incx] / y[index * incy]
        }
    }
}
extension Float32: ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Zero(x: UnsafeMutablePointer<Self>, inc: Int, length: Int) {
        vDSP_clr(x, inc, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Fill(x: Self, y: UnsafeMutablePointer<Self>, inc: Int, length: Int) {
        vDSP_fill(x, y, inc, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        copy(length, x, incx, y, incy)
    }
    @inlinable@inline(__always)@_transparent
    public static func Scale(x: UnsafePointer<Self>, inc incx: Int, y: Self, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_mul(x, incx, y, z, incz, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Neg(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_neg(x, incx, y, incy, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Add(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_add(x, incx, y, incy, z, incz, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Sub(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_sub(x, incx, y, incy, z, incz, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_div(x, incx, y, incy, z, incz, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Mul(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_mul(x, incx, y, incy, z, incz, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func FMA(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafePointer<Self>, inc incz: Int, w: UnsafeMutablePointer<Self>, inc incw: Int, length: Int) {
        vDSP_fma(x, incx, y, incy, z, incz, w, incw, length)
    }
}
extension Float64: ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Zero(x: UnsafeMutablePointer<Self>, inc: Int, length: Int) {
        vDSP_clr(x, inc, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Fill(x: Self, y: UnsafeMutablePointer<Self>, inc: Int, length: Int) {
        vDSP_fill(x, y, inc, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        copy(length, x, incx, y, incy)
    }
    @inlinable@inline(__always)@_transparent
    public static func Scale(x: UnsafePointer<Self>, inc incx: Int, y: Self, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_mul(x, incx, y, z, incz, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Neg(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_neg(x, incx, y, incy, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Add(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_add(x, incx, y, incy, z, incz, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Sub(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_sub(x, incx, y, incy, z, incz, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Mul(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_mul(x, incx, y, incy, z, incz, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_div(x, incx, y, incy, z, incz, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func FMA(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafePointer<Self>, inc incz: Int, w: UnsafeMutablePointer<Self>, inc incw: Int, length: Int) {
        vDSP_fma(x, incx, y, incy, z, incz, w, incw, length)
    }
}
extension Complex64: ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Zero(x: UnsafeMutablePointer<Self>, inc: Int, length: Int) {
        vDSP_clr(x.mutableRawPointer, inc, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Fill(x: Self, y: UnsafeMutablePointer<Self>, inc: Int, length: Int) {
        vDSP_fill(x.rawValue, y.mutableRawPointer, inc, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        copy(length, .init(.init(x)) as UnsafePointer<RawValue>, incx, .init(.init(y)) as UnsafeMutablePointer<RawValue>, incy)
    }
    @inlinable@inline(__always)@_transparent
    public static func Scale(x: UnsafePointer<Self>, inc incx: Int, y: Self, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_mul(x.pointer(to: \.rawValue).unsafelyUnwrapped, incx,
                 y.rawValue,
                 .init(mutating: z.pointer(to: \.rawValue).unsafelyUnwrapped), incz,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Neg(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_neg(x.pointer(to: \.rawValue).unsafelyUnwrapped, incx,
                 .init(mutating: y.pointer(to: \.rawValue).unsafelyUnwrapped), incy,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Add(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_add(x.pointer(to: \.rawValue).unsafelyUnwrapped, incx,
                 y.pointer(to: \.rawValue).unsafelyUnwrapped, incy,
                 .init(mutating: z.pointer(to: \.rawValue).unsafelyUnwrapped), incz,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Sub(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_sub(x.pointer(to: \.rawValue).unsafelyUnwrapped, incx,
                 y.pointer(to: \.rawValue).unsafelyUnwrapped, incy,
                 .init(mutating: z.pointer(to: \.rawValue).unsafelyUnwrapped), incz,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Mul(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_mul(x.pointer(to: \.rawValue).unsafelyUnwrapped, incx,
                 y.pointer(to: \.rawValue).unsafelyUnwrapped, incy,
                 .init(mutating: z.pointer(to: \.rawValue).unsafelyUnwrapped), incz,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_div(x.pointer(to: \.rawValue).unsafelyUnwrapped, incx,
                 y.pointer(to: \.rawValue).unsafelyUnwrapped, incy,
                 .init(mutating: z.pointer(to: \.rawValue).unsafelyUnwrapped), incz,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func FMA(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafePointer<Self>, inc incz: Int, w: UnsafeMutablePointer<Self>, inc incw: Int, length: Int) {
        vDSP_fma(x.pointer(to: \.rawValue).unsafelyUnwrapped, incx,
                 y.pointer(to: \.rawValue).unsafelyUnwrapped, incy,
                 z.pointer(to: \.rawValue).unsafelyUnwrapped, incz,
                 .init(mutating: w.pointer(to: \.rawValue).unsafelyUnwrapped), incw,
                 length)
    }
}
extension Complex128: ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Zero(x: UnsafeMutablePointer<Self>, inc: Int, length: Int) {
        vDSP_clr(x.mutableRawPointer, inc, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Fill(x: Self, y: UnsafeMutablePointer<Self>, inc: Int, length: Int) {
        vDSP_fill(x.rawValue, y.mutableRawPointer, inc, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        copy(length, .init(.init(x)) as UnsafePointer<RawValue>, incx, .init(.init(y)) as UnsafeMutablePointer<RawValue>, incy)
    }
    @inlinable@inline(__always)@_transparent
    public static func Scale(x: UnsafePointer<Self>, inc incx: Int, y: Self, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_mul(x.pointer(to: \.rawValue).unsafelyUnwrapped, incx,
                 y.rawValue,
                 .init(mutating: z.pointer(to: \.rawValue).unsafelyUnwrapped), incz,
                 length)
    }
    @inlinable@inline(__always)
    public static func Neg(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_neg(x.pointer(to: \.rawValue).unsafelyUnwrapped, incx,
                 .init(mutating: y.pointer(to: \.rawValue).unsafelyUnwrapped), incy,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Add(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_add(x.pointer(to: \.rawValue).unsafelyUnwrapped, incx,
                 y.pointer(to: \.rawValue).unsafelyUnwrapped, incy,
                 .init(mutating: z.pointer(to: \.rawValue).unsafelyUnwrapped), incz,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Sub(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_sub(x.pointer(to: \.rawValue).unsafelyUnwrapped, incx,
                 y.pointer(to: \.rawValue).unsafelyUnwrapped, incy,
                 .init(mutating: z.pointer(to: \.rawValue).unsafelyUnwrapped), incz,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Mul(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_mul(x.pointer(to: \.rawValue).unsafelyUnwrapped, incx,
                 y.pointer(to: \.rawValue).unsafelyUnwrapped, incy,
                 .init(mutating: z.pointer(to: \.rawValue).unsafelyUnwrapped), incz,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_div(x.pointer(to: \.rawValue).unsafelyUnwrapped, incx,
                 y.pointer(to: \.rawValue).unsafelyUnwrapped, incy,
                 .init(mutating: z.pointer(to: \.rawValue).unsafelyUnwrapped), incz,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func FMA(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafePointer<Self>, inc incz: Int, w: UnsafeMutablePointer<Self>, inc incw: Int, length: Int) {
        vDSP_fma(x.pointer(to: \.rawValue).unsafelyUnwrapped, incx,
                 y.pointer(to: \.rawValue).unsafelyUnwrapped, incy,
                 z.pointer(to: \.rawValue).unsafelyUnwrapped, incz,
                 .init(mutating: w.pointer(to: \.rawValue).unsafelyUnwrapped), incw,
                 length)
    }
}
