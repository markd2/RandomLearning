#!/usr/bin/swift

// given a list of stock prices over time, figure out an optimal single
// transaction (buy one day, sell later day) to maximize profit(!)
//   https://leetcode.com/problems/best-time-to-buy-and-sell-stock/

import Foundation


class Solution {
   func maxProfit(_ prices: [Int]) -> Int {
       var maxProfit = 0

       var buyScan = 0
       var sellScan = 1

       while sellScan < prices.count {
           let profit = prices[sellScan] - prices[buyScan]
           maxProfit = max(maxProfit, profit)

           // if prices[sellScan] < prices[buyScan] {
           if profit < 0 {
               buyScan = sellScan
           }
           sellScan += 1
       }

       return maxProfit
   }
}

let sol = Solution()

let input1 = [7,1,5,3,6,4]
let expected1 = 5

let input2 = [7,6,4,3,1]
let expected2 = 0

if sol.maxProfit(input1) != expected1 {
    print("failed 1")
}
if sol.maxProfit(input2) != expected2 {
    print("failed 2")
}
