
import Foundation

class Dungeon {
    var name: String
    var rooms: [Room]

    init(name: String, rooms: [Room]) {
        self.name = name
        self.rooms = rooms
    }
}

class Room {
    var name: String
    var bounds: CGRect
    var doors: [Door]
    
    init(name: String, bounds: CGRect, doors: [Door]) {
        self.name = name
        self.bounds = bounds
        self.doors = doors // there's a potential retain cycle
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
}
