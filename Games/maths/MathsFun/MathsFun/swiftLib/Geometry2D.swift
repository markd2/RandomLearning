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
        self.end = Point2D(x: contents[1], y: contents[2])
    }

    var length: Double {
        (end - start).magnitude
    }

    var lengthSquared: Double {
        (end - start).magnitudeSquared
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

}

