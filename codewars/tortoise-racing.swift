#!/usr/bin/swift

// https://www.codewars.com/kata/55e2adece53b4cdcb900006c/swift

// More generally: given two speeds v1 (A's speed, integer > 0) and v2
// (B's speed, integer > 0) and a lead g (integer > 0) how long will it
// take B to catch A?

// The result will be an array [hour, min, sec] which is the time needed
// in hours, minutes and seconds (round down to the nearest second) or a
// string in some languages.

// If v1 >= v2 then return nil, nothing, null, None or {-1, -1, -1}
// for C++, C, Go, Nim, Pascal, COBOL, [-1, -1, -1] for Perl,[] for
// Kotlin or "-1 -1 -1".

import Foundation

func race(_ v1: Int, _ v2: Int, _ headstart: Int) -> [Int]? {
    return [0, 0, 0]
}

let testcases: [((Int, Int, Int), (Int, Int, Int))] = [
  ((720, 850, 70), (0, 32, 18)),
  ((80, 91, 37), (3, 21, 49))
]

var failwaffle = false
for kase in testcases {
    let blah = race(kase.0.0, kase.0.1, kase.0.2) ?? []
    if blah[0] != kase.1.0 || blah[1] != kase.1.1 || blah[2] != kase.1.2 {
        print("expected \(kase.1.0) \(kase.1.1) \(kase.1.2), got \(blah)")
        failwaffle = true
    }
}

if !failwaffle {
    print("success")
}
