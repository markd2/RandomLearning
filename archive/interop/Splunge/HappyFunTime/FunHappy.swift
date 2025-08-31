//
//  FunHappy.swift
//  HappyFunTime
//
//  Created by Mark Dalrymple on 10/18/23.
//

import Foundation
public struct FunHappy {
    private let printInvocation: Bool
    
    public init(printInvocation: Bool) {
        self.printInvocation = printInvocation
    }

    public func happyfun(_ value: Double) -> Double {
        // Print the value if applicable.
        if printInvocation {
            print("[swift] happyfun(\(value))")
        }
        
        // Handle the base case of the recursion.
        guard value > 1.0 else {
            return 1.0
        }
        
        // Create the C++ `FibonacciCalculatorCplusplus` class and invoke its `fibonacci` method.
        let cxxCalculator = HappyFunCplusplus(printInvocation)
        return cxxCalculator.happyfun(value - 1.0) + cxxCalculator.happyfun(value - 2.0)
    }
}
