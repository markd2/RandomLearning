import Foundation

struct Vec2 {
    var asArray: [Double]
    var x: Double { return asArray[0] }
    var y: Double { return asArray[1] }

    init() {
        asArray = [0, 0]
    }

    init(x: Double, y: Double) {
        asArray = [x, y]
    }
}
