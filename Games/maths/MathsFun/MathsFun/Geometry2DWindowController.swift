import Cocoa

class Geometry2DWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
}


class Geometry2DView: NSView {
    @Invalidating(.display)
    var lines: [Line2D] = [
      Line2D(10, 20, 60, 90),
      Line2D(40, 190, 90, 100)]

    @Invalidating(.display)
    var circles: [Circle] = [Circle(55, 55, 30), Circle(80, 120, 50)]

    @Invalidating(.display)
    var rectangles: [Rectangle2D] = [Rectangle2D(155, 155, 30, 20), Rectangle2D(180, 220, 50, 80)]

    @Invalidating(.display)
    var orientedRectangles: [OrientedRectangle] = [
      OrientedRectangle(position: Point2D(x: 200, y: 200),
                        halfExtents: Vec2(x: 60, y: 30),
                        rotation: 66.0)
    ]

    override func draw(_ dirtyRect: NSRect) {
        let rect = bounds

        NSColor.white.set()
        rect.fill()

        NSColor.orange.set()
        lines.forEach { $0.draw() }

        NSColor.purple.set()
        circles.forEach { $0.draw() }

        NSColor.gray.set()
        let unionish = Rectangle2D.fromMinMax(min: rectangles[0].min,
                                          max: rectangles[1].max)
        unionish.draw()

        NSColor.brown.set()
        rectangles.forEach { $0.draw() }

        NSColor.red.set()
        let line = Line2D(0, 0, 200, 200) // hardcode center of oriented rectangle
        line.draw()
        orientedRectangles.forEach { $0.draw() }

        NSColor.black.set()
        rect.frame()
    }
}

extension Line2D {
    func draw() {
        NSBezierPath.strokeLine(from: start, to: end)
    }
}

extension Circle {
    func draw() {
        let boundsRect = CGRect(x: position.x - radius,
                                y: position.y - radius,
                                width: radius * 2,
                                height: radius * 2)
        let bezpath = NSBezierPath(ovalIn: boundsRect)
        bezpath.stroke()
    }
}

extension Rectangle2D {
    func draw() {
        let tl = min
        let br = max
        let boundsRect = CGRect(x: tl.x, y: tl.y,
                                width: br.x - tl.x,
                                height: br.y - tl.y);
        NSBezierPath.stroke(boundsRect)
    }
}

extension OrientedRectangle {
    func draw() {
        NSGraphicsContext.saveGraphicsState()
        let xform = NSAffineTransform()
        xform.translateX(by: position.x, yBy: position.y)
        xform.rotate(byDegrees: rotationDegrees)
        xform.translateX(by: -position.x, yBy: -position.y)
        xform.concat()

        let rect = CGRect(x: position.x - halfExtents.x,
                          y: position.y - halfExtents.y,
                          width: halfExtents.x * 2,
                          height: halfExtents.y * 2)
        NSBezierPath.stroke(rect)

        NSGraphicsContext.restoreGraphicsState()
    }
}


extension NSBezierPath {
    static func strokeLine(from: Point2D, to: Point2D) {
        strokeLine(from: from.cgPoint, to: to.cgPoint)
    }
}

