//
//  Complex.swift
//  MUSE
//
//  Created by Kota on 9/24/25.
//
import Accelerate.vecLib
import protocol Numerics.ComplexNumber
import typealias Numerics.Complex64
import typealias Numerics.Complex128
public enum Complex<Element: ComplexElement> where Element.Magnitude: BitwiseCopyable & Sendable {}
public protocol ComplexElement: vFORCESuiteElement & ComplexNumber {
    static func Copy(z: UnsafePointer<Self>, ldz: Int, r: UnsafeMutablePointer<Magnitude>, ldr: Int, length: Int)
    static func Copy(z: UnsafePointer<Self>, ldz: Int, i: UnsafeMutablePointer<Magnitude>, ldi: Int, length: Int)
    static func Copy(z: UnsafePointer<Self>, ldz: Int, θ: UnsafeMutablePointer<Magnitude>, ldθ: Int, length: Int)
    static func Merge(r: UnsafePointer<Magnitude>, ldr: Int, i: UnsafePointer<Magnitude>, ldi: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int)
    static func Merge(r: UnsafePointer<Magnitude>, ldr: Int, θ: UnsafePointer<Magnitude>, ldθ: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int)
}
extension Complex64: ComplexElement {
    @usableFromInline typealias SplitComplex = DSPSplitComplex
    public static func Copy(z: UnsafePointer<Self>, ldz: Int, r: UnsafeMutablePointer<Magnitude>, ldr: Int, length: Int) {
        Magnitude.Copy(x: .init(.init(z)).advanced(by: 0), ldx: 2 * ldz, y: r, ldy: ldr, length: length)
    }
    public static func Copy(z: UnsafePointer<Self>, ldz: Int, i: UnsafeMutablePointer<Magnitude>, ldi: Int, length: Int) {
        Magnitude.Copy(x: .init(.init(z)).advanced(by: 1), ldx: 2 * ldz, y: i, ldy: ldi, length: length)
    }
    public static func Copy(z: UnsafePointer<Self>, ldz: Int, θ: UnsafeMutablePointer<Magnitude>, ldθ: Int, length: Int) {
        var z = SplitComplex(realp: .init(.init(z)).advanced(by: 0),
                             imagp: .init(.init(z)).advanced(by: 1))
        vDSP_zvphas(&z, 2 * ldz, θ, ldθ, .init(length))
    }
    public static func Merge(r: UnsafePointer<Magnitude>, ldr: Int, i: UnsafePointer<Magnitude>, ldi: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        cblas_scopy(length, r, ldr, .init(.init(z)).advanced(by: 0), 2 * ldz)
        cblas_scopy(length, i, ldi, .init(.init(z)).advanced(by: 1), 2 * ldz)
    }
    public static func Merge(r: UnsafePointer<Magnitude>, ldr: Int, θ: UnsafePointer<Magnitude>, ldθ: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        Merge(r: r, ldr: ldr, i: θ, ldi: ldθ, z: z, ldz: ldz, length: length)
        vDSP_rect(.init(.init(z)), 2 * ldz, .init(.init(z)), 2 * ldz, .init(length))
    }
}
extension Complex128: ComplexElement {
    @usableFromInline typealias SplitComplex = DSPDoubleSplitComplex
    public static func Copy(z: UnsafePointer<Self>, ldz: Int, r: UnsafeMutablePointer<Magnitude>, ldr: Int, length: Int) {
        Magnitude.Copy(x: .init(.init(z)).advanced(by: 0), ldx: 2 * ldz, y: r, ldy: ldr, length: length)
    }
    public static func Copy(z: UnsafePointer<Self>, ldz: Int, i: UnsafeMutablePointer<Magnitude>, ldi: Int, length: Int) {
        Magnitude.Copy(x: .init(.init(z)).advanced(by: 1), ldx: 2 * ldz, y: i, ldy: ldi, length: length)
    }
    public static func Copy(z: UnsafePointer<Self>, ldz: Int, θ: UnsafeMutablePointer<Magnitude>, ldθ: Int, length: Int) {
        var z = SplitComplex(realp: .init(.init(z)).advanced(by: 0),
                             imagp: .init(.init(z)).advanced(by: 1))
        vDSP_zvphasD(&z, 2 * ldz, θ, ldθ, .init(length))
    }
    public static func Merge(r: UnsafePointer<Magnitude>, ldr: Int, i: UnsafePointer<Magnitude>, ldi: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        cblas_dcopy(length, r, ldr, .init(.init(z)).advanced(by: 0), 2 * ldz)
        cblas_dcopy(length, i, ldi, .init(.init(z)).advanced(by: 1), 2 * ldz)
    }
    public static func Merge(r: UnsafePointer<Magnitude>, ldr: Int, θ: UnsafePointer<Magnitude>, ldθ: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        Merge(r: r, ldr: ldr, i: θ, ldi: ldθ, z: z, ldz: ldz, length: length)
        vDSP_rectD(.init(.init(z)), 2 * ldz, .init(.init(z)), 2 * ldz, .init(length))
    }
}
