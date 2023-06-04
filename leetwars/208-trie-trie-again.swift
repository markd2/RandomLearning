#!/usr/bin/swift

import Foundation

// https://leetcode.com/problems/implement-trie-prefix-tree/description/
// make a trie (prefix tree)

class Trie: CustomDebugStringConvertible {

    class TrieNode: CustomDebugStringConvertible {
        var value: String?  // only if this is an actual insert value
        var children: [Character: TrieNode] = [:]

        var debugDescription: String {
            "\((value != nil) ? "YAY" : "") \(children) "
        }
    }

    var root = TrieNode()

    init() {
    }
    
    func insert(_ word: String) {
        var scan: TrieNode? = root

        for character in word {
            let child = scan?.children[character, default: TrieNode()]
            scan?.children[character] = child
            scan = child
        }
        scan?.value = word
    }

    private func findNode(_ word: String) -> TrieNode? {
        // don't insert nodes
        var scan: TrieNode? = root

        for character in word {
            scan = scan?.children[character]
        }

        return scan
    }
    
    // is the actual word in the trie?
    func search(_ word: String) -> Bool {
        guard let node = findNode(word) else { return false }
        guard let value = node.value, value == word else { return false }

        return true
    }

    // is this prefix in the trie?
    func startsWith(_ prefix: String) -> Bool {
        let node = findNode(prefix)
        return node != nil
    }

    var debugDescription: String {
        "\(root)"
    }
}


let trie = Trie()


trie.insert("apple")
if trie.search("apple") != true {
    print("fail 1")
}

if trie.search("app") != false {
    print("fail 2")
}

if trie.startsWith("ap") != true {
    print("fail 3")
}

trie.insert("app")
if trie.search("app") != true {
    print("fail 4")
}
