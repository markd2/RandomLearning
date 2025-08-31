import Foundation

class Generator {
    func generateGrid(offset: CGPoint,
                      widthRoomCount: Int, heightRoomCount: Int,
                      roomSize: CGSize, doorSize: CGFloat) -> Dungeon {
        let dungeon = Dungeon()

        var cursor = offset

        var roomId: SmallID = 0
        var doorId: SmallID = 0

        for row in 0 ..< heightRoomCount {
            cursor.x = offset.x
            for column in 0 ..< widthRoomCount {
                let bounds = CGRect(origin: cursor, size: roomSize)

                dungeon.rooms.add(Room(id: roomId,
                                       name: "\(row)-\(column)",
                                       bounds: bounds))

                // for a complete set of doors, everyone gets a right
                // and bottom door. We can figure out the room ID
                // in the future and don't need to wait for the
                // the instance to be created

                // to the right
                if column < widthRoomCount - 1 {
                    let locked = (row == 0 || column == 0) ? false : (row + column) % 4 == 0
                    dungeon.doors.add(Door(id: doorId, name: "\(doorId)",
                                           locked: locked, damaged: false,
                                           material: .stone))
                    dungeon.roomDoor.add(RoomDoor(doorId: doorId,
                                                  fromRoomId: roomId,
                                                  toRoomId: roomId + 1,
                                                  direction: .right,
                                                  locked: locked))
                    dungeon.roomDoor.add(RoomDoor(doorId: doorId,
                                                  fromRoomId: roomId + 1,
                                                  toRoomId: roomId,
                                                  direction: .left,
                                                  locked: locked))
                    doorId += 1
                }

                // down
                if row < heightRoomCount - 1 {
                    let locked = (row == 0 || column == 0) ? false : (row + column) % 5 == 0
                    dungeon.doors.add(Door(id: doorId, name: "\(doorId)",
                                           locked: locked, damaged: false,
                                           material: .stone))
                    dungeon.roomDoor.add(RoomDoor(doorId: doorId,
                                                  fromRoomId: roomId,
                                                  toRoomId: roomId + SmallID(widthRoomCount),
                                                  direction: .down,
                                                  locked: locked))
                    dungeon.roomDoor.add(RoomDoor(doorId: doorId,
                                                  fromRoomId: roomId + SmallID(widthRoomCount),
                                                  toRoomId: roomId,
                                                  direction: .up,
                                                  locked: locked))
                    doorId += 1
                }

                roomId += 1
                cursor.x += roomSize.width + doorSize
            }
            cursor.y += roomSize.height + doorSize
        }

        dungeon.playerRoom = dungeon.rooms.storage[0].id
        return dungeon
    }
}

