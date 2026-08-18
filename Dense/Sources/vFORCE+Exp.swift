//
//  vFORCE+Exp.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import func Layout.capacity
import AltVec
extension vFORCE {
    @frozen public struct Exp<X: Tensor<Element>> {
        public typealias S = Exp<X.S>
        public typealias T = Exp<X.T>
        public typealias U = Exp<X.U>
        public typealias V = Exp<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Exp2<X: Tensor<Element>> {
        public typealias S = Exp2<X.S>
        public typealias T = Exp2<X.T>
        public typealias U = Exp2<X.U>
        public typealias V = Exp2<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Exp10<X: Tensor<Element>> {
        public typealias S = Exp10<X.S>
        public typealias T = Exp10<X.T>
        public typealias U = Exp10<X.U>
        public typealias V = Exp10<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Expm1<X: Tensor<Element>> {
        public typealias S = Expm1<X.S>
        public typealias T = Expm1<X.T>
        public typealias U = Expm1<X.U>
        public typealias V = Expm1<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
}
// MARK: Exp
extension vFORCE.Exp: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Exp: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Exp: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Exp: Tensor & Operator.UnaryTensor {
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
extension vFORCE.Exp: InstantScalar where X: InstantScalar {}
extension vFORCE.Exp: InstantVector where X: InstantVector {}
extension vFORCE.Exp: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Exp: InstantTensor where X: InstantTensor {
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
// MARK: Exp2
extension vFORCE.Exp2: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Exp2: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Exp2: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Exp2: Tensor & Operator.UnaryTensor {
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
extension vFORCE.Exp2: InstantScalar where X: InstantScalar {}
extension vFORCE.Exp2: InstantVector where X: InstantVector {}
extension vFORCE.Exp2: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Exp2: InstantTensor where X: InstantTensor {
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
// MARK: Exp10
extension vFORCE.Exp10: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Exp10: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Exp10: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Exp10: Tensor & Operator.UnaryTensor {
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
extension vFORCE.Exp10: InstantScalar where X: InstantScalar {}
extension vFORCE.Exp10: InstantVector where X: InstantVector {}
extension vFORCE.Exp10: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Exp10: InstantTensor where X: InstantTensor {
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
// MARK: Expm1
extension vFORCE.Expm1: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Expm1: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Expm1: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Expm1: Tensor & Operator.UnaryTensor {
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
extension vFORCE.Expm1: InstantScalar where X: InstantScalar {}
extension vFORCE.Expm1: InstantVector where X: InstantVector {}
extension vFORCE.Expm1: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Expm1: InstantTensor where X: InstantTensor {
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
