import AppKit

class DoDDungeonView: NSView {
    var dungeon: Dungeon!

    override var acceptsFirstResponder: Bool { return true }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
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

        dungeon.doors.storage.forEach { door in
            drawDoor(door)
        }

    }

    func drawRoom(_ room: Room) {
        if room.id != dungeon.playerRoom {
            NSColor.white.set()
        } else {
            NSColor.yellow.set()
        }
        NSBezierPath.fill(room.bounds)
        NSColor.black.set()
        NSBezierPath.stroke(room.bounds)

        let titleRect = room.bounds.insetBy(dx: 5, dy: 1)
        (room.name as NSString).draw(in: titleRect)
    }

    func drawDoor(_ door: Door) {
        let roomIds = dungeon.roomDoor.roomsForDoorId(door.id)
        guard roomIds.count == 2 else {
            fatalError("expecting exactly two rooms for door ID")
        }

        let fromRoom = dungeon.rooms.roomForId(roomIds[0])
        let toRoom = dungeon.rooms.roomForId(roomIds[1])

        let startBounds = fromRoom.bounds
        let endBounds = toRoom.bounds

        let union = startBounds.union(endBounds)
        var doorBounds = union
        if union.width > union.height {
            let height: CGFloat = 7
            doorBounds.origin.x = doorBounds.origin.x + startBounds.width
            doorBounds.size.width = endBounds.minX - startBounds.maxX
            doorBounds.size.height = height
            doorBounds.origin.y += (union.height / 2.0) - height / 2.0
        } else {
            let width: CGFloat = 10
            doorBounds.origin.y = doorBounds.origin.y + startBounds.height
            doorBounds.size.height = endBounds.minY - startBounds.maxY
            doorBounds.size.width = width
            doorBounds.origin.x += (union.width / 2.0) - width / 2.0
        }
        
        if !door.locked {
            NSColor.brown.set()
            NSBezierPath.fill(doorBounds)
        }
        NSColor.black.set()
        NSBezierPath.stroke(doorBounds)
        
    }

    // we're aflippa da bitz
    override var isFlipped: Bool { return true }
}

