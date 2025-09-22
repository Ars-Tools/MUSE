//
//  TYPECAST+F64.swift
//  MUSE
//
//  Created by Kota on 9/22/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
extension TYPECAST {
    @usableFromInline
    struct F64<X: Tensor<Float64>, Element: Float64CompatibleElement & BitwiseCopyable & Sendable> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = F64<X.S, Element>
        @usableFromInline typealias T = F64<X.T, Element>
        @usableFromInline typealias U = F64<X.U, Element>
        @usableFromInline typealias V = F64<X.V, Element>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @usableFromInline
    struct T64<X: Tensor> where X.Element: Float64CompatibleElement {
        @usableFromInline typealias R = Array<Float64>
        @usableFromInline typealias S = T64<X.S>
        @usableFromInline typealias T = T64<X.T>
        @usableFromInline typealias U = T64<X.U>
        @usableFromInline typealias V = T64<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
}
// MARK: From
extension TYPECAST.F64: Scalar & Operators.UnaryScalar where X: Scalar {}
extension TYPECAST.F64: Vector & Operators.UnaryVector where X: Vector {}
extension TYPECAST.F64: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension TYPECAST.F64: Tensor & Operators.UnaryTensor {
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
extension TYPECAST.F64: InstantScalar where X: InstantScalar {}
extension TYPECAST.F64: InstantVector where X: InstantVector {}
extension TYPECAST.F64: InstantMatrix where X: InstantMatrix {}
extension TYPECAST.F64: InstantTensor where X: InstantTensor {
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
public func typecast<Element: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Scalar<Float64>, as: Element.Type = Element.self) -> some Scalar<Element> {
    TYPECAST.F64(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Vector<Float64>, as: Element.Type = Element.self) -> some Vector<Element> {
    TYPECAST.F64(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Matrix<Float64>, as: Element.Type = Element.self) -> some Matrix<Element> {
    TYPECAST.F64(x: source)
}
@_disfavoredOverload
@inlinable@_transparent
public func typecast<Element: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some Tensor<Float64>, as: Element.Type = Element.self) -> some Tensor<Element> {
    TYPECAST.F64(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some InstantScalar<Float64>, as: Element.Type = Element.self) -> some InstantScalar<Element> {
    TYPECAST.F64(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some InstantVector<Float64>, as: Element.Type = Element.self) -> some InstantVector<Element> {
    TYPECAST.F64(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some InstantMatrix<Float64>, as: Element.Type = Element.self) -> some InstantMatrix<Element> {
    TYPECAST.F64(x: source)
}
@_disfavoredOverload
@inlinable@_transparent
public func typecast<Element: Float64CompatibleElement & BitwiseCopyable & Sendable>(_ source: some InstantTensor<Float64>, as: Element.Type = Element.self) -> some InstantTensor<Element> {
    TYPECAST.F64(x: source)
}
// MARK: To
extension TYPECAST.T64: Scalar & Operators.UnaryScalar where X: Scalar {}
extension TYPECAST.T64: Vector & Operators.UnaryVector where X: Vector {}
extension TYPECAST.T64: Matrix & Operators.UnaryMatrix where X: Matrix {}
extension TYPECAST.T64: Tensor & Operators.UnaryTensor {
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
extension TYPECAST.T64: InstantScalar where X: InstantScalar {}
extension TYPECAST.T64: InstantVector where X: InstantVector {}
extension TYPECAST.T64: InstantMatrix where X: InstantMatrix {}
extension TYPECAST.T64: InstantTensor where X: InstantTensor {
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
public func typecast<Element: Float64CompatibleElement>(_ source: some Scalar<Element>, as: Float64.Type = Float64.self) -> some Scalar<Float64> {
    TYPECAST.T64(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float64CompatibleElement>(_ source: some Vector<Element>, as: Float64.Type = Float64.self) -> some Vector<Float64> {
    TYPECAST.T64(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float64CompatibleElement>(_ source: some Matrix<Element>, as: Float64.Type = Float64.self) -> some Matrix<Float64> {
    TYPECAST.T64(x: source)
}
@_disfavoredOverload
@inlinable@_transparent
public func typecast<Element: Float64CompatibleElement>(_ source: some Tensor<Element>, as: Float64.Type = Float64.self) -> some Tensor<Float64> {
    TYPECAST.T64(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float64CompatibleElement>(_ source: some InstantScalar<Element>, as: Float64.Type = Float64.self) -> some InstantScalar<Float64> {
    TYPECAST.T64(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float64CompatibleElement>(_ source: some InstantVector<Element>, as: Float64.Type = Float64.self) -> some InstantVector<Float64> {
    TYPECAST.T64(x: source)
}
@inlinable@_transparent
public func typecast<Element: Float64CompatibleElement>(_ source: some InstantMatrix<Element>, as: Float64.Type = Float64.self) -> some InstantMatrix<Float64> {
    TYPECAST.T64(x: source)
}
@_disfavoredOverload
@inlinable@_transparent
public func typecast<Element: Float64CompatibleElement>(_ source: some InstantTensor<Element>, as: Float64.Type = Float64.self) -> some InstantTensor<Float64> {
    TYPECAST.T64(x: source)
}
