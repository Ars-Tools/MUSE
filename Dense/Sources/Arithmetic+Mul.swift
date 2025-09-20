//
//  Arithmetic+Mul.swift
//  MUSE
//
//  Created by Kota on 9/17/R7.
//
import typealias Layout.MemoryStrategy
import func Layout.broadcast
import func Layout.capacity
import func Layout.flatten
extension Arithmetic {
    @usableFromInline
    @frozen struct Mul<X: Tensor<Element>, Y: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Mul<X.S, Y.S>
        @usableFromInline typealias T = Mul<X.T, Y.T>
        @usableFromInline typealias U = Mul<X.U, Y.U>
        @usableFromInline typealias V = Mul<X.V, Y.V>
        @usableFromInline let x: X
        @usableFromInline let y: Y
        @inlinable init(x: X, y: Y) {
            self.x = x
            self.y = y
        }
    }
}
extension Arithmetic.Mul {
    @inlinable@inline(__always)@_transparent
    static func`operator`(x: (Array<Int>, Array<Int>), y: (Array<Int>, Array<Int>), z: (Array<Int>, Array<Int>)) -> @Sendable (X.R, Y.R) -> R {
        let xs = broadcast(target: z.0, source: x.0, stride: x.1)
        let ys = broadcast(target: z.0, source: y.0, stride: y.1)
        let capacity = capacity(alloc: z.0, stride: z.1)
        let (length, stride, offset) = flatten(shape: z.0, xs: xs, ys: ys, zs: z.1)
        return {
            withUnsafePointer($0, $1) { x, y in
                    .init(unsafeUninitializedCapacity: capacity) {
                        let z = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            Element.Mul(x: x.advanced(by: offset.x), ldx: stride.x,
                                        y: y.advanced(by: offset.y), ldy: stride.y,
                                        z: z.advanced(by: offset.z), ldz: stride.z,
                                        length: length)
                        }
                        $1 = $0.count
                    }
            }
        }
    }
}
extension Arithmetic.Mul: Scalar & Operators.BinaryScalar where X: Scalar, Y: Scalar {}
extension Arithmetic.Mul: Vector & Operators.BinaryVector where X: Vector, Y: Vector {}
extension Arithmetic.Mul: Matrix & Operators.BinaryMatrix where X: Matrix, Y: Matrix {}
extension Arithmetic.Mul: Tensor & Operators.BinaryTensor where X: Tensor, Y: Tensor {
    @usableFromInline@inline(__always)
    func callAsFunction(as strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try (x(as: strategy), y(as: strategy)) {
        case ((let xs, let xm), (let ys, let ym)):
            let zs = strategy.stride(for: shape)
            let zm = Self.operator(x: (x.shape, xs), y: (y.shape, ys), z: (shape, zs))
            return (zs, {await zm(xm(), ym())})
        }
    }
}
extension Arithmetic.Mul: InstantScalar where X: InstantScalar, Y: InstantScalar {}
extension Arithmetic.Mul: InstantVector where X: InstantVector, Y: InstantVector {}
extension Arithmetic.Mul: InstantMatrix where X: InstantMatrix, Y: InstantMatrix {}
extension Arithmetic.Mul: InstantTensor where X: InstantTensor, Y: InstantTensor {
    @usableFromInline@inline(__always)
    func callAsFunction(by strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try (x(by: strategy), y(by: strategy)) {
        case ((let xs, let xm), (let ys, let ym)):
            let zs = strategy.stride(for: shape)
            let zm = Self.operator(x: (x.shape, xs), y: (y.shape, ys), z: (shape, zs))
            return (zs, {zm(xm(), ym())})
        }
    }
}
// Tensor
@_disfavoredOverload
public func *<Element: ArithmeticElement>(_ lhs: some Scalar<Element>, _ rhs: some Scalar<Element>) -> some Scalar<Element> {
    Arithmetic.Mul(x: lhs, y: rhs)
}
@_disfavoredOverload
public func *<Element: ArithmeticElement>(_ lhs: some Vector<Element>, _ rhs: some Vector<Element>) -> some Vector<Element> {
    Arithmetic.Mul(x: lhs, y: rhs)
}
@_disfavoredOverload
public func *<Element: ArithmeticElement>(_ lhs: some Matrix<Element>, _ rhs: some Matrix<Element>) -> some Matrix<Element> {
    Arithmetic.Mul(x: lhs, y: rhs)
}
@_disfavoredOverload
public func *<Element: ArithmeticElement>(_ lhs: some Tensor<Element>, _ rhs: some Tensor<Element>) -> some Tensor<Element> {
    Arithmetic.Mul(x: lhs, y: rhs)
}
// Tensor
@_disfavoredOverload
public func *<Element: ArithmeticElement>(_ lhs: some InstantScalar<Element>, _ rhs: some InstantScalar<Element>) -> some InstantScalar<Element> {
    Arithmetic.Mul(x: lhs, y: rhs)
}
@_disfavoredOverload
public func *<Element: ArithmeticElement>(_ lhs: some InstantVector<Element>, _ rhs: some InstantVector<Element>) -> some InstantVector<Element> {
    Arithmetic.Mul(x: lhs, y: rhs)
}
@_disfavoredOverload
public func *<Element: ArithmeticElement>(_ lhs: some InstantMatrix<Element>, _ rhs: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    Arithmetic.Mul(x: lhs, y: rhs)
}
@_disfavoredOverload
public func *<Element: ArithmeticElement>(_ lhs: some InstantTensor<Element>, _ rhs: some InstantTensor<Element>) -> some InstantTensor<Element> {
    Arithmetic.Mul(x: lhs, y: rhs)
}
