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
