## \m/ METAL \m/ ![](assets/metal-banana.gif)

Looking at Apple's Metal, because I don't have enough pain in my life.

* Apple site: https://developer.apple.com/metal/ - "a low-overhead
  API, rich shading language, tight integration between graphics and
  compute, and an unparalleled suite of GPU profiling and debugging
  tools."
* feature set tables - https://developer.apple.com/metal/Metal-Feature-Set-Tables.pdf

--------------------------------------------------

# Metal Programming Guide

RedQueenCoder's book!  Using it as a friendly intro to all the things.
https://www.amazon.com/Metal-Programming-Guide-Tutorial-Reference/dp/0134668944

* All of apple's chips that support metal are unified, so no memory copying
  overhead between CPU and GPU
* Command Buffer: central control object, giving control on how and when
  render bffers are executed.  Exposes the complexity in exchanged for control
  and performance.
* Precompiled Shaders: moving shader compilation to build time.
* Prevalidated State: avoids polling an API (like OpenGL ES) for moving into
  an invalid state.
* Metal follows the law of Conservation of Data - it doesn't create or
  destroy, merely modifies it.  So it needs to be fed. Cocoa has the Model I/O
  framework provides an easy way to bring vertex data from 3D modeling
  programs.  Use it to do the heavy lifting of parsing data files and loading
  vertex buffers.
* Representing the GPU:
  - the GPU via `MTLDevice` for creating and managing persistent and transient
    objects used to process data and render to the screen.
    - there's a single call to create a default system device, which is the
      only way the GPU can be represented in software
  - The device lets you create *command queues*.  They hold *command buffers*,
    and the buffers contain encoders that attach commands to the GPU
  - command buffers store the instructions necessary to render a frame. e.g.
    - Set state (how drawing is done)
    - draw calls (doing the actual work of rendering)
    - these are transient objects that are single use
    - the buffer is deallocated when the work is done
  - each command is encoded in the enqueing order in the buffer
  - command _queues_ are expensive to create, so are reused
* Render state Configuration
  - conceptualize the work done by Metal as a series of transformations
    that are linked together in a rendering pipeline
    - data preparation for the GPU
    - vertex processing
    - primitive assembly
    - fragment shading
    - raster output
  - Vertex Fetch -> Vertex Shader -> Tessellation Control Shader -> Tessellation -> Tessellation Evaluation Shader -> Rasterization -> Fragment Shader -> Framebuffer Operations
  - a guiding principle is to move the CPU-expensive work to the beginning
    of the render process (such as state validation)
  - Uses `MTLRenderPipelineState` protocol, contains a collection of state that
    can be quickly set on a render command encoder, avoiding calling
    a ton of state-setting calls.
  - `MTLRenderPipelineDescriptor` has properties to configure how pipeline
    state objects are created
    - sets up a prevalidated state.
  - state that can be prevalidated includes
    - specifying shader functions
    - attaching color / depth / stencil data
    - raster and visiblity state
    - tessellation state
  - can then be passed to the command encoder.
* Preparing Data for the GPU
  - most assets that wll be used in 3D Metal will come from Blender or Maya
  - they create formatted files that contain vertex information describing
    whatever model you are trying to create
  - describe the position and color of each vertex in the shape, describes
    how those vertices are connected to generate meshes that create 
    the apperance of a 3D model
  - brought into the program as a array values
    - if format is supported by ModelIO, can import using it
    - or manually enter all the vertex data into the app
  - Four ways to encode data for the command buffer:
    - `MTLRenderCommandEncoder`
    - `MTLComputerCommandEncoder`
    - `MTLBlitCommandEncoder`
    - `MTLParallelRenderCommandEncoder`
  - the choice of the encoder depends on what kind of work you want from 
    the GPU 
    - right now focus on the graphics side of thing, so
      `MTLRenderCommandEncoder`
    - the render encoder prepares data sources for the vertex and fragment
      shaders, done in the form of buffers
