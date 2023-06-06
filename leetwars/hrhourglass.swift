#!/usr/bin/swift

import Foundation

/*
 * Complete the 'hourglassSum' function below.
 *
 * The function is expected to return an INTEGER.
 * The function accepts 2D_INTEGER_ARRAY arr as parameter.
 */

func hourglassSum(arr matrix: [[Int]]) -> Int {
    let width = matrix[0].count
    let height = matrix[0].count

    func sumAnchoredAt(row: Int, col: Int) -> Int {
        guard row <= height - 3 && col <= width - 3 else {
            fatalError("shouldn't attempt hourglasses at \(row),\(col)")
        }
        
        let sum = matrix[row][col] + matrix[row][col+1] + matrix[row][col+2]
                                   + matrix[row+1][col+1]
                  + matrix[row+2][col] + matrix[row+2][col+1] + matrix[row+2][col+2]
        return sum
    }
    
    var maxSum = Int.min
    for row in 0 ... width - 3 {
        for column in 0 ... height - 3 {
            let sum = sumAnchoredAt(row: row, col: column)
            maxSum = max(maxSum, sum)
        }
    }

    return maxSum
}


let matrix = [[-9, -9, -9,  1, 1, 1],
              [ 0, -9,  0,  4, 3, 2],
              [-9, -9, -9,  1, 2, 3],
              [0,  0,  8,  6, 6, 0],
              [0,  0,  0, -2, 0, 0],
              [0,  0,  1,  2, 4, 0]]
              
let result1 = hourglassSum(arr: matrix)
let expected1 = 28
print(result1)
if result1 != expected1 {
    print("failed 1")
}
