//
//  Complex.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import AltVec
import protocol Numerics.ComplexNumber
public enum Complex<Element: ComplexElement> {}
public protocol ComplexElement: ArithmeticElement & ComplexNumber {
    static func Copy(z: UnsafePointer<Self>, inc: Int, r: UnsafeMutablePointer<Magnitude>, inc: Int, length: Int)
    static func Copy(z: UnsafePointer<Self>, inc: Int, i: UnsafeMutablePointer<Magnitude>, inc: Int, length: Int)
    static func Copy(z: UnsafePointer<Self>, inc: Int, θ: UnsafeMutablePointer<Magnitude>, inc: Int, length: Int)
    static func Swap(x: UnsafePointer<Self>, inc: Int, y: UnsafeMutablePointer<Self>, inc: Int, length: Int)
    static func Conj(x: UnsafePointer<Self>, inc: Int, y: UnsafeMutablePointer<Self>, inc: Int, length: Int)
    static func Merge(r: UnsafePointer<Magnitude>, inc: Int, i: UnsafePointer<Magnitude>, inc: Int, z: UnsafeMutablePointer<Self>, inc: Int, length: Int)
    static func Merge(r: UnsafePointer<Magnitude>, inc: Int, θ: UnsafePointer<Magnitude>, inc: Int, z: UnsafeMutablePointer<Self>, inc: Int, length: Int)
}
extension Complex64: ComplexElement {
    @usableFromInline typealias SplitComplex = DSPSplitComplex
    @inlinable@_transparent
    public static func Copy(z: UnsafePointer<Self>, inc incz: Int, r: UnsafeMutablePointer<Magnitude>, inc incr: Int, length: Int) {
        Magnitude.Copy(x: .init(.init(z)).advanced(by: 0) as UnsafePointer<Magnitude>, inc: 2 * incz, y: r, inc: incr, length: length)
    }
    @inlinable@_transparent
    public static func Copy(z: UnsafePointer<Self>, inc incz: Int, i: UnsafeMutablePointer<Magnitude>, inc inci: Int, length: Int) {
        Magnitude.Copy(x: .init(.init(z)).advanced(by: 1) as UnsafePointer<Magnitude>, inc: 2 * incz, y: i, inc: inci, length: length)
    }
    @inlinable@_transparent
    public static func Copy(z: UnsafePointer<Self>, inc incz: Int, θ: UnsafeMutablePointer<Magnitude>, inc incθ: Int, length: Int) {
        vDSP_phas(.init(.init(z)) as UnsafePointer<RawValue>, 2 * incz, θ, incθ, length)
    }
    @inlinable@_transparent
    public static func Conj(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_conj(.init(.init(x)) as UnsafePointer<RawValue>, incx,
                  .init(.init(y)) as UnsafeMutablePointer<RawValue>, incy,
                  length)
    }
    @inlinable@_transparent
    public static func Swap(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        Magnitude.Copy(x: .init(.init(x)).advanced(by: 0), inc: 2 * incx, y: .init(.init(y)).advanced(by: 1), inc: 2 * incy, length: length)
        Magnitude.Copy(x: .init(.init(x)).advanced(by: 1), inc: 2 * incx, y: .init(.init(y)).advanced(by: 0), inc: 2 * incy, length: length)
    }
    @inlinable@_transparent
    public static func Merge(r: UnsafePointer<Magnitude>, inc incr: Int, i: UnsafePointer<Magnitude>, inc inci: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        Magnitude.Copy(x: r, inc: incr, y: .init(.init(z)).advanced(by: 0), inc: 2 * incz, length: length)
        Magnitude.Copy(x: i, inc: inci, y: .init(.init(z)).advanced(by: 1), inc: 2 * incz, length: length)
    }
    @inlinable@_transparent
    public static func Merge(r: UnsafePointer<Magnitude>, inc incr: Int, θ: UnsafePointer<Magnitude>, inc incθ: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        Merge(r: r, inc: incr, i: θ, inc: incθ, z: z, inc: incz, length: length)
        vDSP_rect(.init(.init(z)) as UnsafePointer<RawValue>, incz,
                  .init(.init(z)) as UnsafeMutablePointer<RawValue>, incz,
                  length)
    }
}
extension Complex128: ComplexElement {
    @usableFromInline typealias SplitComplex = DSPDoubleSplitComplex
    @inlinable@_transparent
    public static func Copy(z: UnsafePointer<Self>, inc incz: Int, r: UnsafeMutablePointer<Magnitude>, inc incr: Int, length: Int) {
        Magnitude.Copy(x: .init(.init(z)).advanced(by: 0) as UnsafePointer<Magnitude>, inc: 2 * incz, y: r, inc: incr, length: length)
    }
    @inlinable@_transparent
    public static func Copy(z: UnsafePointer<Self>, inc incz: Int, i: UnsafeMutablePointer<Magnitude>, inc inci: Int, length: Int) {
        Magnitude.Copy(x: .init(.init(z)).advanced(by: 1) as UnsafePointer<Magnitude>, inc: 2 * incz, y: i, inc: inci, length: length)
    }
    @inlinable@_transparent
    public static func Copy(z: UnsafePointer<Self>, inc incz: Int, θ: UnsafeMutablePointer<Magnitude>, inc incθ: Int, length: Int) {
        vDSP_phas(.init(.init(z)) as UnsafePointer<RawValue>, 2 * incz, θ, incθ, length)
    }
    @inlinable@_transparent
    public static func Conj(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_conj(.init(.init(x)) as UnsafePointer<RawValue>, incx,
                  .init(.init(y)) as UnsafeMutablePointer<RawValue>, incy,
                  length)
    }
    @inlinable@_transparent
    public static func Swap(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        Magnitude.Copy(x: .init(.init(x)).advanced(by: 0), inc: 2 * incx, y: .init(.init(y)).advanced(by: 1), inc: 2 * incy, length: length)
        Magnitude.Copy(x: .init(.init(x)).advanced(by: 1), inc: 2 * incx, y: .init(.init(y)).advanced(by: 0), inc: 2 * incy, length: length)
    }
    @inlinable@_transparent
    public static func Merge(r: UnsafePointer<Magnitude>, inc incr: Int, i: UnsafePointer<Magnitude>, inc inci: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        Magnitude.Copy(x: r, inc: incr, y: .init(.init(z)).advanced(by: 0) as UnsafeMutablePointer<Magnitude>, inc: 2 * incz, length: length)
        Magnitude.Copy(x: i, inc: inci, y: .init(.init(z)).advanced(by: 1) as UnsafeMutablePointer<Magnitude>, inc: 2 * incz, length: length)
    }
    @inlinable@_transparent
    public static func Merge(r: UnsafePointer<Magnitude>, inc incr: Int, θ: UnsafePointer<Magnitude>, inc incθ: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        Merge(r: r, inc: incr, i: θ, inc: incθ, z: z, inc: incz, length: length)
        vDSP_rect(.init(.init(z)) as UnsafePointer<RawValue>, incz,
                  .init(.init(z)) as UnsafeMutablePointer<RawValue>, incz,
                  length)
    }
}
