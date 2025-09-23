//
//  Matrices.swift
//  MUSE
//
//  Created by Kota on 5/16/R7.
//
import typealias Foundation.KeyPathComparator
@inlinable@inline(__always)@_transparent
public func contraction(lhs: some BidirectionalCollection<Int>, rhs: some BidirectionalCollection<Int>, order: Int) -> Array<Int> {
	assert([lhs.count, rhs.count].allSatisfy { order <= $0 })
	return lhs.dropLast(order) + rhs.dropFirst(order)
}
@inlinable@inline(__always)@_transparent
public func matricise(size: some BidirectionalCollection<Int>) -> Optional<(Int, Int)> {
	switch (size.dropLast().first, size.dropFirst().last) {
	case(.some(let r), .some(let c)):
		.some((r, c))
	case(.some, .none), (.none, .some), (.none, .none):
		.none
	}
}
@inlinable@inline(__always)@_transparent
func matricise(source: some BidirectionalCollection<(Int, Int)>) -> (Int, Int, Array<Int>) {
	let (length, stride) = source.first ?? (1, 0)
	return source.enumerated().dropFirst().reduce((length, stride, Array<Int>(arrayLiteral: 0))) {
		switch $1.1.1 {
		case 0:
			($0.0, $0.1, $0.2)
		case $0.0 &* $0.1:
			($0.0 &* $1.1.0, $0.1, $0.2)
		default:
			($0.0, $0.1, product(Swift.stride(from: 0, to: $1.1.0 &* $1.1.1, by: $1.1.1), $0.2).map(&+))
		}
	}
}
// ([(shape, stride)], shuffled total shift, shuffled capacity)
@inlinable@inline(__always)@_transparent
func shuffle<K: RandomAccessCollection<Int>,
             S: RandomAccessCollection<Int>>(shape: K, stride: S) -> (Array<(Int, Int)>, Array<Int>, Int)
where
K.Index == Int,
S.Index == Int {
    let s = stride.sorted()
    let i = s.compactMap(stride.firstIndex(of:))
    let j = stride.compactMap(s.firstIndex(of:))
    let k = i.map { shape[$0] }
    let t = k.dropLast().reduce(into: Array(arrayLiteral: 1)) { $0.append($0.last.unsafelyUnwrapped &* $1) }
    let n = j.map { t[$0] }
    return (Array(zip(k, s)), n, zip(n, shape).reduce(1) { max($0, $1.0 &* $1.1) })
}
// ((n, k), ldb, ldc, ks, MemoryOffset)
@inlinable@inline(__always)@_transparent
public func contraction<RK: RandomAccessCollection<Int>, RS: RandomAccessCollection<Int>>(lhs m: Int, rhs: (RK, RS), strategy: MemoryStrategy) -> ((Int, Int), (Int, Int), (Int, Int), Array<Int>, Array<SIMD2<Int>>) where RK.Index == Int, RS.Index == Int {
	let r = shuffle(shape: rhs.0.dropFirst(), stride: rhs.1.dropFirst())
	let n = matricise(source: r.0)
	let k = rhs.0.first ?? 1
	let s = rhs.1.first ?? 1
	switch strategy {
	case.columnMajor:
		return ((n.0, k), (s, n.1), (1, m), [1] + r.1.map { $0 &* m }, n.2.enumerated().map {
			SIMD2<Int>($1, $0 * m * n.0)
		})
	case.rowMajor:
		return ((n.0, k), (s, n.1), (n.0 * n.2.count, 1), [r.2] + r.1, n.2.enumerated().map {
			SIMD2<Int>($1, $0 * n.0)
		})
	}
}
// ((m, k), ldb, ldc, ks, MemoryOffset)
@inlinable@inline(__always)@_transparent
public func contraction<LK: RandomAccessCollection<Int>, LS: RandomAccessCollection<Int>>(lhs: (LK, LS), rhs n: Int, strategy: MemoryStrategy) -> ((Int, Int), (Int, Int), (Int, Int), Array<Int>, Array<SIMD2<Int>>) where LK.Index == Int, LS.Index == Int {
	let l = shuffle(shape: lhs.0.dropLast(), stride: lhs.1.dropLast())
	let m = matricise(source: l.0)
	let k = lhs.0.last ?? 1
	let s = lhs.1.last ?? 1
	switch strategy {
	case.columnMajor:
		return ((m.0, k), (m.1, s), (1, m.0 * m.2.count), l.1 + [l.2], m.2.enumerated().map {
			SIMD2<Int>($1, $0 * m.0)
		})
	case.rowMajor:
		return ((m.0, k), (m.1, s), (n, 1), l.1.map { $0 &* n } + [1], m.2.enumerated().map {
			SIMD2<Int>($1, $0 * m.0 * n)
		})
	}
}
// ((m, n, k: (Length, AccumOffset), ldA, ldB, ldC, ResultStride, MemoryOffset)
@inlinable@inline(__always)@_transparent
public func contraction<
		LK: RandomAccessCollection<Int>,
		LS: RandomAccessCollection<Int>,
		RK: RandomAccessCollection<Int>,
		RS: RandomAccessCollection<Int>>(lhs: (LK, LS),
										 rhs: (RK, RS),
										 order: Int,
										 strategy: MemoryStrategy) -> ((Int, Int, (Int, Array<SIMD2<Int>>)), (Int, Int), (Int, Int), (Int, Int), Array<Int>, Array<SIMD3<Int>>)
