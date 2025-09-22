//
//  Strategy.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
@_exported import enum Accelerate.AccelerateMatrixOrder
public typealias MemoryStrategy = AccelerateMatrixOrder
import protocol Synchronization.AtomicRepresentable
import typealias Synchronization.Atomic
extension MemoryStrategy: @retroactive AtomicRepresentable {
	@inlinable@inline(__always)@_transparent
	public var transpose: Self {
		switch self {
		case.rowMajor:
			.columnMajor
		case.columnMajor:
			.rowMajor
		}
	}
    @usableFromInline@inline(__always)
    static let Default: Atomic<Self> = .init(.rowMajor)
    @inlinable@inline(__always)@_transparent
    public static var `default`: Self {
        get {
            Default.load(ordering: .acquiring)
        }
        set {
            Default.store(newValue, ordering: .releasing)
        }
    }
}
extension MemoryStrategy {
	@inlinable@inline(__always)@_transparent
	public func stride(for shape: some BidirectionalCollection<Int>) -> Array<Int> {
        switch self {
        case.rowMajor:
            shape.reversed().dropLast().reduce(into: Array<Int>(arrayLiteral: 1)) {
                $0.append($0.last.unsafelyUnwrapped * $1)
            }.reversed()
        case.columnMajor:
            shape.dropLast().reduce(into: Array<Int>(arrayLiteral: 1)) {
                $0.append($0.last.unsafelyUnwrapped * $1)
            }
        }
	}
}
