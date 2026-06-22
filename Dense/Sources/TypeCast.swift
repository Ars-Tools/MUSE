//
//  TypeCast.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import Accelerate.vecLib
import AltVec
public enum TypeCast {}
public protocol Float32CompatibleElement {
    @inlinable@inline(__always)
    static func Copy(x: UnsafePointer<Self>, inc: Int, y: UnsafeMutablePointer<Float32>, inc: Int, length: Int)
    @inlinable@inline(__always)
    static func Copy(x: UnsafePointer<Float32>, inc: Int, y: UnsafeMutablePointer<Self>, inc: Int, length: Int)
}
public protocol Float64CompatibleElement {
    @inlinable@inline(__always)
    static func Copy(x: UnsafePointer<Self>, inc: Int, y: UnsafeMutablePointer<Float64>, inc: Int, length: Int)
    @inlinable@inline(__always)
    static func Copy(x: UnsafePointer<Float64>, inc: Int, y: UnsafeMutablePointer<Self>, inc: Int, length: Int)
}
extension Float32CompatibleElement {
    @inlinable@inline(__always)@_transparent
    static func Copy(x: UnsafePointer<Complex64>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        Copy(x: .init(.init(x)), inc: 2 * incx, y: y, inc: incy, length: length)
    }
    @inlinable@inline(__always)@_transparent
    static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Complex64>, inc incy: Int, length: Int) {
        Copy(x: x, inc: incx, y: .init(.init(y)) as UnsafeMutablePointer<Float32>, inc: 2 * incy, length: length)
        vDSP_vclr(.init(.init(y)).advanced(by: 1), 2 * incy, .init(length))
    }
}
extension Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    static func Copy(x: UnsafePointer<Complex128>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        Copy(x: .init(.init(x)), inc: 2 * incx, y: y, inc: incy, length: length)
    }
    @inlinable@inline(__always)@_transparent
    static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Complex128>, inc incy: Int, length: Int) {
        Copy(x: x, inc: incx, y: .init(.init(y)) as UnsafeMutablePointer<Float64>, inc: 2 * incy, length: length)
        vDSP_vclrD(.init(.init(y)).advanced(by: 1), 2 * incy, .init(length))
    }
}
extension Int8: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float32>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_vfix8(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Float32>, inc incy: Int, length: Int) {
        vDSP_vflt8(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float64>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_vfix8D(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Float64>, inc incy: Int, length: Int) {
        vDSP_vflt8D(x, incx, y, incy, .init(length))
    }
}
extension Int16: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float32>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_vfix16(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Float32>, inc incy: Int, length: Int) {
        vDSP_vflt16(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float64>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_vfix16D(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Float64>, inc incy: Int, length: Int) {
        vDSP_vflt16D(x, incx, y, incy, .init(length))
    }
}
extension Int32: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float32>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_vfix32(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Float32>, inc incy: Int, length: Int) {
        vDSP_vflt32(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float64>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_vfix32D(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Float64>, inc incy: Int, length: Int) {
        vDSP_vflt32D(x, incx, y, incy, .init(length))
    }
}
extension UInt8: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float32>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_vfixu8(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Float32>, inc incy: Int, length: Int) {
        vDSP_vfltu8(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float64>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_vfixu8D(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Float64>, inc incy: Int, length: Int) {
        vDSP_vfltu8D(x, incx, y, incy, .init(length))
    }
}
extension UInt16: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float32>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_vfixu16(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Float32>, inc incy: Int, length: Int) {
        vDSP_vfltu16(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float64>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_vfixu16D(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Float64>, inc incy: Int, length: Int) {
        vDSP_vfltu16D(x, incx, y, incy, .init(length))
    }
}
extension UInt32: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float32>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_vfixu32(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Float32>, inc incy: Int, length: Int) {
        vDSP_vfltu32(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float64>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_vfixu32D(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Float64>, inc incy: Int, length: Int) {
        vDSP_vfltu32D(x, incx, y, incy, .init(length))
    }
}
extension Float32: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float64>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_vdpsp(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Float64>, inc incy: Int, length: Int) {
        vDSP_vspdp(x, incx, y, incy, .init(length))
    }
}
extension Float64: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float32>, inc incx: Int, y: UnsafeMutablePointer<Self>, inc incy: Int, length: Int) {
        vDSP_vspdp(x, incx, y, incy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, inc incx: Int, y: UnsafeMutablePointer<Float32>, inc incy: Int, length: Int) {
        vDSP_vdpsp(x, incx, y, incy, .init(length))
    }
}
