//
//  vFORCE+Exp.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
extension vFORCE {
    @frozen public struct Exp<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Exp2<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Exp10<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Expm1<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
}
// MARK: Exp
extension vFORCE.Exp: Tensor {
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
                                Element.exp(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Exp: InstantTensor where X: InstantTensor {
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
                                Element.exp(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Exp: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Exp: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Exp: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Exp: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Exp<X.S>
    public typealias T = vFORCE.Exp<X.T>
    public typealias U = vFORCE.Exp<X.U>
    public typealias V = vFORCE.Exp<X.V>
}
// MARK: Exp2
extension vFORCE.Exp2: Tensor {
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
                                Element.exp2(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Exp2: InstantTensor where X: InstantTensor {
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
                                Element.exp2(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Exp2: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Exp2: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Exp2: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Exp2: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Exp2<X.S>
    public typealias T = vFORCE.Exp2<X.T>
    public typealias U = vFORCE.Exp2<X.U>
    public typealias V = vFORCE.Exp2<X.V>
}
// MARK: Exp10
extension vFORCE.Exp10: Tensor {
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
                                Element.exp10(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Exp10: InstantTensor where X: InstantTensor {
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
                                Element.exp10(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Exp10: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Exp10: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Exp10: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Exp10: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Exp10<X.S>
    public typealias T = vFORCE.Exp10<X.T>
    public typealias U = vFORCE.Exp10<X.U>
    public typealias V = vFORCE.Exp10<X.V>
}
// MARK: Expm1
extension vFORCE.Expm1: Tensor {
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
                                Element.expm1(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Expm1: InstantTensor where X: InstantTensor {
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
                                Element.expm1(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Expm1: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Expm1: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Expm1: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Expm1: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Expm1<X.S>
    public typealias T = vFORCE.Expm1<X.T>
    public typealias U = vFORCE.Expm1<X.U>
    public typealias V = vFORCE.Expm1<X.V>
}
public func exp<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Exp<X> {
    .init(x: x)
}
public func exp2<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Exp2<X> {
    .init(x: x)
}
public func exp10<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Exp10<X> {
    .init(x: x)
}
public func expm1<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Expm1<X> {
    .init(x: x)
}
