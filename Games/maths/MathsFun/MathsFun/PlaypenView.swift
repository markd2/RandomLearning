import Cocoa;

class PlaypenView: NSView {

    class Vector {
        let interactable: Bool
        var origin: CGPoint
        var vector: Vec2

        init(interactable: Bool, origin: CGPoint, vector: Vec2) {
            self.interactable = interactable
            self.origin = origin
            self.vector = vector
        }
        
        func endpoints(radius: CGFloat) -> (origin: CGRect, vector: CGRect) {

            let originRect = CGRect.rect(centeredAt: origin, radius: radius)
            let vectorRect = CGRect.rect(centeredAt: origin.offsetBy(vector), 
                                         radius: radius)
            return (originRect, vectorRect)
        }
    }

    var vectors: [Vector] = []
    let radius: CGFloat = 10

    var trackingVector: Vector?
    enum TrackingItem {
        case origin
        case vector
    }
    var trackingItem: TrackingItem?

    private func render(vector: Vector) {
        let lineWidth: CGFloat
        if vector.interactable {
            NSColor.black.set()
            lineWidth = 2.0
        } else {
            NSColor.lightGray.set()
            lineWidth = 1.0
        }

        let linePath = NSBezierPath()
        linePath.lineWidth = lineWidth

        linePath.removeAllPoints()
        linePath.move(to: vector.origin)
        linePath.line(to: vector.origin.offsetBy(vector.vector))
        linePath.stroke()

        if vector.interactable {
            let (originRect, vectorRect) = vector.endpoints(radius: radius)

            let originPath = NSBezierPath(ovalIn: originRect)
            let vectorPath = NSBezierPath(ovalIn: vectorRect)

            NSColor.red.set()
            originPath.fill()
            NSColor.purple.set()
            vectorPath.fill()

            NSColor.black.set()
            originPath.stroke()
            vectorPath.stroke()
        }
    }

    func add(vector: Vector) {
        vectors.append(vector)
        needsDisplay = true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        let rect = bounds

        NSColor.white.set()
        rect.fill()

        vectors.forEach(render)

        NSColor.black.set()
        rect.frame()
    }

    override var isFlipped: Bool { return true }

    

} // PlaypenView

extension PlaypenView {
    override func mouseDown(with event: NSEvent) {
        let localPoint = convert(event.locationInWindow, from: nil)

        vectors.filter { $0.interactable }.forEach { vector in
            let (originRect, vectorRect) = vector.endpoints(radius: radius)
            if originRect.contains(localPoint) {
                trackingVector = vector
                trackingItem = .origin
            } else if vectorRect.contains(localPoint) {
                trackingVector = vector
                trackingItem = .vector
            }
        }
    }
    
    private func dragTo(point: CGPoint) {
        guard let trackingVector, let trackingItem else { return }

        switch trackingItem {
        case .origin:
            trackingVector.origin = point
        case .vector:
            let origin = trackingVector.origin
            trackingVector.vector = Vec2(x: point.x - origin.x,
                                         y: point.y - origin.y)
        }
        needsDisplay = true
    }
    
    override func mouseDragged(with event: NSEvent) {
        let localPoint = convert(event.locationInWindow, from: nil)
        dragTo(point: localPoint)
    }
    
    override func mouseUp(with event: NSEvent) {
        trackingVector = nil
        trackingItem = nil
    }
}


extension CGRect {
    /// Radius is kind of weird for a rectangle call, but this is
    /// a call for generating a rectangle around a circle to give to
    /// something (say a BezierPath)
    static func rect(centeredAt: CGPoint, radius: CGFloat) -> CGRect {
        CGRect(x: centeredAt.x - radius / 2.0, y: centeredAt.y - radius / 2.0,
               width: radius, height: radius)
    }
}
