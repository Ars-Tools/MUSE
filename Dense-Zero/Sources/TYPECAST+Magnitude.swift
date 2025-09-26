//
//  TYPECAST+Magnitude.swift
//  MUSE
//
//  Created by Kota on 9/24/25.
//
import typealias Layout.MemoryStrategy
import protocol Numerics.ComplexNumber
import func Layout.capacity
extension TYPECAST {
    @usableFromInline
    struct Abs<X: Tensor> where X.Element: vFORCESuiteElement, X.Element.Magnitude: BitwiseCopyable & Sendable {
        @usableFromInline typealias R = Array<X.Element.Magnitude>
        @usableFromInline typealias S = Abs<X.S>
        @usableFromInline typealias T = Abs<X.T>
        @usableFromInline typealias U = Abs<X.U>
        @usableFromInline typealias V = Abs<X.V>
        @usableFromInline let x: X
        @inlinable init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Mag<X: Tensor> where X.Element: vFORCESuiteElement, X.Element.Magnitude: BitwiseCopyable & Sendable {
        @usableFromInline typealias R = Array<X.Element.Magnitude>
        @usableFromInline typealias S = Mag<X.S>
        @usableFromInline typealias T = Mag<X.T>
        @usableFromInline typealias U = Mag<X.U>
        @usableFromInline typealias V = Mag<X.V>
        @usableFromInline let x: X
        @inlinable init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Arg<X: Tensor> where X.Element: vFORCESuiteElement, X.Element.Magnitude: BitwiseCopyable & Sendable {
        @usableFromInline typealias R = Array<X.Element.Magnitude>
        @usableFromInline typealias S = Arg<X.S>
        @usableFromInline typealias T = Arg<X.T>
        @usableFromInline typealias U = Arg<X.U>
        @usableFromInline typealias V = Arg<X.V>
        @usableFromInline let x: X
        @inlinable init(x: X) {
            self.x = x
        }
    }
}
// MARK: ABS
extension TYPECAST.Abs: Scalar & Operators.UnaryScalar where X: Scalar {}
extension TYPECAST.Abs: Vector & Operators.UnaryVector where X: Vector {}
extension TYPECAST.Abs: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension TYPECAST.Abs: Tensor & Operators.UnaryTensor where X: Tensor {
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
extension TYPECAST.Abs: InstantScalar where X: InstantScalar {}
extension TYPECAST.Abs: InstantVector where X: InstantVector {}
extension TYPECAST.Abs: InstantMatrix where X: InstantMatrix {}
extension TYPECAST.Abs: InstantTensor where X: InstantTensor {
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
@inlinable@inline(__always)@_transparent
public func abs<Element: vFORCESuiteElement>(_ x: some Scalar<Element>) -> some Scalar<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Abs(x: x)
}
@inlinable@inline(__always)@_transparent
public func abs<Element: vFORCESuiteElement>(_ x: some Vector<Element>) -> some Vector<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Abs(x: x)
}
@inlinable@inline(__always)@_transparent
public func abs<Element: vFORCESuiteElement>(_ x: some Matrix<Element>) -> some Matrix<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Abs(x: x)
}
@inlinable@inline(__always)@_transparent
public func abs<Element: vFORCESuiteElement>(_ x: some Tensor<Element>) -> some Tensor<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Abs(x: x)
}
@inlinable@inline(__always)@_transparent
public func abs<Element: vFORCESuiteElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Abs(x: x)
}
@inlinable@inline(__always)@_transparent
public func abs<Element: vFORCESuiteElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Abs(x: x)
}
@inlinable@inline(__always)@_transparent
public func abs<Element: vFORCESuiteElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Abs(x: x)
}
@inlinable@inline(__always)@_transparent
public func abs<Element: vFORCESuiteElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Abs(x: x)
}
// MARK: Mag
extension TYPECAST.Mag: Scalar & Operators.UnaryScalar where X: Scalar {}
extension TYPECAST.Mag: Vector & Operators.UnaryVector where X: Vector {}
extension TYPECAST.Mag: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension TYPECAST.Mag: Tensor & Operators.UnaryTensor where X: Tensor {
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
                            X.Element.mags(x.advanced(by: offset.x), stride.x,
                                           y.advanced(by: offset.y), stride.y, length)
                        }
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
extension TYPECAST.Mag: InstantScalar where X: InstantScalar {}
extension TYPECAST.Mag: InstantVector where X: InstantVector {}
extension TYPECAST.Mag: InstantMatrix where X: InstantMatrix {}
extension TYPECAST.Mag: InstantTensor where X: InstantTensor {
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
                            X.Element.mags(x.advanced(by: offset.x), stride.x,
                                           y.advanced(by: offset.y), stride.y, length)
                        }
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
@inlinable@inline(__always)@_transparent
public func mag<Element: vFORCESuiteElement>(_ x: some Scalar<Element>) -> some Scalar<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Mag(x: x)
}
@inlinable@inline(__always)@_transparent
public func mag<Element: vFORCESuiteElement>(_ x: some Vector<Element>) -> some Vector<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Mag(x: x)
}
@inlinable@inline(__always)@_transparent
public func mag<Element: vFORCESuiteElement>(_ x: some Matrix<Element>) -> some Matrix<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Mag(x: x)
}
@inlinable@inline(__always)@_transparent
public func mag<Element: vFORCESuiteElement>(_ x: some Tensor<Element>) -> some Tensor<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Mag(x: x)
}
@inlinable@inline(__always)@_transparent
public func mag<Element: vFORCESuiteElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Mag(x: x)
}
@inlinable@inline(__always)@_transparent
public func mag<Element: vFORCESuiteElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Mag(x: x)
}
@inlinable@inline(__always)@_transparent
public func mag<Element: vFORCESuiteElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Mag(x: x)
}
@inlinable@inline(__always)@_transparent
public func mag<Element: vFORCESuiteElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Mag(x: x)
}
// MARK: Arg
extension TYPECAST.Arg: Scalar & Operators.UnaryScalar where X: Scalar {}
extension TYPECAST.Arg: Vector & Operators.UnaryVector where X: Vector {}
extension TYPECAST.Arg: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension TYPECAST.Arg: Tensor & Operators.UnaryTensor where X: Tensor {
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
                            X.Element.phas(x.advanced(by: offset.x), stride.x,
                                           y.advanced(by: offset.y), stride.y, length)
                        }
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
extension TYPECAST.Arg: InstantScalar where X: InstantScalar {}
extension TYPECAST.Arg: InstantVector where X: InstantVector {}
extension TYPECAST.Arg: InstantMatrix where X: InstantMatrix {}
extension TYPECAST.Arg: InstantTensor where X: InstantTensor {
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
                            X.Element.phas(x.advanced(by: offset.x), stride.x,
                                           y.advanced(by: offset.y), stride.y, length)
                        }
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
@inlinable@inline(__always)@_transparent
public func arg<Element: vFORCESuiteElement & ComplexNumber>(_ x: some Scalar<Element>) -> some Scalar<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Arg(x: x)
}
@inlinable@inline(__always)@_transparent
public func arg<Element: vFORCESuiteElement & ComplexNumber>(_ x: some Vector<Element>) -> some Vector<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Arg(x: x)
}
@inlinable@inline(__always)@_transparent
public func arg<Element: vFORCESuiteElement & ComplexNumber>(_ x: some Matrix<Element>) -> some Matrix<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Arg(x: x)
}
@inlinable@inline(__always)@_transparent
public func arg<Element: vFORCESuiteElement & ComplexNumber>(_ x: some Tensor<Element>) -> some Tensor<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Arg(x: x)
}
@inlinable@inline(__always)@_transparent
public func arg<Element: vFORCESuiteElement & ComplexNumber>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Arg(x: x)
}
@inlinable@inline(__always)@_transparent
public func arg<Element: vFORCESuiteElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Arg(x: x)
}
@inlinable@inline(__always)@_transparent
public func arg<Element: vFORCESuiteElement & ComplexNumber>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Arg(x: x)
}
@inlinable@inline(__always)@_transparent
public func arg<Element: vFORCESuiteElement & ComplexNumber>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element.Magnitude> where Element.Magnitude: BitwiseCopyable & Sendable {
    TYPECAST.Arg(x: x)
}
