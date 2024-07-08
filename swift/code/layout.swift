// swiftc -O layout.swift -o layout

struct Thing1 {
    let aBool: Bool
    let anInt: Int
    let anotherBool: Bool
    let aShort: Int16
    let anotherInt: Int
}

struct Thing2 {
    let anInt: Int = 0
    let anotherInt: Int = 0
    let aShort: Int16 = 0
    let aBool: Bool = false
    let anotherBool: Bool = false
}

print("Thing 1")
  print("  size: \(MemoryLayout<Thing1>.size)")
  print("  stride: \(MemoryLayout<Thing1>.stride)")
  print("  alignment: \(MemoryLayout<Thing1>.alignment)")
  print("")
  print("  aBool offset: \(MemoryLayout<Thing1>.offset(of: \.aBool)!)")
  print("  anInt offset: \(MemoryLayout<Thing1>.offset(of: \.anInt)!)")
  print("  anotherBool offset: \(MemoryLayout<Thing1>.offset(of: \.anotherBool)!)")
  print("  aShort offset: \(MemoryLayout<Thing1>.offset(of: \.aShort)!)")
  print("  anotherInt offset: \(MemoryLayout<Thing1>.offset(of: \.anotherInt)!)")

print("------------------------------")

print("Thing 2")
  print("  size: \(MemoryLayout<Thing2>.size)")
  print("  stride: \(MemoryLayout<Thing2>.stride)")
  print("  alignment: \(MemoryLayout<Thing2>.alignment)")
  print("")
  print("  anInt offset: \(MemoryLayout<Thing2>.offset(of: \.anInt)!)")
  print("  anotherInt offset: \(MemoryLayout<Thing2>.offset(of: \.anotherInt)!)")
  print("  aShort offset: \(MemoryLayout<Thing2>.offset(of: \.aShort)!)")
  print("  aBool offset: \(MemoryLayout<Thing2>.offset(of: \.aBool)!)")
  print("  anotherBool offset: \(MemoryLayout<Thing2>.offset(of: \.anotherBool)!)")


#if false

protocol Snorgle {
    var anInt: Int { get }
/*
    var aBool: Bool { get }
    var anotherInt: Int { get }
    var anotherBool: Bool { get }
    var aShort: Int16 { get }

    func x()
    func y()
    func z()
    func q()
*/
}

extension Thing1: Snorgle {
    func x() {}
    func y() {}
    func z() {}
    func q() {}
}

extension Thing2: Snorgle {
    func x() {}
    func y() {}
    func z() {}
    func q() {}
}

let thing1 = Thing1()
let thing2 = Thing2()

let snorgle1 = thing1

print("------------------------------")
print("Snorgle")
print("  size: \(MemoryLayout<Snorgle>.size)")
print("  stride: \(MemoryLayout<Snorgle>.stride)")
print("  alignment: \(MemoryLayout<Snorgle>.alignment)")
print("  anInt offset: \(MemoryLayout<Snorgle>.offset(of: \.anInt) ?? -1)")
print("  aBool offset: \(MemoryLayout<Snorgle>.offset(of: \.anInt) ?? -1)")

#endif
