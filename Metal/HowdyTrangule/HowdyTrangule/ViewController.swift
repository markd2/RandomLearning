import UIKit
import Metal
import QuartzCore // layers

class ViewController: UIViewController {
    var device: MTLDevice!
    var metalLayer: CAMetalLayer!

    let vertexData: [Float] = [
       0.0,  0.5, 0.0,
      -0.5, -0.5, 0.0,
       0.5, -0.5, 0.0
    ]
    var vertexBuffer: MTLBuffer!

    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!

    var timer: CADisplayLink!

    override func viewDidLoad() {
        super.viewDidLoad()

        device = MTLCreateSystemDefaultDevice()

        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = .bgra8Unorm  // NORM!
        metalLayer.framebufferOnly = true
        metalLayer.frame = view.layer.frame
        view.layer.addSublayer(metalLayer)

        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        vertexBuffer = device.makeBuffer(bytes: vertexData,
                                         length: dataSize,
                                         options: [])

        // get the shaders and add to the default liberry
        let defaultLibrary = device.makeDefaultLibrary()!
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")

        // now add to the render pipeline
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            try pipelineState = device.makeRenderPipelineState(
              descriptor: pipelineStateDescriptor)
        } catch {
            print("failed to create pipeline state \(error)")
        }

        // command queues expensive to create - make one and re-use.
        // command buffers are cheap
        commandQueue = device.makeCommandQueue()

        timer = CADisplayLink(target: self, 
                              selector: #selector(ViewController.gameloop))
        timer.add(to: RunLoop.main, forMode: .default)
    }

    func render() {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        guard let drawable = metalLayer.nextDrawable() else { return }

        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor =
          MTLClearColor(red: 221.0 / 255.0, green: 160.0 / 255.0,
                        blue: 221.0 / 255.0, alpha: 1.0)

        let commandBuffer = commandQueue.makeCommandBuffer()!
        
        let renderEncoder = (commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor))!
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.drawPrimitives(type: .triangle,
                                     vertexStart: 0, vertexCount: 3)
        renderEncoder.endEncoding()

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    @objc func gameloop() {
        autoreleasepool {
            self.render()
        }
    }

}

