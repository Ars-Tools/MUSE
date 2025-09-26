//
//  Arithmetic+Sub.swift
//  MUSE
//
//  Created by Kota on 9/25/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
import func Layout.broadcast
extension Arithmetic {
    public struct Sub<X: Tensor<Element>, Y: Tensor<Element>> {
        public typealias Storage = Array<Element>
        public let order: MemoryStrategy
        public let x: X
        public let y: Y
        @inlinable
        public init(order: MemoryStrategy, x: X, y: Y) {
            self.order = order
            self.x = x
            self.y = y
        }
    }
}
extension Arithmetic.Sub: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> {
        order.broadcast(x: x.shape, y: y.shape)
    }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Storage) {
        let (xs, xm) = try x.evaluation(for: strategy)
        let (ys, ym) = try y.evaluation(for: strategy)
        let xk = x.shape
        let yk = y.shape
        let zk = order.broadcast(x: xk, y: yk)
        let zs = strategy.stride(for: zk)
        let zm = capacity(alloc: zk, stride: zs)
        let (length, stride, offset) = strategy.flatten(shape: zk,
                                                        xs: order.broadcast(target: zk, source: xk, stride: xs),
                                                        ys: order.broadcast(target: zk, source: yk, stride: ys),
                                                        zs: zs)
        return (zs, {
            await withUnsafePointer(xm(), ym()) { x, y in
                    .init(unsafeUninitializedCapacity: zm) {
                        let z = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            Element.Sub(x: x.advanced(by: offset.x), ldx: stride.x,
                                        y: y.advanced(by: offset.y), ldy: stride.y,
                                        z: z.advanced(by: offset.z), ldz: stride.z, length: length)
                        }
                        $1 = $0.count
                    }
            }
        })
    }
}
extension Arithmetic.Sub: InstantTensor where X: InstantTensor, Y: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Storage) {
        let (xs, xm) = try x.evaluation(for: strategy)
        let (ys, ym) = try y.evaluation(for: strategy)
        let xk = x.shape
        let yk = y.shape
        let zk = order.broadcast(x: xk, y: yk)
        let zs = strategy.stride(for: zk)
        let zm = capacity(alloc: zk, stride: zs)
        let (length, stride, offset) = strategy.flatten(shape: zk,
                                                        xs: order.broadcast(target: zk, source: xk, stride: xs),
                                                        ys: order.broadcast(target: zk, source: yk, stride: ys),
                                                        zs: zs)
        return (zs, {
            withUnsafePointer(xm(), ym()) { x, y in
                    .init(unsafeUninitializedCapacity: zm) {
                        let z = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            Element.Sub(x: x.advanced(by: offset.x), ldx: stride.x,
                                        y: y.advanced(by: offset.y), ldy: stride.y,
                                        z: z.advanced(by: offset.z), ldz: stride.z, length: length)
                        }
                        $1 = $0.count
                    }
            }
        })
    }
}
extension Arithmetic.Sub: Scalar & Operator.BinaryScalar where X: Scalar, Y: Scalar {}
extension Arithmetic.Sub: Vector & Operator.BinaryVector where X: Vector, Y: Vector {}
extension Arithmetic.Sub: Matrix & Operator.BinaryMatrix where X: Matrix, Y: Matrix {}
extension Arithmetic.Sub: ElasticTensor & Operator.BinaryTensor where X: ElasticTensor, Y: ElasticTensor {
    public typealias S = Arithmetic.Sub<X.S, Y.S>
    public typealias T = Arithmetic.Sub<X.T, Y.T>
    public typealias U = Arithmetic.Sub<X.U, Y.U>
    public typealias V = Arithmetic.Sub<X.V, Y.V>
}
@_disfavoredOverload
public func -<Element: ArithmeticElement, X: Tensor<Element>, Y: Tensor<Element>>(_ lhs: X, _ rhs: Y) -> Arithmetic<Element>.Sub<X, Y> {
    .init(order: .default, x: lhs, y: rhs)
}
