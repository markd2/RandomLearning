import SwiftUI

struct ContentView: View {

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

#Preview {
    ContentView()
}
