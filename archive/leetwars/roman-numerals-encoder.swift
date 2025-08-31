#!/usr/bin/swift

// https://www.codewars.com/kata/51b62bf6a9c58071c600001b/train/swift

import Foundation

// convert a number to its roman numeral representation
// "remember there can't be more than three identical symbols in a row"

func solution(_ number: Int) -> String {
    var number = number

    let lookup: [Int: String] = [
      1000: "M",
      500: "D",
      100: "C",
      50: "L",
      10: "X",
      5: "V",
      1: "I"
    ]

    var accumulator: [String: Int] = [:]
    let keys = lookup.keys.sorted().reversed()

    blah:
    for amount in keys {

        guard let letter = lookup[amount] else {
            print("uhr, shouldn't happen \(amount)")
            continue
        }

        while number >= amount {
            accumulator[letter] = accumulator[letter, default: 0] + 1

            number -= amount
        }
    }

    var result = ""
    for (amount, prior) in zip(keys, keys.dropFirst().appending(keys.first)) {
        guard let letter = lookup[amount] else {
            print("uhr, shouldn't happen \(amount)")
            continue
        }

        let count = accumulator[letter] ?? 0
        if count == 4 {
            let higherAmount = keys[prior]
            let higherLetter = lookup[higherAmount]
            result += "\(letter)\(higherLetter)"
        } else {
            for _ in 0 ..< count {
                result += letter
            }
        }
    }
    
    return "\(result)"
}

let testcases: [(Int, String)] = [
  (1, "I"),
  (2, "II"),
  (3, "III"),
  (4, "IV"),
  (5, "V"),
  (6, "VI"),
  (7, "VII"),
  (8, "VIII"),
  (9, "IX"),
  (10, "X"),
  (100, "C"),
  (444, "CDXLIV"),
  (1000, "M"),
  (1954, "MCMLIV"),
  (1990, "MCMXC"),
  (1999, "MCMXCIX"),
  (2000, "MM"),
  (2008, "MMVIII"),
  (3000, "MMM"),
  (3900, "MMMCM"),
  (3914, "MMMCMXIV")
]

var failwaffle = false
for kase in testcases {
    let mcmxviii = solution(kase.0)
    if mcmxviii != kase.1 {
        failwaffle = true
        print("for \(kase.0) got \(mcmxviii) expected \(kase.1)")
    }
}

if !failwaffle {
    print("success")
}


