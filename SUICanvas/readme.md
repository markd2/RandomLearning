# SwiftUI Canvas

Doing canvas stuff for $WORK, so might as well dive deeper.

Announced 2021 in [Add rich graphics to your SwiftUI App](https://developer.apple.com/videos/play/wwdc2021/10021/)

related sessions:
  * Swift UI Acesibility: Beyond the basic (wwdc 21)

# session notes

- safe area
- foreground styles
- materials
- canvas

app is a library of gradients

### Safe area

say a view to take over the screen.

by default sui avoids safe area (chrome, and abit from the edges), and also avoid
drawing under the keyboard

There's multiple safe areas
  - full area
  - container safe area
    - driven by container
  - keyboard safe area
    - subset of container.

Can opt-out of safe areas
  - like backgrounds

```
ContentView()
   .ignoresSafeArea()

ContentView()
    .ignoresSafeArea(edges: .bottom)

ContentView()
    .ignoresSafeArea(.keyboard)
```

adding background over things - add `.background()`

can apply ignoresSafeArea to the background.  (new background modifier does that automatically)

adding a blur - materials (standard blur styles)
  (ultra thin through ultra thick)

.foregroundStyle(.secondary)  (audo shows background color in blurred context)

@8:30 - list not scrolling above the backgtrond bottom view.
 b/c bar is just ZStacked on top of content.  VStack wouldn't show the color.
Want th background of the list to extend below the bar.  That's what safearea
is for, so inset the safe area.

.safeAreaInset(edge: .bottom) {
   .. stacks, views
}

Visualziers in the app - shapes that are tappable.  animations are interurptable

GeometryReader to read the view's size, and zstack to position.
and the bottom, .drawingGroup() - combines into a single area to draw.
don't use with UI controls like textviws or lists

use for a large number of grahical elements.

```
.onTapGesture {
  withAnimaton {
    s.tate.etronmes[idex].selected.toggle()
  }
}
```

still exist some bookkeeping, that can add up with :alot: of orbjects.

Canvas view can show a complex particle system.
  - like drawRect

takes a context and a size

```
var body: some View {
    Canvas { context, size in
        let image = Image(systemImage: "sparkle")
        context.draw(image, at: CGPoint(x: 0, y: 0)
    }
}
```

the closure is not a view builder

can resolve images before drawing,

```
var body: some View {
    Canvas { context, size in
        let image = context.resolve(Image(systemImage: "sparkle"))
        for i in 0 ..< 10 {
            context.draw(image, at: CGPoint(x: size.width * 0.5 + Double(i) * 10, 
                                            y: size.height * 0.5))
        }
    }
}
```

better performance - sharing same result image.

ask for its size and baseline.  so shift by right amount.  (draws a row of >diaonds)

```
var body: some View {
    Canvas { context, size in
        let image = context.resolve(Image(systemImage: "sparkle"))
        let imageSize = image.size
        for i in 0 ..< 10 {
            context.draw(image, at: CGPoint(x: size.width * 0.5 + Double(i) * imageSize.width, 
                                            y: size.height * 0.5))
        }
    }
}
```

say want to draw an ellipse behind the images

```
var body: some View {
    Canvas { context, size in
        let image = context.resolve(Image(systemImage: "sparkle"))
        let imageSize = image.size
        for i in 0 ..< 10 {
            context.draw(image, at: CGPoint(x: size.width * 0.5 + Double(i) * imageSize.width, 
                                            y: size.height * 0.5))
            context.fill(Ellipse().path(in: frame), with: .color(.cyan))
            context.draw(image, in: frame)
        }
    }
}
```

the `fill` takes a (bezier) path.

Canvas has different attributes
  - opacity
  - blend modes
  - transforms
  - "and more"

if set opacity on the context, it affects all drawing afterwards.

rather than push/pop context, is to make changes on a copy.

```
let innerContext = context
innerContext.opacity(0.42)
innerContext.fill(...)
context.draw(image, in: frame)
```

NICE!!

with the resolved image, can set a shading.  Also blend modes.

```
context.blemdMode = .screen // always get brighter
image.shading = .color(.blue)
```
See GraphicsContext type to see things.

### TimelineView

animations, usually happen automation.  Wrap timeline view around view want to change,
and configure with a schedule (timers, or an aimatin scheudle as quickly) - like
a displya link.


```
var body: some View {
  TimelineView(.animation) { timeline in
    Canvas { context, size in
        let now = timeline.date.timeIntervalSinceReferenceDate
        let angle = Angle.degrees(now.remainder(dividingBy: 3) * 120)
        let x = cos(angle.radians)

        let image = context.resolve(Image(systemImage: "sparkle"))
        image.shading = .color(.blue)
        let imageSize = image.size

        context.blendMode = .screen
        for i in 0 ..< 10 {
            context.draw(image, at: CGPoint(x: size.width * 0.5 + x * imageSize.width, 
                                            y: size.height * 0.5))
            var innerContext = context
            innerContext.opacity = 0.5
            innerContext.fill(Ellipse().path(in: frame), with: .color(.cyan))
            context.draw(image, in: frame)
        }
    }
  }
}
```

interactivity, gestures for views.  For canvas, all elements are combined into
a single drawing.

Can add a gesture to the view.  sy to include the number of shapes to show.

```
@State private var count = 2
var body: some View {
  TimelineView(.animation) { timeline in
    Canvas { context, size in
        let now = timeline.date.timeIntervalSinceReferenceDate
        let angle = Angle.degrees(now.remainder(dividingBy: 3) * 120)
        let x = cos(angle.radians)

        let image = context.resolve(Image(systemImage: "sparkle"))
        image.shading = .color(.blue)
        let imageSize = image.size

        context.blendMode = .screen
        for i in 0 ..< 10 {
            context.draw(image, at: CGPoint(x: size.width * 0.5 + x * imageSize.width, 
                                            y: size.height * 0.5))
            var innerContext = context
            innerContext.opacity = 0.5
            innerContext.fill(Ellipse().path(in: frame), with: .color(.cyan))
            context.draw(image, in: frame)
        }
    }
  }
  .onTapGesture { count += 1 }
  .accessbilityLable("My god it's full of stars")
}
```

no information about the contents for accessibility.

use modifiers to give information

there is an accessibilityChildren, that lets you specify a swiftUI view hiearchy to
specify children.
c.f. SwiftUI accessibility: beyond the basics (WWDC 21)

```
struct ParticleVisualzer: View
   var gradients: [Gradient]
   @StateObject private var model = ParticleModel()

   var body: some View {
       TimelineView(.animation) [ timeline in
           Canvas { context, sizse in
               let now = timeline.date.timeINtervalSinceReferenceDate
               model.update(time: now, size: size)

               context.blendMode = .screen
               model.forEachParticle { particle in
                   var innerContext = context
                   innerContext.opacity = particle.opacity
                   innerContext.fill(Ellipse().path(in: particle.frame),
                                     with: particle.shading(gradients))
               }
           }
       }.gesture( DragGesture(minimumDistance: 0).onEnded { model.add(position: $0.location) })
       .accessiblityLabel("splunge")
   }
}
```

fireworks burst

available on all platforms.

----------

# Notes building sample

declared as

```
@MainActor
@preconcurrency
struct Canvas<Symbols> where Symbols : View
```

huh. wonder what that Symbols thing is.

for "immediate mode drawing", to draw rich and dynamic 2D graphincs inside a SUI view.

Making a canvas, give a closure (not a function builder) that takes a
GraphicsContext and and also a CGSize. (and so you start out at 5 levels of indention)

To draw views, use a wild initializer:

```
init(opaque: Bool = false,
     colorMode: ColorRenderingMode = .nonLinear, //  other options extendedLinear and linear
     rendersAsynchronously: Bool = false, // interesting
     renderer: @escaping (inout GraphicsContext, CGSize) -> Void,
     @ViewBuilder symbols: () -> Symbols
```

The symbols is a ViewBuilder to supply SwiftUI views during drawing.
Uniquely tag each view using View/tag(_:) modifier so you can find them
using resolveSymbol(id:).  SUI stores a rendered version of each child view
you specify in the symbols view builder and makes these availabile to the canvas.
Just drawing. No interactivity (because the same view is going to be used over and
over to draw stuff) and no built-in accessibility.

"you can also add masks, apply filters, perform transformations, control blending,
and more"

Use a canvas to improve performance for a drawing that doesn't primarily involve
text or require interactive elements.

----------

Graphics context.  It's a bit lorge of an API.

can draw images, text, and SUI views.

Can clip, adding a path for what gets through.

Changes to contexts are additive.

Each context references a particular layer in a tree of transparency layers,
and has a fully copy of the drawing st ate.

and it is painters-algoriming.  (did a maskedContext with some stuff, drew in
the default context, then again with maskedContext, and got stuff above and below
the default context)

The context has an environment copied from the enclosing view. Can use it for
things like display resolution and color scheme., to resolve types like
image and color that appear. (plus environment values for your own nefarious
purposes)  [sample environment](sample-environment.md)

### API categories

Some of these are Shape rather than canvas, but they share some data structures.


* API
  - Paths
    - stroke (with linewidth or StrokeStyle)
    - fill (with Shading, FillStyle)
  - Draw images, text, views
    - draw(_:in) - draws a resovled symbol in a retnagle
    - draw in/style - uses the style
    - draw(at/anchor) -  aligning an anchor wihtin the image to a point in the context
    - drawLayer(contetns) - draws a new layer into the context, created by drawing code
  - Resolving
    - get a version of an iamge that's fixed with current values of the graphics context's environment
    - resolveSymbol<ID>(id) - gets the identiied child view (if exists)
  - Masking
    - clip (path, style, clip options)
    - clipToLayer (adds a clip shape that you define in a new layer to the context's array of clip shapes)
    - clipBoundingRect
  - opacity and blendmode
    - opacity
    - blendMode
  - filtering
    - addFilter(filter, filterOptions)
  - transforms
    - scaleBy (x/y)
    - rotateBy (angle)
    - traslateBy (x/y)
    - concatenate (CGAffineTransform)
    - transform (returns current tranform)
  - withCGContext
  - environment
  - draw(options) -- draws (Text.Layout.Line) line into the graphics context. Options is Text.Layout.DrawingOptions

* Filter
  - a type that applies image processing operations to rendered content
  - all static functions
  - brightness (double)
  - contrast (double)
  - color
    - saturation(Double)
    - colorInvert(Double)
    - colorMultiply(Color)
    - hueRotation(Angle)
    - grayscale(Double)
    - colorMatrix(ColorMatrix)
  - blur(radius, options) - gaussian blur
  - shadow (color, radius, x, y, blendMode, options)
  - opacity
    - luminnceToAlpha
    - alphaThreshold(min, max, color)
  - projectionTransform
  - metal shader
    - colorShader - apply to the color of each pixel
    - distortionShader - apply as a geometric distortion on location
    - layerShader - applies to the contents of the source layer

* FilterOptions
  - struct, to configure a Filter with addFilter

* BlurOptions
  - dithersResult (reduce banding)
  - opaque

* ShadowOptions
  - configure the grapics context filter that creates shadows
  - disablesGroup - composite the object and its shadow separatedly in current layer
  - inverts Alpha (of the shadow)
  - shadowAbove - draw the shadow above he obejct
  - shadowOnly - draw only the shadow and omit the source object

* ColorMatrix
  - five columns, each with a r/g/b/alpha
  - use for a color transformation

* BlendMode
  - normal
  - darken
  - multiply
  - colorBurn
  - plusDarker
  - lighten
  - screen
  - colorDodge
  - plusLighter
  - overlay
  - softLight
  - hardLight
  - difference
  - exclusion
  - hue
  - saturation
  - color
  - luminosity
  - clear
  - copy
  - sourceIn
  - sourceOut
  - sourceAtop
  - destinationOver
  - destinationIn
  - destinationOut
  - destinationAtop
  - xor

* ClipOptions
  - inverse - invert the shape or layer alpha as the clip mask

* ResolvedSymbol
  - size

* ResolvedImage
  - size
  - baseline (ditance from top of image to the baseline)
  - shading

* ResolvedText
  - resolve a Text view in preparation to drawing it into a context
  - takes in to account environment values like the display resolution and color scheme
  - firstBaseline (in: size)
  - laseBaseline (in: size)
  - measure - measure the size of the resolved text for a given area
  - shading

* StrokeStyle
  - lineWidth
  - lineCap
  - lineJoin
  - miterLimit
  - dash
  - dashPhase

* FillStyle
  - eoFill : bool
  - antialiased: bool

* Shading
  - Color
  - RGB Color Space, r/g/b/alpha
  - RGB Color Space, white, alpha

* Gradient
  - opaque data type
  - make from array of color
  - make from array of stops
  - can make a version that uses a partcular color space

* Stop
  - Color
  - location (CGFloat)

* GradientOptions
  - linearColor (interpolates)
  - mirror (repeats gradient outside its nominal range, reflecting every other instance)
  - `repeat` - repeats the gradient outside its nominal range

* ShapeView (protocol)
  - generic over Content
  - use with drawing methods on _Shape_ to apply multiple fills and/o strokes
    - actually things that return views
  - e.g. .fill / .stroke
  - have stroke and fill styles
  - stroke have antialiased agument
  - strokeBorder(style/antialised) returns a view "the result of insetting by half of its style's line width)
  - and a strokeBorder (lineWidth, antialiased) returns a view result of filling an inner stroke with the content

* Shape
  - hooeee lots of stuff
  - standard shapes
    - buttonBorder (based on environment)
    - capsule
    - capsule(RoundedCornerStyle)
    - circle
    - containerRelative (replaced by an insert version of the current container shape)
    - ellipse
    - rect
    - rect(cornerRadii, style)
    - rect(cornerRadius fcgfloat, style)
    - rect(cornerSize: cgsize, style)
    - rect(with four radiuses)
    - also an UnevenRoundedRectangle
  - geometry
    - sizeThatFits(proposedViewSize)
    - path(in: CGRect), describe this shape as a path within a rectangular frame of reference.
  - transforms
    - trim(from:CGFloat, to:CGFloat) - trims by a fractional amount based on its representation a path (?)  The fraction of the way through drawing this shape where drawing starts.   Ok, this is actually really cool. Bet this is how those "play back part of a bezpath" animations are done
    - transform
    - size size or w/h
    - scale (float / unitPoint or x/y/anchor)
    - rotation
    - offset (point)
    - offset (x,y)
  - fill/stroke charactertistics
    - stroke (linewidth / antialised / StrokeStyle
    - fill (style / fillStyle)
  - role
  - layout direction
  - operations
    - intersection (eoFill)
    - lineIntersection (eoFill)  (returns the line of one shape overlaps the fill of another)
    - lineSubtraction (eoFill)
    - subtracting
    - symmetricDifference
    - union

* LayoutDirectionBehavior
  - fixed - doesn't mirrior when layout direction changes
  - mirrors - mirrors when layout direction is RTL
  - mirrors(layoutdirection) - mirrors when layout direction has the given value

* LayoutDirection
  - leftToRight
  - rightToLeft

* RoundedCornerStyle
  - ciruclar (quarter-circle)
  - continuous

* RectangleCornerRadii
  - topLeading, bottomLeading, bottomTraling, topTrailing

* ShapeRole
  - fill
  - stroke
  - separator






