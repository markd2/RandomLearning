#!/usr/bin/swift

import Foundation

// write a function maskify, which changes all but the last four characters into '#'.

typealias Pair = (String, String)

let tests: [Pair] = [
  ("4556364607935616", "############5616"),
  ("64607935616", "#######5616"),
  ("1", "1"),
  ("", ""),
  ("Skippy", "##ippy"),
  ("Nananananananananananananananana Batman!", "####################################man!")
]

func maskify(_ string: String) -> String {
    return ""
}

var failwaffle = false

for test in tests {
    let words = test.0
    let spun = maskify(words)
    let expected = test.1

    if spun != expected {
        print("ut-oh: got \(spun), expected \(expected)")
        failwaffle = true
    }
}

if !failwaffle {
    print("success")
}



