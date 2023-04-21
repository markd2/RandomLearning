import Cocoa

class Projections: NSWindowController {
    @IBOutlet var playpen: PlaypenView!

    // the playpenview will be changing this as users drag
    var movableVector = PlaypenView.Vector(
      interactable: true,
      origin: CGPoint(x: 250, y: 250),
      vector: Vec2(x: 40, y: 120))

    // the playpenview will be changing this as users drag
    var upVector = PlaypenView.Vector(
      interactable: false,
      origin: CGPoint(x: 100, y: 100),
      vector: Vec2(x: 0, y: -200))

    var downVector = PlaypenView.Vector(
      interactable: false,
      origin: CGPoint(x: 100, y: 100),
      vector: Vec2(x: 0, y: 200))

    var leftVector = PlaypenView.Vector(
      interactable: false,
      origin: CGPoint(x: 100, y: 100),
      vector: Vec2(x: -200, y: 0))

    var rightVector = PlaypenView.Vector(
      interactable: false,
      origin: CGPoint(x: 100, y: 100),
      vector: Vec2(x: 200, y: 0))

    var xAxisProjection = PlaypenView.Vector(
      interactable: false,
      origin: CGPoint(x: 100, y: 100),
      vector: Vec2(x: 200, y: 0))
    
    var yAxisProjection = PlaypenView.Vector(
      interactable: false,
      origin: CGPoint(x: 100, y: 100),
      vector: Vec2(x: 200, y: 0))
    
    var xAxisPerpendicular = PlaypenView.Vector(
      interactable: false,
      origin: CGPoint(x: 100, y: 100),
      vector: Vec2(x: 200, y: 0))
    
    var yAxisPerpendicular = PlaypenView.Vector(
      interactable: false,
      origin: CGPoint(x: 100, y: 100),
      vector: Vec2(x: 200, y: 0))
    
    override func windowDidLoad() {
        super.windowDidLoad()

        xAxisProjection.color = .purple
        yAxisProjection.color = .orange

        xAxisPerpendicular.color = .green
        yAxisPerpendicular.color = .blue

        playpen.add(vector: movableVector)
        playpen.add(vector: upVector)

        playpen.add(vector: downVector)
        playpen.add(vector: leftVector)
        playpen.add(vector: rightVector)

        playpen.add(vector: xAxisProjection)
        playpen.add(vector: yAxisProjection)

        playpen.add(vector: xAxisPerpendicular)
        playpen.add(vector: yAxisPerpendicular)

        playpen.vectorMoved = {
            [self.upVector, self.downVector, self.leftVector, self.rightVector, 
             self.xAxisProjection, self.yAxisProjection,
             self.xAxisPerpendicular, self.yAxisPerpendicular].forEach { vector in
                vector.origin = self.movableVector.origin
                self.adjustProjections()
            }
        }

        playpen.vectorMoved?()
    }

    func adjustProjections() {
        let pj1 = movableVector.vector.project(onTo: leftVector.vector)
        xAxisProjection.vector = pj1

        let pp1 = movableVector.vector.perpendicular(to: leftVector.vector)
        xAxisPerpendicular.vector = pp1
        xAxisPerpendicular.origin = movableVector.origin.offsetBy(movableVector.vector)
        
        let pj2 = movableVector.vector.project(onTo: upVector.vector)
        yAxisProjection.vector = pj2

        let pp2 = movableVector.vector.perpendicular(to: upVector.vector)
        yAxisPerpendicular.vector = pp2
        yAxisPerpendicular.origin = movableVector.origin.offsetBy(movableVector.vector)
    }
    
} // Projections
