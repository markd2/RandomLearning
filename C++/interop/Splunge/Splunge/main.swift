//
//  main.swift
//  Splunge
//
//  Created by Mark Dalrymple on 10/13/23.
//

import Foundation
import CxxTest
import ForestLib

print("Snorgle!")

let blah = cxxFunction(7)
print(blah)

let larch = Tree(.Oak)

var greeble: TreeKind = .Oak
print(greeble, greeble.rawValue)
