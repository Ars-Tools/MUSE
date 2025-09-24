//
//  vFORCE+Log.swift
//  MUSE
//
//  Created by Kota on 9/23/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
extension vFORCE {
    @usableFromInline
    struct Log<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Log<X.S>
        @usableFromInline typealias T = Log<X.T>
        @usableFromInline typealias U = Log<X.U>
        @usableFromInline typealias V = Log<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Log2<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Log2<X.S>
        @usableFromInline typealias T = Log2<X.T>
        @usableFromInline typealias U = Log2<X.U>
        @usableFromInline typealias V = Log2<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Log10<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Log10<X.S>
        @usableFromInline typealias T = Log10<X.T>
        @usableFromInline typealias U = Log10<X.U>
        @usableFromInline typealias V = Log10<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Log1p<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Log1p<X.S>
        @usableFromInline typealias T = Log1p<X.T>
        @usableFromInline typealias U = Log1p<X.U>
        @usableFromInline typealias V = Log1p<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
}
// MARK: Log
extension vFORCE.Log: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Log: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Log: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Log: Tensor & Operators.UnaryTensor {
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
                            Element.log(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Log: InstantScalar where X: InstantScalar {}
extension vFORCE.Log: InstantVector where X: InstantVector {}
extension vFORCE.Log: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Log: InstantTensor where X: InstantTensor {
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
                            Element.log(x.advanced(by: offset.x), stride.x,
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
public func log<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Log(x: x)
}
@_disfavoredOverload
@inlinable
public func log<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Log(x: x)
}
@_disfavoredOverload
@inlinable
public func log<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Log(x: x)
}
@_disfavoredOverload
@inlinable
public func log<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Log(x: x)
}
@_disfavoredOverload
@inlinable
public func log<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Log(x: x)
}
@_disfavoredOverload
@inlinable
public func log<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Log(x: x)
}
@_disfavoredOverload
@inlinable
public func log<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Log(x: x)
}
@_disfavoredOverload
@inlinable
public func log<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Log(x: x)
}
// MARK: Log2
extension vFORCE.Log2: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Log2: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Log2: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Log2: Tensor & Operators.UnaryTensor {
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
                            Element.log2(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Log2: InstantScalar where X: InstantScalar {}
extension vFORCE.Log2: InstantVector where X: InstantVector {}
extension vFORCE.Log2: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Log2: InstantTensor where X: InstantTensor {
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
                            Element.log2(x.advanced(by: offset.x), stride.x,
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
public func log2<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Log2(x: x)
}
@_disfavoredOverload
@inlinable
public func log2<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Log2(x: x)
}
@_disfavoredOverload
@inlinable
public func log2<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Log2(x: x)
}
@_disfavoredOverload
@inlinable
public func log2<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Log2(x: x)
}
@_disfavoredOverload
@inlinable
public func log2<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Log2(x: x)
}
@_disfavoredOverload
@inlinable
public func log2<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Log2(x: x)
}
@_disfavoredOverload
@inlinable
public func log2<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Log2(x: x)
}
@_disfavoredOverload
@inlinable
public func log2<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Log2(x: x)
}
// MARK: Log10
extension vFORCE.Log10: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Log10: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Log10: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Log10: Tensor & Operators.UnaryTensor {
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
                            Element.log10(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Log10: InstantScalar where X: InstantScalar {}
extension vFORCE.Log10: InstantVector where X: InstantVector {}
extension vFORCE.Log10: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Log10: InstantTensor where X: InstantTensor {
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
                            Element.log10(x.advanced(by: offset.x), stride.x,
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
public func log10<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Log10(x: x)
}
@_disfavoredOverload
@inlinable
public func log10<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Log10(x: x)
}
@_disfavoredOverload
@inlinable
public func log10<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Log10(x: x)
}
@_disfavoredOverload
@inlinable
public func log10<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Log10(x: x)
}
@_disfavoredOverload
@inlinable
public func log10<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Log10(x: x)
}
@_disfavoredOverload
@inlinable
public func log10<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Log10(x: x)
}
@_disfavoredOverload
@inlinable
public func log10<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Log10(x: x)
}
@_disfavoredOverload
@inlinable
public func log10<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Log10(x: x)
}
// MARK: Expm1
extension vFORCE.Log1p: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.Log1p: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.Log1p: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.Log1p: Tensor & Operators.UnaryTensor {
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
                            Element.log1p(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.Log1p: InstantScalar where X: InstantScalar {}
extension vFORCE.Log1p: InstantVector where X: InstantVector {}
extension vFORCE.Log1p: InstantMatrix where X: InstantMatrix {}
extension vFORCE.Log1p: InstantTensor where X: InstantTensor {
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
                            Element.log1p(x.advanced(by: offset.x), stride.x,
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
public func log1p<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.Log1p(x: x)
}
@_disfavoredOverload
@inlinable
public func log1p<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.Log1p(x: x)
}
@_disfavoredOverload
@inlinable
public func log1p<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.Log1p(x: x)
}
@_disfavoredOverload
@inlinable
public func log1p<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.Log1p(x: x)
}
@_disfavoredOverload
@inlinable
public func log1p<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.Log1p(x: x)
}
@_disfavoredOverload
@inlinable
public func log1p<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.Log1p(x: x)
}
@_disfavoredOverload
@inlinable
public func log1p<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.Log1p(x: x)
}
@_disfavoredOverload
@inlinable
public func log1p<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.Log1p(x: x)
}
