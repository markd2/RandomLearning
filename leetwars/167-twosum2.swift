#!/usr/bin/swift

import Foundation

// given an array of integers, sorted non-decreasing
// find two numbers such they add up to a specific  target
// return their 1+ indices
// may not use the same element twice
// there will be an answer
// https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/

class Solution {
    func twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
        var leftScan = 0
        var rightScan = numbers.count - 1

        while leftScan < rightScan {
            let sum = numbers[leftScan] + numbers[rightScan]
            if sum == target {
                // fortran compatibility
                return [leftScan + 1, rightScan + 1]
            } else if sum < target {
                leftScan += 1
            } else if sum > target {
                rightScan -= 1
            }
        }

        fatalError("there should always be a solution")
    }
}

let sol = Solution()

let input1 = [2, 7, 11, 15]
let target1 = 9
let expected1 = [1, 2]

let input2 = [2, 3, 4]
let target2 = 6
let expected2 = [1, 3]

let input3 = [-1, 0]
let target3 = -1
let expected3 = [1, 2]


if sol.twoSum(input1, target1) != expected1 {
    print("failed 1 - got \(sol.twoSum(input1, target1))")
}

if sol.twoSum(input2, target2) != expected2 {
    print("failed 2 - got \(sol.twoSum(input2, target2))")
}

if sol.twoSum(input3, target3) != expected3 {
    print("failed 3 - got \(sol.twoSum(input3, target3))")
}

