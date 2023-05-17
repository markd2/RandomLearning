import Cocoa

class SimpleCollisions: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    }
}

class SimpleCollisionsView: NSView {
    var circles: [CircleItem] = [
      CircleItem(circle: Circle(100, 100, 30)),
      CircleItem(circle: Circle(200, 250, 57))
    ]

    var trackingCircle: CircleItem?
    var trackingDelta: CGSize?

    override func draw(_ dirtyRect: NSRect) {
        let rect = bounds

        NSColor.white.set()
        rect.fill()

        NSColor.purple.set()
        for circleItem in circles {
            circleItem.draw()
        }

        NSColor.black.set()
        rect.frame()
    }

    private func unhighlightEverybody() {
        for circleItem in circles {
            circleItem.highlighted = false
        }
    }

    private func hitTestShapes(_ point: CGPoint) {

        for circleItem in circles {
            if circleItem.hitTest(point) {
                trackingCircle = circleItem
                trackingDelta = circleItem.clickDelta(from: point)
                break
            }
        }
        needsDisplay = true
    }

    private func updateCollisions() {
        unhighlightEverybody()

        for citem1 in circles {
            for citem2 in circles {
            }
        }

        needsDisplay = true
    }
}

extension SimpleCollisionsView {
    override func mouseDown(with event: NSEvent) {
        let localPoint = convert(event.locationInWindow, from: nil)
        hitTestShapes(localPoint)
        updateCollisions()
    }
    
    override func mouseDragged(with event: NSEvent) {
        guard let trackingCircle, let trackingDelta else { return }

        let localPoint = convert(event.locationInWindow, from: nil) + trackingDelta
        trackingCircle.moveTo(localPoint)

        updateCollisions()
    }
    
    override func mouseUp(with event: NSEvent) {
    }
}

class CircleItem {
    var circle = Circle(0, 0, 0)
    var highlighted = false

    init() {
    }

    init(circle: Circle) {
        self.circle = circle
    }
    
    func draw() {
        circle.draw(fill: highlighted)
    }

    func hitTest(_ cgpoint: CGPoint) -> Bool {
        let point = Point2D(cgpoint)
        return circle.contains(point)
    }

    func clickDelta(from cgpoint: CGPoint) -> CGSize {
        let center = circle.position.cgPoint
        return center - cgpoint
    }
    
    func moveTo(_ cgpoint: CGPoint) {
        circle.position = Point2D(cgpoint)
    }
}

extension CGPoint {
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGSize {
        CGSize(width: lhs.x - rhs.x, height: lhs.y - rhs.y)
    }

    static func +(lhs: CGPoint, rhs: CGSize) -> CGPoint {
        CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
    }
}
