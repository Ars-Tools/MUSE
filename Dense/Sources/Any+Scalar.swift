//
//  Any+Scalar.swift
//  MUSE
//
//  Created by Kota on 9/18/R7.
//
import typealias Layout.MemoryStrategy
extension ANY {
	@usableFromInline
	struct Scalar {
		@usableFromInline typealias R = CollectionOfOne<Element>
		@usableFromInline typealias S = Self
		@usableFromInline typealias U = Self
		@usableFromInline let body: Core
		@usableFromInline
		class Core: @unchecked Sendable {
			@usableFromInline
			func callAsFunction(as strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> CollectionOfOne<Element>) { fatalError() }
		}
		final class Tensor<Body: Dense.Tensor<Element>>: Core, @unchecked Sendable {
			@usableFromInline let body: Body
			init(core: Body) {
				body = core
			}
			@usableFromInline
			override func callAsFunction(as strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> CollectionOfOne<Element>) {
				switch try body(as: strategy) {
				case (let stride, let kernel) where stride.isEmpty:
					(stride, {
						await.init(kernel().withUnsafeBufferPointer(\.baseAddress.unsafelyUnwrapped.pointee))
					})
				default:
					throw Error.invalidShape(body)
				}
			}
		}
	}
}
extension ANY.Scalar: Scalar {
	@usableFromInline
	init(core: some Dense.Tensor<Element>) {
//		precondition(core.shape.count { 1 < $0 } < 1)
//		body = Tensor(core: core)
        fatalError()
	}
	@inlinable
	func callAsFunction(as strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> CollectionOfOne<Element>) {
		try body(as: strategy)
	}
}
