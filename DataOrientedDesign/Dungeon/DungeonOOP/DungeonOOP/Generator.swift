import Foundation

class Generator {
    func generateGrid(offset: CGPoint,
                      widthRoomCount: Int, heightRoomCount: Int,
                      roomSize: CGSize, doorSize: CGFloat) -> Dungeon {
        var rooms: [Room] = []

        var cursor = offset
        for row in 0 ..< heightRoomCount {
            cursor.x = offset.x
            for column in 0 ..< widthRoomCount {
                let bounds = CGRect(origin: cursor, size: roomSize)
                let room = Room(name: "\(row)-\(column)",
                                bounds: bounds,
                                doors: [])
         
                rooms.append(room)
                cursor.x += roomSize.width + doorSize
            }
            cursor.y += roomSize.height + doorSize
        }

        // now that we have rooms, we can make doors.  Make a complete
        // set of doors, so everyone gets a right and bottom door

        for row in 0 ..< heightRoomCount {
            for column in 0 ..< widthRoomCount {
                var doors: [Door] = []

                let roomIndex = row * widthRoomCount + column
                let rightIndex = roomIndex + 1
                let downIndex = roomIndex + widthRoomCount

                let room = rooms[roomIndex]
                if row < heightRoomCount - 1 {
                    let down = rooms[downIndex]
                    let locked = (row == 0 || column == 0) ? false : (row + column) % 4 == 0
                    let door = Door(name: "\(doors.count)",
                                    side1: room,
                                    side2: down,
                                    locked: locked,
                                    damaged: false,
                                    material: .wood)
                    doors.append(door)
                }
                if column < widthRoomCount - 1 {
                    let right = rooms[rightIndex]
                    let locked = (row == 0 || column == 0) ? false : (row + column) % 5 == 0
                    let door = Door(name: "\(doors.count)",
                                    side1: room,
                                    side2: right,
                                    locked: locked,
                                    damaged: false,
                                    material: .stone)
                    doors.append(door)
                }

                room.doors = doors
            }
        }

        let dungeon = Dungeon(name: "Dungeon", rooms: rooms)
        return dungeon
    }
    
}