* Shaders
  - to perform rendering, need to create vertex and fragment shaders
  - two parts of the same program
  - the vertex shader calculates the position of each vertex, and whether
    the vertex is visible in the frame.
    - it get positional data, but can get other stuff like texture coordinates.
    - receive either per vertex or per object primitive
    - object primitives are used in "instanced draing"
  - the fragment shader fills primitives with colors
    - usually based on the textures and (simplified) light physics
  - Graphics functions have an argument list that enumerates the resources
    they operate on
    - bound to buffer and texture objects via an _argument table_
    - the arguments are passed into the shader, so when writing your shader
      code, your passed-in arguments must correlate to arguments in the
      argument table.
  - vertex shaders receive data that's been prepared for the GPU
    - set up in a st ream that is steadily fed to the shader program,
      processed one at a time.
  - the shader program then processes that and passes it along to be assembled
    into primitives.
  - vertex shadder called for every single vertex referenced in a draw call
    - so optimize by reducing the number of vertices
  - Shaders written in Metal Shading Language (MSL) - subset of C++14
    - includes some standard data types (ints and floats), and some
      specialized types and functions, like dt
  - Metal has a number of build-in classes to determine how vertex data
    is stored and mapped to arguments
* Clipping
  - There are two conceptual worlds
    - world space
    - camera space
  - (objects on/off screen, or partially)
  - if a primitive is not present at all, it's culled
    - including face of a vertex that's not facing the camera
  - if it's partially visible, the primitive gets clipped
    - a triangle is modified to a polygon (which is then broken into
      triangles again) so that it abuts the clipping rectangle
* Primitive Assembly
  - after the vertex shader is done processing the vertex data, needs to be
    assembled into primitives
    - points
    - lines
    - triangles
  - in your draw call, you tell teh GPU what type of primitive you want to
    draw
  - these shapes are translated into a series of pixels that need to be
    colored and output to the screen. these are then rasterized
* Rasterization
  - modeling how images appear on a screen.
  - involves more than shapes and primitives, also with modeling how light
    is scattered and how it interacts with the objects
  - traditionally there's two ways of doing this
    - ray tracing
    - rasterization
  - Ray tracing
    - scans each pixel in the frame until it intersects with something.
      The color of whatever the ray intersects is the color of that pixel
    - primitives behind other objects won't be rendered. THe ray will stop
      and return a color before it can reach the obstructed object
  - Rasterization
    - projects the primitives to the screen, then loops over the pixels
      and chesk to see if an object is present in the pixel. If so,
      it's filled with the object's color
* Fragment Shading
  - the fragment shader is responsible for determing the color of every
    pixel in the frame (r+g+b+a)
  - if there are no lighting or filters or other effects applied, then
    the fragment shader is a pass-through
  - if want lighting or other effects, the fragment shader calculates that.
    - e.g. light on a tennis ball, calcualtes distance to the light to
      figure out the light's influence on the ball's inherant color
  - same with texture mapping
  - the last stop before frame-bufferville
* Raster Output
  - before going to the screen, the output goes through the frame buffer
  - (double-buffering)

### Hello Triangle

like hello world, but draws a triangle. (nice!)

This chapter builds the app without a template. 

Ooh nice, metal is working in the simulators now

* metal uses a normalized coordinate system
  - two units by two units by one
  - the phone screen is one unit by one unit size
  - so upper left of the screen is 1,1,1, and lower right is -1, -1, 0
    - center is 0, 0, 0.5
  - used no matter the aspect ratio of the screen
    - rectangular on phong, square for wartch
  - https://developer.apple.com/documentation/metal/resource_fundamentals/setting_resource_storage_modes
* Three types of `MTLFunction`
  - vertex
  - fragment
  - kernel
  - collected into `MTLLibary` objects
    - can be compiled from strings at runtime, or buildtime
* command buffer needs to encode render commands in order to know what
  work to send to the GPU

TL;DR - minimum using just metal (no scaffolding, no metal views)

