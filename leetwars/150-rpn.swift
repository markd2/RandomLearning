#!/usr/bin/swift

// evaluate RPN
// https://leetcode.com/problems/evaluate-reverse-polish-notation/

import Foundation


class Solution {
    // 26ms - beats 94%.  14.3, beats 94%
    func evalRPN(_ tokens: [String]) -> Int {
        var stack: [Int] = []
        for token in tokens {

            switch token {
            case "+":
                let a = stack.pop()
                let b = stack.pop()
                stack.push(a+b)
            case "-":
                let a = stack.pop()
                let b = stack.pop()
                stack.push(b-a)
            case "*":
                let a = stack.pop()
                let b = stack.pop()
                stack.push(a*b)
            case "/":
                let a = stack.pop()
                let b = stack.pop()
                stack.push(b/a)
            default:
                stack.push(Int(token) ?? 0)
            }
        }

        return stack.first!
    }
}

extension Array {
    mutating func pop() -> Element {
        removeLast()
    }
    mutating func push(_ element: Element) {
        append(element)
    }
}

let sol = Solution()

let input1 = ["2","1","+","3","*"]
let expected1 = 9

let input2 = ["4","13","5","/","+"]
let expected2 = 6

let input3 = ["10","6","9","3","+","-11","*","/","*","17","+","5","+"]
let expected3 = 22

if sol.evalRPN(input1) != expected1 {
    print("failed 1 - got \(sol.evalRPN(input1)), expected \(expected1)")
}
if sol.evalRPN(input2) != expected2 {
    print("failed 2 - got \(sol.evalRPN(input2)), expected \(expected2)")
}
if sol.evalRPN(input3) != expected3 {
    print("failed 3 - got \(sol.evalRPN(input3)), expected \(expected3)")
}
