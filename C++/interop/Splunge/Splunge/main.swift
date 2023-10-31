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

// call a simple C++ function
let blah = cxxFunction(7)
print(blah)

// Use a C++ enum from a pure C++ ibrary target
let larch = Tree(.Oak)

var greeble: TreeKind = .Oak
print(greeble, greeble.rawValue)

// HappyFunTime is a framework target with mixed swift and C++ project
// The HappyFun / FunHappy calculate fibonacci by bouncing between
// languages
let snork = HappyFunCplusplus(true) // C++
let ook = snork.happyfun(10)
print(ook)

let snork2 = FunHappy(printInvocation: true) // Swift
let ook2 = snork2.happyfun(10)
print(ook2)

// play with some templates and explicit specialization on the C++ side
let oop = getMagicNumber()
print(oop)

let greeble2 = CharCharFraction(2, 10);
