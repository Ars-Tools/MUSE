//
//  Complex+Split.swift
//  MUSE
//
//  Created by Kota on 9/24/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
extension Complex {
    @usableFromInline
    struct Realp<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<X.Element.Magnitude>
        @usableFromInline typealias S = Realp<X.S>
        @usableFromInline typealias T = Realp<X.T>
        @usableFromInline typealias U = Realp<X.U>
        @usableFromInline typealias V = Realp<X.V>
        @usableFromInline let x: X
        @inlinable init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Imagp<X: Tensor<Element>> {
        @usableFromInline typealias R = Array<X.Element.Magnitude>
        @usableFromInline typealias S = Imagp<X.S>
        @usableFromInline typealias T = Imagp<X.T>
        @usableFromInline typealias U = Imagp<X.U>
        @usableFromInline typealias V = Imagp<X.V>
        @usableFromInline let x: X
        @inlinable init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct Phase<X: Tensor<Element>> {
        @usableFromInline typealias Element = X.Element.Magnitude
        @usableFromInline typealias R = Array<X.Element.Magnitude>
        @usableFromInline typealias S = Phase<X.S>
        @usableFromInline typealias T = Phase<X.T>
        @usableFromInline typealias U = Phase<X.U>
        @usableFromInline typealias V = Phase<X.V>
        @usableFromInline let x: X
        @inlinable init(x: X) {
            self.x = x
        }
    }
}
// MARK: R
extension Complex.Realp: Scalar & Operators.UnaryScalar where X: Scalar {}
extension Complex.Realp: Vector & Operators.UnaryVector where X: Vector {}
extension Complex.Realp: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension Complex.Realp: Tensor & Operators.UnaryTensor where X: Tensor {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<X.Element.Magnitude>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            X.Element.Copy(z: x.advanced(by: offset.x), ldz: stride.x,
                                           r: y.advanced(by: offset.y), ldr: stride.y, length: length)
                        }
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
extension Complex.Realp: InstantScalar where X: InstantScalar {}
extension Complex.Realp: InstantVector where X: InstantVector {}
extension Complex.Realp: InstantMatrix where X: InstantMatrix {}
extension Complex.Realp: InstantTensor where X: InstantTensor {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<X.Element.Magnitude>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            X.Element.Copy(z: x.advanced(by: offset.x), ldz: stride.x,
                                           r: y.advanced(by: offset.y), ldr: stride.y, length: length)
                        }
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: Scalar {
    public var r: some Scalar<Element.Magnitude> {
        Complex.Realp(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: Vector {
    public var r: some Vector<Element.Magnitude> {
        Complex.Realp(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: Matrix {
    public var r: some Matrix<Element.Magnitude> {
        Complex.Realp(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable {
    public var r: some Tensor<Element.Magnitude> {
        Complex.Realp(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: InstantScalar {
    public var r: some InstantScalar<Element.Magnitude> {
        Complex.Realp(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: InstantVector {
    public var r: some InstantVector<Element.Magnitude> {
        Complex.Realp(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: InstantMatrix {
    public var r: some InstantMatrix<Element.Magnitude> {
        Complex.Realp(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: InstantTensor {
    public var r: some InstantTensor<Element.Magnitude> {
        Complex.Realp(x: self)
    }
}
// MARK: I
extension Complex.Imagp: Scalar & Operators.UnaryScalar where X: Scalar {}
extension Complex.Imagp: Vector & Operators.UnaryVector where X: Vector {}
extension Complex.Imagp: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension Complex.Imagp: Tensor & Operators.UnaryTensor where X: Tensor {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<X.Element.Magnitude>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            X.Element.Copy(z: x.advanced(by: offset.x), ldz: stride.x,
                                           i: y.advanced(by: offset.y), ldi: stride.y, length: length)
                        }
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
extension Complex.Imagp: InstantScalar where X: InstantScalar {}
extension Complex.Imagp: InstantVector where X: InstantVector {}
extension Complex.Imagp: InstantMatrix where X: InstantMatrix {}
extension Complex.Imagp: InstantTensor where X: InstantTensor {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<X.Element.Magnitude>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            X.Element.Copy(z: x.advanced(by: offset.x), ldz: stride.x,
                                           i: y.advanced(by: offset.y), ldi: stride.y, length: length)
                        }
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: Scalar {
    public var i: some Scalar<Element.Magnitude> {
        Complex.Imagp(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: Vector {
    public var i: some Vector<Element.Magnitude> {
        Complex.Imagp(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: Matrix {
    public var i: some Matrix<Element.Magnitude> {
        Complex.Imagp(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable {
    public var i: some Tensor<Element.Magnitude> {
        Complex.Imagp(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: InstantScalar {
    public var i: some InstantScalar<Element.Magnitude> {
        Complex.Imagp(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: InstantVector {
    public var i: some InstantVector<Element.Magnitude> {
        Complex.Imagp(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: InstantMatrix {
    public var i: some InstantMatrix<Element.Magnitude> {
        Complex.Imagp(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: InstantTensor {
    public var i: some InstantTensor<Element.Magnitude> {
        Complex.Imagp(x: self)
    }
}
// MARK: θ
extension Complex.Phase: Scalar & Operators.UnaryScalar where X: Scalar {}
extension Complex.Phase: Vector & Operators.UnaryVector where X: Vector {}
extension Complex.Phase: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension Complex.Phase: Tensor & Operators.UnaryTensor where X: Tensor {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<X.Element.Magnitude>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            X.Element.Copy(z: x.advanced(by: offset.x), ldz: stride.x,
                                           θ: y.advanced(by: offset.y), ldθ: stride.y, length: length)
                        }
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
extension Complex.Phase: InstantScalar where X: InstantScalar {}
extension Complex.Phase: InstantVector where X: InstantVector {}
extension Complex.Phase: InstantMatrix where X: InstantMatrix {}
extension Complex.Phase: InstantTensor where X: InstantTensor {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<X.Element.Magnitude>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                xm().withUnsafeBufferPointer {
                    let x = $0.baseAddress.unsafelyUnwrapped
                    return.init(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            X.Element.Copy(z: x.advanced(by: offset.x), ldz: stride.x,
                                           θ: y.advanced(by: offset.y), ldθ: stride.y, length: length)
                        }
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: Scalar {
    public var θ: some Scalar<Element.Magnitude> {
        Complex.Phase(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: Vector {
    public var θ: some Vector<Element.Magnitude> {
        Complex.Phase(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: Matrix {
    public var θ: some Matrix<Element.Magnitude> {
        Complex.Phase(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable {
    public var θ: some Tensor<Element.Magnitude> {
        Complex.Phase(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: InstantScalar {
    public var θ: some InstantScalar<Element.Magnitude> {
        Complex.Phase(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: InstantVector {
    public var θ: some InstantVector<Element.Magnitude> {
        Complex.Phase(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: InstantMatrix {
    public var θ: some InstantMatrix<Element.Magnitude> {
        Complex.Phase(x: self)
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable, Self: InstantTensor {
    public var θ: some InstantTensor<Element.Magnitude> {
        Complex.Phase(x: self)
    }
}
