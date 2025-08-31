#!/usr/bin/swift

import Foundation

print("This won't run stand-o-lone, due to annoying in building the tree nodes from an array")
exit(0)

// https://leetcode.com/problems/invert-binary-tree/
// invert binary tree

public class TreeNode: CustomDebugStringConvertible {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?

    public init() { self.val = 0; self.left = nil; self.right = nil; }
    public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }

    public var debugDescription: String {
        "\(val) L: \(String(describing: left)) R: \(String(describing: right))"
    }
}


class Solution {
    func invertTree(_ root: TreeNode?) -> TreeNode? {
        guard let root = root else { return nil }
        
        func swapChildren(_ node: TreeNode?) {
            guard let node = node else { return }
            let temp = node.left
            node.left = node.right
            node.right = temp
            swapChildren(node.left)
            swapChildren(node.right)
        }
        swapChildren(root)
        return root
    }
}

let sol = Solution()

func treeify(_ values: [Int]) -> TreeNode {
    var values = values

    let root = TreeNode(values.removeFirst())

    var leftChild: TreeNode?
    var rightChild: TreeNode?

    if !values.isEmpty {
        leftChild = TreeNode(values.removeFirst())
        if !values.isEmpty {
            rightChild = TreeNode(values.removeFirst())
        }
    }

    root.left = leftChild
    root.right = rightChild

    // more to do

    return root
}

func flattened(_ root: TreeNode?) -> [Int] {
    guard let root else { return [] }

    return []
}

let input1 = treeify([4, 2, 7, 1, 3, 6, 9])
let expected1 = [4, 7, 2, 9, 6, 3, 1]

//let input2 = treeify([2, 1, 3])
//let expected2 = [2, 3, 1]


if flattened(sol.invertTree(input1)) != expected1 {
    print("failed 1")
}
/*
if flattened(sol.invertTree(input2)) != expected2 {
    print("failed 2")
}
*/
