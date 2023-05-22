import Cocoa

class SimpleCollisions: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    }
}

class SimpleCollisionsView: NSView {
    var circles: [CircleItem] = [
      CircleItem(circle: Circle(100, 100, 30)),
      CircleItem(circle: Circle(200, 250, 57)),
      CircleItem(circle: Circle(150, 75, 15))
    ]

    var rectangles: [RectangleItem] = [
      RectangleItem(rectangle: Rectangle2D(10, 10, 50, 30)),
      RectangleItem(rectangle: Rectangle2D(240, 100, 80, 100)),
      RectangleItem(rectangle: Rectangle2D(170, 95, 15, 15))
    ]

    var orientedRectangles: [OrientedRectangleItem] = [
      OrientedRectangleItem(orientedRectangle: OrientedRectangle(
                              position: Point2D(x: 337, y: 265),
                              halfExtents: Vec2(x: 60, y: 30),
                              rotation: 66.0)),
      OrientedRectangleItem(orientedRectangle: OrientedRectangle(
                              position: Point2D(x: 115, y: 192),
                              halfExtents: Vec2(x: 20, y: 70),
                              rotation: 123.0))
    ]


    var trackingItem: DraggableItem?
    var trackingDelta: CGSize?

    var draggables: [DraggableItem] {
        circles + rectangles + orientedRectangles
    }

    override func draw(_ dirtyRect: NSRect) {
        let rect = bounds

        NSColor.white.set()
        rect.fill()

        NSColor.purple.set()
        for item in draggables {
            item.draw()
        }

        NSColor.black.set()
        rect.frame()
    }

    private func unhighlightEverybody() {
        for var item in draggables {
            item.highlighted = false
        }
    }

    private func hitTestShapes(_ point: CGPoint) {

        for item in draggables {
            if item.hitTest(point) {
                trackingItem = item
                trackingDelta = item.clickDelta(from: point)
                break
            }
        }
        needsDisplay = true
    }

    private func updateCollisions() {
        unhighlightEverybody()

        // not interested in performance yet
        for citem1 in circles {
            for citem2 in circles {
                if citem1 === citem2 { continue }

                if citem1.circle.intersects(citem2.circle) {
                    citem1.highlighted = true
                    citem2.highlighted = true
                }
            }
            for rect in rectangles {
                if citem1.circle.intersects(rect.rectangle) {
                    citem1.highlighted = true
                    rect.highlighted = true
                }
            }
            for orect in orientedRectangles {
                if citem1.circle.intersects(orect.orientedRectangle) {
                    citem1.highlighted = true
                    orect.highlighted = true
                }
            }
        }

        // test rectangles against rectangles
        for ritem1 in rectangles {
            for rect in rectangles {
                if ritem1 === rect { continue }
                if ritem1.rectangle.intersects(rect.rectangle) {
                    ritem1.highlighted = true
                    rect.highlighted = true
                }
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
        guard let trackingItem, let trackingDelta else { return }

        let localPoint = convert(event.locationInWindow, from: nil) + trackingDelta
        trackingItem.moveTo(localPoint)

        updateCollisions()
    }
    
    override func mouseUp(with event: NSEvent) {
        trackingItem = nil
        trackingDelta = nil
    }
    
    override func scrollWheel(with event: NSEvent) {
        let localPoint = convert(event.locationInWindow, from: nil)

        for orect in orientedRectangles {
            if orect.orientedRectangle.contains(Point2D(localPoint)) {
                orect.orientedRectangle.rotationDegrees -= event.deltaY
                updateCollisions()
                break
            }
        }
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

protocol DraggableItem {
    var highlighted: Bool { get set }
    func draw()
    func hitTest(_ cgpoint: CGPoint) -> Bool
    func clickDelta(from cgpoint: CGPoint) -> CGSize
    func moveTo(_ cgpoint: CGPoint)
}

class CircleItem: DraggableItem {
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

class RectangleItem: DraggableItem {
    var rectangle = Rectangle2D(0, 0, 0, 0)
    var highlighted = false

    init() {
    }

    init(rectangle: Rectangle2D) {
        self.rectangle = rectangle
    }
    
    func draw() {
        rectangle.draw(fill: highlighted)
    }

    func hitTest(_ cgpoint: CGPoint) -> Bool {
        let point = Point2D(cgpoint)
        return rectangle.contains(point)
    }

    func clickDelta(from cgpoint: CGPoint) -> CGSize {
        let origin = rectangle.origin.cgPoint
        return origin - cgpoint
    }
    
    func moveTo(_ cgpoint: CGPoint) {
        rectangle.origin = Point2D(cgpoint)
    }
}

class OrientedRectangleItem: DraggableItem {
    var orientedRectangle = OrientedRectangle(position: Point2D(), halfExtents: Vec2())
    var highlighted = false

    init() {
    }

    init(orientedRectangle: OrientedRectangle) {
        self.orientedRectangle = orientedRectangle
    }
    
    func draw() {
        orientedRectangle.draw(fill: highlighted)
    }

    func hitTest(_ cgpoint: CGPoint) -> Bool {
        let point = Point2D(cgpoint)
        return orientedRectangle.contains(point)
    }

    func clickDelta(from cgpoint: CGPoint) -> CGSize {
        let origin = orientedRectangle.position.cgPoint
        return origin - cgpoint
    }
    
    func moveTo(_ cgpoint: CGPoint) {
        orientedRectangle.position = Point2D(cgpoint)
    }
}
