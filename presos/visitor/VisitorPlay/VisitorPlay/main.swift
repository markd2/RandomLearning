import Foundation

struct Expr {
    let value: Int
}

enum Token {
    case add
    case subtract
    case multiply
    case divide
}

struct Binary {
    let left: Expr
    let op: Token
    let right: Expr

    func evaluateValue() -> Int {
        switch op {
        case .add: return left.value + right.value
        case .subtract: return left.value - right.value
        case .multiply: return left.value * right.value
        case .divide: return left.value / right.value
        }
    }
}


let blah = Binary(left: Expr(value: 23),
                  op: .add,
                  right: Expr(value: 42))
print(blah.evaluateValue())
