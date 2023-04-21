import Cocoa

class Projections: NSWindowController {
    @IBOutlet var playpen: PlaypenView!

    // the playpenview will be changing this as users drag
    var movableVector = PlaypenView.Vector(
      interactable: true,
      origin: CGPoint(x: 100, y: 100),
      vector: Vec2(x: 10, y: 30))

    // the playpenview will be changing this as users drag
    var baseVector = PlaypenView.Vector(
      interactable: false,
      origin: CGPoint(x: 50, y: 200),
      vector: Vec2(x: 150, y: -7))

    override func windowDidLoad() {
        super.windowDidLoad()

        playpen.add(vector: movableVector)
        playpen.add(vector: baseVector)
    }
    
} // Projections
