//
//  Broadcast+.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
import Testing
@testable import Layout
@Suite
struct BroadcastTests {
	@Test func shape() {
		let x = [1,4,1]
		let y = [4,1]
        let z = Layout.broadcast(lhs: x, rhs: y)
		#expect(z == [1, 4, 1])
        #expect(MemoryStrategy.rowMajor.broadcast(x: x, y: y) == [1, 4, 1])
        #expect(MemoryStrategy.columnMajor.broadcast(x: x, y: y) == [4, 4, 1])
	}
	@Test func broadcast() {
		let target = [5, 5, 3]
		let source = [5, 1]
		let stride = [1, 1]
//        let result = Layout.broadcast(target: target, source: source, stride: stride)
        #expect(MemoryStrategy.rowMajor.broadcast(target: target, source: source, stride: stride) == [0, 1, 0])
        #expect(MemoryStrategy.columnMajor.broadcast(target: target, source: source, stride: stride) == [1, 0, 0])
	}
    @Test func stride() {
        #expect(MemoryStrategy.rowMajor.stride(for: [3, 5, 2]) == [10, 2, 1])
        #expect(MemoryStrategy.columnMajor.stride(for: [3, 5, 2]) == [1, 3, 15])
    }
	@Test func capacity() {
		let shape = [1, 3, 5]
		let stride = [60, 4, 12]
		print(Layout.capacity(alloc: shape, stride: stride))
		print(Layout.capacity(slice: shape, stride: stride))
	}
}
