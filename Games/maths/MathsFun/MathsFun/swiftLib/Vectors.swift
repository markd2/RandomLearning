import Foundation

func absRelFPCompare(_ x: Double, _ y: Double) -> Bool {
    let absolute = fabs(x - y) <= Double.ulpOfOne * 10
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


    func dot(_ rhs: Vec2) -> Double {
        return x * rhs.x + y * rhs.y
    }

    var magnitude: Double {
        sqrt(dot(self))
    }

    var magnitudeSquared: Double {
        dot(self)
    }

    var normalized: Vec2 {
        self * (1.0 / magnitude)
    }

    mutating func normalize() {
        let v = self * (1.0 / magnitude)
        asArray = v.asArray
    }
}

struct Vec3: Equatable {
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

    static func +(lhs: Vec3, rhs: Vec3) -> Vec3 {
        return Vec3(x: lhs.x + rhs.x,
                    y: lhs.y + rhs.y,
                    z: lhs.z + rhs.z)
    }

    static func -(lhs: Vec3, rhs: Vec3) -> Vec3 {
        return Vec3(x: lhs.x - rhs.x,
                    y: lhs.y - rhs.y,
                    z: lhs.z - rhs.z)
    }

    static func *(lhs: Vec3, rhs: Vec3) -> Vec3 {
        return Vec3(x: lhs.x * rhs.x,
                    y: lhs.y * rhs.y,
                    z: lhs.z * rhs.z)
    }

    static func *(lhs: Vec3, rhs: Double) -> Vec3 {
        return Vec3(x: lhs.x * rhs,
                    y: lhs.y * rhs,
                    z: lhs.z * rhs)
    }

    static func ==(lhs: Vec3, rhs: Vec3) -> Bool {
        return absRelFPCompare(lhs.x, rhs.x) 
          && absRelFPCompare(lhs.y, rhs.y)
          && absRelFPCompare(lhs.z, rhs.z)
    }

    func dot(_ rhs: Vec3) -> Double {
        return x * rhs.x + y * rhs.y + z * rhs.z
    }

    var magnitude: Double {
        sqrt(dot(self))
    }

    var magnitudeSquared: Double {
        dot(self)
    }

    var normalized: Vec3 {
        self * (1.0 / magnitude)
    }

    mutating func normalize() {
        let v = self * (1.0 / magnitude)
        asArray = v.asArray
    }
}

func distance(_ pt1: Vec2, _ pt2: Vec2) -> Double {
    let connector = pt1 - pt2
    return connector.magnitude
}

func distance(_ pt1: Vec3, _ pt2: Vec3) -> Double {
    let connector = pt1 - pt2
    return connector.magnitude
}
