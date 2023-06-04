#!/usr/bin/swift

import Foundation

// https://leetcode.com/problems/maximum-depth-of-binary-tree/description/
// maximum depth of a binary tree

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
    func maxDepth(_ root: TreeNode?) -> Int {
        guard let root = root else {return 0}
        // if root.left == nil && root.right == nil { return 0 }        

        func diveDiveDive(_ root: TreeNode?, _ currentDepth: Int) -> Int {
            guard let root = root else { return currentDepth }
            var maxDepth = currentDepth
            if let left = root.left {
                let ldepth = diveDiveDive(root.left, currentDepth + 1)
                maxDepth = max(maxDepth, ldepth)
            }
            if let right = root.right {
                let rdepth = diveDiveDive(root.right, currentDepth + 1)
                maxDepth = max(maxDepth, rdepth)
            }
            return maxDepth
        }

        let blah = diveDiveDive(root, 01)
        return blah
    }
}

