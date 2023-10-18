//
//  main.swift
//  Splunge
//
//  Created by Mark Dalrymple on 10/13/23.
//

import Foundation
import CxxTest
import ForestLib
import HappyFunTime

print("Snorgle!")

let blah = cxxFunction(7)
print(blah)

let larch = Tree(.Oak)

var greeble: TreeKind = .Oak
print(greeble, greeble.rawValue)

let snork = HappyFunCplusplus(true) // C++
let ook = snork.happyfun(10)
print(ook)

let snork2 = FunHappy(printInvocation: true) // Swift
let ook2 = snork2.happyfun(10)
print(ook2)
