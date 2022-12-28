
import Foundation

class Dungeon {
    var rooms: Table<Room> = Table<Room>()
    var doors: Table<Door> = Table<Door>()
    var roomDoor: Table<RoomDoor> = Table<RoomDoor>()
}

struct Room {
    let id: UInt8
    let name: String
    let bounds: CGRect
}

enum DoorMaterial {
    case stone
    case wood
    case mimic
}

struct Door {
    let id: UInt8
    let name: String
    let locked: Bool
    let damaged: Bool
    let material: DoorMaterial
}

struct RoomDoor {
    let doorId: UInt8
    let roomId: UInt8
}

class Table<RowType> {
    var storage: [RowType] = []
    
    func add(_ thing: RowType) {
        storage.append(thing)
    }
}


