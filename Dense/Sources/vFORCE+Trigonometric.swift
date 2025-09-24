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
    @usableFromInline
    struct Sinπ<X: Tensor<Element>> {
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
    struct Cosπ<X: Tensor<Element>> {
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
    struct Tanπ<X: Tensor<Element>> {
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
    @usableFromInline
    struct Sinh<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Sinh<X.S>
        @usableFromInline typealias T = Sinh<X.T>
        @usableFromInline typealias U = Sinh<X.U>
        @usableFromInline typealias V = Sinh<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Cosh<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Cosh<X.S>
        @usableFromInline typealias T = Cosh<X.T>
        @usableFromInline typealias U = Cosh<X.U>
        @usableFromInline typealias V = Cosh<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Tanh<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Tanh<X.S>
        @usableFromInline typealias T = Tanh<X.T>
        @usableFromInline typealias U = Tanh<X.U>
        @usableFromInline typealias V = Tanh<X.V>
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
// MARK: π
// MARK: Sin
extension vFORCE.Sinπ: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Sinπ: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Sinπ: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Sinπ: Tensor & Operators.UnaryTensor {
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
                            Element.sinπ(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Sinπ: InstantScalar where X: InstantScalar {}
extension vFORCE.Sinπ: InstantVector where X: InstantVector {}
extension vFORCE.Sinπ: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Sinπ: InstantTensor where X: InstantTensor {
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
                            Element.sinπ(x.advanced(by: offset.x), stride.x,
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
public func sin<Element: vFORCESuiteElement & ArithmeticElement>(π x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Sinπ(x: x)
}
@_disfavoredOverload
@inlinable
public func sin<Element: vFORCESuiteElement & ArithmeticElement>(π x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Sinπ(x: x)
}
@_disfavoredOverload
@inlinable
public func sin<Element: vFORCESuiteElement & ArithmeticElement>(π x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Sinπ(x: x)
}
@_disfavoredOverload
@inlinable
public func sin<Element: vFORCESuiteElement & ArithmeticElement>(π x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Sinπ(x: x)
}
@_disfavoredOverload
@inlinable
public func sin<Element: vFORCESuiteElement & ArithmeticElement>(π x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Sinπ(x: x)
}
@_disfavoredOverload
@inlinable
public func sin<Element: vFORCESuiteElement & ArithmeticElement>(π x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Sinπ(x: x)
}
@_disfavoredOverload
@inlinable
public func sin<Element: vFORCESuiteElement & ArithmeticElement>(π x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Sinπ(x: x)
}
@_disfavoredOverload
@inlinable
public func sin<Element: vFORCESuiteElement & ArithmeticElement>(π x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Sinπ(x: x)
}
// MARK: Cos
extension vFORCE.Cosπ: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Cosπ: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Cosπ: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Cosπ: Tensor & Operators.UnaryTensor {
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
                            Element.cosπ(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Cosπ: InstantScalar where X: InstantScalar {}
extension vFORCE.Cosπ: InstantVector where X: InstantVector {}
extension vFORCE.Cosπ: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Cosπ: InstantTensor where X: InstantTensor {
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
                            Element.cosπ(x.advanced(by: offset.x), stride.x,
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
public func cos<Element: vFORCESuiteElement & ArithmeticElement>(π x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Cosπ(x: x)
}
@_disfavoredOverload
@inlinable
public func cos<Element: vFORCESuiteElement & ArithmeticElement>(π x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Cosπ(x: x)
}
@_disfavoredOverload
@inlinable
public func cos<Element: vFORCESuiteElement & ArithmeticElement>(π x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Cosπ(x: x)
}
@_disfavoredOverload
@inlinable
public func cos<Element: vFORCESuiteElement & ArithmeticElement>(π x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Cosπ(x: x)
}
@_disfavoredOverload
@inlinable
public func cos<Element: vFORCESuiteElement & ArithmeticElement>(π x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Cosπ(x: x)
}
@_disfavoredOverload
@inlinable
public func cos<Element: vFORCESuiteElement & ArithmeticElement>(π x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Cosπ(x: x)
}
@_disfavoredOverload
@inlinable
public func cos<Element: vFORCESuiteElement & ArithmeticElement>(π x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Cosπ(x: x)
}
@_disfavoredOverload
@inlinable
public func cos<Element: vFORCESuiteElement & ArithmeticElement>(π x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Cosπ(x: x)
}
// MARK: Tan
extension vFORCE.Tanπ: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Tanπ: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Tanπ: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Tanπ: Tensor & Operators.UnaryTensor {
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
                            Element.tanπ(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Tanπ: InstantScalar where X: InstantScalar {}
extension vFORCE.Tanπ: InstantVector where X: InstantVector {}
extension vFORCE.Tanπ: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Tanπ: InstantTensor where X: InstantTensor {
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
                            Element.tanπ(x.advanced(by: offset.x), stride.x,
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
public func tan<Element: vFORCESuiteElement & ArithmeticElement>(π x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Tanπ(x: x)
}
@_disfavoredOverload
@inlinable
public func tan<Element: vFORCESuiteElement & ArithmeticElement>(π x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Tanπ(x: x)
}
@_disfavoredOverload
@inlinable
public func tan<Element: vFORCESuiteElement & ArithmeticElement>(π x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Tanπ(x: x)
}
@_disfavoredOverload
@inlinable
public func tan<Element: vFORCESuiteElement & ArithmeticElement>(π x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Tanπ(x: x)
}
@_disfavoredOverload
@inlinable
public func tan<Element: vFORCESuiteElement & ArithmeticElement>(π x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Tanπ(x: x)
}
@_disfavoredOverload
@inlinable
public func tan<Element: vFORCESuiteElement & ArithmeticElement>(π x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Tanπ(x: x)
}
@_disfavoredOverload
@inlinable
public func tan<Element: vFORCESuiteElement & ArithmeticElement>(π x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Tanπ(x: x)
}
@_disfavoredOverload
@inlinable
public func tan<Element: vFORCESuiteElement & ArithmeticElement>(π x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Tanπ(x: x)
}
// MARK: Hyperbolic
// MARK: Sin
extension vFORCE.Sinh: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Sinh: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Sinh: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Sinh: Tensor & Operators.UnaryTensor {
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
                            Element.sinh(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Sinh: InstantScalar where X: InstantScalar {}
extension vFORCE.Sinh: InstantVector where X: InstantVector {}
extension vFORCE.Sinh: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Sinh: InstantTensor where X: InstantTensor {
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
                            Element.sinh(x.advanced(by: offset.x), stride.x,
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
public func sinh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Sinh(x: x)
}
@_disfavoredOverload
@inlinable
public func sinh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Sinh(x: x)
}
@_disfavoredOverload
@inlinable
public func sinh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Sinh(x: x)
}
@_disfavoredOverload
@inlinable
public func sinh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Sinh(x: x)
}
@_disfavoredOverload
@inlinable
public func sinh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Sinh(x: x)
}
@_disfavoredOverload
@inlinable
public func sinh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Sinh(x: x)
}
@_disfavoredOverload
@inlinable
public func sinh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Sinh(x: x)
}
@_disfavoredOverload
@inlinable
public func sinh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Sinh(x: x)
}
// MARK: Cos
extension vFORCE.Cosh: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Cosh: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Cosh: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Cosh: Tensor & Operators.UnaryTensor {
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
                            Element.cosh(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Cosh: InstantScalar where X: InstantScalar {}
extension vFORCE.Cosh: InstantVector where X: InstantVector {}
extension vFORCE.Cosh: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Cosh: InstantTensor where X: InstantTensor {
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
                            Element.cosh(x.advanced(by: offset.x), stride.x,
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
public func cosh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Cosh(x: x)
}
@_disfavoredOverload
@inlinable
public func cosh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Cosh(x: x)
}
@_disfavoredOverload
@inlinable
public func cosh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Cosh(x: x)
}
@_disfavoredOverload
@inlinable
public func cosh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Cosh(x: x)
}
@_disfavoredOverload
@inlinable
public func cosh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Cosh(x: x)
}
@_disfavoredOverload
@inlinable
public func cosh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Cosh(x: x)
}
@_disfavoredOverload
@inlinable
public func cosh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Cosh(x: x)
}
@_disfavoredOverload
@inlinable
public func cosh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Cosh(x: x)
}
// MARK: Tan
extension vFORCE.Tanh: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Tanh: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Tanh: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Tanh: Tensor & Operators.UnaryTensor {
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
                            Element.tanh(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Tanh: InstantScalar where X: InstantScalar {}
extension vFORCE.Tanh: InstantVector where X: InstantVector {}
extension vFORCE.Tanh: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Tanh: InstantTensor where X: InstantTensor {
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
                            Element.tanh(x.advanced(by: offset.x), stride.x,
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
public func tanh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Tanh(x: x)
}
@_disfavoredOverload
@inlinable
public func tanh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Tanh(x: x)
}
@_disfavoredOverload
@inlinable
public func tanh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Tanh(x: x)
}
@_disfavoredOverload
@inlinable
public func tanh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Tanh(x: x)
}
@_disfavoredOverload
@inlinable
public func tanh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Tanh(x: x)
}
@_disfavoredOverload
@inlinable
public func tanh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Tanh(x: x)
}
@_disfavoredOverload
@inlinable
public func tanh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Tanh(x: x)
}
@_disfavoredOverload
@inlinable
public func tanh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Tanh(x: x)
}

