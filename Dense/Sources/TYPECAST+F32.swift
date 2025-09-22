//
//  TYPECAST+F32.swift
//  MUSE
//
//  Created by Kota on 9/22/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
extension TYPECAST {
    @usableFromInline
    struct F32<X: Tensor<Float32>, Element: Float32CompatibleElement & BitwiseCopyable & Sendable> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = F32<X.S, Element>
        @usableFromInline typealias T = F32<X.T, Element>
        @usableFromInline typealias U = F32<X.U, Element>
        @usableFromInline typealias V = F32<X.V, Element>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct T32<X: Tensor> where X.Element: Float32CompatibleElement {
        @usableFromInline typealias R = Array<Float32>
        @usableFromInline typealias S = T32<X.S>
        @usableFromInline typealias T = T32<X.T>
        @usableFromInline typealias U = T32<X.U>
        @usableFromInline typealias V = T32<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
}
// MARK: From
extension TYPECAST.F32: Scalar & Operators.UnaryScalar where X: Scalar {}
extension TYPECAST.F32: Vector & Operators.UnaryVector where X: Vector {}
extension TYPECAST.F32: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension TYPECAST.F32: Tensor & Operators.UnaryTensor {
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
                            Element.Convert(x.advanced(by: offset.x), stride.x,
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
extension TYPECAST.F32: InstantScalar where X: InstantScalar {}
extension TYPECAST.F32: InstantVector where X: InstantVector {}
extension TYPECAST.F32: InstantMatrix where X: InstantMatrix {}
extension TYPECAST.F32: InstantTensor where X: InstantTensor {
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
                            Element.Convert(x.advanced(by: offset.x), stride.x,
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
@inlinable@_transparent
public func typecast<Element: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Scalar<Float32>, as: Element.Type = Element.self) -> some Scalar<Element> {
    TYPECAST.F32(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Vector<Float32>, as: Element.Type = Element.self) -> some Vector<Element> {
    TYPECAST.F32(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Matrix<Float32>, as: Element.Type = Element.self) -> some Matrix<Element> {
    TYPECAST.F32(x: source)
}
@_disfavoredOverload
@inlinable@_transparent
public func typecast<Element: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Tensor<Float32>, as: Element.Type = Element.self) -> some Tensor<Element> {
    TYPECAST.F32(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some InstantScalar<Float32>, as: Element.Type = Element.self) -> some InstantScalar<Element> {
    TYPECAST.F32(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some InstantVector<Float32>, as: Element.Type = Element.self) -> some InstantVector<Element> {
    TYPECAST.F32(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some InstantMatrix<Float32>, as: Element.Type = Element.self) -> some InstantMatrix<Element> {
    TYPECAST.F32(x: source)
}
@_disfavoredOverload
@inlinable@_transparent
public func typecast<Element: Float32CompatibleElement & BitwiseCopyable & Sendable>(_ source: some InstantTensor<Float32>, as: Element.Type = Element.self) -> some InstantTensor<Element> {
    TYPECAST.F32(x: source)
}
// MARK: To
extension TYPECAST.T32: Scalar & Operators.UnaryScalar where X: Scalar {}
extension TYPECAST.T32: Vector & Operators.UnaryVector where X: Vector {}
extension TYPECAST.T32: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension TYPECAST.T32: Tensor & Operators.UnaryTensor {
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
                            X.Element.Convert(x.advanced(by: offset.x), stride.x,
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
extension TYPECAST.T32: InstantScalar where X: InstantScalar {}
extension TYPECAST.T32: InstantVector where X: InstantVector {}
extension TYPECAST.T32: InstantMatrix where X: InstantMatrix {}
extension TYPECAST.T32: InstantTensor where X: InstantTensor {
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
                            X.Element.Convert(x.advanced(by: offset.x), stride.x,
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
@inlinable@_transparent
public func typecast<Element: Float32CompatibleElement>(_ source: some Scalar<Element>, as: Float32.Type = Float32.self) -> some Scalar<Float32> {
    TYPECAST.T32(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float32CompatibleElement>(_ source: some Vector<Element>, as: Float32.Type = Float32.self) -> some Vector<Float32> {
    TYPECAST.T32(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float32CompatibleElement>(_ source: some Matrix<Element>, as: Float32.Type = Float32.self) -> some Matrix<Float32> {
    TYPECAST.T32(x: source)
}
@_disfavoredOverload
@inlinable@_transparent
public func typecast<Element: Float32CompatibleElement>(_ source: some Tensor<Element>, as: Float32.Type = Float32.self) -> some Tensor<Float32> {
    TYPECAST.T32(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float32CompatibleElement>(_ source: some InstantScalar<Element>, as: Float32.Type = Float32.self) -> some InstantScalar<Float32> {
    TYPECAST.T32(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float32CompatibleElement>(_ source: some InstantVector<Element>, as: Float32.Type = Float32.self) -> some InstantVector<Float32> {
    TYPECAST.T32(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float32CompatibleElement>(_ source: some InstantMatrix<Element>, as: Float32.Type = Float32.self) -> some InstantMatrix<Float32> {
    TYPECAST.T32(x: source)
}
@_disfavoredOverload
@inlinable@_transparent
public func typecast<Element: Float32CompatibleElement>(_ source: some InstantTensor<Element>, as: Float32.Type = Float32.self) -> some InstantTensor<Float32> {
    TYPECAST.T32(x: source)
}
