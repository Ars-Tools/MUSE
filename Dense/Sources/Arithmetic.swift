//
//  Arithmetic.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import AltVec
import BLAS
public enum Arithmetic<Element: BitwiseCopyable & Sendable & ArithmeticElement> {
    public typealias Storage = Array<Element>
}
public protocol ArithmeticElement: Numeric {
    @inlinable@inline(__always)
    static func Copy(x: UnsafePointer<Self>, inc: Int, y: UnsafeMutablePointer<Self>, inc: Int, length: Int)
    @inlinable@inline(__always)
    static func Scale(x: UnsafePointer<Self>, inc: Int, y: Self, z: UnsafeMutablePointer<Self>, inc: Int, length: Int)
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
extension ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        for index in 0..<length {
            y[index * incx] = x[index * incy]
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func Scale(x: UnsafePointer<Self>, inc incx: Int, y: Self, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        for index in 0..<length {
            z[index * incz] = x[index * incx] * y
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func Mul(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        for index in 0..<length {
            z[index * incz] = x[index * incx] * y[index * incy]
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
extension ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func withUnsafeTemporary<E, R>(gather shape: some BidirectionalCollection<Int>,
                                                 source xs: some BidirectionalCollection<Int>,
                                                 target ys: some BidirectionalCollection<Int>,
                                                 memory x: UnsafePointer<Self>,
                                                 _ body: (UnsafePointer<Self>) throws (E) -> R) rethrows -> R {
        try withUnsafeTemporaryAllocation(of: Self.self, capacity: capacity(alloc: shape, stride: ys)) {
            let (length, stride, offset) = MemoryStrategy.default.flatten(shape: shape, xs: xs, ys: ys)
            let y = $0.baseAddress.unsafelyUnwrapped
            for offset in offset {
                Copy(x: x.advanced(by: offset.x), inc: stride.x,
                     y: y.advanced(by: offset.y), inc: stride.y,
                     length: length)
            }
            return try body(y)
        }
    }
}
extension Float32: ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        copy(length, x, incx, y, incy)
    }
    @inlinable@inline(__always)@_transparent
    public static func Scale(x: UnsafePointer<Self>, inc incx: Int, y: Self, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_mul(x, incx, y, z, incz, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Mul(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_vmul(x, .init(incx), y, .init(incy), z, .init(incz), .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Add(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_vadd(x, .init(incx), y, .init(incy), z, .init(incz), .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_div(x, incx, y, incy, z, incz, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Sub(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_sub(x, incx, y, incy, z, incz, length)
    }
    @inlinable@inline(__always)
    public static func FMA(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafePointer<Self>, inc incz: Int, w: UnsafeMutablePointer<Self>, inc incw: Int, length: Int) {
        vDSP_fma(x, incx, y, incy, z, incz, w, incw, length)
    }
}
extension Float64: ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        copy(length, x, incx, y, incy)
    }
    @inlinable@inline(__always)@_transparent
    public static func Scale(x: UnsafePointer<Self>, inc incx: Int, y: Self, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_mul(x, incx, y, z, incz, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Mul(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_vmulD(x, .init(incx), y, .init(incy), z, .init(incz), .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Add(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_vaddD(x, .init(incx), y, .init(incy), z, .init(incz), .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_div(x, incx, y, incy, z, incz, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Sub(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_sub(x, incx, y, incy, z, incz, length)
    }
    @inlinable@inline(__always)
    public static func FMA(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafePointer<Self>, inc incz: Int, w: UnsafeMutablePointer<Self>, inc incw: Int, length: Int) {
        vDSP_fma(x, incx, y, incy, z, incz, w, incw, length)
    }
}
extension Complex64: ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        copy(length, .init(.init(x)) as UnsafePointer<RawValue>, incx, .init(.init(y)) as UnsafeMutablePointer<RawValue>, incy)
    }
    @inlinable@inline(__always)@_transparent
    public static func Scale(x: UnsafePointer<Self>, inc incx: Int, y: Self, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_mul(.init(.init(x)), 2 * incx,
                 y.rawValue,
                 .init(.init(z)), 2 * incz,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Mul(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_mul(.init(.init(x)) as UnsafePointer<RawValue>, 2 * incx,
                 .init(.init(y)) as UnsafePointer<RawValue>, 2 * incy,
                 .init(.init(z)) as UnsafeMutablePointer<RawValue>, 2 * incz,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Add(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_add(.init(.init(x)) as UnsafePointer<RawValue>, 2 * incx,
                 .init(.init(y)) as UnsafePointer<RawValue>, 2 * incy,
                 .init(.init(z)) as UnsafeMutablePointer<RawValue>, 2 * incz,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_div(.init(.init(x)) as UnsafePointer<RawValue>, 2 * incx,
                 .init(.init(y)) as UnsafePointer<RawValue>, 2 * incy,
                 .init(.init(z)) as UnsafeMutablePointer<RawValue>, 2 * incz,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Sub(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_sub(.init(.init(x)) as UnsafePointer<RawValue>, 2 * incx,
                 .init(.init(y)) as UnsafePointer<RawValue>, 2 * incy,
                 .init(.init(z)) as UnsafeMutablePointer<RawValue>, 2 * incz,
                 length)
    }
    @inlinable@inline(__always)
    public static func FMA(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafePointer<Self>, inc incz: Int, w: UnsafeMutablePointer<Self>, inc incw: Int, length: Int) {
        vDSP_fma(.init(.init(x)) as UnsafePointer<RawValue>, 2 * incx,
                 .init(.init(y)) as UnsafePointer<RawValue>, 2 * incy,
                 .init(.init(y)) as UnsafePointer<RawValue>, 2 * incz,
                 .init(.init(w)) as UnsafeMutablePointer<RawValue>, 2 * incw,
                 length)
    }
}
extension Complex128: ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        copy(length, .init(.init(x)) as UnsafePointer<RawValue>, incx, .init(.init(y)) as UnsafeMutablePointer<RawValue>, incy)
    }
    @inlinable@inline(__always)@_transparent
    public static func Scale(x: UnsafePointer<Self>, inc incx: Int, y: Self, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_mul(.init(.init(x)), 2 * incx,
                 y.rawValue,
                 .init(.init(z)), 2 * incz,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Mul(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_mul(.init(.init(x)) as UnsafePointer<RawValue>, incx,
                 .init(.init(y)) as UnsafePointer<RawValue>, incy,
                 .init(.init(z)) as UnsafeMutablePointer<RawValue>, incz,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Add(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_add(.init(.init(x)) as UnsafePointer<RawValue>, incx,
                 .init(.init(y)) as UnsafePointer<RawValue>, incy,
                 .init(.init(z)) as UnsafeMutablePointer<RawValue>, incz,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_div(.init(.init(x)) as UnsafePointer<RawValue>, incx,
                 .init(.init(y)) as UnsafePointer<RawValue>, incy,
                 .init(.init(z)) as UnsafeMutablePointer<RawValue>, incz,
                 length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Sub(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        vDSP_sub(.init(.init(x)) as UnsafePointer<RawValue>, incx,
                 .init(.init(y)) as UnsafePointer<RawValue>, incy,
                 .init(.init(z)) as UnsafeMutablePointer<RawValue>, incz,
                 length)
    }
    @inlinable@inline(__always)
    public static func FMA(x: UnsafePointer<Self>, inc incx: Int, y: UnsafePointer<Self>, inc incy: Int, z: UnsafePointer<Self>, inc incz: Int, w: UnsafeMutablePointer<Self>, inc incw: Int, length: Int) {
        vDSP_fma(.init(.init(x)) as UnsafePointer<RawValue>, incx,
                 .init(.init(y)) as UnsafePointer<RawValue>, incy,
                 .init(.init(y)) as UnsafePointer<RawValue>, incz,
                 .init(.init(w)) as UnsafeMutablePointer<RawValue>, incw,
                 length)
    }
}
