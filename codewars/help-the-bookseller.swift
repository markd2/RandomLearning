#!/usr/bin/swift

// https://www.codewars.com/kata/54dc6f5a224c26032800005c/swift

//  bookseller has lots of books classified in 26 categories labeled:
//   - categories: A, B, ... Z
//   - Each book has a code c of 3, 4, 5 or more characters. 
// The 1st character of a code is a capital letter which defines the book category.

// In the bookseller's stocklist each code c is followed by a space
// and by a positive integer n (int n >= 0) which indicates the
// quantity of books of this code in stock.

// e.g. L = {"ABART 20", "CDXEF 50", "BKWRK 25", "BTSQZ 89", "DRTYM 60"}.

// will be given a stock list (like above), and a list of categories:

// e.g. M = ["A", "B", "C", "W"]

// find all the books of L with codes belonging to each category M and sum their
// quantity

// return a string of the form "(A : 20) - (B : 114) - (C : 50) - (W : 0)"

// if either are empty, return ""

import Foundation


func stockList(_ stockList: [String], _ categories: [String]) -> String {
    guard stockList.count > 0, categories.count > 0 else { return "" }

    var acidComplaintDatabase: [String: Int] = [:]

    for stockItem in stockList {
        let itemAmount = stockItem.split(separator: " ")
        guard let value = Int(String(itemAmount[1])) else { return "bad data" }
        let itemCategory = String(itemAmount[0].prefix(1))
        acidComplaintDatabase[itemCategory, default: 0] += value
    }

    var accumulator: [String] = []

    for category in categories {
        accumulator.append("(\(category) : \(acidComplaintDatabase[category, default: 0]))")
    }

    return accumulator.joined(separator: " - ")
}

let list = ["BBAR 150", "CDXE 515", "BKWR 250", "BTSQ 890", "DRTY 600"]
let categories = ["A", "B", "C", "D"]
let expected = "(A : 0) - (B : 1290) - (C : 515) - (D : 600)"

let blah = stockList(list, categories)

if blah != expected {
    print("ut-oh: got: \(blah), expected \(expected)")
} else {
    print("success")
}

