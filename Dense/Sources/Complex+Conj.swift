//
//  Complex+Conj.swift
//  MUSE
//
//  Created by Kota on 9/28/25.
//
import func Layout.capacity
import func Layout.flatten
extension Complex {
    @frozen public struct Conj<X: Tensor<Element>> {
        public typealias S = Conj<X.S>
        public typealias T = Conj<X.T>
        public typealias U = Conj<X.U>
        public typealias V = Conj<X.V>
        @usableFromInline let x: X
        @inlinable
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Swap<X: Tensor<Element>> {
        public typealias S = Swap<X.S>
        public typealias T = Swap<X.T>
        public typealias U = Swap<X.U>
        public typealias V = Swap<X.V>
        @usableFromInline let x: X
        @inlinable
        init(x: X) {
            self.x = x
        }
    }
}
extension Complex.Conj: Scalar & Operator.UnaryScalar where X: Scalar {}
extension Complex.Conj: Vector & Operator.UnaryVector where X: Vector {}
extension Complex.Conj: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension Complex.Conj: Tensor & Operator.UnaryTensor {
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
                                Element.Conj(x: x.advanced(by: offset.x), ldx: stride.x,
                                             y: y.advanced(by: offset.y), ldy: stride.y,
                                             length: length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension Complex.Conj: InstantScalar where X: InstantScalar {}
extension Complex.Conj: InstantVector where X: InstantVector {}
extension Complex.Conj: InstantMatrix where X: InstantMatrix {}
extension Complex.Conj: InstantTensor where X: InstantTensor {
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
                                Element.Conj(x: x.advanced(by: offset.x), ldx: stride.x,
                                             y: y.advanced(by: offset.y), ldy: stride.y,
                                             length: length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension Complex.Swap: Scalar & Operator.UnaryScalar where X: Scalar {}
extension Complex.Swap: Vector & Operator.UnaryVector where X: Vector {}
extension Complex.Swap: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension Complex.Swap: Tensor & Operator.UnaryTensor {
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
                                Element.Swap(x: x.advanced(by: offset.x), ldx: stride.x,
                                             y: y.advanced(by: offset.y), ldy: stride.y,
                                             length: length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension Complex.Swap: InstantScalar where X: InstantScalar {}
extension Complex.Swap: InstantVector where X: InstantVector {}
extension Complex.Swap: InstantMatrix where X: InstantMatrix {}
extension Complex.Swap: InstantTensor where X: InstantTensor {
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
                                Element.Swap(x: x.advanced(by: offset.x), ldx: stride.x,
                                             y: y.advanced(by: offset.y), ldy: stride.y,
                                             length: length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension Tensor where Element: ComplexElement {
    public var conj: Complex<Element>.Conj<Self> {
        .init(x: self)
    }
}
extension Tensor where Element: ComplexElement {
    public var swap: Complex<Element>.Swap<Self> {
        .init(x: self)
    }
}
