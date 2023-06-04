#!/usr/bin/swift

import Foundation

// https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/
// Find the minimum value in a sorted array that's been rotated some number of times.
// must be done in log n time


class Solution {
    func findMin(_ numbers: [Int]) -> Int { 
        // approach - quasi binary search (implied by log n time).
        // start with left and midpoint indexes. get their values
        // If midpoint > left, then this is a monotonically increasing run.
        // stash left as min, then recurse on the right segment
        // if midpoint < left, then the switchover point is within us.
        // stash midpoint as min, then recurse on the left segment

        var result = Int.max

        func halfKing(_ left: Int, _ right: Int) {
            guard left <= right else { return }

            let mid = (left + right) / 2

            let leftVal = numbers[left]
            let midVal = numbers[mid]
            let rightVal = numbers[right]

            result = min(result, leftVal)
            result = min(result, midVal)
            result = min(result, rightVal)

            if midVal > leftVal {
                halfKing(mid + 1, right)
            } else {
                halfKing(left, mid - 1)
            }
        }

        halfKing(0, numbers.count - 1)

        return result
    }
}

let sol = Solution()

let input1 = [3,4,5,1,2]
let expected1 = 1

let input2 = [4,5,6,7,0,1,2]
let expected2 = 0

let input3 = [11,13,15,17]
let expected3 = 11


if sol.findMin(input1) != expected1 {
    print("failed 1")
}
if sol.findMin(input2) != expected2 {
    print("failed 2")
}
if sol.findMin(input3) != expected3 {
    print("failed 3")
}
