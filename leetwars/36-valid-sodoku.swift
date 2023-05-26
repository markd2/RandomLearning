#!/usr/bin/swift

// verify a soduoko board is valid (not necesasrily complete)
// https://leetcode.com/problems/valid-sudoku/

import Foundation


class Solution {
    func isValidSudoku(_ board: [[Character]]) -> Bool {
        // runtime 79ms, beats 63%, memory 14M, beats 74%
        func valid(row: Int) -> Bool {
            var bucket = Set<Character>()

            for column in 0 ..< 9 {
                let blah = board[row][column]
                if blah == "." { continue }
                if bucket.contains(blah) {
                    return false
                }
                bucket.insert(blah)
            }
            return true
        }
        func valid(column: Int) -> Bool {
            var bucket = Set<Character>()

            for row in 0 ..< 9 {
                let blah = board[row][column]
                if blah == "." { continue }
                if bucket.contains(blah) {
                    return false
                }
                bucket.insert(blah)
            }
            return true
        }
        func valid(house: Int) -> Bool {
            //   0 1 2 3 4 5 6 7 8 
            // 0
            // 1  =1=   =2=   =3=
            // 2
            // 3
            // 4  =4=   =5=   =6=
            // 5
            // 6
            // 7  =7=   =8=   =9=
            // 8
            let centers = [(1,1), (1,4), (1,7),
                           (4,1), (4,4), (4,7),
                           (7,1), (7,4), (7,7)]
            let (hrow, hcolumn) = centers[house]
            var bucket =  Set<Character>()
            for row in hrow-1 ... hrow+1 {
                for column in hcolumn-1 ... hcolumn+1 {
                    let blah = board[row][column]
                    if blah == "." { continue }
                    if bucket.contains(blah) {
                        return false
                    }
                    bucket.insert(blah)
                }
            }

            return true
        }
        
        for i in 0 ..< 9 {
            guard valid(row: i), valid(column: i), valid(house: i) else {
                return false
            }
        }
        return true
    }
}

let sol = Solution()

let input1: [[Character]] = [["5","3",".",".","7",".",".",".","."]
                            ,["6",".",".","1","9","5",".",".","."]
                            ,[".","9","8",".",".",".",".","6","."]
                            ,["8",".",".",".","6",".",".",".","3"]
                            ,["4",".",".","8",".","3",".",".","1"]
                            ,["7",".",".",".","2",".",".",".","6"]
                            ,[".","6",".",".",".",".","2","8","."]
                            ,[".",".",".","4","1","9",".",".","5"]
                            ,[".",".",".",".","8",".",".","7","9"]]
let expected1 = true

let input2: [[Character]] = [["8","3",".",".","7",".",".",".","."]
                            ,["6",".",".","1","9","5",".",".","."]
                            ,[".","9","8",".",".",".",".","6","."]
                            ,["8",".",".",".","6",".",".",".","3"]
                            ,["4",".",".","8",".","3",".",".","1"]
                            ,["7",".",".",".","2",".",".",".","6"]
                            ,[".","6",".",".",".",".","2","8","."]
                            ,[".",".",".","4","1","9",".",".","5"]
                            ,[".",".",".",".","8",".",".","7","9"]]
let expected2 = false

let input3: [[Character]] = [[".",".",".",".","5",".",".","1","."],
                             [".","4",".","3",".",".",".",".","."],
                             [".",".",".",".",".","3",".",".","1"],
                             ["8",".",".",".",".",".",".","2","."],
                             [".",".","2",".","7",".",".",".","."],
                             [".","1","5",".",".",".",".",".","."],
                             [".",".",".",".",".","2",".",".","."],
                             [".","2",".","9",".",".",".",".","."],
                             [".",".","4",".",".",".",".",".","."]]
let expected3 = false

if sol.isValidSudoku(input1) != expected1 {
    // too lazy to do proper "any order" checking, so eyeball this.
    print("failed 1")
}
if sol.isValidSudoku(input2) != expected2 {
    print("failed 2")
}
if sol.isValidSudoku(input3) != expected3 {
    print("failed 3")
}


