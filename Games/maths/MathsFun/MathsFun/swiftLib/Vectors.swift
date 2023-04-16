import Foundation

private func absRelFPCompare(_ x: Double, _ y: Double) -> Bool {
    let absolute = fabs(x - y) <= Double.ulpOfOne
    let relative = fmax(1.0, fmax(fabs(x), fabs(y)))
    return absolute && relative != 0
}

struct Vec2: Equatable {
    var asArray: [Double]
    var x: Double { return asArray[0] }
    var y: Double { return asArray[1] }

    init() {
        asArray = [0, 0]
    }

    init(x: Double, y: Double) {
        asArray = [x, y]
    }

    static func +(lhs: Vec2, rhs: Vec2) -> Vec2 {
        return Vec2(x: lhs.x + rhs.x,
                    y: lhs.y + rhs.y)
    }

    static func -(lhs: Vec2, rhs: Vec2) -> Vec2 {
        return Vec2(x: lhs.x - rhs.x,
                    y: lhs.y - rhs.y)
    }

    static func *(lhs: Vec2, rhs: Vec2) -> Vec2 {
        return Vec2(x: lhs.x * rhs.x,
                    y: lhs.y * rhs.y)
    }

    static func *(lhs: Vec2, rhs: Double) -> Vec2 {
        return Vec2(x: lhs.x * rhs,
                    y: lhs.y * rhs)
    }

    static func ==(lhs: Vec2, rhs: Vec2) -> Bool {
        return absRelFPCompare(lhs.x, rhs.x) && absRelFPCompare(lhs.y, rhs.y)
    }
}

struct Vec3 {
    var asArray: [Double]
    var x: Double { return asArray[0] }
    var y: Double { return asArray[1] }
    var z: Double { return asArray[2] }

    init() {
        asArray = [0, 0, 0]
    }

    init(x: Double, y: Double, z: Double) {
        asArray = [x, y, z]
    }
}


