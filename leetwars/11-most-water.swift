#!/usr/bin/swift

// https://leetcode.com/problems/container-with-most-water/

// there are N barriers of 1..N height
// between 2 and 100_000 barriers

func maxArea(_ height: [Int]) -> Int {
    var maxWater = 0
    let count = height.count

    // brute force first for correctness
    for left in 0 ..< count {
        for right in left + 1 ..< count {
            let min = min(height[left], height[right])
            let area = min * (right - left)
            maxWater = max(maxWater, area)
        }
    }

    return maxWater
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


