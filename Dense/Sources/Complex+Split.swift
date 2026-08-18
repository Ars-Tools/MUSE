//
//  Complex+Split.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import AltVec
extension Complex {
    @frozen public struct Realp<X: Tensor<Element>> {
        public typealias S = Realp<X.S>
        public typealias T = Realp<X.T>
        public typealias U = Realp<X.U>
        public typealias V = Realp<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Imagp<X: Tensor<Element>> {
        public typealias S = Imagp<X.S>
        public typealias T = Imagp<X.T>
        public typealias U = Imagp<X.U>
        public typealias V = Imagp<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Phase<X: Tensor<Element>> {
        public typealias S = Phase<X.S>
        public typealias T = Phase<X.T>
        public typealias U = Phase<X.U>
        public typealias V = Phase<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
}
// MARK: R
extension Complex.Realp: Scalar & Operator.UnaryScalar where X: Scalar {}
extension Complex.Realp: Vector & Operator.UnaryVector where X: Vector {}
extension Complex.Realp: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension Complex.Realp: Tensor & Operator.UnaryTensor {
    public typealias Element = X.Element.Magnitude
    @inlinable@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<X.Element.Magnitude>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                    .init(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            X.Element.Copy(z: x.advanced(by: offset.x), inc: stride.x,
                                           r: y.advanced(by: offset.y), inc: stride.y, length: length)
                        }
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
extension Complex.Realp: InstantTensor where X: InstantTensor {
    @inlinable
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<X.Element.Magnitude>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                    .init(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            X.Element.Copy(z: x.advanced(by: offset.x), inc: stride.x,
                                           r: y.advanced(by: offset.y), inc: stride.y, length: length)
                        }
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable {
    @inlinable@_transparent
    public var realp: Complex<Element>.Realp<Self> {
        .init(x: self)
    }
}
// MARK: I
extension Complex.Imagp: Scalar & Operator.UnaryScalar where X: Scalar {}
extension Complex.Imagp: Vector & Operator.UnaryVector where X: Vector {}
extension Complex.Imagp: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension Complex.Imagp: Tensor & Operator.UnaryTensor {
    public typealias Element = X.Element.Magnitude
    @inlinable@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<X.Element.Magnitude>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                    .init(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            X.Element.Copy(z: x.advanced(by: offset.x), inc: stride.x,
                                           i: y.advanced(by: offset.y), inc: stride.y, length: length)
                        }
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
extension Complex.Imagp: InstantTensor where X: InstantTensor {
    @inlinable@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<X.Element.Magnitude>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                    .init(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            X.Element.Copy(z: x.advanced(by: offset.x), inc: stride.x,
                                           i: y.advanced(by: offset.y), inc: stride.y, length: length)
                        }
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable {
    @inlinable@_transparent
    public var imagp: Complex<Element>.Imagp<Self> {
        .init(x: self)
    }
}
// MARK: θ
extension Complex.Phase: Scalar & Operator.UnaryScalar where X: Scalar {}
extension Complex.Phase: Vector & Operator.UnaryVector where X: Vector {}
extension Complex.Phase: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension Complex.Phase: Tensor & Operator.UnaryTensor {
    public typealias Element = X.Element.Magnitude
    @inlinable@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<X.Element.Magnitude>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                    .init(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            X.Element.Copy(z: x.advanced(by: offset.x), inc: stride.x,
                                           θ: y.advanced(by: offset.y), inc: stride.y, length: length)
                        }
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
extension Complex.Phase: InstantTensor where X: InstantTensor {
    @inlinable@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<X.Element.Magnitude>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = x.shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                    .init(unsafeUninitializedCapacity: capacity) {
                        let y = $0.baseAddress.unsafelyUnwrapped
                        for offset in offset {
                            X.Element.Copy(z: x.advanced(by: offset.x), inc: stride.x,
                                           θ: y.advanced(by: offset.y), inc: stride.y, length: length)
                        }
                        $1 = $0.count
                    }
                }
            })
        }
    }
}
extension Tensor where Element: ComplexElement, Element.Magnitude: BitwiseCopyable & Sendable {
    @inlinable@_transparent
    public var θ: Complex<Element>.Phase<Self> {
        .init(x: self)
    }
}
