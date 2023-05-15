import Cocoa

class Geometry2DWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
}


class Geometry2DView: NSView {
    @Invalidating(.display) var lines: [Line2D] = [
        Line2D(10, 20, 60, 90),
        Line2D(40, 90, 90, 100)]
    
    override func draw(_ dirtyRect: NSRect) {
        let rect = bounds

        NSColor.white.set()
        rect.fill()

        NSColor.orange.set()
        lines.forEach { $0.draw() }

        NSColor.black.set()
        rect.frame()
    }
}

extension Line2D {
    func draw() {
        NSBezierPath.strokeLine(from: start, to: end)
    }
}


extension NSBezierPath {
    static func strokeLine(from: Point2D, to: Point2D) {
        strokeLine(from: from.cgPoint, to: to.cgPoint)
    }
}

