
import Foundation
import AppKit

class Dungeon {
    var name: String
    var rooms: [Room]

    init(name: String, rooms: [Room]) {
        self.name = name
        self.rooms = rooms
    }

    func connectedRooms(to room: Room) -> [Room] {
        let rooms = room.doors.map { ($0.side1 == room) ? $0.side2 : $0.side1 }
        return rooms
    }
}

class Room: Equatable {
    var id: UUID
    var name: String
    var bounds: CGRect
    var doors: [Door]
    
    init(name: String, bounds: CGRect, doors: [Door]) {
        id = UUID()
        self.name = name
        self.bounds = bounds
        self.doors = doors // there's a potential retain cycle
    }
    func doorConnectedTo(room: Room) -> Door? {
        let relatedDoors = doors.filter { $0.side1 == room || $0.side2 == room }
        guard relatedDoors.count <= 1 else { fatalError("multiple doors from \(name) to \(room.name)") }
        return relatedDoors.first
    }

    func draw(highlighted: Bool) {
        (highlighted ? NSColor.yellow : NSColor.white).set()
        NSBezierPath.fill(bounds)
        NSColor.black.set()
        NSBezierPath.stroke(bounds)

        let title = bounds.insetBy(dx: 5, dy: 1)
        (name as NSString).draw(in: title)

        for door in doors {
            door.draw()
        }
    }

    // Equatable
    static func == (lhs: Room, rhs: Room) -> Bool {
        return lhs.id == rhs.id
    }
}

class Door {
    enum Material {
        case wood
        case stone
        case mimic
    }

    var name: String
    var side1: Room
    var side2: Room
    var locked: Bool
    var damaged: Bool
    var material: Material

    init(name: String, side1: Room, side2: Room,
         locked: Bool, damaged: Bool, material: Material) {
        self.name = name
        self.side1 = side1
        self.side2 = side2
        self.locked = locked
        self.damaged = damaged
        self.material = material
    }

    func draw() {
        let startBounds = side1.bounds
        let endBounds = side2.bounds

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
        
        if !locked {
            NSColor.brown.set()
            NSBezierPath.fill(doorBounds)
        }
        NSColor.black.set()
        NSBezierPath.stroke(doorBounds)
    }
}
