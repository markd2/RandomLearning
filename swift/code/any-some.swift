// swiftc -O any-some.swift -o any-some

struct Thing1 {
    let aBool: Bool = false
    let anInt: Int = 0
    let anotherBool: Bool = false
    let short: Int16 = 0 
    let anotherInt: Int = 0
}

struct Thing2 {
    let anInt: Int = 0
    let anotherInt: Int = 0
    let aBool: Bool = false
    let anotherBool: Bool = false
    let short: Int16 = 0
}

protocol Snorgle {
    var anInt: Int { get }
    var aBool: Bool { get }
    var anotherInt: Int { get }
    var anotherBool: Bool { get }
    var short: Int16 { get }
}

extension Thing1: Snorgle { }
extension Thing2: Snorgle { }

func blah<T: Snorgle>(_ t: T) {
    print("  size: \(MemoryLayout<T>.size)")
    print("  stride: \(MemoryLayout<T>.stride)")
    print("  alignment: \(MemoryLayout<T>.alignment)")
}

func blahArray<T: Snorgle>(snorgles: [T]) {
    print("  size: \(MemoryLayout<T>.size)")
    print("  stride: \(MemoryLayout<T>.stride)")
    print("  alignment: \(MemoryLayout<T>.alignment)")
}

func blah2(snorgles: [any Snorgle]) {
    print("  size: \(MemoryLayout<any Snorgle>.size)")
    print("  stride: \(MemoryLayout<any Snorgle>.stride)")
    print("  alignment: \(MemoryLayout<any Snorgle>.alignment)")
}

let thing1 = Thing1()
let thing2 = Thing2()

print("----------")
print("calling generic some Snorgle")

blah(thing1)
blah(thing2)

print("----------")
print("calling generic array Snorgle")
blahArray(snorgles: [thing1])
blahArray(snorgles: [thing2])
blahArray(snorgles: [thing1, thing1])
// blahArray(snorgles: [thing1, thing2]) // error - conflicting arguments to generic parameter T


print("----------")
print("calling [any Snorgle]")

blah2(snorgles: [thing1, thing2])

