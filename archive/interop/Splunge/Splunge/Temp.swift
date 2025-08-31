//
//  Temp.swift
//  Splunge
//
//  Created by Mark Dalrymple on 11/20/23.
//

import Foundation


public struct Temperature {
    public var celsius: Double
    public init(celsius: Double) {
        self.celsius = celsius
    }
    public init() {
        self.celsius = 0
    }
}
