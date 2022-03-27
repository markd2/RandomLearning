#!/usr/bin/swift

// The goal of this exercise is to convert a string to a new string where
// each character in the new string is "(" if that character appears
// only once in the original string, or ")" if that character appears
// more than once in the original string. Ignore capitalization when
// determining if a character is a duplicate.

//Examples
// "din"      =>  "((("
// "recede"   =>  "()()()"
// "Success"  =>  ")())())"
// "(( @"     =>  "))((" 

// Notes
// Assertion messages may be unclear about what they display in some
// languages. If you read "...It Should encode XXX", the "XXX" is the
// expected result, not the input!

typealias Pair = (String, String)

let tests: [Pair] = [
  ("din", "((("),
  ("recede", "()()()"),
  ("Success", ")())())"),
  ("(( @", "))((" ),
]

func duplicateEncode(_ word: String) -> String {
    var charCount: [String: Int] = [:]

    for character in word.lowercased() {
        var count = charCount[String(character), default: 0]
        count += 1
        charCount[String(character)] = count
    }

    var blah = ""

    for character in word.lowercased() {
        let count = charCount[String(character)]
        blah += count == 1 ? "(" : ")"
    }
    return blah
}


var failwaffle = false

for test in tests {
    let words = test.0
    let spun = duplicateEncode(words)
    let expected = test.1

    if spun != expected {
        print("ut-oh: got \(spun), expected \(expected)")
        failwaffle = true
    }
}

if !failwaffle {
    print("success")
}
