//
//  vFORCE+Log.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import func Layout.capacity
import AltVec
extension vFORCE {
    @frozen public struct Log<X: Tensor<Element>> {
        public typealias S = Log<X.S>
        public typealias T = Log<X.T>
        public typealias U = Log<X.U>
        public typealias V = Log<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Log2<X: Tensor<Element>> {
        public typealias S = Log2<X.S>
        public typealias T = Log2<X.T>
        public typealias U = Log2<X.U>
        public typealias V = Log2<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Log10<X: Tensor<Element>> {
        public typealias S = Log10<X.S>
        public typealias T = Log10<X.T>
        public typealias U = Log10<X.U>
        public typealias V = Log10<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Log1p<X: Tensor<Element>> {
        public typealias S = Log1p<X.S>
        public typealias T = Log1p<X.T>
        public typealias U = Log1p<X.U>
        public typealias V = Log1p<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
}
// MARK: Log
extension vFORCE.Log: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Log: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Log: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Log: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
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
extension vFORCE.Log: InstantScalar where X: InstantScalar {}
extension vFORCE.Log: InstantVector where X: InstantVector {}
extension vFORCE.Log: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Log: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
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
// MARK: Log2
extension vFORCE.Log2: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Log2: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Log2: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Log2: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
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
extension vFORCE.Log2: InstantScalar where X: InstantScalar {}
extension vFORCE.Log2: InstantVector where X: InstantVector {}
extension vFORCE.Log2: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Log2: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
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
// MARK: Log10
extension vFORCE.Log10: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Log10: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Log10: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Log10: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
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
extension vFORCE.Log10: InstantScalar where X: InstantScalar {}
extension vFORCE.Log10: InstantVector where X: InstantVector {}
extension vFORCE.Log10: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Log10: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
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
// MARK: Expm1
extension vFORCE.Log1p: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Log1p: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Log1p: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Log1p: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
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
extension vFORCE.Log1p: InstantScalar where X: InstantScalar {}
extension vFORCE.Log1p: InstantVector where X: InstantVector {}
extension vFORCE.Log1p: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Log1p: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
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
