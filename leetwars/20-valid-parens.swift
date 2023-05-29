#!/usr/bin/swift

// given string of () {} [], is it valid nestingwise?
// https://leetcode.com/problems/valid-parentheses/

import Foundation


class Solution {
    func isValid(_ string: String) -> Bool {
        var stack = Array<Character>()

        let pairs: [(Character, Character)] = [("(", ")"), ("[", "]"), ("{", "}")]

        for s in string {
            for pair in pairs {
                if s == pair.0 {
                    stack.append(s)
                } else if s == pair.1 {
                    guard !stack.isEmpty else { return false }
                    guard let last = stack.last, last == pair.0 else {
                        return false
                    }
                    stack.removeLast()
                }
            }
        }
        return stack.isEmpty
    }
}

let sol = Solution()

let input1 = "()"
let expected1 = true

let input2 = "()[]{}"
let expected2 = true

let input3 = "(]"
let expected3 = false

let input4 = "([{}{}[]]()[]{{[[]]}})"
let expected4 = true

let input5 = "["
let expected5 = false

let input6 = "]"
let expected6 = false

if sol.isValid(input1) != expected1 {
    print("failed 1 - got \(sol.isValid(input1)), expected \(expected1)")
}
if sol.isValid(input2) != expected2 {
    print("failed 2 - got \(sol.isValid(input2)), expected \(expected2)")
}
if sol.isValid(input3) != expected3 {
    print("failed 3 - got \(sol.isValid(input3)), expected \(expected3)")
}
if sol.isValid(input4) != expected4 {
    print("failed 4 - got \(sol.isValid(input4)), expected \(expected4)")
}
if sol.isValid(input5) != expected5 {
    print("failed 5 - got \(sol.isValid(input5)), expected \(expected5)")
}
if sol.isValid(input6) != expected6 {
    print("failed 6 - got \(sol.isValid(input6)), expected \(expected6)")
}


