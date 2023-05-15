import Foundation

typealias Point2D = Vec2

struct Line2D: Equatable {
    let start: Point2D
    let end: Point2D

    init(start: Point2D, end: Point2D) {
        self.start = start
        self.end = end
    }

    init(_ contents: Double...) {
        self.start = Point2D(x: contents[0], y: contents[1])
        self.end = Point2D(x: contents[2], y: contents[3])
    }

    var length: Double {
        (end - start).magnitude
    }

    var lengthSquared: Double {
        (end - start).magnitudeSquared
    }

    func contains(_ point: Point2D?) -> Bool {
        guard let point else { return false }

        let dx = end.x - start.x
        let dy = end.y - start.y
        let m = dy / dx
        let b = start.y - m * start.x
        return absRelFPCompare(point.y, m * point.x + b)
    }
}

struct Circle: Equatable {
    let position: Point2D
    let radius: Double

    init(position: Point2D, radius: Double) {
        self.position = position
        self.radius = radius
    }

    init(_ contents: Double...) {
        self.position = Point2D(x: contents[0], y: contents[1])
        self.radius = contents[2]
    }

    func contains(_ point: Point2D?) -> Bool {
        guard let point else { return false }

        let line = Line2D(start: point, end: position)
        if line.lengthSquared < radius * radius {
            return true
        }
        return false
    }
}

struct Rectangle2D: Equatable {
    let origin: Point2D
    let size: Vec2

    init(origin: Point2D, size: Vec2) {
        self.origin = origin
        self.size = size
    }

    init(_ contents: Double...) {
        self.origin = Point2D(x: contents[0], y: contents[1])
        self.size = Vec2(x: contents[2], y: contents[3])
    }

    static func fromMinMax(min: Vec2, max: Vec2) -> Rectangle2D {
        Rectangle2D(origin: min, size: max - min)
    }

    var min: Vec2 {
        let p1 = origin
        let p2 = origin + size
        return Vec2(x: fmin(p1.x, p2.x), y: fmin(p1.y, p2.y))
    }

    var max: Vec2 {
        let p1 = origin
        let p2 = origin + size
        return Vec2(x: fmax(p1.x, p2.x), y: fmax(p1.y, p2.y))
    }

    func contains(_ point: Point2D?) -> Bool {
        guard let point else { return false }

        let min = self.min
        let max = self.max

        return min.x <= point.x
          && min.y <= point.y
          && point.x <= max.x
          && point.y <= max.y
    }
}

struct OrientedRectangle: Equatable {
    let position: Point2D
    let halfExtents: Vec2
    let rotationDegrees: Double

    init() {
        self.position = Point2D()
        self.halfExtents = Vec2(x: 1.0, y: 1.0)
        self.rotationDegrees = 0.0
    }

    init(position: Point2D, halfExtents: Vec2) {
        self.position = position
        self.halfExtents = halfExtents
        self.rotationDegrees = 0.0
    }

    init(position: Point2D, halfExtents: Vec2, rotation: Double) {
        self.position = position
        self.halfExtents = halfExtents
        self.rotationDegrees = rotation
    }

    func contains(_ point: Point2D?) -> Bool {
        guard let point else { return false }

        let theta = -rotationDegrees.degreesToRadians
        let zRotation2x2 = Mat2(
          cos(theta), sin(theta),
          -sin(theta), cos(theta))

        let rotVector = (point - position) * zRotation2x2
        
        let localRectangle = Rectangle2D(origin: Point2D(),
                                         size: halfExtents * 2.0)
        let localPoint = rotVector + halfExtents
        return localRectangle.contains(localPoint)
    }
}
