import Foundation

class Player {
    var name: String
    var currentRoom: Room
    var dungeon: Dungeon

    init(name: String, currentRoom: Room, dungeon: Dungeon) {
        self.name = name
        self.currentRoom = currentRoom
        self.dungeon = dungeon
    }

    enum Direction {
        case up, down, left, right
    }

    func attemptMove(direction: Direction) -> Bool {
        let connectedRooms = dungeon.connectedRooms(to: currentRoom)

        for connection in connectedRooms {
            if direction == .right && connection.bounds.minX > currentRoom.bounds.maxX {
                print("right is \(connection.name)")
                currentRoom = connection
                return true
            }
            else if direction == .left && connection.bounds.maxX < currentRoom.bounds.minX {
                print("left is \(connection.name)")
                currentRoom = connection
                return true
            }
            else if direction == .up && connection.bounds.maxY < currentRoom.bounds.minY {
                print("up is \(connection.name)")
                currentRoom = connection
                return true
            }
            else if direction == .down && connection.bounds.minY > currentRoom.bounds.maxY {
                print("down is \(connection.name)")
                currentRoom = connection
                return true
            } else {
                continue
            }
        }
        print("Nobody there!")
        return false
    }
}
