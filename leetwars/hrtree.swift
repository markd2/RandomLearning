#!/usr/bin/swift

import Foundation
typealias FSNode = Node<Int>

class Node<T>: CustomDebugStringConvertible {
    var index: Int
    var value: T
    var children: [Node<T>] 

    init(index: Int, value: T) {
        self.index = index
        self.value = value
        self.children = []
    }

    func addChild(_ child: Node<T>) {
        children.append(child)
    }

    var isLeaf: Bool {
        children.count == 0
    }

    var debugDescription: String {
        "\(index): value: \(value), children: \(children)"
    }
}

func mostBalancedPartition(parent: [Int], files_size sizes: [Int]) -> Int {
    guard parent.count == sizes.count else { fatalError("bad input") }

    // Build a tree, starting with a pile of nodes
    var nodes = [FSNode]()
    for (index, size) in sizes.enumerated() {
        nodes.append(FSNode(index: index, value: size))
    }

    // hook up the connections
    for (index, me) in nodes.enumerated() {
        let pointer = parent[index]
        if pointer == -1 { continue }

        nodes[pointer].addChild(me)
    }

    // sanity check summing sizes in the tree vs the given array
    let sizeSum = sizes.reduce(0) { $0 + $1 }
    let subvalueSum = nodes[0].sumOfSubvalues()
    if sizeSum != subvalueSum { fatalError("recursive tree sum does not match given data") }

    // actualy do the work
    let minDifference = visitConnections(startingAt: nodes[0], totalSum: sizeSum)
    return minDifference
}

// Visit each of the children of this node. Break the tree at that connection,
// and calculate the size difference. Return the smallest difference of sizes
// between file systems rooted at the actual tree root and one rooted at the
// given node
//
// This is recursive, so start at the root, and this will chew all the way down.
//
// totalSum is the total sum of the tree (e.g. rootOfWholeTree.sumOfSubvalues())
//
func visitConnections(startingAt root: FSNode, totalSum: Int) -> Int {
    var minDifference = Int.max

    for child in root.children {
        let oneSum = child.sumOfSubvalues()
        let otherSum = totalSum - oneSum
        let difference = abs(oneSum - otherSum)
        minDifference = min(minDifference, difference)

        let recursiveDifference = visitConnections(startingAt: child, totalSum: totalSum)
        minDifference = min(recursiveDifference, minDifference)
    }
    return minDifference
}

extension Node where T == Int {
    func sumOfSubvalues() -> Int {
        var sum = value
        for child in children {
            sum += child.sumOfSubvalues()
        }
        return sum
    }
}

let parent1 = [-1, 0, 0, 1, 1, 2]
let size1 = [1, 2, 2, 1, 1, 1]
let n1 = 6
let expected1 = 0

let parent2 = [-1, 0, 0, 0]
let size2 = [ 10, 11, 10, 10 ]
let n2 = 4
let expected2 = 19

let parent3 = [-1, 0, 1, 2]
let size3 = [ 1, 4, 3, 4 ]
let n3 = 4
let expected3 = 2

if mostBalancedPartition(parent: parent1, files_size: size1) != expected1 {
    print("failed 1 got \(mostBalancedPartition(parent: parent1, files_size: size1)) expected \(expected1)")
}

if mostBalancedPartition(parent: parent2, files_size: size2) != expected2 {
    print("failed 2 got \(mostBalancedPartition(parent: parent2, files_size: size2)) expected \(expected2)")
}

if mostBalancedPartition(parent: parent3, files_size: size3) != expected3 {
    print("failed 3 got \(mostBalancedPartition(parent: parent3, files_size: size3)) expected \(expected3)")
}
