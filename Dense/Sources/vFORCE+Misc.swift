//
//  vFORCE+Misc.swift
//  MUSE
//
//  Created by Kota on 6/19/26.
//
import func Layout.capacity
import AltVec
extension vFORCE {
    @frozen public struct Sqrt<X: Tensor<Element>> {
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
}
extension vFORCE.Sqrt: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Sqrt: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Sqrt: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Sqrt: Tensor & Operator.UnaryTensor {
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
                                Element.sqrt(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Sqrt: InstantScalar where X: InstantScalar {}
extension vFORCE.Sqrt: InstantVector where X: InstantVector {}
extension vFORCE.Sqrt: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Sqrt: InstantTensor where X: InstantTensor {
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
                                Element.sqrt(x.advanced(by: offset.x), stride.x,
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
@inlinable
public func sqrt<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Sqrt<X> {
    .init(x: x)
}
