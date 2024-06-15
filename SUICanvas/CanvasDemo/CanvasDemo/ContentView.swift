import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ClippingView()
        }.padding()
    }
}

struct ClippingView: View {
    var body: some View {
        // clip to top left quadrant
        Canvas { context, size in
            let halfSize = size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
            context.clip(to: Path(CGRect(origin: .zero, size: halfSize)))
            context.fill(Path(ellipseIn: CGRect(origin: .zero, size: size)),
                         with: .color(.purple))
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
