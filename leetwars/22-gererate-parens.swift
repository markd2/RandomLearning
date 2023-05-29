#!/usr/bin/swift

// Given n pairs of parens, enerate all combinations of well-formed parens
// 1 <= n <= 8
// https://leetcode.com/problems/generate-parentheses/

import Foundation


class Solution {
    func generateParenthesis(_ count: Int) -> [String] {
        var stack = [String]()
        var result = [String]()

        func backtrack(_ activeOpens: Int, _ activeCloses: Int) {

            // base case, exhausted the number of opens and closes allowed
            if activeOpens == count && activeCloses == count {
                result.append(stack.joined(separator: ""))
                return
            }

            // can only add an open, otherwise 
            // adding a close would be syntactically invalid. e.g. (()))
            if activeOpens < count {
                stack.append("(")
                backtrack(activeOpens + 1, activeCloses)
                stack.removeLast()
            }

            // can only add a close if number of active closed is less than number
            // of active opens
            if activeCloses < activeOpens {
                stack.append(")")
                backtrack(activeOpens, activeCloses + 1)
                stack.removeLast()
            }
        }

        // start off with no active parens
        backtrack(0, 0)

        return result
    }
}

let sol = Solution()

let input1 = 1
let expected1 = Set(["()"])

let input2 = 3
let expected2 = Set(["((()))","(()())","(())()","()(())","()()()"])

let input3 = 4
let expected3 = Set(["(((())))","((()()))","((())())","((()))()","(()(()))","(()()())","(()())()","(())(())","(())()()","()((()))","()(()())","()(())()","()()(())","()()()()"])

/*
if Set(sol.generateParenthesis(input1)) != expected1 {
    print("failed 1 - got \(sol.generateParenthesis(input1)), expected \(expected1)")
}
if Set(sol.generateParenthesis(input2)) != expected2 {
    print("failed 2 - got \(sol.generateParenthesis(input2).sorted()), expected \(expected2.sorted())")
}
*/
if Set(sol.generateParenthesis(input3)) != expected3 {
    print("failed 3 - got \(sol.generateParenthesis(input3).sorted()), expected \(expected3.sorted())")
}


/*
1: ()
2: ()()                        (())
3: ()()() (()()) (())() ()(()) ((()))
   indiv  (2)     +end  +beg     (2)

Take all the prior, add () to beginning and end.
and also wrap whole thing

so ()() gives ()()() and ()()()  (elided into a single ()()())
and (()) gives ()(()) and (())()

()()() 2(0) with () glommed
(()()) 2(0) wrapped
(())() 2(1) with () glommed
()(()) 2(1) with () glommed
((())) - wrap whole thing

So recurse. base case is ()

n+1 is each of the elements of n:
- wrapped in parens
- () prepended
- () appended
- then uniqued


failed

failed 3 - got 

GOT
["(((())))", "((()()))", "((())())", "((()))()", "(()(()))", "(()()())", "(()())()",
             "(())()()", "()((()))", "()(()())", "()(())()", "()()(())", "()()()()"]
EXPECTED
["(((())))", "((()()))", "((())())", "((()))()", "(()(()))", "(()()())", "(()())()",
 "(())(())", "(())()()", "()((()))", "()(()())", "()(())()", "()()(())", "()()()()"]


got 
["(((())))", "((()()))", "((())())", "((()))()", "(()(()))", "(()()())", "(()())()",
             "(())()()", "()((()))", "()(()())", "()(())()", "()()(())", "()()()()"], 
expected 
["(((())))", "((()()))", "((())())", "((()))()", "(()(()))", "(()()())", "(()())()", 
 "(())(())", "(())()()", "()((()))", "()(()())", "()(())()", "()()(())", "()()()()"]


*/
