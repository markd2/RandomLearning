import Cocoa;

class PlaypenView: NSView {

    struct Vector {
        let interactable: Bool
        var origin: CGPoint
        var vector: Vec2
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

        let bezPath = NSBezierPath()
        bezPath.lineWidth = lineWidth

        bezPath.removeAllPoints()
        bezPath.move(to: vector.origin)
        bezPath.line(to: vector.vector.cgPoint)

        bezPath.stroke()
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