```
// in view controller
    var metalLayer: CAMetalLayer!

    var device: MTLDevice!
    var vertexBuffer: MTLBuffer!

    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!

// the shape to draw
    let vertexData: [Float] = [
       0.0,  0.5, 0.0,
      -0.5, -0.5, 0.0,
       0.5, -0.5, 0.0
    ]

// trigger the renderer
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

// shader implementation

#include <metal_stdlib>
using namespace metal;

// [[ buffer(0) ]] says to pull data from the first vertex buffer 
//    sent to the shader
// the second argument is the index of the vertex within the vertex array
vertex float4 basic_vertex(
    const device packed_float3 *vertex_array [[ buffer(0) ]],
    unsigned int vid [[ vertex_id ]]) {
    
    return float4(vertex_array[vid], 1.0);
}

fragment half4 basic_fragment() {
    return half(1.0);
}
```

* MetalKit
  - new framework (as of iOS 9) to reduce effort
  - texture loading
  - model handling
  - view management
  - The metal layer, CADisplay link stuff is taken care of 
    MTKView / MTKViewDelegate
    - MTKView has three modes to draw to the screen
    - internal timer - similar to HowdyTriangule
    - notifications, where view redraws only when it is told
    - a draw() method
      - also exists on MTKViewDelegate

### Essential Mathemagics

* Graphics programming boils down to figuring out how to express
  how an object appears and moves around in space
  - but need a coordnate system:
    - a point of origin
    - a consistent unit of measurement
    - a convention to oreint the positive and negative directions
  - cartesian coordinates
    - 3D cartesian coordinate system with a z-axis perpindicular to the x/y
      axes.
    - right-handed positive axis of rotation moves counterclockwise
    - left-handed positive axis of rotation moves clockwise
  - for metal, negative z is coming out of the screen towards the user
  - Metal has 2 coordinate spaces
    - applies to 3D world space
      - x and y axes run from -1 to 1, z from 0 to 1
    - applies to 2D rasterized projection space
      - same as used by CoreGraphics (opposite from OpenGL)
      - origin upper-left
* Points, Vectors, and Vector operations
  - point is a coordiante in space (x,y,z)
  - vectors are magnitude and direction, describing movement from one point
    to another
  - `float4` vector type
    - the fourth float is 1 for points and 0 for vector
  - points can be subtracted to create vectors (the 1 going to 0)
  - points cannot be added together (because then the 1 goes to 2)
  - dot product
    - a dot b = ax*bx + ay*by = |a||b|cos(theta)
    - gives us the cosine of an angle between two vectors
      - unit vectors (length of 1)
    - gives a way of measuring the impact one vector has on another
      - like MarioKart, speed boost affects more the faster you go
      - direction too.  if you're going lateral, the boost only works forward
    - used in graphics (among other things) to determine how light interacts
      with an object
      - find the cosine of the angle created by the surface normal and the
        direction the ray of light is coming from
  - cross product
    - related to dot product
    - the dot doesn't care about x vs y vs z. the cross product does
    - it's used to find the axis of rotation between two vectors
  - normalization and unit vectors
    - a lot of graphics-related math is easier to do when dealing with
      percentages
    - (reducing to a vector of length 1)
    - useful for determining direction
    - normalize with pythagorean theorem
    - normalization doesn't change the shape or angle of the vector, just
      scaling it up or down
  - orthogonality
    - 90 degrees / right angles
  - to get the normalized coordinates, divide each component by
    the length (of the hypotenuse)
  - sine/cosine/tangent
    - triangle ABC, points run counter clockwise, right angle by B.
    - sin c = opposite / hypotenuse = AB/AC
    - cos c = adjacent / hypotenuse = BC/AC
    - tan c = opposite / adjacent = AB/BC
    - cot c = adjacent / opposite = BC/AB
    - sec c = hypotenuse / adjacent = AC/BC
    - csc c = hypotenuse / opposite = AC/AB
```
 C
a|\
d| \ hypotenuse
j|  \
a|   \
c|    \
e|     \
n|      \
t|_      \
 |_|______\
 B         A
   opposite
```
  - (going to skim - since this stuff was covered in the game physics book)
  - matrices are set up with null/zero values in places where the coordinate
    is not impacted by changes happening in other coordinate spaces
  - projection matrix determines camera space
  - world space is every object in the screen
  - camera space determines which objects are within the field of view
