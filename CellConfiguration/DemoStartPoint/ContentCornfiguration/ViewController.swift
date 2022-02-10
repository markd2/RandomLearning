import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!

    var flags = Array(repeating: false, count: 15)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SNORGLE")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "SNORGLE")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SNORGLE", for: indexPath)

        switch indexPath.row % 1 {
        case 0:
            cell.textLabel?.text = "\(indexPath)"
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
          bottomAnchor.constraint(equalTo: label.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.isOn = (configuration as? SnorgleContentConfiguration)?.flag ?? false
        addSubview(toggle)
        
        toggle.addAction(UIAction { action in
                             (configuration as? SnorgleContentConfiguration)?.toggled(toggle.isOn)
                         }, for: .valueChanged)
        
        let constraints2 = [
          toggle.centerYAnchor.constraint(equalTo: label.centerYAnchor),
          toggle.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 8),
          toggle.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints2)
  
        configure(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) get bent")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? SnorgleContentConfiguration else { return }
        label.text = configuration.text
        if configuration.flag {
            label.text = "ON " + configuration.text
        }
    }

}

struct SnorgleContentConfiguration: UIContentConfiguration {
    var text: String
    var flag: Bool
    var toggled: (Bool) -> () = { _ in  }
    

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

            let constraints = [
              leftAnchor.constraint(equalTo: view.leftAnchor),
              topAnchor.constraint(equalTo: view.topAnchor),
              bottomAnchor.constraint(equalTo: view.bottomAnchor),
              rightAnchor.constraint(equalTo: view.rightAnchor)
            ]
            NSLayoutConstraint.activate(constraints)

            innerView = view
        }
    }
}

