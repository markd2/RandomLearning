import Cocoa

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
        dungeonView.dungeon = dungeon
        player = Player(name: "Splunge", currentRoom: dungeon.rooms.first!, dungeon: dungeon)
    }

    override var representedObject: Any? {
        didSet {
        }
    }


}

