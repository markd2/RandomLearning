import AppKit

class DoDDungeonView: NSView {
    var dungeon: Dungeon!

    override func viewDidMoveToWindow() {
        self.window?.backgroundColor = .purple
    }

    override func draw(_ rect: NSRect) {
        NSColor.lightGray.set()
        NSBezierPath.fill(rect)
        defer { 
            NSColor.black.set()
            NSBezierPath.stroke(rect)
        }

    }
}

