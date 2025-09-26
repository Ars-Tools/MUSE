//
//  Arithmetic.swift
//  MUSE
//
//  Created by Kota on 9/25/25.
//
import Accelerate.vecLib
import typealias Numerics.Complex64
import typealias Numerics.Complex128
import typealias Layout.MemoryStrategy
import func Layout.flatten
import func Layout.capacity
public enum Arithmetic<Element: ArithmeticElement> {
    public typealias Storage = Array<Element>
}
public protocol ArithmeticElement: Numeric & BitwiseCopyable {
    @inlinable@inline(__always)
    static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int)
    @inlinable@inline(__always)
    static func Scale(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int)
    @inlinable@inline(__always)
    static func Mul(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int)
    @inlinable@inline(__always)
    static func Div(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int)
    @inlinable@inline(__always)
    static func Add(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int)
    @inlinable@inline(__always)
    static func Sub(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int)
    @inlinable@inline(__always)
    static func FMA(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafePointer<Self>, ldz: Int, w: UnsafeMutablePointer<Self>, ldw: Int, length: Int)
}
extension ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        for index in 0..<length {
            y[index * ldy] = x[index * ldx]
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func Scale(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        for index in 0..<length {
            z[index * ldz] = x[index * ldx] * y.pointee
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func Mul(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        for index in 0..<length {
            z[index * ldz] = x[index * ldx] * y[index * ldy]
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func Add(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        for index in 0..<length {
            z[index * ldz] = x[index * ldx] + y[index * ldy]
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func Sub(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        for index in 0..<length {
            z[index * ldz] = x[index * ldx] - y[index * ldy]
        }
    }
    @inlinable@inline(__always)@_transparent
    public static func FMA(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafePointer<Self>, ldz: Int, w: UnsafeMutablePointer<Self>, ldw: Int, length: Int) {
        for index in 0..<length {
            w[index * ldz] = x[index * ldx] * y[index * ldy] + z[index * ldz]
        }
    }
}
extension Float16: ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        for index in 0..<length {
            z[index * ldz] = x[index * ldx] / y[index * ldy]
        }
    }
}
extension Int32: ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        vDSP_vdivi(y, .init(ldy), x, .init(ldx), z, .init(ldz), .init(length))
    }
}
extension Int64: ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        for index in 0..<length {
            z[index * ldz] = x[index * ldx] / y[index * ldy]
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
                Copy(x: x.advanced(by: offset.x), ldx: stride.x,
                     y: y.advanced(by: offset.y), ldy: stride.y,
                     length: length)
            }
            return try body(y)
        }
    }
}
extension Float32: ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        scopy_(withUnsafePointer(to: length, \.self),
               x, withUnsafePointer(to: ldx, \.self),
               y, withUnsafePointer(to: ldy, \.self))
    }
    @inlinable@inline(__always)@_transparent
    public static func Scale(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        vDSP_vsmul(x, ldx, y, z, ldz, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Mul(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        vDSP_vmul(x, .init(ldx), y, .init(ldy), z, .init(ldz), .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Add(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        vDSP_vadd(x, .init(ldx), y, .init(ldy), z, .init(ldz), .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        vDSP_vdiv(y, .init(ldy), x, .init(ldx), z, .init(ldz), .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Sub(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        vDSP_vsub(y, .init(ldy), x, .init(ldx), z, .init(ldz), .init(length))
    }
    @inlinable@inline(__always)
    public static func FMA(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafePointer<Self>, ldz: Int, w: UnsafeMutablePointer<Self>, ldw: Int, length: Int) {
        vDSP_vma(x, .init(ldx), y, .init(ldy), z, .init(ldz), w, .init(ldw), .init(length))
    }
}
extension Float64: ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        dcopy_(withUnsafePointer(to: length, \.self),
               x, withUnsafePointer(to: ldx, \.self),
               y, withUnsafePointer(to: ldy, \.self))
    }
    @inlinable@inline(__always)@_transparent
    public static func Scale(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        vDSP_vsmulD(x, ldx, y, z, ldz, .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Mul(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        vDSP_vmulD(x, .init(ldx), y, .init(ldy), z, .init(ldz), .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Add(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        vDSP_vaddD(x, .init(ldx), y, .init(ldy), z, .init(ldz), .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        vDSP_vdivD(y, .init(ldy), x, .init(ldx), z, .init(ldz), .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Sub(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        vDSP_vsubD(y, .init(ldy), x, .init(ldx), z, .init(ldz), .init(length))
    }
    @inlinable@inline(__always)
    public static func FMA(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafePointer<Self>, ldz: Int, w: UnsafeMutablePointer<Self>, ldw: Int, length: Int) {
        vDSP_vmaD(x, .init(ldx), y, .init(ldy), z, .init(ldz), w, .init(ldw), .init(length))
    }
}
extension Complex64: ArithmeticElement {
    @inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        ccopy_(withUnsafePointer(to: length, \.self),
               .init(x), withUnsafePointer(to: ldx, \.self),
               .init(y), withUnsafePointer(to: ldy, \.self))
    }
    @inlinable@inline(__always)@_transparent
    public static func Scale(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        var x = DSPSplitComplex(realp: .init(.init(x)).advanced(by: 0),
                                imagp: .init(.init(x)).advanced(by: 1))
        var y = DSPSplitComplex(realp: .init(.init(y)).advanced(by: 0),
                                imagp: .init(.init(y)).advanced(by: 1))
        var z = DSPSplitComplex(realp: .init(.init(z)).advanced(by: 0),
                                imagp: .init(.init(z)).advanced(by: 1))
        vDSP_zvzsml(&x, .init(2 * ldx),
                    &y,
                    &z, .init(2 * ldz),
                    .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Mul(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        var x = DSPSplitComplex(realp: .init(.init(x)).advanced(by: 0),
                                imagp: .init(.init(x)).advanced(by: 1))
        var y = DSPSplitComplex(realp: .init(.init(y)).advanced(by: 0),
                                imagp: .init(.init(y)).advanced(by: 1))
        var z = DSPSplitComplex(realp: .init(.init(z)).advanced(by: 0),
                                imagp: .init(.init(z)).advanced(by: 1))
        vDSP_zvmul(&x, .init(2 * ldx),
                   &y, .init(2 * ldy),
                   &z, .init(2 * ldz),
                   .init(length), 1)
    }
    @inlinable@inline(__always)@_transparent
    public static func Add(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        var x = DSPSplitComplex(realp: .init(.init(x)).advanced(by: 0),
                                imagp: .init(.init(x)).advanced(by: 1))
        var y = DSPSplitComplex(realp: .init(.init(y)).advanced(by: 0),
                                imagp: .init(.init(y)).advanced(by: 1))
        var z = DSPSplitComplex(realp: .init(.init(z)).advanced(by: 0),
                                imagp: .init(.init(z)).advanced(by: 1))
        vDSP_zvadd(&x, .init(2 * ldx),
                   &y, .init(2 * ldy),
                   &z, .init(2 * ldz),
                   .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        var x = DSPSplitComplex(realp: .init(.init(x)).advanced(by: 0),
                                imagp: .init(.init(x)).advanced(by: 1))
        var y = DSPSplitComplex(realp: .init(.init(y)).advanced(by: 0),
                                imagp: .init(.init(y)).advanced(by: 1))
        var z = DSPSplitComplex(realp: .init(.init(z)).advanced(by: 0),
                                imagp: .init(.init(z)).advanced(by: 1))
        vDSP_zvdiv(&y, .init(2 * ldy),
                   &x, .init(2 * ldx),
                   &z, .init(2 * ldz),
                   .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Sub(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        var x = DSPSplitComplex(realp: .init(.init(x)).advanced(by: 0),
                                imagp: .init(.init(x)).advanced(by: 1))
        var y = DSPSplitComplex(realp: .init(.init(y)).advanced(by: 0),
                                imagp: .init(.init(y)).advanced(by: 1))
        var z = DSPSplitComplex(realp: .init(.init(z)).advanced(by: 0),
                                imagp: .init(.init(z)).advanced(by: 1))
        vDSP_zvsub(&x, .init(2 * ldx),
                   &y, .init(2 * ldy),
                   &z, .init(2 * ldz),
                   .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func FMA(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafePointer<Self>, ldz: Int, w: UnsafeMutablePointer<Self>, ldw: Int, length: Int) {
        var x = DSPSplitComplex(realp: .init(.init(x)).advanced(by: 0),
                                imagp: .init(.init(x)).advanced(by: 1))
        var y = DSPSplitComplex(realp: .init(.init(y)).advanced(by: 0),
                                imagp: .init(.init(y)).advanced(by: 1))
        var z = DSPSplitComplex(realp: .init(.init(z)).advanced(by: 0),
                                imagp: .init(.init(z)).advanced(by: 1))
        var w = DSPSplitComplex(realp: .init(.init(w)).advanced(by: 0),
                                imagp: .init(.init(w)).advanced(by: 1))
        vDSP_zvma(&x, .init(2 * ldx),
                  &y, .init(2 * ldy),
                  &z, .init(2 * ldz),
                  &w, .init(2 * ldw),
                  .init(length))
    }
}
extension Complex128: ArithmeticElement {@inlinable@inline(__always)@_transparent
    public static func Copy(x: UnsafePointer<Self>, ldx: Int, y: UnsafeMutablePointer<Self>, ldy: Int, length: Int) {
        zcopy_(withUnsafePointer(to: length, \.self),
               .init(x), withUnsafePointer(to: ldx, \.self),
               .init(y), withUnsafePointer(to: ldy, \.self))
    }
    @inlinable@inline(__always)@_transparent
    public static func Scale(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        var x = DSPDoubleSplitComplex(realp: .init(.init(x)).advanced(by: 0),
                                      imagp: .init(.init(x)).advanced(by: 1))
        var y = DSPDoubleSplitComplex(realp: .init(.init(y)).advanced(by: 0),
                                      imagp: .init(.init(y)).advanced(by: 1))
        var z = DSPDoubleSplitComplex(realp: .init(.init(z)).advanced(by: 0),
                                      imagp: .init(.init(z)).advanced(by: 1))
        vDSP_zvzsmlD(&x, .init(2 * ldx),
                     &y,
                     &z, .init(2 * ldz),
                     .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Mul(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        var x = DSPDoubleSplitComplex(realp: .init(.init(x)).advanced(by: 0),
                                      imagp: .init(.init(x)).advanced(by: 1))
        var y = DSPDoubleSplitComplex(realp: .init(.init(y)).advanced(by: 0),
                                      imagp: .init(.init(y)).advanced(by: 1))
        var z = DSPDoubleSplitComplex(realp: .init(.init(z)).advanced(by: 0),
                                      imagp: .init(.init(z)).advanced(by: 1))
        vDSP_zvmulD(&x, .init(2 * ldx),
                    &y, .init(2 * ldy),
                    &z, .init(2 * ldz),
                    .init(length), 1)
    }
    @inlinable@inline(__always)@_transparent
    public static func Add(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        var x = DSPDoubleSplitComplex(realp: .init(.init(x)).advanced(by: 0),
                                      imagp: .init(.init(x)).advanced(by: 1))
        var y = DSPDoubleSplitComplex(realp: .init(.init(y)).advanced(by: 0),
                                      imagp: .init(.init(y)).advanced(by: 1))
        var z = DSPDoubleSplitComplex(realp: .init(.init(z)).advanced(by: 0),
                                      imagp: .init(.init(z)).advanced(by: 1))
        vDSP_zvaddD(&x, .init(2 * ldx),
                    &y, .init(2 * ldy),
                    &z, .init(2 * ldz),
                    .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Div(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        var x = DSPDoubleSplitComplex(realp: .init(.init(x)).advanced(by: 0),
                                      imagp: .init(.init(x)).advanced(by: 1))
        var y = DSPDoubleSplitComplex(realp: .init(.init(y)).advanced(by: 0),
                                      imagp: .init(.init(y)).advanced(by: 1))
        var z = DSPDoubleSplitComplex(realp: .init(.init(z)).advanced(by: 0),
                                      imagp: .init(.init(z)).advanced(by: 1))
        vDSP_zvdivD(&y, .init(2 * ldy),
                    &x, .init(2 * ldx),
                    &z, .init(2 * ldz),
                    .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func Sub(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafeMutablePointer<Self>, ldz: Int, length: Int) {
        var x = DSPDoubleSplitComplex(realp: .init(.init(x)).advanced(by: 0),
                                      imagp: .init(.init(x)).advanced(by: 1))
        var y = DSPDoubleSplitComplex(realp: .init(.init(y)).advanced(by: 0),
                                      imagp: .init(.init(y)).advanced(by: 1))
        var z = DSPDoubleSplitComplex(realp: .init(.init(z)).advanced(by: 0),
                                      imagp: .init(.init(z)).advanced(by: 1))
        vDSP_zvsubD(&x, .init(2 * ldx),
                    &y, .init(2 * ldy),
                    &z, .init(2 * ldz),
                    .init(length))
    }
    @inlinable@inline(__always)@_transparent
    public static func FMA(x: UnsafePointer<Self>, ldx: Int, y: UnsafePointer<Self>, ldy: Int, z: UnsafePointer<Self>, ldz: Int, w: UnsafeMutablePointer<Self>, ldw: Int, length: Int) {
        var x = DSPDoubleSplitComplex(realp: .init(.init(x)).advanced(by: 0),
                                      imagp: .init(.init(x)).advanced(by: 1))
        var y = DSPDoubleSplitComplex(realp: .init(.init(y)).advanced(by: 0),
                                      imagp: .init(.init(y)).advanced(by: 1))
        var z = DSPDoubleSplitComplex(realp: .init(.init(z)).advanced(by: 0),
                                      imagp: .init(.init(z)).advanced(by: 1))
        var w = DSPDoubleSplitComplex(realp: .init(.init(w)).advanced(by: 0),
                                      imagp: .init(.init(w)).advanced(by: 1))
        vDSP_zvmaD(&x, .init(2 * ldx),
                   &y, .init(2 * ldy),
                   &z, .init(2 * ldz),
                   &w, .init(2 * ldw),
                   .init(length))
    }
}
