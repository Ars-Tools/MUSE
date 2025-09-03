//
//  Hungarian.swift
//  MUSE
//
//  Created by Kota on 9/2/R7.
//
// solve optima pair by using Hungarian method, cost is row-major-matrix
public func hungarian<T: Numeric & Comparable>(size: Int, cost: Array<T>) -> Set<SIMD2<Int>> {
	var matrix = cost
	func getMatrixValue(row: Int, col: Int) -> T {
		return matrix[row * size + col]
	}
	func setMatrixValue(row: Int, col: Int, value: T) {
		matrix[row * size + col] = value
	}
	for row in 0..<size {
		var minVal = getMatrixValue(row: row, col: 0)
		for col in 1..<size {
			minVal = min(minVal, getMatrixValue(row: row, col: col))
		}
		for col in 0..<size {
			setMatrixValue(row: row, col: col, value: getMatrixValue(row: row, col: col) - minVal)
		}
	}
	for col in 0..<size {
		var minVal = getMatrixValue(row: 0, col: col)
		for row in 1..<size {
			minVal = min(minVal, getMatrixValue(row: row, col: col))
		}
		if minVal > 0 {
			for row in 0..<size {
				setMatrixValue(row: row, col: col, value: getMatrixValue(row: row, col: col) - minVal)
			}
		}
	}
	while true {
		var assignedRows = [Int](repeating: -1, count: size) // assignedRows[col] = row
		var assignedCols = [Int](repeating: -1, count: size) // assignedCols[row] = col
		
		for row in 0..<size {
			for col in 0..<size {
				if getMatrixValue(row: row, col: col) == 0 && assignedRows[col] == -1 {
					assignedRows[col] = row
					assignedCols[row] = col
					break
				}
			}
		}
		
		var markedRows = [Bool](repeating: false, count: size)
		var markedCols = [Bool](repeating: false, count: size)

		for row in 0..<size {
			if assignedCols[row] == -1 {
				markedRows[row] = true
			}
		}
		var changed = true
		while changed {
			changed = false
			for row in 0..<size where markedRows[row] {
				for col in 0..<size where !markedCols[col] {
					if getMatrixValue(row: row, col: col) == 0 {
						markedCols[col] = true
						changed = true
					}
				}
			}
			if changed { continue }
			for col in 0..<size where markedCols[col] {
				let row = assignedRows[col]
				if row != -1 && !markedRows[row] {
					markedRows[row] = true
					changed = true
				}
			}
		}

		let numCoveringLines = markedCols.filter { $0 }.count + markedRows.filter { !$0 }.count
		
		if numCoveringLines >= size {
			var result = Set<SIMD2<Int>>()

			func findPath(u: Int, target: inout [Int], visited: inout [Bool]) -> Bool {
				for v_idx in 0..<size {
					let v = v_idx
					if getMatrixValue(row: u, col: v) == 0 && !visited[v_idx] {
						visited[v_idx] = true
						if target[v] < 0 || findPath(u: target[v], target: &target, visited: &visited) {
							target[v] = u
							return true
						}
					}
				}
				return false
			}

			var target = [Int](repeating: -1, count: size)
			for u in 0..<size {
				var visited = [Bool](repeating: false, count: size)
				_ = findPath(u: u, target: &target, visited: &visited)
			}
			
			for v in 0..<size where target[v] != -1 {
				result.insert(SIMD2<Int>(target[v], v))
			}
			return result
		}
		var minUncoveredValue: T? = nil
		for row in 0..<size {
			for col in 0..<size {
				if markedRows[row] && !markedCols[col] {
					let val = getMatrixValue(row: row, col: col)
					if minUncoveredValue == nil || val < minUncoveredValue! {
						minUncoveredValue = val
					}
				}
			}
		}
		guard let minVal = minUncoveredValue else {
			fatalError("Could not find minimum uncovered value, problem with logic.")
		}
		for row in 0..<size where markedRows[row] {
			for col in 0..<size where !markedCols[col] {
				setMatrixValue(row: row, col: col, value: getMatrixValue(row: row, col: col) - minVal)
			}
		}
		for row in 0..<size where !markedRows[row] {
			for col in 0..<size where markedCols[col] {
				setMatrixValue(row: row, col: col, value: getMatrixValue(row: row, col: col) + minVal)
			}
		}
	}
}
