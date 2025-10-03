//
//  Complex.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import Accelerate.vecLib
import protocol Numerics.ComplexNumber
public enum Complex<Element: ComplexElement> {}
public protocol ComplexElement: ArithmeticElement & ComplexNumber {
    static func Copy(z: UnsafePointer<Self>, ldz: Int, r: UnsafeMutablePointer<Magnitude>, ldr: Int, length: Int)
    static func Copy(z: UnsafePointer<Self>, ldz: Int, i: UnsafeMutablePointer<Magnitude>, ldi: Int, length: Int)
    static func Copy(z: UnsafePointer<Self>, ldz: Int, θ: UnsafeMutablePointer<Magnitude>, ldθ: Int, length: Int)
    static func Swap(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int)
    static func Conj(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int)
    static func Merge(r: UnsafePointer<Magnitude>, ldr: Int, i: UnsafePointer<Magnitude>, ldi: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int)
    static func Merge(r: UnsafePointer<Magnitude>, ldr: Int, θ: UnsafePointer<Magnitude>, ldθ: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int)
}
extension Complex64: ComplexElement {
    @usableFromInline typealias SplitComplex = DSPSplitComplex
    @inlinable@_transparent
    public static func Copy(z: UnsafePointer<Self>, ldz: Int, r: UnsafeMutablePointer<Magnitude>, ldr: Int, length: Int) {
        scopy_(withUnsafePointer(to: length, \.self),
               .init(.init(z)).advanced(by: 0), withUnsafePointer(to: 2 * ldz, \.self),
               r, withUnsafePointer(to: ldr, \.self))
    }
    @inlinable@_transparent
    public static func Copy(z: UnsafePointer<Self>, ldz: Int, i: UnsafeMutablePointer<Magnitude>, ldi: Int, length: Int) {
        scopy_(withUnsafePointer(to: length, \.self),
               .init(.init(z)).advanced(by: 1), withUnsafePointer(to: 2 * ldz, \.self),
               i, withUnsafePointer(to: ldi, \.self))
    }
    @inlinable@_transparent
    public static func Copy(z: UnsafePointer<Self>, ldz: Int, θ: UnsafeMutablePointer<Magnitude>, ldθ: Int, length: Int) {
        var z = SplitComplex(realp: .init(.init(z)).advanced(by: 0),
                             imagp: .init(.init(z)).advanced(by: 1))
        vDSP_zvphas(&z, 2 * ldz, θ, ldθ, .init(length))
    }
    @inlinable@_transparent
    public static func Swap(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        if x != y {
            scopy_(withUnsafePointer(to: length, \.self),
                   .init(.init(x)).advanced(by: 0), withUnsafePointer(to: 2 * ldx, \.self),
                   .init(.init(y)).advanced(by: 1), withUnsafePointer(to: 2 * ldy, \.self))
            scopy_(withUnsafePointer(to: length, \.self),
                   .init(.init(x)).advanced(by: 1), withUnsafePointer(to: 2 * ldx, \.self),
                   .init(.init(y)).advanced(by: 0), withUnsafePointer(to: 2 * ldy, \.self))
        } else {
            vDSP_vswap(.init(.init(y)).advanced(by: 0), 2 * ldx,
                       .init(.init(y)).advanced(by: 1), 2 * ldx, .init(length))
        }
    }
    @inlinable@_transparent
    public static func Conj(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        var z = SplitComplex(realp: .init(.init(x)).advanced(by: 0),
                             imagp: .init(.init(x)).advanced(by: 1))
        var w = SplitComplex(realp: .init(.init(y)).advanced(by: 0),
                             imagp: .init(.init(y)).advanced(by: 1))
        vDSP_zvconj(&z, 2 * ldx, &w, 2 * ldy, .init(length))
    }
    @inlinable@_transparent
    public static func Merge(r: UnsafePointer<Magnitude>, ldr: Int, i: UnsafePointer<Magnitude>, ldi: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        cblas_scopy(length, r, ldr, .init(.init(z)).advanced(by: 0), 2 * ldz)
        cblas_scopy(length, i, ldi, .init(.init(z)).advanced(by: 1), 2 * ldz)
    }
    @inlinable@_transparent
    public static func Merge(r: UnsafePointer<Magnitude>, ldr: Int, θ: UnsafePointer<Magnitude>, ldθ: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        Merge(r: r, ldr: ldr, i: θ, ldi: ldθ, z: z, ldz: ldz, length: length)
        vDSP_rect(.init(.init(z)), 2 * ldz, .init(.init(z)), 2 * ldz, .init(length))
    }
}
extension Complex128: ComplexElement {
    @usableFromInline typealias SplitComplex = DSPDoubleSplitComplex
    @inlinable@_transparent
    public static func Copy(z: UnsafePointer<Self>, ldz: Int, r: UnsafeMutablePointer<Magnitude>, ldr: Int, length: Int) {
        dcopy_(withUnsafePointer(to: length, \.self),
               .init(.init(z)).advanced(by: 0), withUnsafePointer(to: 2 * ldz, \.self),
               r, withUnsafePointer(to: ldr, \.self))
    }
    @inlinable@_transparent
    public static func Copy(z: UnsafePointer<Self>, ldz: Int, i: UnsafeMutablePointer<Magnitude>, ldi: Int, length: Int) {
        dcopy_(withUnsafePointer(to: length, \.self),
               .init(.init(z)).advanced(by: 1), withUnsafePointer(to: 2 * ldz, \.self),
               i, withUnsafePointer(to: ldi, \.self))
    }
    @inlinable@_transparent
    public static func Copy(z: UnsafePointer<Self>, ldz: Int, θ: UnsafeMutablePointer<Magnitude>, ldθ: Int, length: Int) {
        var z = SplitComplex(realp: .init(.init(z)).advanced(by: 0),
                             imagp: .init(.init(z)).advanced(by: 1))
        vDSP_zvphasD(&z, 2 * ldz, θ, ldθ, .init(length))
    }
    @inlinable@_transparent
    public static func Swap(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        if x != y {
            dcopy_(withUnsafePointer(to: length, \.self),
                   .init(.init(x)).advanced(by: 0), withUnsafePointer(to: 2 * ldx, \.self),
                   .init(.init(y)).advanced(by: 1), withUnsafePointer(to: 2 * ldy, \.self))
            dcopy_(withUnsafePointer(to: length, \.self),
                   .init(.init(x)).advanced(by: 1), withUnsafePointer(to: 2 * ldx, \.self),
                   .init(.init(y)).advanced(by: 0), withUnsafePointer(to: 2 * ldy, \.self))
        } else {
            vDSP_vswapD(.init(.init(y)).advanced(by: 0), 2 * ldx,
                        .init(.init(y)).advanced(by: 1), 2 * ldx, .init(length))
        }
    }
    @inlinable@_transparent
    public static func Conj(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        var z = SplitComplex(realp: .init(.init(x)).advanced(by: 0),
                             imagp: .init(.init(x)).advanced(by: 1))
        var w = SplitComplex(realp: .init(.init(y)).advanced(by: 0),
                             imagp: .init(.init(y)).advanced(by: 1))
        vDSP_zvconjD(&z, 2 * ldx, &w, 2 * ldy, .init(length))
    }
    @inlinable@_transparent
    public static func Merge(r: UnsafePointer<Magnitude>, ldr: Int, i: UnsafePointer<Magnitude>, ldi: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        cblas_dcopy(length, r, ldr, .init(.init(z)).advanced(by: 0), 2 * ldz)
        cblas_dcopy(length, i, ldi, .init(.init(z)).advanced(by: 1), 2 * ldz)
    }
    @inlinable@_transparent
    public static func Merge(r: UnsafePointer<Magnitude>, ldr: Int, θ: UnsafePointer<Magnitude>, ldθ: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        Merge(r: r, ldr: ldr, i: θ, ldi: ldθ, z: z, ldz: ldz, length: length)
        vDSP_rectD(.init(.init(z)), 2 * ldz, .init(.init(z)), 2 * ldz, .init(length))
    }
}
