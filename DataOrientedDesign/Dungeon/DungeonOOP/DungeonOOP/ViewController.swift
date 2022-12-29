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
        print("oop: |\(event.characters)| and |\(event.keyCode)|")
    }
    

}

