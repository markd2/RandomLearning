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
}
