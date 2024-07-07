// swiftc -O layout.swift -o layout

struct Thing1 {
    let aBool: Bool
    let anInt: Int
    let anotherBool: Bool
    let short: Int16
    let anotherInt: Int
}

struct Thing2 {
    let anInt: Int = 0
    let anotherInt: Int = 0
    let aBool: Bool = false
    let anotherBool: Bool = false
    let short: Int16 = 0
}

print("Thing 1")
  print("  size: \(MemoryLayout<Thing1>.size)")
  print("  stride: \(MemoryLayout<Thing1>.stride)")
  print("  alignment: \(MemoryLayout<Thing1>.alignment)")
  print("")
  print("  aBool offset: \(MemoryLayout<Thing1>.offset(of: \.aBool)!)")
  print("  anInt offset: \(MemoryLayout<Thing1>.offset(of: \.anInt)!)")
  print("  anotherBool offset: \(MemoryLayout<Thing1>.offset(of: \.anotherBool)!)")
  print("  short offset: \(MemoryLayout<Thing1>.offset(of: \.short)!)")
  print("  anotherInt offset: \(MemoryLayout<Thing1>.offset(of: \.anotherInt)!)")

print("------------------------------")

print("Thing 2")
  print("  size: \(MemoryLayout<Thing2>.size)")
  print("  stride: \(MemoryLayout<Thing2>.stride)")
  print("  alignment: \(MemoryLayout<Thing2>.alignment)")
  print("")
  print("  anInt offset: \(MemoryLayout<Thing2>.offset(of: \.anInt)!)")
  print("  anotherInt offset: \(MemoryLayout<Thing2>.offset(of: \.anotherInt)!)")
  print("  aBool offset: \(MemoryLayout<Thing2>.offset(of: \.aBool)!)")
  print("  anotherBool offset: \(MemoryLayout<Thing2>.offset(of: \.anotherBool)!)")
  print("  short offset: \(MemoryLayout<Thing2>.offset(of: \.short)!)")
