//
//  Arithmetic+Mul.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
extension Arithmetic {
    public struct Mul<X: Tensor<Element>, Y: Tensor<Element>> {
        public typealias S = Mul<X.S, Y.S>
        public typealias T = Mul<X.T, Y.T>
        public typealias U = Mul<X.U, Y.U>
        public typealias V = Mul<X.V, Y.V>
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
extension Arithmetic.Mul: Scalar & Operator.BinaryScalar where X: Scalar, Y: Scalar {}
extension Arithmetic.Mul: Vector & Operator.BinaryVector where X: Vector, Y: Vector {}
extension Arithmetic.Mul: Matrix & Operator.BinaryMatrix where X: Matrix, Y: Matrix {}
extension Arithmetic.Mul: Operator.BinaryTensor {
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
                        Element.Mul(x: x.advanced(by: offset.x), ldx: stride.x,
                                    y: y.advanced(by: offset.y), ldy: stride.y,
                                    z: z.advanced(by: offset.z), ldz: stride.z, length: length)
                    }
                    $1 = $0.count
                }
            }
        })
    }
}
extension Arithmetic.Mul: InstantScalar where X: InstantScalar, Y: InstantScalar {}
extension Arithmetic.Mul: InstantVector where X: InstantVector, Y: InstantVector {}
extension Arithmetic.Mul: InstantMatrix where X: InstantMatrix, Y: InstantMatrix {}
extension Arithmetic.Mul: InstantTensor where X: InstantTensor, Y: InstantTensor {
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
                        Element.Mul(x: x.advanced(by: offset.x), ldx: stride.x,
                                    y: y.advanced(by: offset.y), ldy: stride.y,
                                    z: z.advanced(by: offset.z), ldz: stride.z, length: length)
                    }
                    $1 = $0.count
                }
            }
        })
    }
}
@_disfavoredOverload
public func *<Element, X, Y>(_ lhs: X, _ rhs: Y) -> Arithmetic<Element>.Mul<X, Y> {
    .init(order: .default, x: lhs, y: rhs)
}
