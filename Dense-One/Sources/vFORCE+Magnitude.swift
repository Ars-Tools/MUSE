//
//  vFORCE+Magnitude.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
extension vFORCE {
    @frozen public struct Magnitude<X: Tensor<Element>> where X.Element.Magnitude: BitwiseCopyable {
        public typealias Element = X.Element.Magnitude
        public typealias Storage = Array<Element>
        public let x: X
        @inlinable
        public init(x: X) {
            self.x = x
        }
    }
}
extension vFORCE.Magnitude: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Storage) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let xk = x.shape
            let ys = strategy.stride(for: xk)
            let capacity = capacity(alloc: xk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: xk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                X.Element.fabs(x.advanced(by: offset.x), stride.x,
                                               y.advanced(by: offset.y), stride.y, length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension vFORCE.Magnitude: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<X.Element.Magnitude>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let xk = x.shape
            let ys = strategy.stride(for: xk)
            let capacity = capacity(alloc: xk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: xk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let y = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                X.Element.fabs(x.advanced(by: offset.x), stride.x,
                                               y.advanced(by: offset.y), stride.y, length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension vFORCE.Magnitude: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Magnitude: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Magnitude: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Magnitude: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Magnitude<X.S>
    public typealias T = vFORCE.Magnitude<X.T>
    public typealias U = vFORCE.Magnitude<X.U>
    public typealias V = vFORCE.Magnitude<X.V>
    
}
extension Tensor where Element: vFORCEElement & ArithmeticElement, Element.Magnitude: BitwiseCopyable {
    public var magnitude: vFORCE<Element>.Magnitude<Self> {
        .init(x: self)
    }
}
