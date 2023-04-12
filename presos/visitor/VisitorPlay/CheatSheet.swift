////
////  CheatSheet.swift
////  VisitorPlay
////
////  Created by markd on 3/9/23.
////
//
//import Foundation
//
//
//// --------------------------------------------------
//
//protocol ASTVisitor {
//    func visitValue(value: Value)
//    func visitToken(token: Token)
//    func visitBinary(binary: Binary)
//}
//
//
//class Printer: ASTVisitor {
//    func visitValue(value: Value) {
//        print(value.value)
//    }
//
//    func visitToken(token: Token) {
//        switch token {
//        case .add: print("+")
//        case .subtract: print("-")
//        case .multiply: print("x")
//        case .divide: print("/")
//        }
//    }
//
//    func visitBinary(binary: Binary) {
//        binary.left.accept(visitor: self)
//        binary.op.accept(visitor: self)
//        binary.right.accept(visitor: self)
//    }
//}
//
//let printer = Printer()
//print("'pretty' print")
//blah.accept(visitor: printer)
//
//
//
//
//
//// --------------------------------------------------
//
//// Verify that all values are even
//class Evenator: ASTVisitor {
//    var isValid = true
//
//    func visitValue(value: Value) {
//        if value.value % 2 == 1 {
//            isValid = false
//            print("ERROR - \(value.value) is not even")
//        }
//    }
//
//    func visitToken(token: Token) {
//        // nobody home
//    }
//
//    func visitBinary(binary: Binary) {
//        binary.left.accept(visitor: self)
//        binary.op.accept(visitor: self)
//        binary.right.accept(visitor: self)
//    }
//}
//
//print("\n")
//
//let evenator = Evenator()
//blah.accept(visitor: evenator)
//if !evenator.isValid {
//    print("SADGE")
//}
//
//print("\n")
//
//
