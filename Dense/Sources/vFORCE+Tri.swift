//
//  vFORCE+Tri.swift
//  MUSE
//
//  Created by Kota on 9/27/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
extension vFORCE {
    @frozen public struct Sin<X: Tensor<Element>> {
        public typealias S = vFORCE.Sin<X.S>
        public typealias T = vFORCE.Sin<X.T>
        public typealias U = vFORCE.Sin<X.U>
        public typealias V = vFORCE.Sin<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Cos<X: Tensor<Element>> {
        public typealias S = Cos<X.S>
        public typealias T = Cos<X.T>
        public typealias U = Cos<X.U>
        public typealias V = Cos<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Tan<X: Tensor<Element>> {
        public typealias S = Tan<X.S>
        public typealias T = Tan<X.T>
        public typealias U = Tan<X.U>
        public typealias V = Tan<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Sinπ<X: Tensor<Element>> {
        public typealias S = Sinπ<X.S>
        public typealias T = Sinπ<X.T>
        public typealias U = Sinπ<X.U>
        public typealias V = Sinπ<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Cosπ<X: Tensor<Element>> {
        public typealias S = Cosπ<X.S>
        public typealias T = Cosπ<X.T>
        public typealias U = Cosπ<X.U>
        public typealias V = Cosπ<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Tanπ<X: Tensor<Element>> {
        public typealias S = Tanπ<X.S>
        public typealias T = Tanπ<X.T>
        public typealias U = Tanπ<X.U>
        public typealias V = Tanπ<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Sinh<X: Tensor<Element>> {
        public typealias S = Sinh<X.S>
        public typealias T = Sinh<X.T>
        public typealias U = Sinh<X.U>
        public typealias V = Sinh<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Cosh<X: Tensor<Element>> {
        public typealias S = Cosh<X.S>
        public typealias T = Cosh<X.T>
        public typealias U = Cosh<X.U>
        public typealias V = Cosh<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    @frozen public struct Tanh<X: Tensor<Element>> {
        public typealias S = Tanh<X.S>
        public typealias T = Tanh<X.T>
        public typealias U = Tanh<X.U>
        public typealias V = Tanh<X.V>
        @usableFromInline let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
}
// MARK: Sin
extension vFORCE.Sin: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Sin: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Sin: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Sin: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
// MARK: Cos
extension vFORCE.Cos: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Cos: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Cos: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Cos: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
// MARK: Tan
extension vFORCE.Tan: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Tan: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Tan: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Tan: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
// MARK: Sinπ
extension vFORCE.Sinπ: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Sinπ: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Sinπ: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Sinπ: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
// MARK: Cosπ
extension vFORCE.Cosπ: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Cosπ: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Cosπ: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Cosπ: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
// MARK: Tanπ
extension vFORCE.Tanπ: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Tanπ: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Tanπ: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Tanπ: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
// MARK: Sinh
extension vFORCE.Sinh: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Sinh: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Sinh: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Sinh: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
// MARK: Cosh
extension vFORCE.Cosh: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Cosh: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Cosh: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Cosh: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
// MARK: Tanh
extension vFORCE.Tanh: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Tanh: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Tanh: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Tanh: Tensor & Operator.UnaryTensor {
    public typealias Element = Element
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                await withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> Array<Element>) {
        switch try x.evaluation(for: strategy) {
        case (let xs, let xm):
            let yk = shape
            let ys = strategy.stride(for: yk)
            let capacity = capacity(alloc: yk, stride: ys)
            let (length, stride, offset) = strategy.flatten(shape: yk, xs: xs, ys: ys)
            return (ys, {
                withUnsafePointer(xm()) { x in
                        .init(unsafeUninitializedCapacity: capacity) {
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
public func sin<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Sin<X> {
    .init(x: x)
}
@_disfavoredOverload
public func cos<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Cos<X> {
    .init(x: x)
}
@_disfavoredOverload
public func tan<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Tan<X> {
    .init(x: x)
}
@_disfavoredOverload
public func sinπ<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Sinπ<X> {
    .init(x: x)
}
@_disfavoredOverload
public func cosπ<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Cosπ<X> {
    .init(x: x)
}
@_disfavoredOverload
public func tanπ<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Tanπ<X> {
    .init(x: x)
}
@_disfavoredOverload
public func sinh<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Sinh<X> {
    .init(x: x)
}
@_disfavoredOverload
public func cosh<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Cosh<X> {
    .init(x: x)
}
@_disfavoredOverload
public func tanh<X: Tensor>(_ x: X) -> vFORCE<X.Element>.Tanh<X> {
    .init(x: x)
}
