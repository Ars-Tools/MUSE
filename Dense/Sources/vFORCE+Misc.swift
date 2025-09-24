//
//  vFORCE+Misc.swift
//  MUSE
//
//  Created by Kota on 9/23/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
extension vFORCE {
    @usableFromInline
    struct Sqrt<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Sqrt<X.S>
        @usableFromInline typealias T = Sqrt<X.T>
        @usableFromInline typealias U = Sqrt<X.U>
        @usableFromInline typealias V = Sqrt<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Cbrt<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Cbrt<X.S>
        @usableFromInline typealias T = Cbrt<X.T>
        @usableFromInline typealias U = Cbrt<X.U>
        @usableFromInline typealias V = Cbrt<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Ceil<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Ceil<X.S>
        @usableFromInline typealias T = Ceil<X.T>
        @usableFromInline typealias U = Ceil<X.U>
        @usableFromInline typealias V = Ceil<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Round<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Round<X.S>
        @usableFromInline typealias T = Round<X.T>
        @usableFromInline typealias U = Round<X.U>
        @usableFromInline typealias V = Round<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Floor<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Floor<X.S>
        @usableFromInline typealias T = Floor<X.T>
        @usableFromInline typealias U = Floor<X.U>
        @usableFromInline typealias V = Floor<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Pow<X: Tensor<Element>, Y: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Pow<X.S, Y.S>
        @usableFromInline typealias T = Pow<X.T, Y.T>
        @usableFromInline typealias U = Pow<X.U, Y.U>
        @usableFromInline typealias V = Pow<X.V, Y.V>
        @usableFromInline let x: X
        @usableFromInline let y: Y
        @inlinable@_transparent
        init(x: X, y: Y) {
            self.x = x
            self.y = y
        }
    }
    @usableFromInline
    struct Mod<X: Tensor<Element>, Y: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Mod<X.S, Y.S>
        @usableFromInline typealias T = Mod<X.T, Y.T>
        @usableFromInline typealias U = Mod<X.U, Y.U>
        @usableFromInline typealias V = Mod<X.V, Y.V>
        @usableFromInline let x: X
        @usableFromInline let y: Y
        @inlinable@_transparent
        init(x: X, y: Y) {
            self.x = x
            self.y = y
        }
    }
}
// MARK: Pow
extension vFORCE.Pow: Scalar & Operators.BinaryScalar where X: Scalar, Y: Scalar {}
extension vFORCE.Pow: Vector & Operators.BinaryVector where X: Vector, Y: Vector {}
extension vFORCE.Pow: Matrix & Operators.BinaryMatrix where X: Matrix, Y: Matrix {}
extension vFORCE.Pow: Tensor & Operators.BinaryTensor {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try (x.evaluation(for: strategy), y.evaluation(for: strategy)) {
        case ((let xs, let xm), (let ys, let ym)):
            let zk = shape
            let zs = strategy.stride(for: zk)
            let (length, stride, offset) = strategy.flatten(shape: shape,
                                                            xs: strategy.broadcast(target: zk, source: x.shape, stride: xs),
                                                            ys: strategy.broadcast(target: zk, source: y.shape, stride: ys),
                                                            zs: zs)
            let capacity = capacity(alloc: shape, stride: zs)
            return (zs, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.pow(x.advanced(by: offset.x), stride.x,
                                             y.advanced(by: offset.y), stride.y,
                                             z.advanced(by: offset.z), stride.z,
                                             length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension vFORCE.Pow: InstantScalar where X: InstantScalar, Y: InstantScalar {}
extension vFORCE.Pow: InstantVector where X: InstantVector, Y: InstantVector {}
extension vFORCE.Pow: InstantMatrix where X: InstantMatrix, Y: InstantMatrix {}
extension vFORCE.Pow: InstantTensor where X: InstantTensor, Y: InstantTensor {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try (x.evaluation(for: strategy), y.evaluation(for: strategy)) {
        case ((let xs, let xm), (let ys, let ym)):
            let xk = x.shape
            let yk = y.shape
            let zk = MemoryStrategy.default.broadcast(x: xk, y: yk)
            let zs = strategy.stride(for: zk)
            let capacity = capacity(alloc: zk, stride: zs)
            let (length, stride, offset) = strategy.flatten(shape: zk,
                                                            xs: MemoryStrategy.default.broadcast(target: zk, source: xk, stride: xs),
                                                            ys: MemoryStrategy.default.broadcast(target: zk, source: yk, stride: ys),
                                                            zs: zs)
            return (zs, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.pow(x.advanced(by: offset.x), stride.x,
                                             y.advanced(by: offset.y), stride.y,
                                             z.advanced(by: offset.z), stride.z,
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
public func pow<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>, _ y: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Pow(x: x, y: y)
}
@_disfavoredOverload
public func pow<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>, _ y: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Pow(x: x, y: y)
}
@_disfavoredOverload
public func pow<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>, _ y: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Pow(x: x, y: y)
}
@_disfavoredOverload
public func pow<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>, _ y: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Pow(x: x, y: y)
}
@_disfavoredOverload
public func pow<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>, _ y: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Pow(x: x, y: y)
}
@_disfavoredOverload
public func pow<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>, _ y: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Pow(x: x, y: y)
}
@_disfavoredOverload
public func pow<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>, _ y: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Pow(x: x, y: y)
}
@_disfavoredOverload
public func pow<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>, _ y: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Pow(x: x, y: y)
}
// MARK: Mod
extension vFORCE.Mod: Scalar & Operators.BinaryScalar where X: Scalar, Y: Scalar {}
extension vFORCE.Mod: Vector & Operators.BinaryVector where X: Vector, Y: Vector {}
extension vFORCE.Mod: Matrix & Operators.BinaryMatrix where X: Matrix, Y: Matrix {}
extension vFORCE.Mod: Tensor & Operators.BinaryTensor {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try (x.evaluation(for: strategy), y.evaluation(for: strategy)) {
        case ((let xs, let xm), (let ys, let ym)):
            let zk = shape
            let zs = strategy.stride(for: zk)
            let (length, stride, offset) = strategy.flatten(shape: shape,
                                                            xs: strategy.broadcast(target: zk, source: x.shape, stride: xs),
                                                            ys: strategy.broadcast(target: zk, source: y.shape, stride: ys),
                                                            zs: zs)
            let capacity = capacity(alloc: shape, stride: zs)
            return (zs, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.fmod(x.advanced(by: offset.x), stride.x,
                                             y.advanced(by: offset.y), stride.y,
                                             z.advanced(by: offset.z), stride.z,
                                             length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension vFORCE.Mod: InstantScalar where X: InstantScalar, Y: InstantScalar {}
extension vFORCE.Mod: InstantVector where X: InstantVector, Y: InstantVector {}
extension vFORCE.Mod: InstantMatrix where X: InstantMatrix, Y: InstantMatrix {}
extension vFORCE.Mod: InstantTensor where X: InstantTensor, Y: InstantTensor {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try (x.evaluation(for: strategy), y.evaluation(for: strategy)) {
        case ((let xs, let xm), (let ys, let ym)):
            let zk = shape
            let zs = strategy.stride(for: shape)
            let (length, stride, offset) = strategy.flatten(shape: shape,
                                                            xs: strategy.broadcast(target: zk, source: x.shape, stride: xs),
                                                            ys: strategy.broadcast(target: zk, source: y.shape, stride: ys),
                                                            zs: zs)
            let capacity = capacity(alloc: shape, stride: zs)
            return (zs, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.fmod(x.advanced(by: offset.x), stride.x,
                                             y.advanced(by: offset.y), stride.y,
                                             z.advanced(by: offset.z), stride.z,
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
public func %<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>, _ y: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Mod(x: x, y: y)
}
@_disfavoredOverload
public func %<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>, _ y: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Mod(x: x, y: y)
}
@_disfavoredOverload
public func %<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>, _ y: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Mod(x: x, y: y)
}
@_disfavoredOverload
public func %<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>, _ y: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Mod(x: x, y: y)
}
@_disfavoredOverload
public func %<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>, _ y: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Mod(x: x, y: y)
}
@_disfavoredOverload
public func %<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>, _ y: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Mod(x: x, y: y)
}
@_disfavoredOverload
public func %<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>, _ y: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Mod(x: x, y: y)
}
@_disfavoredOverload
public func %<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>, _ y: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Mod(x: x, y: y)
}
