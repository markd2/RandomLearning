import UIKit

class PlaceholderUIView: UIView {
    static var colors: [UIColor] = [.lightGray, .gray,
                                    .cyan, .yellow, .magenta, .orange,
                                    .purple, .brown]
    private var color: UIColor

    override init(frame: CGRect) {
        color = Self.colors.randomElement()!
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("no init(coder:). bummer #ripxibs")
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        UIRectFill(rect)
        UIColor.black.set()
        UIRectFrame(rect)

        let bezPath = UIBezierPath()
        bezPath.move(to: CGPoint(x: rect.minX, y: rect.minY))
        bezPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        bezPath.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        bezPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        bezPath.stroke()
    }
}

#Preview {
    let container = UIView()

    let rect1 = CGRect(x: 30, y: 50, width: 100, height: 200)
    let placeholder1 = PlaceholderUIView(frame: rect1)
    container.addSubview(placeholder1)

    let rect2 = CGRect(x: 70, y: 300, width: 300, height: 400)
    let placeholder2 = PlaceholderUIView(frame: rect2)
    container.addSubview(placeholder2)

    return container
}
