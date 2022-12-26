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

        let dungeon = Dungeon(name: "Dungeon", rooms: rooms)
        return dungeon
    }
    
}
