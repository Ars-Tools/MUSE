//
//  Buffer+Scalar.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
@_exported import typealias Numerics.Complex64
@_exported import typealias Numerics.Complex128
protocol ScalarBuffer<Element>: MutableScalar & BitwiseCopyable & Sendable where S == Self, T == Self, U == Self, V == Self, Storage == CollectionOfOne<Self> {}
extension ScalarBuffer {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Storage) {
        ([], {.init(self)})
    }
}
extension Bool: ScalarBuffer {
    public typealias Element = Self
}
extension Int: ScalarBuffer {
    public typealias Element = Self
}
extension UInt: ScalarBuffer {
    public typealias Element = Self
}
extension Int8: ScalarBuffer {
    public typealias Element = Self
}
extension Int16: ScalarBuffer {
    public typealias Element = Self
}
extension Int32: ScalarBuffer {
    public typealias Element = Self
}
extension Int64: ScalarBuffer {
    public typealias Element = Self
}
extension UInt8: ScalarBuffer {
    public typealias Element = Self
}
extension UInt16: ScalarBuffer {
    public typealias Element = Self
}
extension UInt32: ScalarBuffer {
    public typealias Element = Self
}
extension UInt64: ScalarBuffer {
    public typealias Element = Self
}
extension Float32: ScalarBuffer {
    public typealias Element = Self
}
extension Float64: ScalarBuffer {
    public typealias Element = Self
}
extension Complex64: ScalarBuffer {
    public typealias Element = Self
}
extension Complex128: ScalarBuffer {
    public typealias Element = Self
}
