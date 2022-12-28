
import Foundation

typealias SmallID = UInt8

class Dungeon {
    var rooms: Table<Room> = Table<Room>()
    var doors: Table<Door> = Table<Door>()
    var roomDoor: Table<RoomDoor> = Table<RoomDoor>()
}

struct Room {
    let id: SmallID
    let name: String
    let bounds: CGRect
}

enum DoorMaterial {
    case stone
    case wood
    case mimic
}

struct Door {
    let id: SmallID
    let name: String
    let locked: Bool
    let damaged: Bool
    let material: DoorMaterial
}

struct RoomDoor {
    let doorId: SmallID
    let fromRoomId: SmallID
    let toRoomId: SmallID
}

class Table<RowType> {
    var storage: [RowType] = []
    
    func add(_ thing: RowType) {
        storage.append(thing)
    }
}


