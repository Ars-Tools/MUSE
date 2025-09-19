//
//  Buffer+Scalar.swift
//  MUSE
//
//  Created by Kota on 9/8/R7.
//
import protocol Accelerate.AccelerateBuffer
import protocol Accelerate.AccelerateMutableBuffer
import typealias Numerics.Complex32
import typealias Numerics.Complex64
import typealias Numerics.Complex128
extension Bool: MutScalar {}
extension Int: MutScalar {}
extension Int8: MutScalar {}
extension Int16: MutScalar {}
extension Int32: MutScalar {}
extension Int64: MutScalar {}
extension Int128: MutScalar {}
extension UInt8: MutScalar {}
extension UInt16: MutScalar {}
extension UInt32: MutScalar {}
extension UInt64: MutScalar {}
extension UInt128: MutScalar {}
extension Float16: MutScalar {}
extension Float32: MutScalar {}
extension Float64: MutScalar {}
extension Complex32: MutScalar {}
extension Complex64: MutScalar {}
extension Complex128: MutScalar {}
