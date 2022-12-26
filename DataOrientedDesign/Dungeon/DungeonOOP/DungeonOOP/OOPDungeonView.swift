import AppKit
import Quartz

class OOPDungeonView: NSView {

    override func draw(_ rect: CGRect) {
        NSColor.black.set()
        NSBezierPath.fill(rect)

        NSColor.white.set()
        NSBezierPath.stroke(rect)
    }
}

