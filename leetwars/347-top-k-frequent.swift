#!/usr/bin/swift

// https://leetcode.com/problems/top-k-frequent-elements/
// given array of numbers, return the k most frequent elements.
// return in any order

import Foundation


class Solution {
    func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
        // 77ms, beats 28%, 15.4mb, beats 99.8% (yes!)
        var counter: [Int: Int] = [:]

        for num in nums {
            counter[num, default: 0] += 1
        }

        let ook = counter
          .map { ($0, $1) }
        .sorted(by: { $0.1 > $1.1 })
        .prefix(k)
        .map { $0.0 }

        return ook
    }
}

let input1 = ([1,1,1,1,2,2,3], 2)
let expected1 = [1, 2]

let input2 = ([1], 1)
let expected2 = [1]

let input3 = ([-1, -1], 1)
let expected3 = [-1]

let input4 = ([4,1,-1,2,-1,2,3], 2)
let expected4 = [-1, 2]


let sol = Solution()

if sol.topKFrequent(input1.0, input1.1) != expected1 {
    // too lazy to do proper "any order" checking, so eyeball this.
    print("failed 1 - got \(sol.topKFrequent(input1.0, input1.1))")
}
if sol.topKFrequent(input2.0, input2.1) != expected2 {
    print("failed 2 - got \(sol.topKFrequent(input2.0, input2.1))")
}
if sol.topKFrequent(input3.0, input3.1) != expected3 {
    print("failed 3 - got \(sol.topKFrequent(input3.0, input3.1))")
}
if sol.topKFrequent(input4.0, input4.1) != expected4 {
    print("failed 4 - got \(sol.topKFrequent(input4.0, input4.1))")
}

