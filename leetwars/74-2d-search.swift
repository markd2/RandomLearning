#!/usr/bin/swift

import Foundation

// https://leetcode.com/problems/search-a-2d-matrix/
// given a 2-D matrix, values sorted (rows are  non-decreasing, and start of one
// row is greater than the row before it

class Solution {
    func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
        let rows = matrix.count
        let columns = matrix[0].count
        let count = rows * columns

        func index(_ index: Int) -> (row: Int, column: Int) {
            let row = index / columns
            let column = index % columns
            return (row, column)
        }
        
        func contains(_ start: Int, _ end: Int) -> Bool {
            guard start <= end else {
                return false
            }
            
            let middleFlat = (start + end) / 2

            let (middleRow, middleColumn) = index(middleFlat)
            let value = matrix[middleRow][middleColumn]

            if value == target {
                return true
            } else if target < value {
                return contains(start, middleFlat - 1)
            } else {
                return contains(middleFlat + 1, end)
            }
        }

        let gotOne = contains(0, count - 1)

        return gotOne
    }
}

let sol = Solution()

let input1 = [[1,3,5,7],[10,11,16,20],[23,30,34,60]]
let target1 = 3
let expected1 = true

let input2 = [[1,3,5,7],[10,11,16,20],[23,30,34,60]]
let target2 = 13
let expected2 = false


if sol.searchMatrix(input1, target1) != expected1 {
    print("failed 1")
}
if sol.searchMatrix(input2, target2) != expected2 {
    print("failed 2")
}
