import Cocoa

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
}

