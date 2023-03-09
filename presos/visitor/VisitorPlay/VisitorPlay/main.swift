import Foundation

struct Expr {
    let value: Int
    
    func accept(visitor: ASTVisitor) {
        return visitor.visitExpr(expr: self)
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
    let left: Expr
    let op: Token
    let right: Expr

    func accept(visitor: ASTVisitor) {
        return visitor.visitBinary(binary: self)
    }
    
    internal init(left: Expr, op: Token, right: Expr) {
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
    func visitExpr(expr: Expr)
    func visitToken(token: Token)
    func visitBinary(binary: Binary)
}

// --------------------------------------------------

let blah = Binary(left: Expr(value: 23),
                  op: .add,
                  right: Expr(value: 42))
                  
print("evaluating value: \(blah.evaluateValue())\n")


class Printer: ASTVisitor {
    func visitExpr(expr: Expr) {
        print(expr.value)
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

    func visitExpr(expr: Expr) {
        if expr.value % 2 == 1 {
            isValid = false
            print("ERROR - \(expr.value) is not even")
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

let evenator = Evenator()
blah.accept(visitor: evenator)
if !evenator.isValid {
    print("SADGE")
}
