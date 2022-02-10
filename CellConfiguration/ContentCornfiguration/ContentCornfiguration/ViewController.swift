import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var containerView: CustomContainerView!
    @IBOutlet var secondContainerView: CustomContainerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SNORGLE")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "SNORGLE")

        let config = SnorgleContentConfiguration(text: "hello greeeble")
        containerView.contentConfiguration = config
/*
        var listConfig = UIListContentConfiguration. ()
        listConfig.text = "ohai"
        listConfig.image = UIImage(systemName: "tortoise")

        let config2 = UIListContentView.init(configuration: listConfig)
        secondContainerView.contentConfiguration = config2
*/
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 42
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SNORGLE", for: indexPath)

        switch indexPath.row % 3 {
        case 0:
            cell.textLabel?.text = "\(indexPath)"
        case 1:
            var config = cell.defaultContentConfiguration()
            config.text = "celconf \(indexPath)"
            config.image = UIImage(systemName: "tortoise")
            cell.contentConfiguration = config
        case 2:
            let config = SnorgleContentConfiguration(text: "hello \(indexPath)")
            cell.contentConfiguration = config
        default:
            print("AHHHHH!!!")
        }

        return cell
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SNORGLE", for: indexPath)

        let config = SnorgleContentConfiguration(text: "hello \(indexPath)")
        cell.contentConfiguration = config
        
        return cell
    }
}

extension UIView {
    func pin(_ thing2: UIView) {
        let constraints = [
          leftAnchor.constraint(equalTo: thing2.leftAnchor),
          topAnchor.constraint(equalTo: thing2.topAnchor),
          bottomAnchor.constraint(equalTo: thing2.bottomAnchor),
          rightAnchor.constraint(equalTo: thing2.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
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

        pin(label)
  
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

// --------------------------------------------------

class CustomContainerView: UIView {
    var innerView: (UIView & UIContentView)?

    var contentConfiguration: UIContentConfiguration? {
        didSet {
            innerView?.removeFromSuperview()
            guard let contentConfiguration = contentConfiguration else { return }
            let view = contentConfiguration.makeContentView()
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            pin(view)

            innerView = view
        }
    }
}

