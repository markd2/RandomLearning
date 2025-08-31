#!/usr/bin/swift

import Foundation

// https://leetcode.com/problems/group-anagrams/

// given an array of strings, group the anagrams together.  Can return in any order

class Solution {
    func groupAnagrams(_ strs: [String]) -> [[String]] {
        // 112 ms (beats 48%), 17.4mb (beats 36%)
        var agg: [Array<Character>: [String]] = [:]

        for str in strs {
            let key = str.sorted()
            agg[key, default: []] += [str]
        }
        
        return Array(agg.values)
    }
}

let input1 = ["eat","tea","tan","ate","nat","bat"]
let expected1 = [["nat","tan"],["bat"],["eat","tea","ate"]]

let input2 = [""]
let expected2 = [[""]]

let input3 = ["splunge"]
let expected3 = [["splunge"]]

let sol = Solution()

if sol.groupAnagrams(input1) != expected1 {
    // too lazy to do proper "any order" checking, so eyeball this.
    print("failed 1 - got \(sol.groupAnagrams(input1))")
}
if sol.groupAnagrams(input2) != expected2 {
    print("failed 2")
}
if sol.groupAnagrams(input3) != expected3 {
    print("failed 3")
}
