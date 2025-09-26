//
//  vFORCE+Arc.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
extension vFORCE {
    @frozen public struct ArcSin<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct ArcCos<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct ArcTan<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct ArcSinh<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct ArcCosh<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct ArcTanh<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
}
// MARK: ArcSin
extension vFORCE.ArcSin: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.asin(x.advanced(by: offset.x), stride.x,
                                             y.advanced(by: offset.y), stride.y,
                                             length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension vFORCE.ArcSin: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.asin(x.advanced(by: offset.x), stride.x,
                                             y.advanced(by: offset.y), stride.y,
                                             length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension vFORCE.ArcSin: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.ArcSin: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.ArcSin: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcSin: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.ArcSin<X.S>
    public typealias T = vFORCE.ArcSin<X.T>
    public typealias U = vFORCE.ArcSin<X.U>
    public typealias V = vFORCE.ArcSin<X.V>
}
// MARK: ArcCos
extension vFORCE.ArcCos: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.acos(x.advanced(by: offset.x), stride.x,
                                             y.advanced(by: offset.y), stride.y,
                                             length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension vFORCE.ArcCos: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.acos(x.advanced(by: offset.x), stride.x,
                                             y.advanced(by: offset.y), stride.y,
                                             length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension vFORCE.ArcCos: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.ArcCos: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.ArcCos: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcCos: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.ArcCos<X.S>
    public typealias T = vFORCE.ArcCos<X.T>
    public typealias U = vFORCE.ArcCos<X.U>
    public typealias V = vFORCE.ArcCos<X.V>
}
// MARK: ArcTan
extension vFORCE.ArcTan: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.atan(x.advanced(by: offset.x), stride.x,
                                             y.advanced(by: offset.y), stride.y,
                                             length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension vFORCE.ArcTan: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.atan(x.advanced(by: offset.x), stride.x,
                                             y.advanced(by: offset.y), stride.y,
                                             length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension vFORCE.ArcTan: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.ArcTan: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.ArcTan: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcTan: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.ArcTan<X.S>
    public typealias T = vFORCE.ArcTan<X.T>
    public typealias U = vFORCE.ArcTan<X.U>
    public typealias V = vFORCE.ArcTan<X.V>
}
// MARK: ArcSinh
extension vFORCE.ArcSinh: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.asinh(x.advanced(by: offset.x), stride.x,
                                              y.advanced(by: offset.y), stride.y,
                                              length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension vFORCE.ArcSinh: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.sinh(x.advanced(by: offset.x), stride.x,
                                             y.advanced(by: offset.y), stride.y,
                                             length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension vFORCE.ArcSinh: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.ArcSinh: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.ArcSinh: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcSinh: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.ArcSinh<X.S>
    public typealias T = vFORCE.ArcSinh<X.T>
    public typealias U = vFORCE.ArcSinh<X.U>
    public typealias V = vFORCE.ArcSinh<X.V>
}
// MARK: ArcCosh
extension vFORCE.ArcCosh: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.acosh(x.advanced(by: offset.x), stride.x,
                                              y.advanced(by: offset.y), stride.y,
                                              length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension vFORCE.ArcCosh: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.acosh(x.advanced(by: offset.x), stride.x,
                                              y.advanced(by: offset.y), stride.y,
                                              length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension vFORCE.ArcCosh: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.ArcCosh: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.ArcCosh: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcCosh: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.ArcCosh<X.S>
    public typealias T = vFORCE.ArcCosh<X.T>
    public typealias U = vFORCE.ArcCosh<X.U>
    public typealias V = vFORCE.ArcCosh<X.V>
}
// MARK: ArcTanh
extension vFORCE.ArcTanh: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.atanh(x.advanced(by: offset.x), stride.x,
                                              y.advanced(by: offset.y), stride.y,
                                              length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension vFORCE.ArcTanh: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.atanh(x.advanced(by: offset.x), stride.x,
                                              y.advanced(by: offset.y), stride.y,
                                              length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension vFORCE.ArcTanh: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.ArcTanh: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.ArcTanh: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcTanh: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.ArcTanh<X.S>
    public typealias T = vFORCE.ArcTanh<X.T>
    public typealias U = vFORCE.ArcTanh<X.U>
    public typealias V = vFORCE.ArcTanh<X.V>
}
@_disfavoredOverload
public func asin<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Sin<X> {
    .init(x: x)
}
@_disfavoredOverload
public func acos<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Cos<X> {
    .init(x: x)
}
@_disfavoredOverload
public func atan<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Tan<X> {
    .init(x: x)
}
@_disfavoredOverload
public func asinh<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Sinh<X> {
    .init(x: x)
}
@_disfavoredOverload
public func acosh<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Cosh<X> {
    .init(x: x)
}
@_disfavoredOverload
public func atanh<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Tanh<X> {
    .init(x: x)
}
