import Cocoa

class Cubist: NSWindowController {
    @IBOutlet var goodiesView: NSView!

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    @IBAction func splunge(_ sender: NSButton) {
        print("Splunge")
    }
}


/*
The process of projecting a 3D shape onto a 2D plane is known as perspective projection. The goal is to map each point in 3D space to a corresponding point in a 2D image such that the appearance of the 3D shape is preserved as much as possible.

One way to perform perspective projection is to use a projection matrix. The projection matrix maps points in 3D space to a 2D plane by performing a series of transformations. Here's the basic math for perspective projection:

1. Translate the 3D shape so that the camera is at the origin. This can be done by subtracting the camera position from the coordinates of each point in the 3D shape.

2. Rotate the 3D shape so that it is aligned with the camera. This can be done by applying the inverse of the camera's rotation matrix to each point in the 3D shape.

3. Apply the perspective transformation to each point in the 3D shape. This involves multiplying the coordinates of each point by a projection matrix. The projection matrix is typically constructed using the field of view angle, the aspect ratio, and the near and far clipping planes.

4. Divide the x and y coordinates of each point by its z coordinate. This converts the 3D coordinates to 2D coordinates on the image plane.

5. Scale and translate the resulting 2D coordinates so that they fit within the dimensions of the output image.

The resulting 2D coordinates can then be used to draw the 3D shape on a 2D image.

Note that there are many variations on this basic approach, and the details will depend on the specific graphics library or framework being used. Additionally, other types of projections such as orthographic projection can be used as well.
*/
