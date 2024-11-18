import Foundation

struct FibboGenerator: AsyncSequence, AsyncIteratorProtocol {
    var thing1 = 1
    var thing2 = 1
    
    mutating func next() async -> Int? {
        let next = thing1 + thing2
        thing1 = thing2
        thing2 = next
        return next < 10_000_000_000_000 ? next : nil
    }

    func makeAsyncIterator() -> FibboGenerator {
        self
    }
}

let sequence = FibboGenerator()



var i = 0
for await number in sequence {
    print(i, number)
    i += 1
    if i > 42 {
        break
    }
}
