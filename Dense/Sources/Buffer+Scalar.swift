//
//  Buffer+Scalar.swift
//  MUSE
//
//  Created by Kota on 9/8/R7.
//
import protocol Accelerate.AccelerateBuffer
import protocol Accelerate.AccelerateMutableBuffer
import typealias Numerics.Complex32
import typealias Numerics.Complex64
import typealias Numerics.Complex128
import typealias Layout.MemoryStrategy
extension CollectionOfOne: @retroactive AccelerateBuffer & AccelerateMutableBuffer {
    @inlinable
    public func withUnsafeBufferPointer<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R) rethrows -> R {
        try span.withUnsafeBufferPointer(body)
    }
}
extension Bool: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
extension Int: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
extension Int8: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
extension Int16: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
extension Int32: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
extension Int64: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
extension Int128: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
extension UInt8: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
extension UInt16: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
extension UInt32: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
extension UInt64: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
extension UInt128: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
extension Float16: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
extension Float32: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
extension Float64: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
extension Complex32: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
extension Complex64: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
extension Complex128: MutableScalar {
    public typealias R = CollectionOfOne<Self>
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        ([], {R(self)})
    }
}
