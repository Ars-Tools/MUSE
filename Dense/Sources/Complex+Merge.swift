//
//  Complex+Merge.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import func Layout.capacity
import func Layout.flatten
extension Complex {
    @frozen public struct Ortho<X: Tensor<Element.Magnitude>, Y: Tensor<Element.Magnitude>> {
        public typealias S = Ortho<X.S, Y.S>
        public typealias T = Ortho<X.T, Y.T>
        public typealias U = Ortho<X.U, Y.U>
        public typealias V = Ortho<X.V, Y.V>
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
    @frozen public struct Polar<X: Tensor<Element.Magnitude>, Y: Tensor<Element.Magnitude>> {
        public typealias S = Polar<X.S, Y.S>
        public typealias T = Polar<X.T, Y.T>
        public typealias U = Polar<X.U, Y.U>
        public typealias V = Polar<X.V, Y.V>
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
// MARK: Ortho
extension Complex.Ortho: Scalar & Operator.BinaryScalar where X: Scalar, Y: Scalar {}
extension Complex.Ortho: Vector & Operator.BinaryVector where X: Vector, Y: Vector {}
extension Complex.Ortho: Matrix & Operator.BinaryMatrix where X: Matrix, Y: Matrix {}
extension Complex.Ortho: Tensor & Operator.BinaryTensor {
    public typealias Element = Element
    @inlinable@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try (x.evaluation(for: strategy), y.evaluation(for: strategy)) {
        case ((let xs, let xm), (let ys, let ym)):
            let xk = x.shape
            let yk = y.shape
            let zk = order.broadcast(x: xk, y: yk)
            let zs = strategy.stride(for: zk)
            let capacity = capacity(alloc: zk, stride: zs)
            let (length, stride, offset) = strategy.flatten(shape: zk,
                                                            xs: order.broadcast(target: zk, source: xk, stride: xs),
                                                            ys: order.broadcast(target: zk, source: yk, stride: ys),
                                                            zs: zs)
            return (zs, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.Merge(r: x.advanced(by: offset.x), inc: stride.x,
                                              i: y.advanced(by: offset.y), inc: stride.y,
                                              z: z.advanced(by: offset.z), inc: stride.z, length: length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension Complex.Ortho: InstantTensor where X: InstantTensor, Y: InstantTensor {
    @inlinable@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try (x.evaluation(for: strategy), y.evaluation(for: strategy)) {
        case ((let xs, let xm), (let ys, let ym)):
            let xk = x.shape
            let yk = y.shape
            let zk = order.broadcast(x: xk, y: yk)
            let zs = strategy.stride(for: zk)
            let capacity = capacity(alloc: zk, stride: zs)
            let (length, stride, offset) = strategy.flatten(shape: zk,
                                                            xs: order.broadcast(target: zk, source: xk, stride: xs),
                                                            ys: order.broadcast(target: zk, source: yk, stride: ys),
                                                            zs: zs)
            return (zs, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.Merge(r: x.advanced(by: offset.x), inc: stride.x,
                                              i: y.advanced(by: offset.y), inc: stride.y,
                                              z: z.advanced(by: offset.z), inc: stride.z, length: length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
// MARK: Polar
extension Complex.Polar: Scalar & Operator.BinaryScalar where X: Scalar, Y: Scalar {}
extension Complex.Polar: Vector & Operator.BinaryVector where X: Vector, Y: Vector {}
extension Complex.Polar: Matrix & Operator.BinaryMatrix where X: Matrix, Y: Matrix {}
extension Complex.Polar: Tensor & Operator.BinaryTensor {
    public typealias Element = Element
    @inlinable@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try (x.evaluation(for: strategy), y.evaluation(for: strategy)) {
        case ((let xs, let xm), (let ys, let ym)):
            let xk = x.shape
            let yk = y.shape
            let zk = order.broadcast(x: xk, y: yk)
            let zs = strategy.stride(for: zk)
            let capacity = capacity(alloc: zk, stride: zs)
            let (length, stride, offset) = strategy.flatten(shape: zk,
                                                            xs: order.broadcast(target: zk, source: x.shape, stride: xs),
                                                            ys: order.broadcast(target: zk, source: y.shape, stride: ys),
                                                            zs: zs)
            return (zs, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.Merge(r: x.advanced(by: offset.x), inc: stride.x,
                                              θ: y.advanced(by: offset.y), inc: stride.y,
                                              z: z.advanced(by: offset.z), inc: stride.z, length: length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension Complex.Polar: InstantTensor where X: InstantTensor, Y: InstantTensor {
    @inlinable@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try (x.evaluation(for: strategy), y.evaluation(for: strategy)) {
        case ((let xs, let xm), (let ys, let ym)):
            let xk = x.shape
            let yk = y.shape
            let zk = order.broadcast(x: xk, y: yk)
            let zs = strategy.stride(for: zk)
            let capacity = capacity(alloc: zk, stride: zs)
            let (length, stride, offset) = strategy.flatten(shape: zk,
                                                            xs: order.broadcast(target: zk, source: x.shape, stride: xs),
                                                            ys: order.broadcast(target: zk, source: y.shape, stride: ys),
                                                            zs: zs)
            return (zs, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.Merge(r: x.advanced(by: offset.x), inc: stride.x,
                                              θ: y.advanced(by: offset.y), inc: stride.y,
                                              z: z.advanced(by: offset.z), inc: stride.z, length: length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
public func complex<Element, R, I>(r: R, i: I, as type: Element.Type = Element.self) -> Complex<Element>.Ortho<R, I> {
    .init(order: .default, x: r, y: i)
}
public func complex<Element, R, Θ>(r: R, θ: Θ, as type: Element.Type = Element.self) -> Complex<Element>.Polar<R, Θ> {
    .init(order: .default, x: r, y: θ)
}
