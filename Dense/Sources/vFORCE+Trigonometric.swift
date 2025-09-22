//
//  vFORCE+Trigonometric.swift
//  MUSE
//
//  Created by Kota on 9/22/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
extension vFORCE {
    @usableFromInline
    struct Sin<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Sin<X.S>
        @usableFromInline typealias T = Sin<X.T>
        @usableFromInline typealias U = Sin<X.U>
        @usableFromInline typealias V = Sin<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Cos<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Cos<X.S>
        @usableFromInline typealias T = Cos<X.T>
        @usableFromInline typealias U = Cos<X.U>
        @usableFromInline typealias V = Cos<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Tan<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Tan<X.S>
        @usableFromInline typealias T = Tan<X.T>
        @usableFromInline typealias U = Tan<X.U>
        @usableFromInline typealias V = Tan<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
}
// MARK: Sin
extension vFORCE.Sin: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Sin: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Sin: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Sin: Tensor & Operators.UnaryTensor {
    @usableFromInline
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let shape = x.shape
            let ys = strategy.stride(for: shape)
            let capacity = capacity(alloc: shape, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: shape, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                    R(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            Element.sin(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Sin: InstantScalar where X: InstantScalar {}
extension vFORCE.Sin: InstantVector where X: InstantVector {}
extension vFORCE.Sin: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Sin: InstantTensor where X: InstantTensor {
    @usableFromInline
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let shape = x.shape
            let ys = strategy.stride(for: shape)
            let capacity = capacity(alloc: shape, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: shape, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                    R(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            Element.sin(x.advanced(by: offset.x), stride.x,
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
@_disfavoredOverload
@inlinable
public func sin<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Sin(x: x)
}
@_disfavoredOverload
@inlinable
public func sin<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Sin(x: x)
}
@_disfavoredOverload
@inlinable
public func sin<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Sin(x: x)
}
@_disfavoredOverload
@inlinable
public func sin<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Sin(x: x)
}
@_disfavoredOverload
@inlinable
public func sin<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Sin(x: x)
}
@_disfavoredOverload
@inlinable
public func sin<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Sin(x: x)
}
@_disfavoredOverload
@inlinable
public func sin<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Sin(x: x)
}
@_disfavoredOverload
@inlinable
public func sin<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Sin(x: x)
}
// MARK: Cos
extension vFORCE.Cos: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Cos: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Cos: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Cos: Tensor & Operators.UnaryTensor {
    @usableFromInline
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let shape = x.shape
            let ys = strategy.stride(for: shape)
            let capacity = capacity(alloc: shape, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: shape, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                    R(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            Element.cos(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Cos: InstantScalar where X: InstantScalar {}
extension vFORCE.Cos: InstantVector where X: InstantVector {}
extension vFORCE.Cos: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Cos: InstantTensor where X: InstantTensor {
    @usableFromInline
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let shape = x.shape
            let ys = strategy.stride(for: shape)
            let capacity = capacity(alloc: shape, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: shape, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                    R(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            Element.cos(x.advanced(by: offset.x), stride.x,
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
@_disfavoredOverload
@inlinable
public func cos<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Cos(x: x)
}
@_disfavoredOverload
@inlinable
public func cos<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Cos(x: x)
}
@_disfavoredOverload
@inlinable
public func cos<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Cos(x: x)
}
@_disfavoredOverload
@inlinable
public func cos<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Cos(x: x)
}
@_disfavoredOverload
@inlinable
public func cos<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Cos(x: x)
}
@_disfavoredOverload
@inlinable
public func cos<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Cos(x: x)
}
@_disfavoredOverload
@inlinable
public func cos<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Cos(x: x)
}
@_disfavoredOverload
@inlinable
public func cos<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Cos(x: x)
}
// MARK: Tan
extension vFORCE.Tan: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Tan: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Tan: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Tan: Tensor & Operators.UnaryTensor {
    @usableFromInline
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> R) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let shape = x.shape
            let ys = strategy.stride(for: shape)
            let capacity = capacity(alloc: shape, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: shape, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                    R(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            Element.tan(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Tan: InstantScalar where X: InstantScalar {}
extension vFORCE.Tan: InstantVector where X: InstantVector {}
extension vFORCE.Tan: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Tan: InstantTensor where X: InstantTensor {
    @usableFromInline
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> R) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let shape = x.shape
            let ys = strategy.stride(for: shape)
            let capacity = capacity(alloc: shape, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: shape, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                    R(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            Element.tan(x.advanced(by: offset.x), stride.x,
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
@_disfavoredOverload
@inlinable
public func tan<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Tan(x: x)
}
@_disfavoredOverload
@inlinable
public func tan<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Tan(x: x)
}
@_disfavoredOverload
@inlinable
public func tan<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Tan(x: x)
}
@_disfavoredOverload
@inlinable
public func tan<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Tan(x: x)
}
@_disfavoredOverload
@inlinable
public func tan<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Tan(x: x)
}
@_disfavoredOverload
@inlinable
public func tan<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Tan(x: x)
}
@_disfavoredOverload
@inlinable
public func tan<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Tan(x: x)
}
@_disfavoredOverload
@inlinable
public func tan<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Tan(x: x)
}
