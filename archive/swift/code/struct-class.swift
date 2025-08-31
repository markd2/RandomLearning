// swiftc -O struct-class.swift -o struct-class

import Foundation

class Snork {
    let anInt = 0
    let aBool = false
    let name: String

    init(name: String) {
        self.name = name
    }

    var count: Int {
        CFGetRetainCount(self)
    }
}

var gSnork: Snork = Snork(name: "globalSnork")

struct Thing1 {
    let snork1 = gSnork
    let snork2 = gSnork
    let snork3 = gSnork
    let snork4 = gSnork
    let snork5 = gSnork
    let snork6 = gSnork
}


let thing1 = Thing1()
print("1. snork retain count is \(thing1.snork1.count)")

gSnork = Snork(name: "another snork")
print("2. snork retain count is \(thing1.snork1.count)")

let thing2 = thing1
print("3. snork retain count is \(thing2.snork1.count)")

let thing3 = thing1
print("4. snork retain count is \(thing2.snork1.count)")

