import Foundation

struct Value {
    let value: Int
    
    func accept(visitor: ASTVisitor) {
        return visitor.visitValue(value: self)
    }
}

enum Token {
    case add
    case subtract
    case multiply
    case divide
    
    func accept(visitor: ASTVisitor) {
        return visitor.visitToken(token: self)
    }

}

class Binary {
    let left: Value
    let op: Token
    let right: Value

    func accept(visitor: ASTVisitor) {
        return visitor.visitBinary(binary: self)
    }
    
    internal init(left: Value, op: Token, right: Value) {
        self.left = left
        self.op = op
        self.right = right
    }
    
    func evaluateValue() -> Int {
        switch op {
        case .add: return left.value + right.value
        case .subtract: return left.value - right.value
        case .multiply: return left.value * right.value
        case .divide: return left.value / right.value
        }
    }
}

// --------------------------------------------------

protocol ASTVisitor {
    func visitValue(value: Value)
    func visitToken(token: Token)
    func visitBinary(binary: Binary)
}

// --------------------------------------------------

let blah = Binary(left: Value(value: 23),
                  op: .add,
                  right: Value(value: 42))
                  
print("evaluating value: \(blah.evaluateValue())\n")


class Printer: ASTVisitor {
    func visitValue(value: Value) {
        print(value.value)
    }

    func visitToken(token: Token) {
        switch token {
        case .add: print("+")
        case .subtract: print("-")
        case .multiply: print("x")
        case .divide: print("/")
        }
    }

    func visitBinary(binary: Binary) {
        binary.left.accept(visitor: self)
        binary.op.accept(visitor: self)
        binary.right.accept(visitor: self)
    }
}

let printer = Printer()
print("'pretty' print")
blah.accept(visitor: printer)

// --------------------------------------------------

// Verify that all values are even
class Evenator: ASTVisitor {
    var isValid = true

    func visitValue(value: Value) {
        if value.value % 2 == 1 {
            isValid = false
            print("ERROR - \(value.value) is not even")
        }
    }

    func visitToken(token: Token) {
        // nobody home
    }

    func visitBinary(binary: Binary) {
        binary.left.accept(visitor: self)
        binary.op.accept(visitor: self)
        binary.right.accept(visitor: self)
    }
}

print("\n")

let evenator = Evenator()
blah.accept(visitor: evenator)
if !evenator.isValid {
    print("SADGE")
}

print("\n")

