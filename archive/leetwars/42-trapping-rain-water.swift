#!/usr/bin/swift

import Foundation

// Given n non-negative integers representing an elevation map (width of bar is 1),
// compute how much water it can trap after raining.
// https://leetcode.com/problems/trapping-rain-water/


func trap(_ heights: [Int]) -> Int {

    // this is kind of piggy, using an additional 2*N space
    // maximum height to the right or left of a particular index
    var lefts = Array(repeating: 0, count: heights.count)
    var rights = Array(repeating: 0, count: heights.count)

    var leftMax = Int.min
    var rightMax = Int.min

    let count = heights.count

    // figure out the various fenceposts
    // scan left to right
    for i in 0 ..< count {
        leftMax = max(leftMax, heights[i])
        rightMax = max(rightMax, heights[count - i - 1])
        lefts[i] = leftMax
        rights[count - i - 1] = rightMax
    }

    var glub = 0

    for (i, height) in heights.enumerated() {
        glub += min(lefts[i], rights[i]) - height
    }

    return glub
}


let height1 = [0,1,0,2,1,0,1,3,2,1,2,1]
let expectedOutput1 = 6
if trap(height1) != expectedOutput1 {
    print("bummer 1")
}

let height2 = [4,2,0,3,2,5]
let expectedOutput2 = 9
if trap(height2) != expectedOutput2 {
    print("bummer 2")
}
