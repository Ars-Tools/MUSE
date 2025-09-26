//
//  vFORCE+Exp.swift
//  MUSE
//
//  Created by Kota on 9/23/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
extension vFORCE {
    @usableFromInline
    struct Exp<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Exp<X.S>
        @usableFromInline typealias T = Exp<X.T>
        @usableFromInline typealias U = Exp<X.U>
        @usableFromInline typealias V = Exp<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Exp2<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Exp2<X.S>
        @usableFromInline typealias T = Exp2<X.T>
        @usableFromInline typealias U = Exp2<X.U>
        @usableFromInline typealias V = Exp2<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Exp10<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Exp10<X.S>
        @usableFromInline typealias T = Exp10<X.T>
        @usableFromInline typealias U = Exp10<X.U>
        @usableFromInline typealias V = Exp10<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Expm1<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Expm1<X.S>
        @usableFromInline typealias T = Expm1<X.T>
        @usableFromInline typealias U = Expm1<X.U>
        @usableFromInline typealias V = Expm1<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
}
// MARK: Exp
extension vFORCE.Exp: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Exp: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Exp: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Exp: Tensor & Operators.UnaryTensor {
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
                            Element.exp(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Exp: InstantScalar where X: InstantScalar {}
extension vFORCE.Exp: InstantVector where X: InstantVector {}
extension vFORCE.Exp: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Exp: InstantTensor where X: InstantTensor {
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
                            Element.exp(x.advanced(by: offset.x), stride.x,
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
// MARK: Exp2
extension vFORCE.Exp2: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Exp2: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Exp2: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Exp2: Tensor & Operators.UnaryTensor {
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
                            Element.exp2(x.advanced(by: offset.x), stride.x,
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
public func exp<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Exp(x: x)
}
@_disfavoredOverload
@inlinable
public func exp<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Exp(x: x)
}
@_disfavoredOverload
@inlinable
public func exp<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Exp(x: x)
}
@_disfavoredOverload
@inlinable
public func exp<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Exp(x: x)
}
@_disfavoredOverload
@inlinable
public func exp<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Exp(x: x)
}
@_disfavoredOverload
@inlinable
public func exp<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Exp(x: x)
}
@_disfavoredOverload
@inlinable
public func exp<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Exp(x: x)
}
@_disfavoredOverload
@inlinable
public func exp<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Exp(x: x)
}
// MARK: Exp2
extension vFORCE.Exp2: InstantScalar where X: InstantScalar {}
extension vFORCE.Exp2: InstantVector where X: InstantVector {}
extension vFORCE.Exp2: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Exp2: InstantTensor where X: InstantTensor {
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
                            Element.exp2(x.advanced(by: offset.x), stride.x,
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
public func exp2<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Exp2(x: x)
}
@_disfavoredOverload
@inlinable
public func exp2<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Exp2(x: x)
}
@_disfavoredOverload
@inlinable
public func exp2<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Exp2(x: x)
}
@_disfavoredOverload
@inlinable
public func exp2<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Exp2(x: x)
}
@_disfavoredOverload
@inlinable
public func exp2<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Exp2(x: x)
}
@_disfavoredOverload
@inlinable
public func exp2<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Exp2(x: x)
}
@_disfavoredOverload
@inlinable
public func exp2<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Exp2(x: x)
}
@_disfavoredOverload
@inlinable
public func exp2<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Exp2(x: x)
}
// MARK: Exp10
extension vFORCE.Exp10: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Exp10: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Exp10: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Exp10: Tensor & Operators.UnaryTensor {
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
                            Element.exp10(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Exp10: InstantScalar where X: InstantScalar {}
extension vFORCE.Exp10: InstantVector where X: InstantVector {}
extension vFORCE.Exp10: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Exp10: InstantTensor where X: InstantTensor {
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
                            Element.exp10(x.advanced(by: offset.x), stride.x,
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
public func exp10<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Exp10(x: x)
}
@_disfavoredOverload
@inlinable
public func exp10<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Exp10(x: x)
}
@_disfavoredOverload
@inlinable
public func exp10<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Exp10(x: x)
}
@_disfavoredOverload
@inlinable
public func exp10<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Exp10(x: x)
}
@_disfavoredOverload
@inlinable
public func exp10<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Exp10(x: x)
}
@_disfavoredOverload
@inlinable
public func exp10<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Exp10(x: x)
}
@_disfavoredOverload
@inlinable
public func exp10<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Exp10(x: x)
}
@_disfavoredOverload
@inlinable
public func exp10<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Exp10(x: x)
}
// MARK: Expm1
extension vFORCE.Expm1: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Expm1: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Expm1: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Expm1: Tensor & Operators.UnaryTensor {
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
                            Element.expm1(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Expm1: InstantScalar where X: InstantScalar {}
extension vFORCE.Expm1: InstantVector where X: InstantVector {}
extension vFORCE.Expm1: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Expm1: InstantTensor where X: InstantTensor {
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
                            Element.expm1(x.advanced(by: offset.x), stride.x,
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
public func expm1<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Expm1(x: x)
}
@_disfavoredOverload
@inlinable
public func expm1<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Expm1(x: x)
}
@_disfavoredOverload
@inlinable
public func expm1<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Expm1(x: x)
}
@_disfavoredOverload
@inlinable
public func expm1<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Expm1(x: x)
}
@_disfavoredOverload
@inlinable
public func expm1<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Expm1(x: x)
}
@_disfavoredOverload
@inlinable
public func expm1<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Expm1(x: x)
}
@_disfavoredOverload
@inlinable
public func expm1<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Expm1(x: x)
}
@_disfavoredOverload
@inlinable
public func expm1<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Expm1(x: x)
}

