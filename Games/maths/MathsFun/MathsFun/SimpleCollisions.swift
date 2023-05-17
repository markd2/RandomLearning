import Cocoa

class SimpleCollisions: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    }
}

class SimpleCollisionsView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        let rect = bounds

        NSColor.white.set()
        rect.fill()

        NSColor.black.set()
        rect.frame()
    }
}
