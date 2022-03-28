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

// slow/fast are in feet per hour
func race(_ slow: Int, _ fast: Int, _ headstart: Int) -> [Int]? {
    var slowPos = slow
    var fastPos = fast

    var accumulator = Double(headstart) / Double(slow)

    // how long it takes fast to get to headstart (hours)
    func catchup(_ fast: Int, _ headstart: Int) -> Double {
        return Double(headstart) / Double(fast)
    }
    
    let time = catchup(fast, headstart)
    slowPos = headstart

    print("time \(time)")
    accumulator += time

    var newDistance = Double(slow) * time
    fastPos = Int(newDistance)
    
    print("\(slowPos) vs \(fastPos)")

    while newDistance > 0 {
        let newTime = catchup(fast, Int(newDistance))
        print("time \(newTime)")
        accumulator += newTime

        newDistance = Double(slow) * newTime
        slowPos = fastPos
        fastPos = Int(newDistance)
        print("\(slowPos) vs \(fastPos)")
    }
    print("new distance is \(newDistance)")
    print("accumulator is \(accumulator)")

    let floatSeconds = accumulator * 60 * 60
    let hour = Int(floatSeconds) / (60 * 60)
    let minute = (Int(floatSeconds) - (hour * 60*60)) / 60
    let seconds = Int(floatSeconds) % 60

    return [hour, minute, seconds]
}

let testcases: [((Int, Int, Int), (Int, Int, Int))] = [
  ((720, 850, 70), (0, 32, 18)),
//  ((80, 91, 37), (3, 21, 49))
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
