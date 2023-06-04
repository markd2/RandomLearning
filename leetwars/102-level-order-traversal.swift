#!/usr/bin/swift

import Foundation

// https://leetcode.com/problems/binary-tree-level-order-traversal/description/
// level order traversal (a.k.a. BFS)

print("This won't run stand-o-lone, due to annoying in building the tree nodes from an array")
exit(0)

/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     public var val: Int
 *     public var left: TreeNode?
 *     public var right: TreeNode?
 *     public init() { self.val = 0; self.left = nil; self.right = nil; }
 *     public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
 *     public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
 *         self.val = val
 *         self.left = left
 *         self.right = right
 *     }
 * }
 */
class Solution {
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        // Breadth-first search
        // have result list
        // have a queue (prime with root)
        // make a new sublist
        // for each element in the queue
        //   pop it off the front, put its value in a list
        //   add its children to the back of the queue
        // if new sublist is not empty
        //   add to the result list

        var queue: [TreeNode?] = []
        queue.append(root)

        var result: [[Int]] = []

        while !queue.isEmpty {
            var list: [Int] = []
            let popCount = queue.count

            for _ in 0 ..< popCount {
                if let node = queue.removeFirst() {
                    list.append(node.val)
                    queue.append(node.left)
                    queue.append(node.right)
                }
            }

            if !list.isEmpty {
                result.append(list)
            }
        }


        return result
    }
}
