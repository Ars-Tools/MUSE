//
//  Complex.swift
//  MUSE
//
//  Created by Kota on 8/18/26.
//
import MKL
import protocol Numerics.ComplexNumber
import typealias Numerics.Complex64
import typealias Numerics.Complex128
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
    @inlinable@inline(__always)@_transparent
    public static func Copy(z: UnsafePointer<Self>, inc incz: Int, r: UnsafeMutablePointer<Magnitude>, inc incr: Int, length: Int) {
        Magnitude.Copy(x: .init(.init(z)).advanced(by: 0) as UnsafePointer<Magnitude>, inc: 2 * incz, y: r, inc: incr, length: length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(z: UnsafePointer<Self>, inc incz: Int, i: UnsafeMutablePointer<Magnitude>, inc inci: Int, length: Int) {
        Magnitude.Copy(x: .init(.init(z)).advanced(by: 1) as UnsafePointer<Magnitude>, inc: 2 * incz, y: i, inc: inci, length: length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(z: UnsafePointer<Self>, inc incz: Int, θ: UnsafeMutablePointer<Magnitude>, inc incθ: Int, length: Int) {
        vDSP_phas(z.pointer(to: \.rawValue).unsafelyUnwrapped, incz, θ, incθ, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Conj(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_conj(x.pointer(to: \.rawValue).unsafelyUnwrapped, incx,
                  .init(mutating: y.pointer(to: \.rawValue).unsafelyUnwrapped), incy,
                  length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Swap(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        Magnitude.Copy(x: .init(.init(x)).advanced(by: 0), inc: 2 * incx, y: .init(.init(y)).advanced(by: 1), inc: 2 * incy, length: length)
        Magnitude.Copy(x: .init(.init(x)).advanced(by: 1), inc: 2 * incx, y: .init(.init(y)).advanced(by: 0), inc: 2 * incy, length: length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Merge(r: UnsafePointer<Magnitude>, inc incr: Int, i: UnsafePointer<Magnitude>, inc inci: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        Magnitude.Copy(x: r, inc: incr, y: .init(.init(z)).advanced(by: 0), inc: 2 * incz, length: length)
        Magnitude.Copy(x: i, inc: inci, y: .init(.init(z)).advanced(by: 1), inc: 2 * incz, length: length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Merge(r: UnsafePointer<Magnitude>, inc incr: Int, θ: UnsafePointer<Magnitude>, inc incθ: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        Merge(r: r, inc: incr, i: θ, inc: incθ, z: z, inc: incz, length: length)
        vDSP_rect(z.pointer(to: \.rawValue).unsafelyUnwrapped, incz,
                  .init(mutating: z.pointer(to: \.rawValue).unsafelyUnwrapped), incz,
                  length)
    }
}
extension Complex128: ComplexElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(z: UnsafePointer<Self>, inc incz: Int, r: UnsafeMutablePointer<Magnitude>, inc incr: Int, length: Int) {
        Magnitude.Copy(x: .init(.init(z)).advanced(by: 0) as UnsafePointer<Magnitude>, inc: 2 * incz, y: r, inc: incr, length: length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(z: UnsafePointer<Self>, inc incz: Int, i: UnsafeMutablePointer<Magnitude>, inc inci: Int, length: Int) {
        Magnitude.Copy(x: .init(.init(z)).advanced(by: 1) as UnsafePointer<Magnitude>, inc: 2 * incz, y: i, inc: inci, length: length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(z: UnsafePointer<Self>, inc incz: Int, θ: UnsafeMutablePointer<Magnitude>, inc incθ: Int, length: Int) {
        vDSP_phas(z.pointer(to: \.rawValue).unsafelyUnwrapped, incz, θ, incθ, length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Conj(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_conj(x.pointer(to: \.rawValue).unsafelyUnwrapped, incx,
                  .init(mutating: y.pointer(to: \.rawValue).unsafelyUnwrapped), incy,
                  length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Swap(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        Magnitude.Copy(x: .init(.init(x)).advanced(by: 0), inc: 2 * incx, y: .init(.init(y)).advanced(by: 1), inc: 2 * incy, length: length)
        Magnitude.Copy(x: .init(.init(x)).advanced(by: 1), inc: 2 * incx, y: .init(.init(y)).advanced(by: 0), inc: 2 * incy, length: length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Merge(r: UnsafePointer<Magnitude>, inc incr: Int, i: UnsafePointer<Magnitude>, inc inci: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        Magnitude.Copy(x: r, inc: incr, y: .init(.init(z)).advanced(by: 0) as UnsafeMutablePointer<Magnitude>, inc: 2 * incz, length: length)
        Magnitude.Copy(x: i, inc: inci, y: .init(.init(z)).advanced(by: 1) as UnsafeMutablePointer<Magnitude>, inc: 2 * incz, length: length)
    }
    @inlinable@inline(__always)@_transparent
    public static func Merge(r: UnsafePointer<Magnitude>, inc incr: Int, θ: UnsafePointer<Magnitude>, inc incθ: Int, z: UnsafeMutablePointer<Self>, inc incz: Int, length: Int) {
        Merge(r: r, inc: incr, i: θ, inc: incθ, z: z, inc: incz, length: length)
        vDSP_rect(z.pointer(to: \.rawValue).unsafelyUnwrapped, incz,
                  .init(mutating: z.pointer(to: \.rawValue).unsafelyUnwrapped), incz,
                  length)
    }
}
