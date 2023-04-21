import Cocoa

class Projections: NSWindowController {
    @IBOutlet var playpen: PlaypenView!

    override func windowDidLoad() {
        super.windowDidLoad()

        playpen.add(vector: PlaypenView.Vector(
                      interactable: true,
                      origin: CGPoint(x: 100, y: 100),
                      vector: Vec2(x: 10, y: 30)))
        playpen.add(vector: PlaypenView.Vector(
                      interactable: false,
                      origin: CGPoint(x: 200, y: 200),
                      vector: Vec2(x: -17, y: 130)))
    }
    
} // Projections
