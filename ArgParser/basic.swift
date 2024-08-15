#!/usr/bin/swift sh

import Foundation
import ArgumentParser // https://github.com/apple/swift-argument-parser

@main
struct Repeat: ParsableCommand {
    @Flag(help: "Include a counter with each repeption.")
    var includeCounter = false

    @Option(name: .shortAndLong, help: "The number of times to repeat 'phrase'.")
    var count: Int? = nil

    @Argument(help: "the phrase to repeat.")
    var phrase: String

    mutating func run() throws {
        let repeatCount = count ?? 2
        
        for i in 1...repeatCount {
            if includeCounter {
                print("\(i): \(phrase)")
            } else {
                print(phrase)
            }
        }
    }
}

