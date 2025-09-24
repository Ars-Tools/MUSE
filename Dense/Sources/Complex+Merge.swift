//
//  Complex+Merge.swift
//  MUSE
//
//  Created by Kota on 9/24/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
import func Layout.flatten
extension Complex {
    @usableFromInline
    struct Ortho<X: Tensor<Element.Magnitude>, Y: Tensor<Element.Magnitude>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Ortho<X.S, Y.S>
        @usableFromInline typealias T = Ortho<X.T, Y.T>
        @usableFromInline typealias U = Ortho<X.U, Y.U>
        @usableFromInline typealias V = Ortho<X.V, Y.V>
        @usableFromInline let x: X
        @usableFromInline let y: Y
        @inlinable init(x: X, y: Y) {
            self.x = x
            self.y = y
        }
    }
    @usableFromInline
    struct Polar<X: Tensor<Element.Magnitude>, Y: Tensor<Element.Magnitude>> {
        @usableFromInline typealias R = Array<Element>
        @usableFromInline typealias S = Polar<X.S, Y.S>
        @usableFromInline typealias T = Polar<X.T, Y.T>
        @usableFromInline typealias U = Polar<X.U, Y.U>
        @usableFromInline typealias V = Polar<X.V, Y.V>
        @usableFromInline let x: X
        @usableFromInline let y: Y
        @inlinable init(x: X, y: Y) {
            self.x = x
            self.y = y
        }
    }
}
// MARK: Ortho
extension Complex.Ortho: Scalar & Operators.BinaryScalar where X: Scalar, Y: Scalar {}
extension Complex.Ortho: Vector & Operators.BinaryVector where X: Vector, Y: Vector {}
extension Complex.Ortho: Matrix & Operators.BinaryMatrix where X: Matrix, Y: Matrix {}
extension Complex.Ortho: Tensor & Operators.BinaryTensor {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try (x.evaluation(for: strategy), y.evaluation(for: strategy)) {
        case ((let xs, let xm), (let ys, let ym)):
            let xk = x.shape
            let yk = y.shape
            let zk = MemoryStrategy.default.broadcast(x: xk, y: yk)
            let zs = strategy.stride(for: zk)
            let capacity = capacity(alloc: zk, stride: zs)
            let (length, stride, offset) = strategy.flatten(shape: zk,
                                                            xs: MemoryStrategy.default.broadcast(target: zk, source: xk, stride: xs),
                                                            ys: MemoryStrategy.default.broadcast(target: zk, source: yk, stride: ys),
                                                            zs: zs)
            return (zs, {
                await withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.Merge(r: x.advanced(by: offset.x), ldr: stride.x,
                                              i: y.advanced(by: offset.y), ldi: stride.y,
                                              z: z.advanced(by: offset.z), ldz: stride.z, length: length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension Complex.Ortho: InstantScalar where X: InstantScalar, Y: InstantScalar {}
extension Complex.Ortho: InstantVector where X: InstantVector, Y: InstantVector {}
extension Complex.Ortho: InstantMatrix where X: InstantMatrix, Y: InstantMatrix {}
extension Complex.Ortho: InstantTensor where X: InstantTensor, Y: InstantTensor {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try (x.evaluation(for: strategy), y.evaluation(for: strategy)) {
        case ((let xs, let xm), (let ys, let ym)):
            let xk = x.shape
            let yk = y.shape
            let zk = MemoryStrategy.default.broadcast(x: xk, y: yk)
            let zs = strategy.stride(for: zk)
            let capacity = capacity(alloc: zk, stride: zs)
            let (length, stride, offset) = strategy.flatten(shape: zk,
                                                            xs: MemoryStrategy.default.broadcast(target: zk, source: xk, stride: xs),
                                                            ys: MemoryStrategy.default.broadcast(target: zk, source: yk, stride: ys),
                                                            zs: zs)
            return (zs, {
                withUnsafePointer(xm(), ym()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.Merge(r: x.advanced(by: offset.x), ldr: stride.x,
                                              i: y.advanced(by: offset.y), ldi: stride.y,
                                              z: z.advanced(by: offset.z), ldz: stride.z, length: length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
@inlinable
public func complex<Element: ComplexElement>(r: some Vector<Element.Magnitude>, i: some Vector<Element.Magnitude>) -> some Vector<Element> {
    Complex.Ortho(x: r, y: i)
}
@inlinable
public func complex<Element: ComplexElement>(r: some Matrix<Element.Magnitude>, i: some Matrix<Element.Magnitude>) -> some Matrix<Element> {
    Complex.Ortho(x: r, y: i)
}
@inlinable
public func complex<Element: ComplexElement>(r: some Tensor<Element.Magnitude>, i: some Vector<Element.Magnitude>) -> some Tensor<Element> {
    Complex.Ortho(x: r, y: i)
}
@inlinable
public func complex<Element: ComplexElement>(r: some InstantVector<Element.Magnitude>, i: some InstantVector<Element.Magnitude>) -> some InstantVector<Element> {
    Complex.Ortho(x: r, y: i)
}
@inlinable
public func complex<Element: ComplexElement>(r: some InstantMatrix<Element.Magnitude>, i: some InstantMatrix<Element.Magnitude>) -> some InstantMatrix<Element> {
    Complex.Ortho(x: r, y: i)
}
@inlinable
public func complex<Element: ComplexElement>(r: some InstantTensor<Element.Magnitude>, i: some InstantTensor<Element.Magnitude>) -> some InstantTensor<Element> {
    Complex.Ortho(x: r, y: i)
}
// MARK: Polar
extension Complex.Polar: Scalar & Operators.BinaryScalar where X: Scalar, Y: Scalar {}
extension Complex.Polar: Vector & Operators.BinaryVector where X: Vector, Y: Vector {}
extension Complex.Polar: Matrix & Operators.BinaryMatrix where X: Matrix, Y: Matrix {}
extension Complex.Polar: Tensor & Operators.BinaryTensor {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try (x.evaluation(for: strategy), y.evaluation(for: strategy)) {
        case ((let xs, let xk), (let ys, let yk)):
            let zk = shape
            let zs = strategy.stride(for: zk)
            let capacity = capacity(alloc: zk, stride: zs)
            let (length, stride, offset) = strategy.flatten(shape: zk,
                                                            xs: strategy.broadcast(target: zk, source: x.shape, stride: xs),
                                                            ys: strategy.broadcast(target: zk, source: y.shape, stride: ys),
                                                            zs: zs)
            return (zs, {
                await withUnsafePointer(xk(), yk()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.Merge(r: x.advanced(by: offset.x), ldr: stride.x,
                                              θ: y.advanced(by: offset.y), ldθ: stride.y,
                                              z: z.advanced(by: offset.z), ldz: stride.z, length: length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
extension Complex.Polar: InstantScalar where X: InstantScalar, Y: InstantScalar {}
extension Complex.Polar: InstantVector where X: InstantVector, Y: InstantVector {}
extension Complex.Polar: InstantMatrix where X: InstantMatrix, Y: InstantMatrix {}
extension Complex.Polar: InstantTensor where X: InstantTensor, Y: InstantTensor {
    @inlinable
    func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try (x.evaluation(for: strategy), y.evaluation(for: strategy)) {
        case ((let xs, let xk), (let ys, let yk)):
            let zk = shape
            let zs = strategy.stride(for: zk)
            let capacity = capacity(alloc: zk, stride: zs)
            let (length, stride, offset) = strategy.flatten(shape: zk,
                                                            xs: strategy.broadcast(target: zk, source: x.shape, stride: xs),
                                                            ys: strategy.broadcast(target: zk, source: y.shape, stride: ys),
                                                            zs: zs)
            return (zs, {
                withUnsafePointer(xk(), yk()) { x, y in
                        .init(unsafeUninitializedCapacity: capacity) {
                            let z = $0.baseAddress.unsafelyUnwrapped
                            for offset in offset {
                                Element.Merge(r: x.advanced(by: offset.x), ldr: stride.x,
                                              θ: y.advanced(by: offset.y), ldθ: stride.y,
                                              z: z.advanced(by: offset.z), ldz: stride.z, length: length)
                            }
                            $1 = $0.count
                        }
                }
            })
        }
    }
}
@inlinable
public func complex<Element: ComplexElement>(r: some Vector<Element.Magnitude>, θ: some Vector<Element.Magnitude>) -> some Vector<Element> {
    Complex.Polar(x: r, y: θ)
}
@inlinable
public func complex<Element: ComplexElement>(r: some Matrix<Element.Magnitude>, θ: some Matrix<Element.Magnitude>) -> some Matrix<Element> {
    Complex.Polar(x: r, y: θ)
}
@inlinable
public func complex<Element: ComplexElement>(r: some Tensor<Element.Magnitude>, θ: some Vector<Element.Magnitude>) -> some Tensor<Element> {
    Complex.Polar(x: r, y: θ)
}
@inlinable
public func complex<Element: ComplexElement>(r: some InstantVector<Element.Magnitude>, θ: some InstantVector<Element.Magnitude>) -> some InstantVector<Element> {
    Complex.Polar(x: r, y: θ)
}
@inlinable
public func complex<Element: ComplexElement>(r: some InstantMatrix<Element.Magnitude>, θ: some InstantMatrix<Element.Magnitude>) -> some InstantMatrix<Element> {
    Complex.Polar(x: r, y: θ)
}
@inlinable
public func complex<Element: ComplexElement>(r: some InstantTensor<Element.Magnitude>, θ: some InstantTensor<Element.Magnitude>) -> some InstantTensor<Element> {
    Complex.Polar(x: r, y: θ)
}
