#!/usr/bin/swift

// https://leetcode.com/problems/contains-duplicate/

// given an array of numbers, return true if any value appears at least twice, false
// if every one is distinct

import Foundation

class Solution {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        // runtime 638ms (beats 38%), memory 18.6mb (beats 90%)
        Set(nums).count != nums.count
    }
}

class Solution2 {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        // runtime 739ms (beats 7%), memory 18.5mb (beats 95%)
        IndexSet(nums).count != nums.count
    }
}

class Solution3 {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        // runtime 644ms (beats 23%), memory 19.3mb (beats 25%)

        var exists = [Int: Bool]()

        for num in nums {
            if exists[num] != nil { return true }
            exists[num] = true
        }
        return false
    }
}


let input1 = [1,2,3,1]
let expected1 = true

let input2 = [1,2,3,4]
let expected2 = false

let input3 = [1,1,1,3,3,4,3,2,4,2]
let expected3 = true

let sol = Solution()

if sol.containsDuplicate(input1) != expected1 {
    print("failed 1")
}
if sol.containsDuplicate(input2) != expected2 {
    print("failed 2")
}
if sol.containsDuplicate(input3) != expected3 {
    print("failed 3")
}

