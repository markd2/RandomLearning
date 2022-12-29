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

    override var representedObject: Any? {
        didSet {
        }
    }
    
    override var acceptsFirstResponder: Bool { return true }

    override func keyDown(with event: NSEvent) {
        var done = true

        switch event.characters {
        case "w":
            dungeon.attemptMove(direction: .up)
        case "a":
            dungeon.attemptMove(direction: .left)
        case "s":
            dungeon.attemptMove(direction: .down)
        case "d":
            dungeon.attemptMove(direction: .right)
        default:
            done = false
        }

        if done { return }

        done = true
        switch event.keyCode {
        case kUpArrowKeyCode:
            dungeon.attemptMove(direction: .up)
        case kLeftArrowKeyCode:
            dungeon.attemptMove(direction: .left)
        case kDownArrowKeyCode:
            dungeon.attemptMove(direction: .down)
        case kRightArrowKeyCode:
            dungeon.attemptMove(direction: .right)
        default:
            done = false
        }

        if done { return }
    }
    

}

