// swiftc -O any-some.swift -o any-some

struct Thing1 { // size 32, stride 32, alignment 8
    let aBool: Bool = false
    let anInt: Int = 0
    let anotherBool: Bool = false
    let short: Int16 = 0 
    let anotherInt: Int = 0
}

struct Thing2 { // size 20, stride 24, alignment 8
    let anInt: Int = 0
    let anotherInt: Int = 0
    let aBool: Bool = false
    let anotherBool: Bool = false
    let short: Int16 = 0
}

protocol Snorgle {
    var anInt: Int { get }
#if false
    var aBool: Bool { get }
    var anotherInt: Int { get }
    var anotherBool: Bool { get }
    var short: Int16 { get }
#endif
}

extension Thing1: Snorgle { }
extension Thing2: Snorgle { }

let thing1 = Thing1()
let thing2 = Thing2()

print("----------")
func anySnorgles(snorgles: [Snorgle]) {
    print("  size: \(MemoryLayout<Snorgle>.size)")
    print("  stride: \(MemoryLayout<Snorgle>.stride)")
    print("  alignment: \(MemoryLayout<Snorgle>.alignment)")
}

print("calling [Snorgle]")
anySnorgles(snorgles: [thing1, thing2])




#if true

print("----------")
print("calling generic some Snorgle")

func someSnorgle<T: Snorgle>(_ t: T) {
    print("  size: \(MemoryLayout<T>.size)")
    print("  stride: \(MemoryLayout<T>.stride)")
    print("  alignment: \(MemoryLayout<T>.alignment)")
}

someSnorgle(thing1)
print("")
someSnorgle(thing2)

#if false

print("----------")

func someSnorgles<T: Snorgle>(snorgles: [T]) {
    print("  size: \(MemoryLayout<T>.size)")
    print("  stride: \(MemoryLayout<T>.stride)")
    print("  alignment: \(MemoryLayout<T>.alignment)")
}

print("calling generic array Snorgle")
someSnorgles(snorgles: [thing1])
print("")
someSnorgles(snorgles: [thing2])
print("")
someSnorgles(snorgles: [thing1, thing1])
// someSnorgles(snorgles: [thing1, thing2])

#endif
#endif
