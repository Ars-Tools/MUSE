//
//  TypeCast.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import Accelerate.vecLib
public enum TypeCast {}
public protocol Float32CompatibleElement {
    @inlinable@inline(__always)
    static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Float32>, ldy: Int, length: Int)
    @inlinable@inline(__always)
    static func Copy(x: UnsafePointer<Float32>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int)
}
public protocol Float64CompatibleElement {
    @inlinable@inline(__always)
    static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Float64>, ldy: Int, length: Int)
    @inlinable@inline(__always)
    static func Copy(x: UnsafePointer<Float64>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int)
}
extension Float32CompatibleElement {
    @inlinable@inline(__always)@_transparent
    static func Copy(x: UnsafePointer<Complex64>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        x.withMemoryRebound(to: Float32.self, capacity: 2 * ldx * length) {
            Copy(x: $0, ldx: 2 * ldx, y: y, ldy: ldy, length: length)
        }
    }
    @inlinable@inline(__always)@_transparent
    static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Complex64>, ldy: Int, length: Int) {
        y.withMemoryRebound(to: Float32.self, capacity: 2 * ldx * length) {
            Copy(x: x, ldx: ldx, y: y, ldy: 2 * ldy, length: length)
            vDSP_vclr($0.advanced(by: 1), 2 * ldy, .init(length))
        }
    }
}
extension Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    static func Copy(x: UnsafePointer<Complex64>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        x.withMemoryRebound(to: Float64.self, capacity: 2 * ldx * length) {
            Copy(x: $0, ldx: 2 * ldx, y: y, ldy: ldy, length: length)
        }
    }
    @inlinable@inline(__always)@_transparent
    static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Complex64>, ldy: Int, length: Int) {
        y.withMemoryRebound(to: Float64.self, capacity: 2 * ldx * length) {
            Copy(x: x, ldx: ldx, y: y, ldy: 2 * ldy, length: length)
            vDSP_vclrD($0.advanced(by: 1), 2 * ldy, .init(length))
        }
    }
}
extension Int8: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float32>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        vDSP_vfix8(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Float32>, ldy: Int, length: Int) {
        vDSP_vflt8(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float64>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        vDSP_vfix8D(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Float64>, ldy: Int, length: Int) {
        vDSP_vflt8D(x, ldx, y, ldy, .init(length))
    }
}
extension Int16: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float32>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        vDSP_vfix16(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Float32>, ldy: Int, length: Int) {
        vDSP_vflt16(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float64>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        vDSP_vfix16D(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Float64>, ldy: Int, length: Int) {
        vDSP_vflt16D(x, ldx, y, ldy, .init(length))
    }
}
extension Int32: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float32>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        vDSP_vfix32(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Float32>, ldy: Int, length: Int) {
        vDSP_vflt32(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float64>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        vDSP_vfix32D(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Float64>, ldy: Int, length: Int) {
        vDSP_vflt32D(x, ldx, y, ldy, .init(length))
    }
}
extension UInt8: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float32>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        vDSP_vfixu8(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Float32>, ldy: Int, length: Int) {
        vDSP_vfltu8(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float64>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        vDSP_vfixu8D(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Float64>, ldy: Int, length: Int) {
        vDSP_vfltu8D(x, ldx, y, ldy, .init(length))
    }
}
extension UInt16: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float32>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        vDSP_vfixu16(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Float32>, ldy: Int, length: Int) {
        vDSP_vfltu16(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float64>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        vDSP_vfixu16D(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Float64>, ldy: Int, length: Int) {
        vDSP_vfltu16D(x, ldx, y, ldy, .init(length))
    }
}
extension UInt32: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float32>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        vDSP_vfixu32(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Float32>, ldy: Int, length: Int) {
        vDSP_vfltu32(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float64>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        vDSP_vfixu32D(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Float64>, ldy: Int, length: Int) {
        vDSP_vfltu32D(x, ldx, y, ldy, .init(length))
    }
}
extension Float32: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float64>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        vDSP_vdpsp(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Float64>, ldy: Int, length: Int) {
        vDSP_vspdp(x, ldx, y, ldy, .init(length))
    }
}
extension Float64: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Float32>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        vDSP_vspdp(x, ldx, y, ldy, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Float32>, ldy: Int, length: Int) {
        vDSP_vdpsp(x, ldx, y, ldy, .init(length))
    }
}
