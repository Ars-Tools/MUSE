//
//  TYPECAST.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import Accelerate.vecLib
import typealias Numerics.Complex64
import typealias Numerics.Complex128
@usableFromInline
enum TYPECAST {}
public protocol Float32CompatibleElement {
    static func Convert(_ A: UnsafePointer<Float32>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float32>, _ IB: Int, _ N: Int)
}
public protocol Float64CompatibleElement {
    static func Convert(_ A: UnsafePointer<Float64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int)
    static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float64>, _ IB: Int, _ N: Int)
}
extension Float32CompatibleElement {
    static func Convert(_ A: UnsafePointer<Complex64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        A.withMemoryRebound(to: Float32.self, capacity: 2 * IA * N) {
            Convert($0, 2 * IA, B, IB, N)
        }
    }
    static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Complex64>, _ IB: Int, _ N: Int) {
        B.withMemoryRebound(to: Float32.self, capacity: 2 * IB * N) {
            Convert(A, IA, $0, 2 * IB, N)
            vDSP_vclr($0.advanced(by: 1), 2 * IB, .init(N))
        }
    }
}
extension Float64CompatibleElement {
    static func Convert(_ A: UnsafePointer<Complex128>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        A.withMemoryRebound(to: Float64.self, capacity: 2 * IA * N) {
            Convert($0, 2 * IA, B, IB, N)
        }
    }
    static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Complex128>, _ IB: Int, _ N: Int) {
        B.withMemoryRebound(to: Float64.self, capacity: 2 * IB * N) {
            Convert(A, IA, $0, 2 * IB, N)
            vDSP_vclrD($0.advanced(by: 1), 2 * IB, .init(N))
        }
    }
}
extension Int8: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Float32>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        vDSP_vfix8(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float32>, _ IB: Int, _ N: Int) {
        vDSP_vflt8(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Float64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        vDSP_vfix8D(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float64>, _ IB: Int, _ N: Int) {
        vDSP_vflt8D(A, IA, B, IB, .init(N))
    }
}
extension Int16: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Float32>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        vDSP_vfix16(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float32>, _ IB: Int, _ N: Int) {
        vDSP_vflt16(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Float64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        vDSP_vfix16D(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float64>, _ IB: Int, _ N: Int) {
        vDSP_vflt16D(A, IA, B, IB, .init(N))
    }
}
extension Int32: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Float32>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        vDSP_vfix32(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float32>, _ IB: Int, _ N: Int) {
        vDSP_vflt32(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Float64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        vDSP_vfix32D(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float64>, _ IB: Int, _ N: Int) {
        vDSP_vflt32D(A, IA, B, IB, .init(N))
    }
}
extension UInt8: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Float32>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        vDSP_vfixu8(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float32>, _ IB: Int, _ N: Int) {
        vDSP_vfltu8(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Float64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        vDSP_vfixu8D(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float64>, _ IB: Int, _ N: Int) {
        vDSP_vfltu8D(A, IA, B, IB, .init(N))
    }
}
extension UInt16: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Float32>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        vDSP_vfixu16(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float32>, _ IB: Int, _ N: Int) {
        vDSP_vfltu16(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Float64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        vDSP_vfixu16D(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float64>, _ IB: Int, _ N: Int) {
        vDSP_vfltu16D(A, IA, B, IB, .init(N))
    }
}
extension UInt32: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Float32>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        vDSP_vfixu32(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float32>, _ IB: Int, _ N: Int) {
        vDSP_vflt32(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Float64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        vDSP_vfix32D(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float64>, _ IB: Int, _ N: Int) {
        vDSP_vflt32D(A, IA, B, IB, .init(N))
    }
}
extension Float32: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        cblas_scopy(N, A, IA, B, IB)
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Float64>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        vDSP_vdpsp(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float64>, _ IB: Int, _ N: Int) {
        vDSP_vspdp(A, IA, B, IB, .init(N))
    }
}
extension Float64: Float32CompatibleElement & Float64CompatibleElement {
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Float32>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        vDSP_vspdp(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Float32>, _ IB: Int, _ N: Int) {
        vDSP_vdpsp(A, IA, B, IB, .init(N))
    }
    @inlinable@inline(__always)@_transparent
    public static func Convert(_ A: UnsafePointer<Self>, _ IA: Int, _ B: UnsafeMutablePointer<Self>, _ IB: Int, _ N: Int) {
        cblas_dcopy(N, A, IA, B, IB)
    }
}
