import Cocoa

let kLeftArrowKeyCode:  UInt16  = 123
let kRightArrowKeyCode: UInt16  = 124
let kDownArrowKeyCode:  UInt16  = 125
let kUpArrowKeyCode:    UInt16  = 126

class ViewController: NSViewController {

    var dungeon: Dungeon!
    @IBOutlet var dungeonView: DoDDungeonView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let roomSize = CGSize(width: 50, height: 30)
        let offset = CGPoint(x: 10, y: 10)

        dungeon = Generator().generateGrid(offset: offset,
                                           widthRoomCount: 10,
                                           heightRoomCount: 15,
                                           roomSize: roomSize,
                                           doorSize: 15)
        dungeonView.dungeon = dungeon
    }

    override var acceptsFirstResponder: Bool { return true }

    func attemptMove(direction: Direction) -> Bool {
        // spin through RoomDoors and find the id + direction
        let roomId = dungeon.playerRoom

        dungeon.roomDoor.storage.forEach { roomDoor in
            if roomDoor.fromRoomId == roomId && roomDoor.direction == direction && !roomDoor.locked {
                dungeon.playerRoom = roomDoor.toRoomId
                dungeonView.needsDisplay = true
            }
        }
        return true
    }

    override func keyDown(with event: NSEvent) {
        var done = true
        var moved = false

        defer {
            if moved {
                dungeonView.needsDisplay = true
            }
        }

        switch event.characters {
        case "w":
            moved = attemptMove(direction: .up)
        case "a":
            moved = attemptMove(direction: .left)
        case "s":
            moved = attemptMove(direction: .down)
        case "d":
            moved = attemptMove(direction: .right)
        default:
            done = false
        }

        if done { return }

        done = true
        switch event.keyCode {
        case kUpArrowKeyCode:
            moved = attemptMove(direction: .up)
        case kLeftArrowKeyCode:
            moved = attemptMove(direction: .left)
        case kDownArrowKeyCode:
            moved = attemptMove(direction: .down)
        case kRightArrowKeyCode:
            moved = attemptMove(direction: .right)
        default:
            done = false
        }

        if done { return }
    }

}

