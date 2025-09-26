//
//  Solver+Iterative.swift
//  MUSE
//
//  Created by Kota on 9/22/25.
//
import Accelerate
import Auxiliary
import Dense
import typealias Layout.MemoryStrategy
import typealias Dense.Basic
import func Layout.capacity
extension Solver {
    public final class Iterative {
        let system: Basic<Element>.AB<CCS<Element>, CRS<Element>>
        let preconditioner: Element.SparseOpaquePreconditioner
        init(_ x: some SparseMatrix<Element>) {
            system = switch x.lil(for: .columnMajor) {
            case (.columnMajor, let lil):
                    .A(.init(lil: lil, count: x.rows))
            case (.rowMajor, let lil):
                    .B(.init(lil: lil, count: x.cols))
            }
            preconditioner = switch system {
            case.A(let ccs):
                Element.Preconditioner(type: SparsePreconditionerDiagScaling,
                                       m: ccs.rows, n: ccs.cols, op: .N,
                                       colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray)
            case.B(let crs):
                Element.Preconditioner(type: SparsePreconditionerDiagScaling,
                                       m: crs.rows, n: crs.cols, op: .T,
                                       colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray)
            }
        }
        deinit {
            Element.Cleanup(preconditioner: preconditioner)
        }
    }
}
extension Solver.Iterative {
    public func solve<R>(y: MatrixBuffer<R>, method: SparseIterativeMethod = SparseLSMR()) -> MatrixBuffer<Array<Element>> where R.Element == Element {
        let m = system.cols
        let ((n, k), ldb, ldc, stride, offset) = MemoryStrategy.columnMajor.contraction(m: m, y: ([y.rows, y.cols], [y.ldr, y.ldc]))
        assert(stride.count == 2)
        assert(offset == [.zero])
        return switch system {
        case.A(let ccs):
            switch (ldb, ldc) {
            case ((1, let ldb), (1, let ldc)):
                MatrixBuffer<Array<Element>>(shape: (m, n), stride: (1, ldc), data: .init(unsafeUninitializedCapacity: capacity(alloc: [m, n], stride: stride)) {
                    Element.Solve(method: method,
                                  preconditioner: preconditioner,
                                  m: k, n: m, nrhs: n,
                                  colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                  Y: y.withUnsafeBufferPointer(\.baseAddress.unsafelyUnwrapped), ldY: ldb, opY: .N,
                                  X: $0.baseAddress.unsafelyUnwrapped, ldX: ldc, opX: .N)
                    $1 = $0.count
                })
            case ((1, let ldb), (let ldc, 1)):
                MatrixBuffer<Array<Element>>(shape: (m, n), stride: (1, ldc), data: .init(unsafeUninitializedCapacity: capacity(alloc: [m, n], stride: stride)) {
                    Element.Solve(method: method,
                                  preconditioner: preconditioner,
                                  m: k, n: m, nrhs: n,
                                  colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                  Y: y.withUnsafeBufferPointer(\.baseAddress.unsafelyUnwrapped), ldY: ldb, opY: .N,
                                  X: $0.baseAddress.unsafelyUnwrapped, ldX: ldc, opX: .T)
                    $1 = $0.count
                })
            case ((let ldb, 1), (1, let ldc)):
                MatrixBuffer<Array<Element>>(shape: (m, n), stride: (1, ldc), data: .init(unsafeUninitializedCapacity: capacity(alloc: [m, n], stride: stride)) {
                    Element.Solve(method: method,
                                  preconditioner: preconditioner,
                                  m: k, n: m, nrhs: n,
                                  colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                  Y: y.withUnsafeBufferPointer(\.baseAddress.unsafelyUnwrapped), ldY: ldb, opY: .T,
                                  X: $0.baseAddress.unsafelyUnwrapped, ldX: ldc, opX: .N)
                    $1 = $0.count
                })
            case ((let ldb, 1), (let ldc, 1)):
                MatrixBuffer<Array<Element>>(shape: (m, n), stride: (1, ldc), data: .init(unsafeUninitializedCapacity: capacity(alloc: [m, n], stride: stride)) {
                    Element.Solve(method: method,
                                  preconditioner: preconditioner,
                                  m: k, n: m, nrhs: n,
                                  colStart: ccs.colStart, rowIndex: ccs.rowIndex, valArray: ccs.valArray, opA: .N,
                                  Y: y.withUnsafeBufferPointer(\.baseAddress.unsafelyUnwrapped), ldY: ldb, opY: .T,
                                  X: $0.baseAddress.unsafelyUnwrapped, ldX: ldc, opX: .T)
                    $1 = $0.count
                })
            default:
                fatalError("not implemented")
            }
        case.B(let crs):
            switch (ldb, ldc) {
            case ((1, let ldb), (1, let ldc)):
                MatrixBuffer<Array<Element>>(shape: (m, n), stride: (1, ldc), data: .init(unsafeUninitializedCapacity: capacity(alloc: [m, n], stride: stride)) {
                    Element.Solve(method: method,
                                  preconditioner: preconditioner,
                                  m: k, n: m, nrhs: n,
                                  colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                  Y: y.withUnsafeBufferPointer(\.baseAddress.unsafelyUnwrapped), ldY: ldb, opY: .N,
                                  X: $0.baseAddress.unsafelyUnwrapped, ldX: ldc, opX: .N)
                    $1 = $0.count
                })
            case ((let ldb, 1), (1, let ldc)):
                MatrixBuffer<Array<Element>>(shape: (m, n), stride: (1, ldc), data: .init(unsafeUninitializedCapacity: capacity(alloc: [m, n], stride: stride)) {
                    Element.Solve(method: method,
                                  preconditioner: preconditioner,
                                  m: k, n: m, nrhs: n,
                                  colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                  Y: y.withUnsafeBufferPointer(\.baseAddress.unsafelyUnwrapped), ldY: ldb, opY: .T,
                                  X: $0.baseAddress.unsafelyUnwrapped, ldX: ldc, opX: .N)
                    $1 = $0.count
                })
            case ((1, let ldb), (let ldc, 1)):
                MatrixBuffer<Array<Element>>(shape: (m, n), stride: (ldc, 1), data: .init(unsafeUninitializedCapacity: capacity(alloc: [m, n], stride: stride)) {
                    Element.Solve(method: method,
                                  preconditioner: preconditioner,
                                  m: k, n: m, nrhs: n,
                                  colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                  Y: y.withUnsafeBufferPointer(\.baseAddress.unsafelyUnwrapped), ldY: ldb, opY: .N,
                                  X: $0.baseAddress.unsafelyUnwrapped, ldX: ldc, opX: .T)
                    $1 = $0.count
                })
            case ((let ldb, 1), (let ldc, 1)):
                MatrixBuffer<Array<Element>>(shape: (m, n), stride: (ldc, 1), data: .init(unsafeUninitializedCapacity: capacity(alloc: [m, n], stride: stride)) {
                    Element.Solve(method: method,
                                  preconditioner: preconditioner,
                                  m: k, n: m, nrhs: n,
                                  colStart: crs.rowStart, rowIndex: crs.colIndex, valArray: crs.valArray, opA: .T,
                                  Y: y.withUnsafeBufferPointer(\.baseAddress.unsafelyUnwrapped), ldY: ldb, opY: .T,
                                  X: $0.baseAddress.unsafelyUnwrapped, ldX: ldc, opX: .T)
                    $1 = $0.count
                })
            default:
                fatalError()
            }
        }
    }
}
