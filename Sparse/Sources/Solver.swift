//
//  Solver.swift
//  MUSE
//
//  Created by Kota on 9/28/25.
//
@preconcurrency import Accelerate
import Dense
import Layout
import typealias Numerics.Complex64
import typealias Numerics.Complex128
public enum Op {
    case N
    case T
    case C
}
public enum Solver<Element: SolverElement> {}
public protocol SolverElement: BLASElement {
    associatedtype SparseOpaqueFactorization: Sendable
    associatedtype SparseOpaquePreconditioner: Sendable
    @inlinable static func Inner(nz: Int,
                                 xm: UnsafePointer<Self>, xi: UnsafePointer<Int64>,
                                 ym: UnsafePointer<Self>, ys: Int) -> Self
    @inlinable static func SPMV(m: Int, n: Int,
                                colStart: UnsafePointer<Int>,
                                rowIndex: UnsafePointer<Int32>,
                                valArray: UnsafePointer<Self>,
                                opA: Op,
                                x: UnsafePointer<Self>,
                                y: UnsafePointer<Self>)
    @inlinable static func Multiply(m: Int, n: Int, k: Int,
                                    colStart: UnsafePointer<Int>,
                                    rowIndex: UnsafePointer<Int32>,
                                    valArray: UnsafePointer<Self>,
                                    opA: Op,
                                    X: UnsafePointer<Self>, ldX: Int, opX: Op,
                                    Y: UnsafePointer<Self>, ldY: Int, opY: Op)
    @inlinable static func Factorization(type: SparseFactorization_t,
                                         m: Int, n: Int,
                                         colStart: UnsafePointer<Int>,
                                         rowIndex: UnsafePointer<Int32>,
                                         valArray: UnsafePointer<Self>, opA: Op) -> SparseOpaqueFactorization
    @inlinable static func SymbolicFactorization(factorization: SparseOpaqueFactorization) -> SparseOpaqueSymbolicFactorization
    @inlinable static func Solve(factorization: SparseOpaqueFactorization,
                                 m: Int, n: Int, nrhs: Int,
                                 Y: UnsafePointer<Self>, ldY: Int, opY: Op,
                                 X: UnsafeMutablePointer<Self>, ldX: Int, opX: Op)
    @inlinable static func Cleanup(factorization: SparseOpaqueFactorization)
    @inlinable static func Preconditioner(type: SparsePreconditioner_t,
                                          m: Int, n: Int, op: Op,
                                          colStart: UnsafePointer<Int>,
                                          rowIndex: UnsafePointer<Int32>,
                                          valArray: UnsafePointer<Self>) -> SparseOpaquePreconditioner
    @discardableResult
    @inlinable static func Solve(method: SparseIterativeMethod,
                                 preconditioner: SparseOpaquePreconditioner,
                                 m: Int, n: Int, nrhs k: Int,
                                 colStart: UnsafePointer<Int>,
                                 rowIndex: UnsafePointer<Int32>,
                                 valArray: UnsafePointer<Self>, opA: Op,
                                 Y: UnsafePointer<Self>, ldY: Int, opY: Op,
                                 X: UnsafeMutablePointer<Self>, ldX: Int, opX: Op) -> SparseIterativeStatus_t
    @inlinable static func Cleanup(preconditioner: SparseOpaquePreconditioner)
    @inlinable static func Convert<E, R>(m: Int, n: Int,
                                         nonZeros: Int,
                                         rowIndex: UnsafePointer<Int32>,
                                         colIndex: UnsafePointer<Int32>,
                                         valArray: UnsafePointer<Self>,
                                         _ body: (UnsafePointer<Int>, UnsafePointer<Int32>, UnsafePointer<Self>) throws (E) -> R) rethrows -> R
}
extension SparseAttributes_t {
    @inlinable@_transparent
    var t: Self {
        .init(transpose: !transpose,
              triangle: triangle, kind: kind,
              _reserved: _reserved, _allocatedBySparse: _allocatedBySparse)
    }
}
extension SparseAttributesComplex_t {
    @inlinable@_transparent
    var t: Self {
        .init(transpose: !transpose,
              triangle: triangle, kind: kind,
              conjugate_transpose: conjugate_transpose,
              _reserved: _reserved, _allocatedBySparse: _allocatedBySparse)
    }
    @inlinable@_transparent
    var c: Self {
        .init(transpose: !transpose,
              triangle: triangle, kind: kind,
              conjugate_transpose: !conjugate_transpose,
              _reserved: _reserved, _allocatedBySparse: _allocatedBySparse)
    }
}
// MARK: Float32
extension Float32: SolverElement {
    public typealias SparseOpaqueFactorization = SparseOpaqueFactorization_Float
    public typealias SparseOpaquePreconditioner = SparseOpaquePreconditioner_Float
    @inlinable@_transparent
    public static func Inner(nz: Int,
                             xm: UnsafePointer<Self>, xi: UnsafePointer<Int64>,
                             ym: UnsafePointer<Self>, ys: Int) -> Self {
        sparse_inner_product_dense_float(.init(nz), xm, xi, ym, .init(ys))
    }
    @inlinable@_transparent
    public static func Outer(m: Int, n: Int, nz: Int,
                             α: Self,
                             xm: UnsafePointer<Self>, xi: UnsafePointer<Int64>,
                             ym: UnsafePointer<Self>, ys: Int) {
        var lil = sparse_matrix_create_float(.init(m), .init(n))
        defer {
            sparse_matrix_destroy(.init(lil))
        }
        sparse_outer_product_dense_float(.init(m), .init(n), .init(nz), α,
                                         ym, .init(ys),
                                         xm, xi,
                                         &lil)
        
    }
    @inlinable@_transparent
    public static func SPMV(m: Int, n: Int,
                            colStart: UnsafePointer<Int>,
                            rowIndex: UnsafePointer<Int32>,
                            valArray: UnsafePointer<Self>,
                            opA: Op,
                            x: UnsafePointer<Self>,
                            y: UnsafePointer<Self>) {
        let structure = switch opA {
        case.T,.C:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(n),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructure
        return SparseMultiply(.init(structure: structure, data: .init(mutating: valArray)),
                              .init(count: .init(n), data: .init(mutating: x)),
                              .init(count: .init(m), data: .init(mutating: y)))
    }
    @inlinable@_transparent
    public static func Multiply(m: Int, n: Int, k: Int,
                                colStart: UnsafePointer<Int>,
                                rowIndex: UnsafePointer<Int32>,
                                valArray: UnsafePointer<Self>,
                                opA: Op,
                                X: UnsafePointer<Self>, ldX: Int, opX: Op,
                                Y: UnsafePointer<Self>, ldY: Int, opY: Op) {
        let structure = switch opA {
        case.T,.C:
                .init(rowCount: .init(k), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(k),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructure
        let x = switch opX {
        case.T,.C:
                .init(rowCount: .init(n), columnCount: .init(k), columnStride: .init(ldX),
                      attributes: .init().t,
                      data: .init(mutating: X))
        default:
                .init(rowCount: .init(k), columnCount: .init(n), columnStride: .init(ldX),
                      attributes: .init(),
                      data: .init(mutating: X))
        } as DenseMatrix_Float
        let y = switch opY {
        case.T,.C:
                .init(rowCount: .init(n), columnCount: .init(m), columnStride: .init(ldY),
                      attributes: .init().t,
                      data: .init(mutating: Y))
        default:
                .init(rowCount: .init(m), columnCount: .init(n), columnStride: .init(ldY),
                      attributes: .init(),
                      data: .init(mutating: Y))
        } as DenseMatrix_Float
        return SparseMultiply(.init(structure: structure, data: .init(mutating: valArray)), x, y)
    }
    // Direct
    @inlinable@_transparent
    public static func Factorization(type: SparseFactorization_t,
                                     m: Int, n: Int,
                                     colStart: UnsafePointer<Int>,
                                     rowIndex: UnsafePointer<Int32>,
                                     valArray: UnsafePointer<Self>, opA: Op) -> SparseOpaqueFactorization {
        let structure = switch opA {
        case.T,.C:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(n),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructure
        return SparseFactor(type, .init(structure: structure, data: .init(mutating: valArray)))
    }
    
    @inlinable@_transparent
    public static func SymbolicFactorization(factorization: SparseOpaqueFactorization) -> SparseOpaqueSymbolicFactorization {
        factorization.symbolicFactorization
    }
    @inlinable@_transparent
    public static func Solve(factorization: SparseOpaqueFactorization,
                             m: Int, n: Int, nrhs: Int,
                             Y: UnsafePointer<Self>, ldY: Int, opY: Op,
                             X: UnsafeMutablePointer<Self>, ldX: Int, opX: Op) {
        let m = Int32(m)
        let n = Int32(n)
        let k = Int32(nrhs)
        let y = switch opY {
        case.T,.C:
                .init(rowCount: .init(k), columnCount: .init(m), columnStride: .init(ldY),
                      attributes: .init().t,
                      data: .init(mutating: Y))
        default:
                .init(rowCount: .init(m), columnCount: .init(k), columnStride: .init(ldY),
                      attributes: .init(),
                      data: .init(mutating: Y))
        } as DenseMatrix_Float
        let x = switch opX {
        case.T,.C:
                .init(rowCount: .init(k), columnCount: .init(n), columnStride: .init(ldX),
                      attributes: .init().t,
                      data: .init(mutating: X))
        default:
                .init(rowCount: .init(n), columnCount: .init(k), columnStride: .init(ldX),
                      attributes: .init(),
                      data: .init(mutating: X))
        } as DenseMatrix_Float
        SparseSolve(factorization, y, x)
    }
    @inlinable@_transparent
    public static func Cleanup(factorization: SparseOpaqueFactorization) {
        SparseCleanup(factorization)
    }
    // Iterative
    @inlinable@_transparent
    public static func Preconditioner(type: SparsePreconditioner_t,
                                      m: Int, n: Int, op: Op,
                                      colStart: UnsafePointer<Int>,
                                      rowIndex: UnsafePointer<Int32>,
                                      valArray: UnsafePointer<Self>) -> SparseOpaquePreconditioner {
        let structure = switch op {
        case.T,.C:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(n),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructure
        return SparseCreatePreconditioner(type, .init(structure: structure, data: .init(mutating: valArray)))
    }
    @discardableResult
    @inlinable@_transparent
    public static func Solve(method: SparseIterativeMethod,
                             preconditioner: SparseOpaquePreconditioner,
                             m: Int, n: Int, nrhs k: Int,
                             colStart: UnsafePointer<Int>,
                             rowIndex: UnsafePointer<Int32>,
                             valArray: UnsafePointer<Self>, opA: Op,
                             Y: UnsafePointer<Self>, ldY: Int, opY: Op,
                             X: UnsafeMutablePointer<Self>, ldX: Int, opX: Op) -> SparseIterativeStatus_t{
        let structure = switch opA {
        case.T,.C:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(n),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructure
        let y = switch opY {
        case.T,.C:
                .init(rowCount: .init(k), columnCount: .init(m), columnStride: .init(ldY),
                      attributes: .init().t,
                      data: .init(mutating: Y))
        default:
                .init(rowCount: .init(m), columnCount: .init(k), columnStride: .init(ldY),
                      attributes: .init(),
                      data: .init(mutating: Y))
        } as DenseMatrix_Float
        let x = switch opX {
        case.T,.C:
                .init(rowCount: .init(k), columnCount: .init(n), columnStride: .init(ldX),
                      attributes: .init().t,
                      data: .init(mutating: X))
        default:
                .init(rowCount: .init(n), columnCount: .init(k), columnStride: .init(ldX),
                      attributes: .init(),
                      data: .init(mutating: X))
        } as DenseMatrix_Float
        return SparseSolve(method, .init(structure: structure, data: .init(mutating: valArray)), y, x, preconditioner)
    }
    @inlinable@_transparent
    public static func Cleanup(preconditioner: SparseOpaquePreconditioner) {
        SparseCleanup(preconditioner)
    }
    // COO
    @inlinable@_transparent
    public static func Convert<E, R>(m: Int, n: Int,
                                     nonZeros: Int,
                                     rowIndex: UnsafePointer<Int32>,
                                     colIndex: UnsafePointer<Int32>,
                                     valArray: UnsafePointer<Self>,
                                     _ body: (UnsafePointer<Int>, UnsafePointer<Int32>, UnsafePointer<Self>) throws (E) -> R) rethrows -> R {
        let m = SparseConvertFromCoordinate(.init(m), .init(n),
                                            nonZeros, 1,
                                            .init(),
                                            rowIndex, colIndex, valArray)
        defer {
            SparseCleanup(m)
        }
        return try body(m.structure.columnStarts,
                        m.structure.rowIndices,
                        m.data)
    }
}
// MARK: Float64
extension Float64: SolverElement {
    public typealias SparseOpaqueFactorization = SparseOpaqueFactorization_Double
    public typealias SparseOpaquePreconditioner = SparseOpaquePreconditioner_Double
    @inlinable@_transparent
    public static func Inner(nz: Int,
                             xm: UnsafePointer<Self>, xi: UnsafePointer<Int64>,
                             ym: UnsafePointer<Self>, ys: Int) -> Self {
        sparse_inner_product_dense_double(.init(nz), xm, xi, ym, .init(ys))
    }
    @inlinable@_transparent
    public static func Outer(m: Int, n: Int, nz: Int,
                             α: Self,
                             xm: UnsafePointer<Self>, xi: UnsafePointer<Int64>,
                             ym: UnsafePointer<Self>, ys: Int) {
        var lil = sparse_matrix_create_double(.init(m), .init(n))
        defer {
            sparse_matrix_destroy(.init(lil))
        }
        sparse_outer_product_dense_double(.init(m), .init(n), .init(nz), α,
                                          ym, .init(ys),
                                          xm, xi,
                                          &lil)
        
    }
    @inlinable@_transparent
    public static func SPMV(m: Int, n: Int,
                            colStart: UnsafePointer<Int>,
                            rowIndex: UnsafePointer<Int32>,
                            valArray: UnsafePointer<Self>,
                            opA: Op,
                            x: UnsafePointer<Self>,
                            y: UnsafePointer<Self>) {
        let structure = switch opA {
        case.T,.C:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(n),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructure
        return SparseMultiply(.init(structure: structure, data: .init(mutating: valArray)),
                              .init(count: .init(n), data: .init(mutating: x)),
                              .init(count: .init(m), data: .init(mutating: y)))
    }
    @inlinable@_transparent
    public static func Multiply(m: Int, n: Int, k: Int,
                                colStart: UnsafePointer<Int>,
                                rowIndex: UnsafePointer<Int32>,
                                valArray: UnsafePointer<Self>,
                                opA: Op,
                                X: UnsafePointer<Self>, ldX: Int, opX: Op,
                                Y: UnsafePointer<Self>, ldY: Int, opY: Op) {
        let structure = switch opA {
        case.T,.C:
                .init(rowCount: .init(k), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(k),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructure
        let x = switch opX {
        case.T,.C:
                .init(rowCount: .init(n), columnCount: .init(k), columnStride: .init(ldX),
                      attributes: .init().t,
                      data: .init(mutating: X))
        default:
                .init(rowCount: .init(k), columnCount: .init(n), columnStride: .init(ldX),
                      attributes: .init(),
                      data: .init(mutating: X))
        } as DenseMatrix_Double
        let y = switch opY {
        case.T,.C:
                .init(rowCount: .init(n), columnCount: .init(m), columnStride: .init(ldY),
                      attributes: .init().t,
                      data: .init(mutating: Y))
        default:
                .init(rowCount: .init(m), columnCount: .init(n), columnStride: .init(ldY),
                      attributes: .init(),
                      data: .init(mutating: Y))
        } as DenseMatrix_Double
        return SparseMultiply(.init(structure: structure, data: .init(mutating: valArray)), x, y)
    }
    // Direct
    @inlinable@_transparent
    public static func Factorization(type: SparseFactorization_t,
                                     m: Int, n: Int,
                                     colStart: UnsafePointer<Int>,
                                     rowIndex: UnsafePointer<Int32>,
                                     valArray: UnsafePointer<Self>, opA: Op) -> SparseOpaqueFactorization {
        let structure = switch opA {
        case.T,.C:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(n),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructure
        return SparseFactor(type, .init(structure: structure, data: .init(mutating: valArray)))
    }
    @inlinable@_transparent
    public static func SymbolicFactorization(factorization: SparseOpaqueFactorization) -> SparseOpaqueSymbolicFactorization {
        factorization.symbolicFactorization
    }
    @inlinable@_transparent
    public static func Solve(factorization: SparseOpaqueFactorization,
                             m: Int, n: Int, nrhs: Int,
                             Y: UnsafePointer<Self>, ldY: Int, opY: Op,
                             X: UnsafeMutablePointer<Self>, ldX: Int, opX: Op) {
        let m = Int32(m)
        let n = Int32(n)
        let k = Int32(nrhs)
        let y = switch opY {
        case.T,.C:
                .init(rowCount: .init(k), columnCount: .init(m), columnStride: .init(ldY),
                      attributes: .init().t,
                      data: .init(mutating: Y))
        default:
                .init(rowCount: .init(m), columnCount: .init(k), columnStride: .init(ldY),
                      attributes: .init(),
                      data: .init(mutating: Y))
        } as DenseMatrix_Double
        let x = switch opX {
        case.T,.C:
                .init(rowCount: .init(k), columnCount: .init(n), columnStride: .init(ldX),
                      attributes: .init().t,
                      data: .init(mutating: X))
        default:
                .init(rowCount: .init(n), columnCount: .init(k), columnStride: .init(ldX),
                      attributes: .init(),
                      data: .init(mutating: X))
        } as DenseMatrix_Double
        SparseSolve(factorization, y, x)
    }
    @inlinable@_transparent
    public static func Cleanup(factorization: SparseOpaqueFactorization) {
        SparseCleanup(factorization)
    }
    // Iterative
    @inlinable@_transparent
    public static func Preconditioner(type: SparsePreconditioner_t,
                                      m: Int, n: Int, op: Op,
                                      colStart: UnsafePointer<Int>,
                                      rowIndex: UnsafePointer<Int32>,
                                      valArray: UnsafePointer<Self>) -> SparseOpaquePreconditioner {
        let structure = switch op {
        case.T,.C:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(n),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructure
        return SparseCreatePreconditioner(type, .init(structure: structure, data: .init(mutating: valArray)))
    }
    @discardableResult
    @inlinable@_transparent
    public static func Solve(method: SparseIterativeMethod,
                             preconditioner: SparseOpaquePreconditioner,
                             m: Int, n: Int, nrhs k: Int,
                             colStart: UnsafePointer<Int>,
                             rowIndex: UnsafePointer<Int32>,
                             valArray: UnsafePointer<Self>, opA: Op,
                             Y: UnsafePointer<Self>, ldY: Int, opY: Op,
                             X: UnsafeMutablePointer<Self>, ldX: Int, opX: Op) -> SparseIterativeStatus_t {
        let structure = switch opA {
        case.T,.C:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(n),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructure
        let y = switch opY {
        case.T,.C:
                .init(rowCount: .init(k), columnCount: .init(m), columnStride: .init(ldY),
                      attributes: .init().t,
                      data: .init(mutating: Y))
        default:
                .init(rowCount: .init(m), columnCount: .init(k), columnStride: .init(ldY),
                      attributes: .init(),
                      data: .init(mutating: Y))
        } as DenseMatrix_Double
        let x = switch opX {
        case.T,.C:
                .init(rowCount: .init(k), columnCount: .init(n), columnStride: .init(ldX),
                      attributes: .init().t,
                      data: .init(mutating: X))
        default:
                .init(rowCount: .init(n), columnCount: .init(k), columnStride: .init(ldX),
                      attributes: .init(),
                      data: .init(mutating: X))
        } as DenseMatrix_Double
        return SparseSolve(method, .init(structure: structure, data: .init(mutating: valArray)), y, x, preconditioner)
    }
    @inlinable@_transparent
    public static func Cleanup(preconditioner: SparseOpaquePreconditioner) {
        SparseCleanup(preconditioner)
    }
    // COO
    @inlinable@_transparent
    public static func Convert<E, R>(m: Int, n: Int,
                                     nonZeros: Int,
                                     rowIndex: UnsafePointer<Int32>,
                                     colIndex: UnsafePointer<Int32>,
                                     valArray: UnsafePointer<Self>,
                                     _ body: (UnsafePointer<Int>, UnsafePointer<Int32>, UnsafePointer<Self>) throws (E) -> R) rethrows -> R {
        let m = SparseConvertFromCoordinate(.init(m), .init(n),
                                            nonZeros, 1,
                                            .init(),
                                            rowIndex, colIndex, valArray)
        defer {
            SparseCleanup(m)
        }
        return try body(m.structure.columnStarts,
                        m.structure.rowIndices,
                        m.data)
    }
}
// MARK: Complex64
extension Complex64: SolverElement {
    public typealias SparseOpaqueFactorization = SparseOpaqueFactorization_Complex_Float
    public typealias SparseOpaquePreconditioner = SparseOpaquePreconditioner_Complex_Float
    @inlinable@_transparent
    public static func Inner(nz: Int,
                             xm: UnsafePointer<Self>, xi: UnsafePointer<Int64>,
                             ym: UnsafePointer<Self>, ys: Int) -> Self {
        (0..<nz).reduce(.zero) {
            $0 + xm[$1] * ym[ys * .init(xi[$1])]
        }
    }
    @inlinable@_transparent
    public static func SPMV(m: Int, n: Int,
                            colStart: UnsafePointer<Int>,
                            rowIndex: UnsafePointer<Int32>,
                            valArray: UnsafePointer<Self>,
                            opA: Op,
                            x: UnsafePointer<Self>,
                            y: UnsafePointer<Self>) {
        let structure = switch opA {
        case.T:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        case.C:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().c,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(n),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructureComplex
        return SparseMultiply(SparseMatrix_Complex_Float(structure: structure, data: .init(valArray)),
                              .init(count: .init(n), data: .init(x)),
                              .init(count: .init(m), data: .init(y)))
    }
    @inlinable@_transparent
    public static func Multiply(m: Int, n: Int, k: Int,
                                colStart: UnsafePointer<Int>,
                                rowIndex: UnsafePointer<Int32>,
                                valArray: UnsafePointer<Self>,
                                opA: Op,
                                X: UnsafePointer<Self>, ldX: Int, opX: Op,
                                Y: UnsafePointer<Self>, ldY: Int, opY: Op) {
        let structure = switch opA {
        case.T:
                .init(rowCount: .init(k), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        case.C:
                .init(rowCount: .init(k), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().c,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(k),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructureComplex
        let x = switch opX {
        case.T:
                .init(rowCount: .init(n), columnCount: .init(k), columnStride: .init(ldX),
                      attributes: .init().t,
                      data: .init(X))
        case.C:
                .init(rowCount: .init(n), columnCount: .init(k), columnStride: .init(ldX),
                      attributes: .init().c,
                      data: .init(X))
        default:
                .init(rowCount: .init(k), columnCount: .init(n), columnStride: .init(ldX),
                      attributes: .init(),
                      data: .init(X))
        } as DenseMatrix_Complex_Float
        let y = switch opY {
        case.T:
                .init(rowCount: .init(n), columnCount: .init(m), columnStride: .init(ldY),
                      attributes: .init().t,
                      data: .init(Y))
        case.C:
                .init(rowCount: .init(n), columnCount: .init(m), columnStride: .init(ldY),
                      attributes: .init().c,
                      data: .init(Y))
        default:
                .init(rowCount: .init(m), columnCount: .init(n), columnStride: .init(ldY),
                      attributes: .init(),
                      data: .init(Y))
        } as DenseMatrix_Complex_Float
        return SparseMultiply(.init(structure: structure, data: .init(valArray)), x, y)
    }
    // Direct
    @inlinable@_transparent
    public static func Factorization(type: SparseFactorization_t,
                                     m: Int, n: Int,
                                     colStart: UnsafePointer<Int>,
                                     rowIndex: UnsafePointer<Int32>,
                                     valArray: UnsafePointer<Self>, opA: Op) -> SparseOpaqueFactorization {
        let structure = switch opA {
        case.T,.C:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(n),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructureComplex
        return SparseFactor(type, .init(structure: structure, data: .init(valArray)))
    }
    @inlinable@_transparent
    public static func SymbolicFactorization(factorization: SparseOpaqueFactorization) -> SparseOpaqueSymbolicFactorization {
        factorization.symbolicFactorization
    }
    @inlinable@_transparent
    public static func Solve(factorization: SparseOpaqueFactorization,
                             m: Int, n: Int, nrhs: Int,
                             Y: UnsafePointer<Self>, ldY: Int, opY: Op,
                             X: UnsafeMutablePointer<Self>, ldX: Int, opX: Op) {
        let m = Int32(m)
        let n = Int32(n)
        let k = Int32(nrhs)
        let y = switch opY {
        case.T:
                .init(rowCount: .init(k), columnCount: .init(m), columnStride: .init(ldY),
                      attributes: .init().t,
                      data: .init(Y))
        case.C:
                .init(rowCount: .init(k), columnCount: .init(m), columnStride: .init(ldY),
                      attributes: .init().c,
                      data: .init(Y))
        default:
                .init(rowCount: .init(m), columnCount: .init(k), columnStride: .init(ldY),
                      attributes: .init(),
                      data: .init(Y))
        } as DenseMatrix_Complex_Float
        let x = switch opX {
        case.T:
                .init(rowCount: .init(k), columnCount: .init(n), columnStride: .init(ldX),
                      attributes: .init().t,
                      data: .init(X))
        case.C:
                .init(rowCount: .init(k), columnCount: .init(n), columnStride: .init(ldX),
                      attributes: .init().c,
                      data: .init(X))
        default:
                .init(rowCount: .init(n), columnCount: .init(k), columnStride: .init(ldX),
                      attributes: .init(),
                      data: .init(X))
        } as DenseMatrix_Complex_Float
        SparseSolve(factorization, y, x)
    }
    @inlinable@_transparent
    public static func Cleanup(factorization: SparseOpaqueFactorization) {
        SparseCleanup(factorization)
    }
    // Iterative
    @inlinable@_transparent
    public static func Preconditioner(type: SparsePreconditioner_t,
                                      m: Int, n: Int, op: Op,
                                      colStart: UnsafePointer<Int>,
                                      rowIndex: UnsafePointer<Int32>,
                                      valArray: UnsafePointer<Self>) -> SparseOpaquePreconditioner {
        let structure = switch op {
        case.T:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        case.C:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().c,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(n),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructureComplex
        return SparseCreatePreconditioner(type, .init(structure: structure, data: .init(valArray)))
    }
    @discardableResult
    @inlinable@_transparent
    public static func Solve(method: SparseIterativeMethod,
                             preconditioner: SparseOpaquePreconditioner,
                             m: Int, n: Int, nrhs k: Int,
                             colStart: UnsafePointer<Int>,
                             rowIndex: UnsafePointer<Int32>,
                             valArray: UnsafePointer<Self>, opA: Op,
                             Y: UnsafePointer<Self>, ldY: Int, opY: Op,
                             X: UnsafeMutablePointer<Self>, ldX: Int, opX: Op) -> SparseIterativeStatus_t {
        let structure = switch opA {
        case.T:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        case.C:
            
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(n),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructureComplex
        let y = switch opY {
        case.T:
                .init(rowCount: .init(k), columnCount: .init(m), columnStride: .init(ldY),
                      attributes: .init().t,
                      data: .init(Y))
        case.C:
                .init(rowCount: .init(k), columnCount: .init(m), columnStride: .init(ldY),
                      attributes: .init().c,
                      data: .init(Y))
        default:
                .init(rowCount: .init(m), columnCount: .init(k), columnStride: .init(ldY),
                      attributes: .init(),
                      data: .init(Y))
        } as DenseMatrix_Complex_Float
        let x = switch opX {
        case.T:
                .init(rowCount: .init(k), columnCount: .init(n), columnStride: .init(ldX),
                      attributes: .init().t,
                      data: .init(X))
        case.C:
                .init(rowCount: .init(k), columnCount: .init(n), columnStride: .init(ldX),
                      attributes: .init().c,
                      data: .init(X))
        default:
                .init(rowCount: .init(n), columnCount: .init(k), columnStride: .init(ldX),
                      attributes: .init(),
                      data: .init(X))
        } as DenseMatrix_Complex_Float
        return SparseSolve(method, .init(structure: structure, data: .init(valArray)), y, x, preconditioner)
    }
    @inlinable@_transparent
    public static func Cleanup(preconditioner: SparseOpaquePreconditioner) {
        SparseCleanup(preconditioner)
    }
    // COO
    @inlinable@_transparent
    public static func Convert<E, R>(m: Int, n: Int,
                                     nonZeros: Int,
                                     rowIndex: UnsafePointer<Int32>,
                                     colIndex: UnsafePointer<Int32>,
                                     valArray: UnsafePointer<Self>,
                                     _ body: (UnsafePointer<Int>, UnsafePointer<Int32>, UnsafePointer<Self>) throws (E) -> R) rethrows -> R {
        let m = SparseConvertFromCoordinate(.init(m), .init(n),
                                            nonZeros, 1,
                                            .init(),
                                            rowIndex, colIndex, .init(valArray)) as SparseMatrix_Complex_Float
        defer {
            SparseCleanup(m)
        }
        return try body(m.structure.columnStarts,
                        m.structure.rowIndices,
                        .init(m.data))
    }
}
// MARK: Complex128
extension Complex128: SolverElement {
    public typealias SparseOpaqueFactorization = SparseOpaqueFactorization_Complex_Double
    public typealias SparseOpaquePreconditioner = SparseOpaquePreconditioner_Complex_Double
    @inlinable@_transparent
    public static func Inner(nz: Int,
                             xm: UnsafePointer<Self>, xi: UnsafePointer<Int64>,
                             ym: UnsafePointer<Self>, ys: Int) -> Self {
        (0..<nz).reduce(.zero) {
            $0 + xm[$1] * ym[ys * .init(xi[$1])]
        }
    }
    @inlinable@_transparent
    public static func SPMV(m: Int, n: Int,
                            colStart: UnsafePointer<Int>,
                            rowIndex: UnsafePointer<Int32>,
                            valArray: UnsafePointer<Self>,
                            opA: Op,
                            x: UnsafePointer<Self>,
                            y: UnsafePointer<Self>) {
        let structure = switch opA {
        case.T:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        case.C:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().c,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(n),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructureComplex
        return SparseMultiply(SparseMatrix_Complex_Float(structure: structure, data: .init(valArray)),
                              .init(count: .init(n), data: .init(x)),
                              .init(count: .init(m), data: .init(y)))
    }
    @inlinable@_transparent
    public static func Multiply(m: Int, n: Int, k: Int,
                                colStart: UnsafePointer<Int>,
                                rowIndex: UnsafePointer<Int32>,
                                valArray: UnsafePointer<Self>,
                                opA: Op,
                                X: UnsafePointer<Self>, ldX: Int, opX: Op,
                                Y: UnsafePointer<Self>, ldY: Int, opY: Op) {
        let structure = switch opA {
        case.T:
                .init(rowCount: .init(k), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        case.C:
                .init(rowCount: .init(k), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().c,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(k),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructureComplex
        let x = switch opX {
        case.T:
                .init(rowCount: .init(n), columnCount: .init(k), columnStride: .init(ldX),
                      attributes: .init().t,
                      data: .init(X))
        case.C:
                .init(rowCount: .init(n), columnCount: .init(k), columnStride: .init(ldX),
                      attributes: .init().c,
                      data: .init(X))
        default:
                .init(rowCount: .init(k), columnCount: .init(n), columnStride: .init(ldX),
                      attributes: .init(),
                      data: .init(X))
        } as DenseMatrix_Complex_Double
        let y = switch opY {
        case.T:
                .init(rowCount: .init(n), columnCount: .init(m), columnStride: .init(ldY),
                      attributes: .init().t,
                      data: .init(Y))
        case.C:
                .init(rowCount: .init(n), columnCount: .init(m), columnStride: .init(ldY),
                      attributes: .init().c,
                      data: .init(Y))
        default:
                .init(rowCount: .init(m), columnCount: .init(n), columnStride: .init(ldY),
                      attributes: .init(),
                      data: .init(Y))
        } as DenseMatrix_Complex_Double
        return SparseMultiply(.init(structure: structure, data: .init(valArray)), x, y)
    }
    // Direct
    @inlinable@_transparent
    public static func Factorization(type: SparseFactorization_t,
                                     m: Int, n: Int,
                                     colStart: UnsafePointer<Int>,
                                     rowIndex: UnsafePointer<Int32>,
                                     valArray: UnsafePointer<Self>, opA: Op) -> SparseOpaqueFactorization {
        let structure = switch opA {
        case.T:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        case.C:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().c,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(n),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructureComplex
        return SparseFactor(type, .init(structure: structure, data: .init(valArray)))
    }
    @inlinable@_transparent
    public static func SymbolicFactorization(factorization: SparseOpaqueFactorization) -> SparseOpaqueSymbolicFactorization {
        factorization.symbolicFactorization
    }
    @inlinable@_transparent
    public static func Solve(factorization: SparseOpaqueFactorization,
                             m: Int, n: Int, nrhs: Int,
                             Y: UnsafePointer<Self>, ldY: Int, opY: Op,
                             X: UnsafeMutablePointer<Self>, ldX: Int, opX: Op) {
        let m = Int32(m)
        let n = Int32(n)
        let k = Int32(nrhs)
        let y = switch opY {
        case.T:
                .init(rowCount: .init(k), columnCount: .init(m), columnStride: .init(ldY),
                      attributes: .init().t,
                      data: .init(Y))
        case.C:
                .init(rowCount: .init(k), columnCount: .init(m), columnStride: .init(ldY),
                      attributes: .init().c,
                      data: .init(Y))
        default:
                .init(rowCount: .init(m), columnCount: .init(k), columnStride: .init(ldY),
                      attributes: .init(),
                      data: .init(Y))
        } as DenseMatrix_Complex_Double
        let x = switch opX {
        case.T,.C:
                .init(rowCount: .init(k), columnCount: .init(n), columnStride: .init(ldX),
                      attributes: .init().t,
                      data: .init(X))
        default:
                .init(rowCount: .init(n), columnCount: .init(k), columnStride: .init(ldX),
                      attributes: .init(),
                      data: .init(X))
        } as DenseMatrix_Complex_Double
        SparseSolve(factorization, y, x)
    }
    @inlinable@_transparent
    public static func Cleanup(factorization: SparseOpaqueFactorization) {
        SparseCleanup(factorization)
    }
    // Iterative
    @inlinable@_transparent
    public static func Preconditioner(type: SparsePreconditioner_t,
                                      m: Int, n: Int, op: Op,
                                      colStart: UnsafePointer<Int>,
                                      rowIndex: UnsafePointer<Int32>,
                                      valArray: UnsafePointer<Self>) -> SparseOpaquePreconditioner {
        let structure = switch op {
        case.T,.C:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(n),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructureComplex
        return SparseCreatePreconditioner(type, .init(structure: structure, data: .init(valArray)))
    }
    @discardableResult
    @inlinable@_transparent
    public static func Solve(method: SparseIterativeMethod,
                             preconditioner: SparseOpaquePreconditioner,
                             m: Int, n: Int, nrhs k: Int,
                             colStart: UnsafePointer<Int>,
                             rowIndex: UnsafePointer<Int32>,
                             valArray: UnsafePointer<Self>, opA: Op,
                             Y: UnsafePointer<Self>, ldY: Int, opY: Op,
                             X: UnsafeMutablePointer<Self>, ldX: Int, opX: Op) -> SparseIterativeStatus_t{
        let structure = switch opA {
        case.T,.C:
                .init(rowCount: .init(n), columnCount: .init(m),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init().t,
                      blockSize: 1)
        default:
                .init(rowCount: .init(m), columnCount: .init(n),
                      columnStarts: .init(mutating: colStart), rowIndices: .init(mutating: rowIndex),
                      attributes: .init(),
                      blockSize: 1)
        } as SparseMatrixStructureComplex
        let y = switch opY {
        case.T,.C:
                .init(rowCount: .init(k), columnCount: .init(m), columnStride: .init(ldY),
                      attributes: .init().t,
                      data: .init(Y))
        default:
                .init(rowCount: .init(m), columnCount: .init(k), columnStride: .init(ldY),
                      attributes: .init(),
                      data: .init(Y))
        } as DenseMatrix_Complex_Double
        let x = switch opX {
        case.T,.C:
                .init(rowCount: .init(k), columnCount: .init(n), columnStride: .init(ldX),
                      attributes: .init().t,
                      data: .init(X))
        default:
                .init(rowCount: .init(n), columnCount: .init(k), columnStride: .init(ldX),
                      attributes: .init(),
                      data: .init(X))
        } as DenseMatrix_Complex_Double
        return SparseSolve(method, .init(structure: structure, data: .init(valArray)), y, x, preconditioner)
    }
    @inlinable@_transparent
    public static func Cleanup(preconditioner: SparseOpaquePreconditioner) {
        SparseCleanup(preconditioner)
    }
    // COO
    @inlinable@_transparent
    public static func Convert<E, R>(m: Int, n: Int,
                                     nonZeros: Int,
                                     rowIndex: UnsafePointer<Int32>,
                                     colIndex: UnsafePointer<Int32>,
                                     valArray: UnsafePointer<Self>,
                                     _ body: (UnsafePointer<Int>, UnsafePointer<Int32>, UnsafePointer<Self>) throws (E) -> R) rethrows -> R {
        let m = SparseConvertFromCoordinate(.init(m), .init(n),
                                            nonZeros, 1,
                                            .init(),
                                            rowIndex, colIndex, .init(valArray)) as SparseMatrix_Complex_Double
        defer {
            SparseCleanup(m)
        }
        return try body(m.structure.columnStarts,
                        m.structure.rowIndices,
                        .init(m.data))
    }
}
