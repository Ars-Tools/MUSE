//
//  vFORCE+Arc.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
import AltVec
extension vFORCE {
    @frozen public struct ArcSin<X: Tensor<Element>> {
        public typealias S = vFORCE.ArcSin<X.S>
        public typealias T = vFORCE.ArcSin<X.T>
        public typealias U = vFORCE.ArcSin<X.U>
        public typealias V = vFORCE.ArcSin<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct ArcCos<X: Tensor<Element>> {
        public typealias S = vFORCE.ArcCos<X.S>
        public typealias T = vFORCE.ArcCos<X.T>
        public typealias U = vFORCE.ArcCos<X.U>
        public typealias V = vFORCE.ArcCos<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct ArcTan<X: Tensor<Element>> {
        public typealias S = vFORCE.ArcTan<X.S>
        public typealias T = vFORCE.ArcTan<X.T>
        public typealias U = vFORCE.ArcTan<X.U>
        public typealias V = vFORCE.ArcTan<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct ArcSinh<X: Tensor<Element>> {
        public typealias S = vFORCE.ArcSinh<X.S>
        public typealias T = vFORCE.ArcSinh<X.T>
        public typealias U = vFORCE.ArcSinh<X.U>
        public typealias V = vFORCE.ArcSinh<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct ArcCosh<X: Tensor<Element>> {
        public typealias S = vFORCE.ArcCosh<X.S>
        public typealias T = vFORCE.ArcCosh<X.T>
        public typealias U = vFORCE.ArcCosh<X.U>
        public typealias V = vFORCE.ArcCosh<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct ArcTanh<X: Tensor<Element>> {
        public typealias S = vFORCE.ArcTanh<X.S>
        public typealias T = vFORCE.ArcTanh<X.T>
        public typealias U = vFORCE.ArcTanh<X.U>
        public typealias V = vFORCE.ArcTanh<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
}
// MARK: ArcSin
extension vFORCE.ArcSin: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.ArcSin: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.ArcSin: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcSin: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
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
extension vFORCE.ArcSin: InstantScalar where X: InstantScalar {}
extension vFORCE.ArcSin: InstantVector where X: InstantVector {}
extension vFORCE.ArcSin: InstantMatrix where X: InstantMatrix {}
extension vFORCE.ArcSin: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
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
// MARK: ArcCos
extension vFORCE.ArcCos: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.ArcCos: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.ArcCos: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcCos: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
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
extension vFORCE.ArcCos: InstantScalar where X: InstantScalar {}
extension vFORCE.ArcCos: InstantVector where X: InstantVector {}
extension vFORCE.ArcCos: InstantMatrix where X: InstantMatrix {}
extension vFORCE.ArcCos: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
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
// MARK: ArcTan
extension vFORCE.ArcTan: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.ArcTan: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.ArcTan: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcTan: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
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
extension vFORCE.ArcTan: InstantScalar where X: InstantScalar {}
extension vFORCE.ArcTan: InstantVector where X: InstantVector {}
extension vFORCE.ArcTan: InstantMatrix where X: InstantMatrix {}
extension vFORCE.ArcTan: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
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
// MARK: ArcSinh
extension vFORCE.ArcSinh: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.ArcSinh: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.ArcSinh: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcSinh: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
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
extension vFORCE.ArcSinh: InstantScalar where X: InstantScalar {}
extension vFORCE.ArcSinh: InstantVector where X: InstantVector {}
extension vFORCE.ArcSinh: InstantMatrix where X: InstantMatrix {}
extension vFORCE.ArcSinh: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
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
// MARK: ArcCosh
extension vFORCE.ArcCosh: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.ArcCosh: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.ArcCosh: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcCosh: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
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
extension vFORCE.ArcCosh: InstantScalar where X: InstantScalar {}
extension vFORCE.ArcCosh: InstantVector where X: InstantVector {}
extension vFORCE.ArcCosh: InstantMatrix where X: InstantMatrix {}
extension vFORCE.ArcCosh: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
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
// MARK: ArcTanh
extension vFORCE.ArcTanh: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.ArcTanh: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.ArcTanh: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcTanh: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
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
extension vFORCE.ArcTanh: InstantScalar where X: InstantScalar {}
extension vFORCE.ArcTanh: InstantVector where X: InstantVector {}
extension vFORCE.ArcTanh: InstantMatrix where X: InstantMatrix {}
extension vFORCE.ArcTanh: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
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
@_disfavoredOverload
public func asin<X: Tensor>(_ x: X) -> vFORCE<X.Element>.ArcSin<X> {
    .init(x: x)
}
@_disfavoredOverload
public func acos<X: Tensor>(_ x: X) -> vFORCE<X.Element>.ArcCos<X> {
    .init(x: x)
}
@_disfavoredOverload
public func atan<X: Tensor>(_ x: X) -> vFORCE<X.Element>.ArcTan<X> {
    .init(x: x)
}
@_disfavoredOverload
public func asinh<X: Tensor>(_ x: X) -> vFORCE<X.Element>.ArcSinh<X> {
    .init(x: x)
}
@_disfavoredOverload
public func acosh<X: Tensor>(_ x: X) -> vFORCE<X.Element>.ArcCosh<X> {
    .init(x: x)
}
@_disfavoredOverload
public func atanh<X: Tensor>(_ x: X) -> vFORCE<X.Element>.ArcTanh<X> {
    .init(x: x)
}
