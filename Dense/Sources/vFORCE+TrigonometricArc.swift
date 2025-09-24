//
//  vFORCE+TrigonometricArc.swift
//  MUSE
//
//  Created by Kota on 9/24/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
extension vFORCE {
    @usableFromInline
    struct ArcSin<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = ArcSin<X.S>
        @usableFromInline typealias T = ArcSin<X.T>
        @usableFromInline typealias U = ArcSin<X.U>
        @usableFromInline typealias V = ArcSin<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct ArcCos<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = ArcCos<X.S>
        @usableFromInline typealias T = ArcCos<X.T>
        @usableFromInline typealias U = ArcCos<X.U>
        @usableFromInline typealias V = ArcCos<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct ArcTan<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = ArcTan<X.S>
        @usableFromInline typealias T = ArcTan<X.T>
        @usableFromInline typealias U = ArcTan<X.U>
        @usableFromInline typealias V = ArcTan<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct ArcSinh<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = ArcSinh<X.S>
        @usableFromInline typealias T = ArcSinh<X.T>
        @usableFromInline typealias U = ArcSinh<X.U>
        @usableFromInline typealias V = ArcSinh<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct ArcCosh<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = ArcCosh<X.S>
        @usableFromInline typealias T = ArcCosh<X.T>
        @usableFromInline typealias U = ArcCosh<X.U>
        @usableFromInline typealias V = ArcCosh<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct ArcTanh<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = ArcTanh<X.S>
        @usableFromInline typealias T = ArcTanh<X.T>
        @usableFromInline typealias U = ArcTanh<X.U>
        @usableFromInline typealias V = ArcTanh<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
}
// MARK: Sin
extension vFORCE.ArcSin: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.ArcSin: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.ArcSin: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcSin: Tensor & Operators.UnaryTensor {
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
                            Element.asin(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.ArcSin: InstantScalar where X: InstantScalar {}
extension vFORCE.ArcSin: InstantVector where X: InstantVector {}
extension vFORCE.ArcSin: InstantMatrix where X: InstantMatrix {}
extension vFORCE.ArcSin: InstantTensor where X: InstantTensor {
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
                            Element.asin(x.advanced(by: offset.x), stride.x,
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
public func asin<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.ArcSin(x: x)
}
@_disfavoredOverload
@inlinable
public func asin<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.ArcSin(x: x)
}
@_disfavoredOverload
@inlinable
public func asin<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.ArcSin(x: x)
}
@_disfavoredOverload
@inlinable
public func asin<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.ArcSin(x: x)
}
@_disfavoredOverload
@inlinable
public func asin<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.ArcSin(x: x)
}
@_disfavoredOverload
@inlinable
public func asin<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.ArcSin(x: x)
}
@_disfavoredOverload
@inlinable
public func asin<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.ArcSin(x: x)
}
@_disfavoredOverload
@inlinable
public func asin<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.ArcSin(x: x)
}
// MARK: Cos
extension vFORCE.ArcCos: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.ArcCos: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.ArcCos: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcCos: Tensor & Operators.UnaryTensor {
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
                            Element.acos(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.ArcCos: InstantScalar where X: InstantScalar {}
extension vFORCE.ArcCos: InstantVector where X: InstantVector {}
extension vFORCE.ArcCos: InstantMatrix where X: InstantMatrix {}
extension vFORCE.ArcCos: InstantTensor where X: InstantTensor {
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
                            Element.acos(x.advanced(by: offset.x), stride.x,
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
public func acos<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.ArcCos(x: x)
}
@_disfavoredOverload
@inlinable
public func acos<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.ArcCos(x: x)
}
@_disfavoredOverload
@inlinable
public func acos<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.ArcCos(x: x)
}
@_disfavoredOverload
@inlinable
public func acos<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.ArcCos(x: x)
}
@_disfavoredOverload
@inlinable
public func acos<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.ArcCos(x: x)
}
@_disfavoredOverload
@inlinable
public func acos<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.ArcCos(x: x)
}
@_disfavoredOverload
@inlinable
public func acos<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.ArcCos(x: x)
}
@_disfavoredOverload
@inlinable
public func acos<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.ArcCos(x: x)
}
// MARK: Tan
extension vFORCE.ArcTan: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.ArcTan: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.ArcTan: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcTan: Tensor & Operators.UnaryTensor {
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
                            Element.atan(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.ArcTan: InstantScalar where X: InstantScalar {}
extension vFORCE.ArcTan: InstantVector where X: InstantVector {}
extension vFORCE.ArcTan: InstantMatrix where X: InstantMatrix {}
extension vFORCE.ArcTan: InstantTensor where X: InstantTensor {
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
                            Element.atan(x.advanced(by: offset.x), stride.x,
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
public func atan<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.ArcTan(x: x)
}
@_disfavoredOverload
@inlinable
public func atan<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.ArcTan(x: x)
}
@_disfavoredOverload
@inlinable
public func atan<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.ArcTan(x: x)
}
@_disfavoredOverload
@inlinable
public func atan<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.ArcTan(x: x)
}
@_disfavoredOverload
@inlinable
public func atan<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.ArcTan(x: x)
}
@_disfavoredOverload
@inlinable
public func atan<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.ArcTan(x: x)
}
@_disfavoredOverload
@inlinable
public func atan<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.ArcTan(x: x)
}
@_disfavoredOverload
@inlinable
public func atan<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.ArcTan(x: x)
}
// Hyperbolic
extension vFORCE.ArcSinh: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.ArcSinh: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.ArcSinh: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcSinh: Tensor & Operators.UnaryTensor {
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
                            Element.asinh(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.ArcSinh: InstantScalar where X: InstantScalar {}
extension vFORCE.ArcSinh: InstantVector where X: InstantVector {}
extension vFORCE.ArcSinh: InstantMatrix where X: InstantMatrix {}
extension vFORCE.ArcSinh: InstantTensor where X: InstantTensor {
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
                            Element.asinh(x.advanced(by: offset.x), stride.x,
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
public func asinh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.ArcSinh(x: x)
}
@_disfavoredOverload
@inlinable
public func asinh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.ArcSinh(x: x)
}
@_disfavoredOverload
@inlinable
public func asinh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.ArcSinh(x: x)
}
@_disfavoredOverload
@inlinable
public func asinh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.ArcSinh(x: x)
}
@_disfavoredOverload
@inlinable
public func asinh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.ArcSinh(x: x)
}
@_disfavoredOverload
@inlinable
public func asinh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.ArcSinh(x: x)
}
@_disfavoredOverload
@inlinable
public func asinh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.ArcSinh(x: x)
}
@_disfavoredOverload
@inlinable
public func asinh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.ArcSinh(x: x)
}
// MARK: Cos
extension vFORCE.ArcCosh: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.ArcCosh: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.ArcCosh: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcCosh: Tensor & Operators.UnaryTensor {
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
                            Element.acosh(x.advanced(by: offset.x), stride.x,
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
extension vFORCE.ArcCosh: InstantScalar where X: InstantScalar {}
extension vFORCE.ArcCosh: InstantVector where X: InstantVector {}
extension vFORCE.ArcCosh: InstantMatrix where X: InstantMatrix {}
extension vFORCE.ArcCosh: InstantTensor where X: InstantTensor {
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
                            Element.acosh(x.advanced(by: offset.x), stride.x,
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
public func acosh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.ArcCosh(x: x)
}
@_disfavoredOverload
@inlinable
public func acosh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.ArcCosh(x: x)
}
@_disfavoredOverload
@inlinable
public func acosh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.ArcCosh(x: x)
}
@_disfavoredOverload
@inlinable
public func acosh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.ArcCosh(x: x)
}
@_disfavoredOverload
@inlinable
public func acosh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.ArcCosh(x: x)
}
@_disfavoredOverload
@inlinable
public func acosh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.ArcCosh(x: x)
}
@_disfavoredOverload
@inlinable
public func acosh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.ArcCosh(x: x)
}
@_disfavoredOverload
@inlinable
public func acosh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.ArcCosh(x: x)
}
// MARK: Tan
extension vFORCE.ArcTanh: Scalar & Operators.UnaryScalar where X: Scalar {}
extension vFORCE.ArcTanh: Vector & Operators.UnaryVector where X: Vector {}
extension vFORCE.ArcTanh: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension vFORCE.ArcTanh: Tensor & Operators.UnaryTensor {
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
extension vFORCE.ArcTanh: InstantScalar where X: InstantScalar {}
extension vFORCE.ArcTanh: InstantVector where X: InstantVector {}
extension vFORCE.ArcTanh: InstantMatrix where X: InstantMatrix {}
extension vFORCE.ArcTanh: InstantTensor where X: InstantTensor {
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
public func atanh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Scalar<Element>) -> some Scalar<Element> {
    vFORCE.ArcTanh(x: x)
}
@_disfavoredOverload
@inlinable
public func atanh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Vector<Element>) -> some Vector<Element> {
    vFORCE.ArcTanh(x: x)
}
@_disfavoredOverload
@inlinable
public func atanh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Matrix<Element>) -> some Matrix<Element> {
    vFORCE.ArcTanh(x: x)
}
@_disfavoredOverload
@inlinable
public func atanh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some Tensor<Element>) -> some Tensor<Element> {
    vFORCE.ArcTanh(x: x)
}
@_disfavoredOverload
@inlinable
public func atanh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantScalar<Element>) -> some InstantScalar<Element> {
    vFORCE.ArcTanh(x: x)
}
@_disfavoredOverload
@inlinable
public func atanh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantVector<Element>) -> some InstantVector<Element> {
    vFORCE.ArcTanh(x: x)
}
@_disfavoredOverload
@inlinable
public func atanh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantMatrix<Element>) -> some InstantMatrix<Element> {
    vFORCE.ArcTanh(x: x)
}
@_disfavoredOverload
@inlinable
public func atanh<Element: vFORCESuiteElement & ArithmeticElement>(_ x: some InstantTensor<Element>) -> some InstantTensor<Element> {
    vFORCE.ArcTanh(x: x)
}
