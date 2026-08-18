//
//  Arithmetic+Sub.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import AltVec
extension Arithmetic {
    public struct Sub<X: Tensor<Element>, Y: Tensor<Element>> {
        public typealias S = Sub<X.S, Y.S>
        public typealias T = Sub<X.T, Y.T>
        public typealias U = Sub<X.U, Y.U>
        public typealias V = Sub<X.V, Y.V>
        @usableFromInline let order: MemoryStrategy
        @usableFromInline let x: X
        @usableFromInline let y: Y
        @inlinable
        init(order: MemoryStrategy, x: X, y: Y) {
            self.order = order
            self.x = x
            self.y = y
        }
    }
}
extension Arithmetic.Sub: Scalar & Operator.BinaryScalar where X: Scalar, Y: Scalar {}
extension Arithmetic.Sub: Vector & Operator.BinaryVector where X: Vector, Y: Vector {}
extension Arithmetic.Sub: Matrix & Operator.BinaryMatrix where X: Matrix, Y: Matrix {}
extension Arithmetic.Sub: Operator.BinaryTensor {
    public typealias Element = Element
    public typealias Storage = Array<Element>
    @inlinable@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Storage) {
        let xk = x.shape
        let yk = y.shape
        let zk = order.broadcast(x: xk, y: yk)
        let (xs, xm) = try x.evaluation(for: strategy)
        let (ys, ym) = try y.evaluation(for: strategy)
        let zs = strategy.stride(for: zk)
        let zm = capacity(alloc: zk, stride: zs)
        let (length, stride, offset) = order.flatten(shape: zk,
                                                     xs: order.broadcast(target: zk, source: xk, stride: xs),
                                                     ys: order.broadcast(target: zk, source: yk, stride: ys),
                                                     zs: zs)
        return (zs, {
            await withUnsafePointer(xm(), ym()) { x, y in
                .init(unsafeUninitializedCapacity: zm) {
                    let z = $0.baseAddress.unsafelyUnwrapped
                    for offset in offset {
                        Element.Sub(x: x.advanced(by: offset.x), inc: stride.x,
                                    y: y.advanced(by: offset.y), inc: stride.y,
                                    z: z.advanced(by: offset.z), inc: stride.z, length: length)
                    }
                    $1 = $0.count
                }
            }
        })
    }
}
extension Arithmetic.Sub: InstantScalar where X: InstantScalar, Y: InstantScalar {}
extension Arithmetic.Sub: InstantVector where X: InstantVector, Y: InstantVector {}
extension Arithmetic.Sub: InstantMatrix where X: InstantMatrix, Y: InstantMatrix {}
extension Arithmetic.Sub: InstantTensor where X: InstantTensor, Y: InstantTensor {
    @inlinable@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Storage) {
        let xk = x.shape
        let yk = y.shape
        let zk = order.broadcast(x: xk, y: yk)
        let (xs, xm) = try x.evaluation(for: strategy)
        let (ys, ym) = try y.evaluation(for: strategy)
        let zs = strategy.stride(for: zk)
        let zm = capacity(alloc: zk, stride: zs)
        let (length, stride, offset) = order.flatten(shape: zk,
                                                     xs: order.broadcast(target: zk, source: xk, stride: xs),
                                                     ys: order.broadcast(target: zk, source: yk, stride: ys),
                                                     zs: zs)
        return (zs, {
            withUnsafePointer(xm(), ym()) { x, y in
                .init(unsafeUninitializedCapacity: zm) {
                    let z = $0.baseAddress.unsafelyUnwrapped
                    for offset in offset {
                        Element.Sub(x: x.advanced(by: offset.x), inc: stride.x,
                                    y: y.advanced(by: offset.y), inc: stride.y,
                                    z: z.advanced(by: offset.z), inc: stride.z, length: length)
                    }
                    $1 = $0.count
                }
            }
        })
    }
}
@_disfavoredOverload
public func -<Element, X, Y>(_ lhs: X, _ rhs: Y) -> Arithmetic<Element>.Sub<X, Y> {
    .init(order: .default, x: lhs, y: rhs)
}
