#!/usr/bin/swift

import Foundation

// is a string a palindrome?
// https://leetcode.com/problems/valid-palindrome/

class Solution {
    func isPalindrome(_ rawString: String) -> Bool {
        let alphanum = CharacterSet.alphanumerics
        // let letters = CharacterSet.letters

        let string = String(rawString.unicodeScalars.filter { alphanum.contains($0) }).uppercased()

        // Empty string that reads the same forward and backwards is a palindrome.
        guard !string.isEmpty else { return true }
        guard string.count > 1 else { return true }

        var forwardScan = string.startIndex
        var backwardScan = string.index(before: string.endIndex)
        
        while forwardScan < backwardScan {
            let oop2 = string[forwardScan]
            let ack2 = string[backwardScan]

            if oop2 != ack2 {
                return false
            }

            forwardScan = string.index(after: forwardScan)
            backwardScan = string.index(before: backwardScan)
        }
        return true
     }
}

let sol = Solution()

let input1 = "I se,em to \" \\#(123be a verb"
let expected1 = false

let input2 = "A man, a plan, a canal: Panama"
let expected2 = true

let input3 = "A man, a plan, a can of spam: Bananama!"
let expected3 = false

let input4 = "Taco Cat!"
let expected4 = true

let input5 = " "
let expected5 = true

let input6 = "0P"
let expected6 = false

let input7 = "a"
let expected7 = true

let input8 = "abb"
let expected8 = false

if sol.isPalindrome(input1) != expected1 {
    print("failed 1")
}
if sol.isPalindrome(input2) != expected2 {
    print("failed 2")
}
if sol.isPalindrome(input3) != expected3 {
    print("failed 3")
}
if sol.isPalindrome(input4) != expected4 {
    print("failed 4")
}
if sol.isPalindrome(input5) != expected5 {
    print("failed 5")
}
if sol.isPalindrome(input6) != expected6 {
    print("failed 6")
}
if sol.isPalindrome(input7) != expected7 {
    print("failed 7")
}
if sol.isPalindrome(input8) != expected8 {
    print("failed 8")
}
