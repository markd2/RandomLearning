import Cocoa;

class PlaypenView: NSView {

    struct Vector {
        let interactable: Bool
        var origin: CGPoint
        var vector: Vec2
        
        func endpoints(radius: CGFloat) -> (origin: CGRect, vector: CGRect) {
            let originRect = CGRect.rect(centeredAt: origin, radius: radius)
            let vectorRect = CGRect.rect(centeredAt: vector.cgPoint, radius: radius)
            return (originRect, vectorRect)
        }
    }

    var vectors: [Vector] = []

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
        linePath.line(to: vector.vector.cgPoint)
        linePath.stroke()

        if vector.interactable {

            let radius: CGFloat = 10
            let (originRect, vectorRect) = vector.endpoints(radius: radius)

            let originPath = NSBezierPath(ovalIn: originRect)
            let vectorPath = NSBezierPath(ovalIn: vectorRect)

            NSColor.red.set()
            originPath.fill()
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


extension CGRect {
    /// Radius is kind of weird for a rectangle call, but this is
    /// a call for generating a rectangle around a circle to give to
    /// something (say a BezierPath)
    static func rect(centeredAt: CGPoint, radius: CGFloat) -> CGRect {
        CGRect(x: centeredAt.x - radius / 2.0, y: centeredAt.y - radius / 2.0,
               width: radius, height: radius)
    }
}
