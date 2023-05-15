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
    
    override func draw(_ dirtyRect: NSRect) {
        let rect = bounds

        NSColor.white.set()
        rect.fill()

        NSColor.orange.set()
        lines.forEach { $0.draw() }

        NSColor.purple.set()
        circles.forEach { $0.draw() }

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


extension NSBezierPath {
    static func strokeLine(from: Point2D, to: Point2D) {
        strokeLine(from: from.cgPoint, to: to.cgPoint)
    }
}

