//
//  vFORCE+Tri.swift
//  MUSE
//
//  Created by Kota on 9/26/25.
//
import typealias Layout.MemoryStrategy
import func Layout.capacity
extension vFORCE {
    public struct Sin<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    public struct Cos<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    public struct Tan<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    public struct Sinπ<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    public struct Cosπ<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    public struct Tanπ<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    public struct Sinh<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    public struct Cosh<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
    public struct Tanh<X: Tensor<Element>> {
        public let x: X
        @inlinable@_transparent
        init(x: X) {
            self.x = x
        }
    }
}
// MARK: Sin
extension vFORCE.Sin: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
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
extension vFORCE.Sin: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
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
extension vFORCE.Sin: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Sin: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Sin: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Sin: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Sin<X.S>
    public typealias T = vFORCE.Sin<X.T>
    public typealias U = vFORCE.Sin<X.U>
    public typealias V = vFORCE.Sin<X.V>
}
// MARK: Cos
extension vFORCE.Cos: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
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
extension vFORCE.Cos: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
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
extension vFORCE.Cos: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Cos: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Cos: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Cos: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Cos<X.S>
    public typealias T = vFORCE.Cos<X.T>
    public typealias U = vFORCE.Cos<X.U>
    public typealias V = vFORCE.Cos<X.V>
}
// MARK: Tan
extension vFORCE.Tan: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
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
extension vFORCE.Tan: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
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
extension vFORCE.Tan: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Tan: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Tan: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Tan: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Tan<X.S>
    public typealias T = vFORCE.Tan<X.T>
    public typealias U = vFORCE.Tan<X.U>
    public typealias V = vFORCE.Tan<X.V>
}
// MARK: Sinπ
extension vFORCE.Sinπ: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
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
extension vFORCE.Sinπ: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
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
extension vFORCE.Sinπ: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Sinπ: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Sinπ: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Sinπ: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Sinπ<X.S>
    public typealias T = vFORCE.Sinπ<X.T>
    public typealias U = vFORCE.Sinπ<X.U>
    public typealias V = vFORCE.Sinπ<X.V>
}
// MARK: Cosπ
extension vFORCE.Cosπ: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
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
extension vFORCE.Cosπ: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
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
extension vFORCE.Cosπ: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Cosπ: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Cosπ: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Cosπ: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Cosπ<X.S>
    public typealias T = vFORCE.Cosπ<X.T>
    public typealias U = vFORCE.Cosπ<X.U>
    public typealias V = vFORCE.Cosπ<X.V>
}
// MARK: Tanπ
extension vFORCE.Tanπ: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
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
extension vFORCE.Tanπ: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
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
extension vFORCE.Tanπ: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Tanπ: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Tanπ: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Tanπ: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Tanπ<X.S>
    public typealias T = vFORCE.Tanπ<X.T>
    public typealias U = vFORCE.Tanπ<X.U>
    public typealias V = vFORCE.Tanπ<X.V>
}
// MARK: Sinh
extension vFORCE.Sinh: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
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
extension vFORCE.Sinh: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
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
extension vFORCE.Sinh: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Sinh: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Sinh: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Sinh: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Sinh<X.S>
    public typealias T = vFORCE.Sinh<X.T>
    public typealias U = vFORCE.Sinh<X.U>
    public typealias V = vFORCE.Sinh<X.V>
}
// MARK: Cosh
extension vFORCE.Cosh: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
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
extension vFORCE.Cosh: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
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
extension vFORCE.Cosh: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Cosh: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Cosh: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Cosh: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Cosh<X.S>
    public typealias T = vFORCE.Cosh<X.T>
    public typealias U = vFORCE.Cosh<X.U>
    public typealias V = vFORCE.Cosh<X.V>
}
// MARK: Tanh
extension vFORCE.Tanh: Tensor {
    @inlinable@inline(__always)@_transparent
    public var shape: Array<Int> { x.shape }
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> vFORCE.Storage) {
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
extension vFORCE.Tanh: InstantTensor where X: InstantTensor {
    @inlinable@inline(__always)@_transparent
    public func evaluation(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () -> vFORCE.Storage) {
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
extension vFORCE.Tanh: Scalar & Operator.UnaryScalar where X: Scalar {}
extension vFORCE.Tanh: Vector & Operator.UnaryVector where X: Vector {}
extension vFORCE.Tanh: Matrix & Operator.UnaryMatrix where X: Matrix {}
extension vFORCE.Tanh: ElasticTensor & Operator.UnaryTensor where X: ElasticTensor {
    public typealias S = vFORCE.Tanh<X.S>
    public typealias T = vFORCE.Tanh<X.T>
    public typealias U = vFORCE.Tanh<X.U>
    public typealias V = vFORCE.Tanh<X.V>
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
