#!/usr/bin/swift

// https://leetcode.com/problems/valid-anagram/

// given two strings, return true if t is an anagram of s, false otherwise 

import Foundation

class Solution {
    func isAnagram(_ s: String, _ t: String) -> Bool {
        // 16ms (beats 89%), memory 14.7 (beats 50%)
        // another run is 6ms (beats 99.75%), memory 14.7 (same) _shrug_
        return s.unicodeScalars.sorted() == t.unicodeScalars.sorted()
    }
}

let sol = Solution()

let input1 = ("anagram", "nagaram")
let expected1 = true
let input2 = ("rat", "car")
let expected2 = false
let input3 = ("råt", "årt")
let expected3 = true

if sol.isAnagram(input1.0, input1.1) != expected1 {
    print("failed 1")
}
if sol.isAnagram(input2.0, input2.1) != expected2 {
    print("failed 2")
}
if sol.isAnagram(input3.0, input3.1) != expected3 {
    print("failed 3")
}