where
	LK.Index == Int,
	LS.Index == Int,
	RK.Index == Int,
	RS.Index == Int {
	let l = shuffle(shape: lhs.0.dropLast(order), stride: lhs.1.dropLast(order))
	let r = shuffle(shape: rhs.0.dropFirst(order), stride: rhs.1.dropFirst(order))
	let m = matricise(source: l.0)
	let n = matricise(source: r.0)
	let k = flatten(shape: broadcast(lhs: lhs.0.suffix(order), rhs: rhs.0.prefix(order).reversed()),
					xs: lhs.1.suffix(order),
					ys: rhs.1.prefix(order).reversed())
	switch strategy {
	case.columnMajor:
		let s = l.1 + r.1.map { $0 &* l.2 }
		let ldr = m.0
		let ldc = m.0 &* n.0 &* m.2.count
		return ((m.0, n.0, (k.0, k.2)), (m.1, k.1.x), (k.1.y, n.1), (1, m.0 &* m.2.count), s, product(m.2.enumerated(), n.2.enumerated()).map {
			SIMD3<Int>($0.1, $1.1, $0.0 &* ldr &+ $1.0 &* ldc)
		})
	case.rowMajor:
		let s = l.1.map { $0 &* r.2 } + r.1
		let ldr = n.0 &* m.0 &* n.2.count
		let ldc = n.0
		return ((m.0, n.0, (k.0, k.2)), (m.1, k.1.x), (k.1.y, n.1), (n.0 &* n.2.count, 1), s, product(n.2.enumerated(), m.2.enumerated()).map {
			SIMD3<Int>($1.1, $0.1, $1.0 &* ldr &+ $0.0 &* ldc)
		})
	}
}
extension MemoryStrategy {
    // ((n, k), ldb, ldc, ks, MemoryOffset)
    @inlinable@inline(__always)@_transparent
    public func contraction<RK: RandomAccessCollection<Int>, RS: RandomAccessCollection<Int>>(m: Int, y: (RK, RS)) -> ((Int, Int), (Int, Int), (Int, Int), Array<Int>, Array<SIMD2<Int>>) where RK.Index == Int, RS.Index == Int {
        let r = shuffle(shape: y.0.dropFirst(), stride: y.1.dropFirst())
        let n = matricise(source: r.0)
        let k = y.0.first ?? 1
        let s = y.1.first ?? 0
        switch self {
        case.columnMajor:
            return ((n.0, k), (s, n.1), (1, m), [1] + r.1.map { $0 &* m }, n.2.enumerated().map {
                SIMD2<Int>($1, $0 * m * n.0)
            })
        case.rowMajor:
            return ((n.0, k), (s, n.1), (n.0 * n.2.count, 1), [r.2] + r.1, n.2.enumerated().map {
                SIMD2<Int>($1, $0 * n.0)
            })
        }
    }
    // ((m, k), ldb, ldc, ks, MemoryOffset)
    @inlinable@inline(__always)@_transparent
    public func contraction<LK: RandomAccessCollection<Int>, LS: RandomAccessCollection<Int>>(x: (LK, LS), n: Int) -> ((Int, Int), (Int, Int), (Int, Int), Array<Int>, Array<SIMD2<Int>>) where LK.Index == Int, LS.Index == Int {
        let l = shuffle(shape: x.0.dropLast(), stride: x.1.dropLast())
        let m = matricise(source: l.0)
        let k = x.0.last ?? 1
        let s = x.1.last ?? 0
        switch self {
        case.columnMajor:
            return ((m.0, k), (m.1, s), (1, m.0 * m.2.count), l.1 + [l.2], m.2.enumerated().map {
                SIMD2<Int>($1, $0 * m.0)
            })
        case.rowMajor:
            return ((m.0, k), (m.1, s), (n, 1), l.1.map { $0 &* n } + [1], m.2.enumerated().map {
                SIMD2<Int>($1, $0 * m.0 * n)
            })
        }
    }
    // ((m, n, k: (Length, AccumOffset), ldA, ldB, ldC, ResultStride, MemoryOffset)
    @inlinable@inline(__always)@_transparent
    public func contraction<
        XK: RandomAccessCollection<Int>,
        XS: RandomAccessCollection<Int>,
        YK: RandomAccessCollection<Int>,
        YS: RandomAccessCollection<Int>>(x: (XK, XS),
                                         y: (YK, YS),
                                         order: Int) -> ((Int, Int, (Int, Array<SIMD2<Int>>)), (Int, Int), (Int, Int), (Int, Int), Array<Int>, Array<SIMD3<Int>>)
    where
    XK.Index == Int,
    XS.Index == Int,
    YK.Index == Int,
    YS.Index == Int {
        let l = shuffle(shape: x.0.dropLast(order), stride: x.1.dropLast(order))
        let r = shuffle(shape: y.0.dropFirst(order), stride: y.1.dropFirst(order))
        let m = matricise(source: l.0)
        let n = matricise(source: r.0)
        let k = flatten(shape: broadcast(x: x.0.suffix(order), y: y.0.prefix(order).reversed()),
                        xs: x.1.suffix(order),
                        ys: y.1.prefix(order).reversed())
        switch self {
        case.columnMajor:
            let s = l.1 + r.1.map { $0 &* l.2 }
            let ldr = m.0
            let ldc = m.0 &* n.0 &* m.2.count
            return ((m.0, n.0, (k.0, k.2)), (m.1, k.1.x), (k.1.y, n.1), (1, m.0 &* m.2.count), s, product(m.2.enumerated(), n.2.enumerated()).map {
                SIMD3<Int>($0.1, $1.1, $0.0 &* ldr &+ $1.0 &* ldc)
            })
        case.rowMajor:
            let s = l.1.map { $0 &* r.2 } + r.1
            let ldr = n.0 &* m.0 &* n.2.count
            let ldc = n.0
            return ((m.0, n.0, (k.0, k.2)), (m.1, k.1.x), (k.1.y, n.1), (n.0 &* n.2.count, 1), s, product(n.2.enumerated(), m.2.enumerated()).map {
                SIMD3<Int>($1.1, $0.1, $1.0 &* ldr &+ $0.0 &* ldc)
            })
        }
    }
}
