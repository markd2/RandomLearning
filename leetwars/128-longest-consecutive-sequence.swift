#!/usr/bin/swift

// given unsorted list of ints, find the length of the longest consecutive elements sequence
// https://leetcode.com/problems/longest-consecutive-sequence/

import Foundation


class Solution {
    // oof, slow.  848ms, less than 6%. but the faster ones are very similar.  huh.
    func longestConsecutive(_ nums: [Int]) -> Int {
        let set = Set(nums)

        var longest = 0

        for num in nums {
            // does this start a sequence?
            if !set.contains(num - 1) {
                var length = 0
                while set.contains(num + length) {
                    length += 1
                }
                longest = max(longest, length)
            }
        }

        return longest
    }

}

let sol = Solution()

let input1 = [100, 4, 200, 1, 3, 2]
let expected1 = 4

let input2 = [0, 3, 7, 2, 5, 8, 4, 6, 0, 1]
let expected2 = 9

if sol.longestConsecutive(input1) != expected1 {
    print("failed 1 - got \(sol.longestConsecutive(input1)), expected \(expected1)")
}
if sol.longestConsecutive(input2) != expected2 {
    print("failed 2 - got \(sol.longestConsecutive(input2)), expected \(expected2)")
}


