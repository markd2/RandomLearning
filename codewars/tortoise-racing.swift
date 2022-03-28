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
    guard slow < fast else { return nil }

    let slowSpeed = Double(slow) / 3600 // feet per second
    let fastSpeed = Double(fast) / 3600

    // and they're off!
    var slowPosition = Double(headstart)
    var fastPosition = 0.0

    var totalSeconds = 0.0

    while true {
        // once they cross, game over
        guard (totalSeconds * slowSpeed + Double(headstart)) > (totalSeconds * fastSpeed) else {
            break
        }

        let catchUpDistance = slowPosition - fastPosition
        guard catchUpDistance > 0 else { break }

        // time to close the distance
        let fastCatchUpTime = catchUpDistance / fastSpeed
        totalSeconds += fastCatchUpTime

        // during that time, slow moved this much
        let slowMove = slowSpeed * fastCatchUpTime

        fastPosition = slowPosition
        slowPosition += slowMove
    }

    let floatSeconds = round(Double(totalSeconds))
    print("float seconds \(floatSeconds) nee \(totalSeconds)")
    let hour = Int(floatSeconds) / (60 * 60)
    let minute = (Int(floatSeconds) - (hour * 60*60)) / 60
    let seconds = Int(floatSeconds) % 60

    return [hour, minute, seconds]
}

let testcases: [((Int, Int, Int), (Int, Int, Int))] = [
  ((720, 850, 70), (0, 32, 18)),
  ((80, 91, 37), (3, 21, 49)),
  ((820, 850, 550), (18, 20, 0)),
  ((279, 314, 77), (2, 12, 0)),
  ((570, 712, 71), (0, 30, 0)),
  ((720, 850, 37), (0, 17, 4))
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

/* ok moose, let's think about this.

 * say thing1 moves at 50 m/s
 * thing 2 moves at 100 m/s
 * thing1 has a 200 m head start

initial position:
|  time  | thing1dist | thing2dist | 
|   0    |      200   |       0    | - start.  fast takes 2 seconds to catch up 200m
|   2    |      ???   |     200    | - in those two seconds, slow moves 100
|   2    |      300   |     200    | - fast takes 1 second to catch up 100m
|   3    |      ???   |     300    | - in that one second, slow moves 50
|   3    |      350   |     300    | - fast takes .5 second to catch up 50m
|   3.5  |      ???   |     350    | - in that half second, slow moves 25
|   3.5  |      375   |     350    | - fast takes .25 second to catch up 25m
|   3.75 |      ???   |     375    | - in that quarter second, slow moves 12.5
|   3.75 |    387.5   |     375    | - fast takes .125 second to catch up 12.5m
|  3.875 |    ?????   |   387.5    | - in that .125 second, slow moves 0.07m
| 3.945  |    ?????   |

continue until it converse
 - it takes 2 seconds to catch up.
|        |      ???   |     200    || - in that 2 seconds, slow dude moved 100 m
|   2    |      200   |     200    |  100  | - it takes 1 second to catch up

so code-styleZ

current time = 0
while racing {
    what's the distance between slow and fast?
    how much time does it take fast to move that distance?
    how much does slow move in that time?
    fastPosition = slowPosition
    slowPosition = slow speed * time
    time += amount of time
}


OR, another way

since the time is hour - based, we can calculate distance moved per second

then have a timer

for timer = 0 ... Inf {
    slowPosition = headStart + timer * slowSpeed
    fastPosition = timer * fastSpeed
}

and then loop until fast is > slow.  That helps avoid the xeno's paradox

The examples have a three hour race, so that would be 10K iterations, vs probably a
handlful for the explicit integration.  oh well.

*/
