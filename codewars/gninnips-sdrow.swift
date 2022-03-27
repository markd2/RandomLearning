#!/usr/bin/swift

import Foundation

// Write a function that takes in a string of one or more words, and
// returns the same string, but with all five or more letter words
// reversed (Just like the name of this Kata). Strings passed in will
// consist of only letters and spaces. Spaces will be included only when
// more than one word is present.

typealias Pair = (String, String)

let tests: [Pair] = [
  ("Hey fellow warriors", "Hey wollef sroirraw"),
  ("This is a test", "This is a test"),
  ("This is another test", "This is rehtona test")
]

func spinWords(_ string: String) -> String {
    return ""
}

var failwaffle = false

for test in tests {
    let words = test.0
    let spun = spinWords(words)
    let expected = test.1

    if spun != expected {
        print("ut-oh: got \(spun), expected \(expected)")
        failwaffle = true
    }
}

if !failwaffle {
    print("success")
}
