
import Foundation

enum Direction {
    case up, down, left, right
}


typealias SmallID = UInt16

class Dungeon {
    var rooms: Table<Room> = Table<Room>()
    var doors: Table<Door> = Table<Door>()
    var roomDoor: Table<RoomDoor> = Table<RoomDoor>()
    var playerRoom: SmallID = 0

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
    let direction: Direction
}

class Table<RowType> {
    var storage: [RowType] = []
    
    func add(_ thing: RowType) {
        storage.append(thing)
    }
}


extension Table<Room> {
    func roomForId(_ roomId: SmallID) -> Room {
        guard let room = storage.first(where: { $0.id == roomId } ) else {
            fatalError("should have found \(roomId) in room collection")
        }
        return room
    }
}


extension Table<RoomDoor> {
    func roomsForDoorId(_ doorId: SmallID) -> [SmallID] {
        let blah = storage
          .filter { $0.doorId == doorId }
          .flatMap { [$0.fromRoomId, $0.toRoomId] }
          .uniqued()
        return blah
    }
}
