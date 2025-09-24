//
//  vFORCE+Magnitude.swift
//  MUSE
//
//  Created by Kota on 9/24/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
public struct Magnitude<X: Tensor> where X.Element: vFORCESuiteElement, X.Element.Magnitude: BitwiseCopyable & Sendable {
    public typealias R = Array<X.Element.Magnitude>
    public typealias S = Magnitude<X.S>
    public typealias T = Magnitude<X.T>
    public typealias U = Magnitude<X.U>
    public typealias V = Magnitude<X.V>
    public let x: X
    @inlinable
    public init(x: X) {
        self.x = x
    }
}
extension Magnitude: Scalar & Operators.UnaryScalar where X: Scalar {}
extension Magnitude: Vector & Operators.UnaryVector where X: Vector {}
extension Magnitude: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension Magnitude: Tensor & Operators.UnaryTensor where X: Tensor {
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<X.Element.Magnitude>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let xk = x.shape
            let ys = strategy.stride(for: xk)
            let capacity = capacity(alloc: xk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: xk, xs: xs, ys: ys)
            return (ys, {
                await xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: capacity) {
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
extension Magnitude: InstantScalar where X: InstantScalar {}
extension Magnitude: InstantVector where X: InstantVector {}
extension Magnitude: InstantMatrix where X: InstantMatrix {}
extension Magnitude: InstantTensor where X: InstantTensor {
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<X.Element.Magnitude>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let xk = x.shape
            let ys = strategy.stride(for: xk)
            let capacity = capacity(alloc: xk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: xk, xs: xs, ys: ys)
            return (ys, {
                xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: capacity) {
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

extension vFORCE {
    @usableFromInline
    struct Magnitude<X: Tensor<Element>> where X.Element.Magnitude: BitwiseCopyable & Sendable {
        @usableFromInline typealias R = Array<X.Element.Magnitude>
        @usableFromInline typealias S = Magnitude<X.S>
        @usableFromInline typealias T = Magnitude<X.T>
        @usableFromInline typealias U = Magnitude<X.U>
        @usableFromInline typealias V = Magnitude<X.V>
        @usableFromInline let x: X
        @inlinable init(x: X) {
            self.x = x
        }
    }
}
extension vFORCE.Magnitude: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Magnitude: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Magnitude: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Magnitude: Tensor & Operators.UnaryTensor where X: Tensor {
    @usableFromInline
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<X.Element.Magnitude>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let xk = x.shape
            let ys = strategy.stride(for: xk)
            let capacity = capacity(alloc: xk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: xk, xs: xs, ys: ys)
            return (ys, {
                await xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: capacity) {
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
extension vFORCE.Magnitude: InstantScalar where X: InstantScalar {}
extension vFORCE.Magnitude: InstantVector where X: InstantVector {}
extension vFORCE.Magnitude: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Magnitude: InstantTensor where X: InstantTensor {
    @usableFromInline
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<X.Element.Magnitude>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let xk = x.shape
            let ys = strategy.stride(for: xk)
            let capacity = capacity(alloc: xk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: xk, xs: xs, ys: ys)
            return (ys, {
                xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: capacity) {
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
extension Scalar where Element: vFORCESuiteElement & ArithmeticElement, Element.Magnitude: BitwiseCopyable & Sendable {
    @inlinable
    public var magnitude: Magnitude<Self> {
        .init(x: self)
    }
}
extension Vector where Element: vFORCESuiteElement & ArithmeticElement, Element.Magnitude: BitwiseCopyable & Sendable {
    @inlinable
    public var magnitude: Magnitude<Self> {
        .init(x: self)
    }
}
extension Matrix where Element: vFORCESuiteElement & ArithmeticElement, Element.Magnitude: BitwiseCopyable & Sendable {
    @inlinable
    public var magnitude: Magnitude<Self> {
        .init(x: self)
    }
}
extension Tensor where Element: vFORCESuiteElement & ArithmeticElement, Element.Magnitude: BitwiseCopyable & Sendable {
    @inlinable
    public var magnitude: Magnitude<Self> {
        .init(x: self)
    }
}
