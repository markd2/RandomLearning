import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Infinitie()
        }.padding()
    }
}

// --------------------------------------------------=


// Respect
struct Infinitie: View {
    @State private var trimEnd: CGFloat = 0.0
    
    var body: some View {
        Path { path in
            path.addLines([
                .init(x: 2, y: 1),
                .init(x: 1, y: 0),
                .init(x: 0, y: 1),
                .init(x: 1, y: 2),
                .init(x: 3, y: 0),
                .init(x: 4, y: 1),
                .init(x: 3, y: 2),
                .init(x: 2, y: 1)
            ])
        }
        .trim(from: 0.15, to: 0.80)
        .scale(50, anchor: .topLeading)
        .stroke(Color.black, lineWidth: 3)
    }
}

// --------------------------------------------------=

struct ClippingView: View {
    var body: some View {
        // clip to top left quadrant
        Canvas { context, size in
            print(context.environment.description)
            var maskedContext = context
            let halfSize = size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
            maskedContext.clip(to: Path(CGRect(origin: .zero, size: halfSize)))
            maskedContext.fill(Path(ellipseIn: CGRect(origin: .zero, size: size)),
                               with: .color(.purple))

            let origin = CGPoint(x: size.width / 4, y: size.height / 4)
            context.fill(Path(CGRect(origin: origin, size: halfSize)),
                         with: .color(.yellow))

            let quarterSize = size.applying(CGAffineTransform(scaleX: 0.33, y: 0.33))
            maskedContext.fill(Path(ellipseIn: CGRect(origin: .zero, size: quarterSize)),
                               with: .color(.orange))
        }
        .border(Color.black)
        .background(.white)
    }
}

struct ScatterView: View {
    let rects = [
        CGRect(x: 100, y: 100, width: 30, height: 30),
        CGRect(x: 50, y: 120, width: 30, height: 30),
        CGRect(x: 200, y: 300, width: 30, height: 30),
        CGRect(x: 95, y: 78, width: 30, height: 30),
        CGRect(x: 10, y: 20, width: 45, height: 45),
    ]
    var body: some View {
        VStack {
            Text("Bork")
            ScatterPlotView(rects: rects, mark: Image(systemName: "tortoise"))
        }
    }
}

struct EllipseContentView: View {
    var body: some View {
        VStack {
            Canvas { context, size in
                context.stroke(
                  Path(ellipseIn: CGRect(origin: .zero, size: size)),
                  with: .color(.purple),
                  lineWidth: 4)
            }
            .border(Color.black)
            .background(.white)
        }
        .padding()
    }
}

// Uses "symbols" - UI views for doing rendering.  No interactivity or accessibility
struct ScatterPlotView<Mark: View>: View {
    let rects: [CGRect]
    let mark: Mark // bork bork bork

    enum SymbolID: Int {
        case mark
    }

    var body: some View {
        Canvas { context, size in
            if let mark = context.resolveSymbol(id: SymbolID.mark) {
                for rect in rects {
                    context.draw(mark, in: rect)
                }
            }
        } symbols: {
            mark.tag(SymbolID.mark)
        } 
          .border(Color.black)
          .background(.white)
    }
}

#Preview {
    ContentView()
}
