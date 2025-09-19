//
//  Any+Vector.swift
//  MUSE
//
//  Created by Kota on 9/18/R7.
//
import typealias Layout.MemoryStrategy
extension ANY {
	@usableFromInline
	struct Vector {
		@usableFromInline typealias R = Array<Element>
		@usableFromInline typealias S = Self
		@usableFromInline typealias U = Scalar
		@usableFromInline let body: Core
		@usableFromInline
		class Core: @unchecked Sendable {
			@usableFromInline
			var count: Int { fatalError() }
			@usableFromInline
			subscript(position: Int) -> U { fatalError() }
			@inlinable
			subscript(bounds: some RangeExpression<Int>) -> S { fatalError() }
			@usableFromInline
			func callAsFunction(for strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) { fatalError() }
		}
		@usableFromInline
		final class Vec<Body: Dense.Vector<Element>>: Core, @unchecked Sendable {
			@usableFromInline let body: Body
			@usableFromInline
			init(core: Body) {
				body = core
			}
			@usableFromInline
			override func callAsFunction(for strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
				switch try body(for: strategy) {
				case (let s, let k) where s.count == 1:
					([s.reduce(0, +)], {
						await k().withUnsafeBufferPointer(Array.init)
					})
				default:
					throw Error.invalidShape(body)
				}
			}
			@usableFromInline
			override var count: Int {
				body.count
			}
			@usableFromInline
			override subscript(position: Int) -> U {
				.init(core: body[position])
			}
			@inlinable
			override subscript(bounds: some RangeExpression<Int>) -> S {
				.init(core: body[bounds])
			}
		}
		@usableFromInline
		final class Tensor<Body: Dense.Tensor<Element>>: Core, @unchecked Sendable {
			@usableFromInline let body: Body
			@usableFromInline let axis: Int
			@usableFromInline
			init(core: Body, axis main: Int) {
				body = core
				axis = main
			}
			@usableFromInline
			override var count: Int {
				body.shape.enumerated().first { $0.0 == axis }.map(\.1) ?? .zero
			}
			@usableFromInline
			override subscript(position: Int) -> U {
				.init(core: body[(0..<body.shape.count).map {
					$0 == axis ? position : 0
				}])
			}
			@usableFromInline
			override subscript(bounds: some RangeExpression<Int>) -> S {
				.init(body: Tensor<Body.S>(core: body[body.shape.enumerated().map {
					$0 == axis ? bounds.relative(to: 0..<$1) : (0..<$1)
				}], axis: axis))
			}
			@usableFromInline
			override func callAsFunction(for strategy: Layout.MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
				switch try body(for: strategy) {
				case (let layout, let kernel):
					let stride = layout.enumerated().compactMap {
						$0 == axis ? .some($1) : .none
					}
					return (stride.isEmpty ? [1] : stride, {
						await kernel().withUnsafeBufferPointer(Array.init)
					})
				}
			}
		}
	}
}
extension ANY.Vector: Vector {
	@usableFromInline
	init(core: some Dense.Vector<Element>) {
		body = Vec(core: core)
	}
	@usableFromInline
	init(core: some Dense.Tensor<Element>) {
		body = Tensor(core: core, axis: core.shape.enumerated().max { $0.1 < $1.1 }.map(\.0) ?? 0)
	}
	@inlinable
	var count: Int {
		body.count
	}
	@inlinable
	subscript(position: Int) -> U {
		body[position]
	}
	@inlinable
	subscript(bounds: some RangeExpression<Int>) -> V {
		body[bounds]
	}
	@inlinable
	func callAsFunction(for strategy: MemoryStrategy) throws -> (Array<Int>, @Sendable () async -> Array<Element>) {
		try body(for: strategy)
	}
}
public func vector<Element>(_ source: some Tensor<Element>) -> some Vector<Element> {
	ANY.Vector(core: source)
}
