//
//  vFORCE+Log.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
extension vFORCE {
    public struct Log<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    public struct Log2<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    public struct Log10<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    public struct Log1p<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
}
// MARK: Log
extension vFORCE.Log: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let shape = x.shape
            let ys = strategy.stride(for: shape)
            let capacity = capacity(alloc: shape, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: shape, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.log(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Log: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let shape = x.shape
            let ys = strategy.stride(for: shape)
            let capacity = capacity(alloc: shape, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: shape, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.log(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Log: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Log: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Log: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Log: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Log<X.S>
    public typealias T = vFORCE.Log<X.T>
    public typealias U = vFORCE.Log<X.U>
    public typealias V = vFORCE.Log<X.V>
}
// MARK: Log2
extension vFORCE.Log2: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let shape = x.shape
            let ys = strategy.stride(for: shape)
            let capacity = capacity(alloc: shape, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: shape, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.log2(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Log2: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let shape = x.shape
            let ys = strategy.stride(for: shape)
            let capacity = capacity(alloc: shape, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: shape, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.log2(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Log2: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Log2: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Log2: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Log2: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Log2<X.S>
    public typealias T = vFORCE.Log2<X.T>
    public typealias U = vFORCE.Log2<X.U>
    public typealias V = vFORCE.Log2<X.V>
}
// MARK: Exp10
extension vFORCE.Log10: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let shape = x.shape
            let ys = strategy.stride(for: shape)
            let capacity = capacity(alloc: shape, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: shape, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.log10(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Log10: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let shape = x.shape
            let ys = strategy.stride(for: shape)
            let capacity = capacity(alloc: shape, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: shape, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.log10(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Log10: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Log10: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Log10: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Log10: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Log10<X.S>
    public typealias T = vFORCE.Log10<X.T>
    public typealias U = vFORCE.Log10<X.U>
    public typealias V = vFORCE.Log10<X.V>
}
// MARK: Log1p
extension vFORCE.Log1p: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let shape = x.shape
            let ys = strategy.stride(for: shape)
            let capacity = capacity(alloc: shape, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: shape, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.log1p(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Log1p: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let shape = x.shape
            let ys = strategy.stride(for: shape)
            let capacity = capacity(alloc: shape, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: shape, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.log1p(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Log1p: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Log1p: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Log1p: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Log1p: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Log1p<X.S>
    public typealias T = vFORCE.Log1p<X.T>
    public typealias U = vFORCE.Log1p<X.U>
    public typealias V = vFORCE.Log1p<X.V>
}
public func log<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Log<X> {
    .init(x: x)
}
public func log2<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Log2<X> {
    .init(x: x)
}
public func log10<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Log10<X> {
    .init(x: x)
}
public func log1p<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Log1p<X> {
    .init(x: x)
}
