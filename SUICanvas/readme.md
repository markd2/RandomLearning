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

