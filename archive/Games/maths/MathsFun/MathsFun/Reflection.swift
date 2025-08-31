import Cocoa

class Reflection: NSWindowController {
    @IBOutlet var playpen: PlaypenView!

    var movableVector = PlaypenView.Vector(
      interactable: true,
      origin: CGPoint(x: 75, y: 100),
      vector: Vec2(x: 40, y: -20))

    var normalVector = PlaypenView.Vector(
      interactable: true,
      origin: CGPoint(x: 25, y: 25),
      vector: Vec2(x: 100, y: 0))

    var reflectionVector = PlaypenView.Vector(
      interactable: false,
      origin: CGPoint(x: 25, y: 25),
      vector: Vec2(x: 0, y: 200))
    
    override func windowDidLoad() {
        super.windowDidLoad()

        normalVector.color = .lightGray
        reflectionVector.color = .purple

        playpen.add(vector: movableVector)
        playpen.add(vector: normalVector)
        playpen.add(vector: reflectionVector)


        playpen.vectorMoved = {
            [self.movableVector, self.normalVector,
             self.reflectionVector].forEach { vector in
                vector.origin = self.movableVector.origin
                self.adjustReflection()
            }
        }

        playpen.vectorMoved?()
    }

    func adjustReflection() {
        let reflect = movableVector.vector.reflected(around: normalVector.vector.normalized)
        reflectionVector.vector = reflect * -1
    }

} // Reflection
