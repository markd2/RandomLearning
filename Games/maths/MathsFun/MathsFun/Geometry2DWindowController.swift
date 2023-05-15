import Cocoa

class Geometry2DWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    }
}


class Geometry2DView: NSView {
    @Invalidating(.display)
    var trackingPoint: Point2D? = nil

    @Invalidating(.display)
    var lines: [Line2D] = [
      Line2D(10, 20, 60, 90),
      Line2D(40, 190, 90, 100)]

    @Invalidating(.display)
    var circles: [Circle] = [
      Circle(370, 10, 15),
      Circle(370, 30, 15),
      Circle(370, 50, 15),
      Circle(370, 70, 15),
      Circle(255, 75, 90),
      Circle(80, 120, 50)]

    @Invalidating(.display)
    var rectangles: [Rectangle2D] = [
      Rectangle2D(155, 155, 30, 20),
      Rectangle2D(50, 255, 88, 88),
      Rectangle2D(180, 220, 50, 80)]

    @Invalidating(.display)
    var orientedRectangles: [OrientedRectangle] = [
      OrientedRectangle(position: Point2D(x: 350, y: 200),
                        halfExtents: Vec2(x: 60, y: 30),
                        rotation: 66.0),
      OrientedRectangle(position: Point2D(x: 200, y: 350),
                        halfExtents: Vec2(x: 20, y: 70),
                        rotation: 123.0)
    ]

    override func draw(_ dirtyRect: NSRect) {
        let rect = bounds

        NSColor.white.set()
        rect.fill()

        NSColor.orange.set()
        lines.forEach { 
            let isHit = $0.contains(trackingPoint)
            $0.draw(fill: isHit)
        }

        NSColor.purple.set()
        circles.forEach {
            let isHit = $0.contains(trackingPoint)
            $0.draw(fill: isHit)
        }

        NSColor.brown.set()
        rectangles.forEach {
            let isHit = $0.contains(trackingPoint)
            $0.draw(fill: isHit)
        }

        NSColor.red.set()
        orientedRectangles.forEach {
            let isHit = $0.contains(trackingPoint)
            $0.draw(fill: isHit)
        }

        NSColor.black.set()
        rect.frame()
    }
}

extension Line2D {
    func draw(fill: Bool = false) {
        NSBezierPath.strokeLine(from: start, to: end)
    }
}

extension Circle {
    func draw(fill: Bool = false) {
        let boundsRect = CGRect(x: position.x - radius,
                                y: position.y - radius,
                                width: radius * 2,
                                height: radius * 2)
        let bezpath = NSBezierPath(ovalIn: boundsRect)
        if fill { bezpath.fill() }
        bezpath.stroke()
    }
}

extension Rectangle2D {
    func draw(fill: Bool = false) {
        let tl = min
        let br = max
        let boundsRect = CGRect(x: tl.x, y: tl.y,
                                width: br.x - tl.x,
                                height: br.y - tl.y);
        if fill { NSBezierPath.fill(boundsRect) }
        NSBezierPath.stroke(boundsRect)
    }
}

extension OrientedRectangle {
    func draw(fill: Bool = false) {
        NSGraphicsContext.saveGraphicsState()
        let xform = NSAffineTransform()
        xform.translateX(by: position.x, yBy: position.y)
        xform.rotate(byDegrees: -rotationDegrees)
        xform.translateX(by: -position.x, yBy: -position.y)
        xform.concat()

        let rect = CGRect(x: position.x - halfExtents.x,
                          y: position.y - halfExtents.y,
                          width: halfExtents.x * 2,
                          height: halfExtents.y * 2)
        if fill { NSBezierPath.fill(rect) }
        NSBezierPath.stroke(rect)

        NSGraphicsContext.restoreGraphicsState()
    }
}


extension NSBezierPath {
    static func strokeLine(from: Point2D, to: Point2D) {
        strokeLine(from: from.cgPoint, to: to.cgPoint)
    }
}

extension Geometry2DView {
    // can't use hitTest b/c NSView has one too
    private func hitTestShapes(_ point: CGPoint) {
        // lines are too thin to really hit-test

        for circle in circles {
            if circle.contains(Point2D(point)) {
                NSLog("Yay circle")
            }
        }

        for rectangle in rectangles {
            if rectangle.contains(Point2D(point)) {
                NSLog("Yay rectangle")
            }
        }

        for oriented in orientedRectangles {
            if oriented.contains(Point2D(point)) {
                NSLog("Yay oriented rectangle")
            }
        }
    }

    override func mouseDown(with event: NSEvent) {
        let localPoint = convert(event.locationInWindow, from: nil)
        hitTestShapes(localPoint)
        trackingPoint = Point2D(localPoint)
    }
    
    override func mouseDragged(with event: NSEvent) {
        let localPoint = convert(event.locationInWindow, from: nil)
        hitTestShapes(localPoint)
        trackingPoint = Point2D(localPoint)
    }
    
    override func mouseUp(with event: NSEvent) {
        trackingPoint = nil
    }
}
