import AppKit
import Quartz

class OOPDungeonView: NSView {
    var dungeon: Dungeon!
    var player: Player!

    override var acceptsFirstResponder: Bool { return true }

    override func draw(_ rect: CGRect) {
        NSColor.lightGray.set()
        NSBezierPath.fill(rect)
        defer { 
            NSColor.black.set()
            NSBezierPath.stroke(rect)
        }

        guard let dungeon = dungeon else { return }

        for room in dungeon.rooms {
            room.draw(highlighted: room == player.currentRoom)
        }
    }

    override var isFlipped: Bool { return true }
}

