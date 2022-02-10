import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SNORGLE")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 42
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SNORGLE", for: indexPath)

        if indexPath.row % 2 == 0 {
            cell.textLabel?.text = "\(indexPath)"
        } else {
            let config = SnorgleContentConfiguration(text: "hello \(indexPath)")
            cell.contentConfiguration = config
        }
        
        return cell
    }
}

// --------------------------------------------------

class SnorgleView: UIView, UIContentView {
    let label: UILabel

    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: .zero)

        // add subviews
        addSubview(label)

        let constraints = [
          leftAnchor.constraint(equalTo: label.leftAnchor),
          topAnchor.constraint(equalTo: label.topAnchor),
          bottomAnchor.constraint(equalTo: label.bottomAnchor),
          rightAnchor.constraint(equalTo: label.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        configure(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) get bent")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? SnorgleContentConfiguration else { return }
        label.text = configuration.text
    }

}

struct SnorgleContentConfiguration: UIContentConfiguration {
    var text: String

    func makeContentView() -> UIView & UIContentView {
        return SnorgleView(self)
    }
    
    func updated(for state: UIConfigurationState) -> SnorgleContentConfiguration {
        return self
    }
    

}
