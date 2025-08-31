import Cocoa

let kLeftArrowKeyCode:  UInt16  = 123
let kRightArrowKeyCode: UInt16  = 124
let kDownArrowKeyCode:  UInt16  = 125
let kUpArrowKeyCode:    UInt16  = 126

class ViewController: NSViewController {
    var dungeon: Dungeon!
    var player: Player!
    @IBOutlet var dungeonView: OOPDungeonView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let roomSize = CGSize(width: 50, height: 30)
        let offset = CGPoint(x: 10, y: 10)

        dungeon = Generator().generateGrid(offset: offset,
                                           widthRoomCount: 10,
                                           heightRoomCount: 15,
                                           roomSize: roomSize,
                                           doorSize: 15)
        player = Player(name: "Splunge", currentRoom: dungeon.rooms.first!, dungeon: dungeon)
        dungeonView.dungeon = dungeon
        dungeonView.player = player
    }

    override var acceptsFirstResponder: Bool { return true }

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
            moved = player.attemptMove(direction: .up)
        case "a":
            moved = player.attemptMove(direction: .left)
        case "s":
            moved = player.attemptMove(direction: .down)
        case "d":
            moved = player.attemptMove(direction: .right)
        default:
            done = false
        }

        if done { return }

        done = true
        switch event.keyCode {
        case kUpArrowKeyCode:
            moved = player.attemptMove(direction: .up)
        case kLeftArrowKeyCode:
            moved = player.attemptMove(direction: .left)
        case kDownArrowKeyCode:
            moved = player.attemptMove(direction: .down)
        case kRightArrowKeyCode:
            moved = player.attemptMove(direction: .right)
        default:
            done = false
        }

        if done { return }
    }
    

}

