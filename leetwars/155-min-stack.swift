#!/usr/bin/swift

// implkement a stack that keeps track of its smallest value
// https://leetcode.com/problems/min-stack/

import Foundation

class MinStack {
    // 61ms - beats 91%, memory 15, beats 45%
    var guts: [Int] = []
    var minimums: [Int] = []

    init() {
    }
    
    func push(_ val: Int) {
        guts.append(val)
        if minimums.isEmpty || val <= minimums.last! {
            minimums.push(val)
        }
    }
    
    func pop() {
        let last = guts.removeLast()
        if last == minimums.last! {
            minimums.pop()
        }
    }
    
    func top() -> Int {
        guts.last!
    }
    
    func getMin() -> Int { // in a real swift program, this would be optional
        minimums.last!
    }
}

extension Array {
    @discardableResult mutating func pop() -> Element {
        removeLast()
    }
    mutating func push(_ element: Element) {
        append(element)
    }
}

let blah = MinStack()

blah.push(-2)
blah.push(0)
blah.push(-3)
let min = blah.getMin()
if min != -3 {
    print("sadge 1 - got \(min)")
}
blah.pop()
_ = blah.top()
let min2 = blah.getMin()
if min2 != -2 {
    print("sadge 2 = got \(min2)")
}
