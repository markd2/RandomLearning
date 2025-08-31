#!/usr/bin/swift

import Foundation

// https://leetcode.com/problems/subsets/
// given an integer array (unique), return all possible subsets (power set)
// without duplicate subsets. Subset, not a permutation.  so [2, 1] is [1, 2]
// Can return in any order.  
// 2n == number of subsets

class Solution {
    func subsets(_ nums: [Int]) -> [[Int]] {
        var result: [[Int]] = []

        // if reach basecase, got past our leaf nodes.
        var subset: [Int] = []
        func dfs(_ i: Int) { // index of the value we are making decision on
            // base case, ran off the end
            if i >= nums.count {
                print("snorgle")
                result.append(subset)
                return
            }
            subset.append(nums[i])
            dfs(i + 1) // left branch of decision tree
            
            // decision not to incllude nums[i]
            // so the empty subset branch
            subset.removeLast()
            dfs(i + 1)
        }
        dfs(0)
        return result
    }
}

let sol = Solution()

let input1 = [1, 2, 3]
let blah1 = sol.subsets(input1)
print(blah1)

let input2 = [0]
let blah2 = sol.subsets(input2)
print(blah2)

