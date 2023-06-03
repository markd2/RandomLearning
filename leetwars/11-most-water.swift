#!/usr/bin/swift

import Foundation

// https://leetcode.com/problems/container-with-most-water/

// there are n barriers of 1..n height
// between 2 and 100_000 barriers

func maxArea(_ heights: [Int]) -> Int {
    var maxWater = 0

    var leftScan = 0
    var rightScan = heights.count - 1

    while leftScan < rightScan {
        let height = min(heights[rightScan], heights[leftScan])
        let base = rightScan - leftScan
        let area = height * base
        
        maxWater = max(maxWater, area)

        if heights[rightScan] > heights[leftScan] {
            leftScan += 1
        } else if heights[rightScan] < heights[leftScan] {
            rightScan -= 1
        } else {
            // pick one
            leftScan += 1
        }
    }

    return maxWater
/*
    // brute force first for correctness
    for left in 0 ..< count {
        for right in left + 1 ..< count {
            let min = min(height[left], height[right])
            let area = min * (right - left)
            maxwater = max(maxwater, area)
        }
    }
    return maxWater
*/
}


let height1 = [1,8,6,2,5,4,8,3,7]
let expectedOutput1 = 49
if maxArea(height1) != expectedOutput1 {
    print("bummer 1")
}

let height2 = [1, 1]
let expectedOutput2 = 1
if maxArea(height2) != expectedOutput2 {
    print("bummer 2")
}
