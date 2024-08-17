#!/usr/bin/swift sh

import Foundation
import ArgumentParser // https://github.com/apple/swift-argument-parser

struct RollOptions: ParsableArguments {
    @Option(help: ArgumentHelp("Rolls the dice <n> times.",
                               valueName: "n"))
    var times = 1

    @Option(help: ArgumentHelp(
              "Rolls an <m>-sided dice.",
              discussion: "use this to override the default value of a d6",
              valueName: "m"))
    var sides = 6

    @Option(help: "a seed to use for repeatable random generation.")
    var seed: Int? = nil

    @Flag(name: .shortAndLong, help: "show all roll results.")
    var verbose = false
}

// if writing in a script style, call parseOrExit() to parse a single
// ParsableArguments type
let options = RollOptions.parseOrExit()

let seed = options.seed ?? .random(in: .min ... .max)
var rng = SplitMix64(seed: UInt64(truncatingIfNeeded: seed))

let rolls = (1...options.times).map { _ in
    Int.random(in: 1...options.sides, using: &rng)
}

if options.verbose {
    for (number, roll) in zip(1..., rolls) {
        print("Yo \(number): \(roll)")
    }
}

print(rolls.reduce(0, +))


// --------------------------------------------------

// courtesy of https://github.com/sbooth/DRBGs/blob/main/Sources/DRBGs/SplitMix64.swift#

struct SplitMix64: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed
    }

    mutating func next() -> UInt64 {
        self.state &+= 0x9e3779b97f4a7c15
        var z: UInt64 = self.state
        z = (z ^ (z &>> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z &>> 27)) &* 0x94d049bb133111eb
        return z ^ (z &>> 31)
    }
}
