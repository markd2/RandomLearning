#!/usr/bin/swift

// given an array of temperatures, return an array such that
// for day i, the value in the array is the number of days you have to wait
// after the ith day to get a warmer temperature.
// if there is no future warmer day, get 0 instead
// https://leetcode.com/problems/daily-temperatures/

import Foundation


class Solution {
    // runtime 1,112 ms, beats 30%, memory 24mb, beats 33%
    func dailyTemperatures(_ temps: [Int]) -> [Int] {
        var result: [Int] = Array(repeating: 0, count: temps.count)
        var waitingStack: [(temperature: Int, index : Int)] = [] // monotonically decreasing temps

        for (index, temp) in temps.enumerated() {

            while !waitingStack.isEmpty && waitingStack.top.temperature < temp {
                let top = waitingStack.pop()
                result[top.index] = index - top.index
            }

            waitingStack.push((temp, index))
        }

        return result
    }
}

extension Array {
    @discardableResult mutating func pop() -> Element {
        removeLast()
    }
    mutating func push(_ element: Element) {
        append(element)
    }
    var top: Element {
        last!
    }
}


let sol = Solution()

let input1 = [73,74,75,71,69,72,76,73]
let expected1 = [1,1,4,2,1,1,0,0]

let input2 = [30,40,50,60]
let expected2 = [1, 1, 1, 0]

let input3 = [30,60,90]
let expected3 = [1,1,0]

if sol.dailyTemperatures(input1) != expected1 {
    print("failed 1 - got \(sol.dailyTemperatures(input1)), expected \(expected1)")
}
if sol.dailyTemperatures(input2) != expected2 {
    print("failed 2 - got \(sol.dailyTemperatures(input2)), expected \(expected2)")
}
if sol.dailyTemperatures(input3) != expected3 {
    print("failed 3 - got \(sol.dailyTemperatures(input3)), expected \(expected3)")
}

