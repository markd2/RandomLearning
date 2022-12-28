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

        dungeon.rooms.storage.forEach { room in
            drawRoom(room)
        }

    }

    func drawRoom(_ room: Room) {
        NSColor.white.set()
        NSBezierPath.fill(room.bounds)
        NSColor.black.set()
        NSBezierPath.stroke(room.bounds)

        let titleRect = room.bounds.insetBy(dx: 5, dy: 1)
        (room.name as NSString).draw(in: titleRect)
    }

    // we're aflippa da bitz
    override var isFlipped: Bool { return true }
}

