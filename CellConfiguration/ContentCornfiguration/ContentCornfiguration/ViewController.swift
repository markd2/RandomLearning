import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var containerView: CustomContainerView!
    @IBOutlet var secondContainerView: CustomContainerView!

    var flags = Array(repeating: false, count: 20)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SNORGLE")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "SNORGLE")

        var config = SnorgleContentConfiguration(text: "hello greeeble", flag: false)
        config.toggled = { [weak self] onOff in
            guard let self = self else { return }
            config.flag = onOff
            self.containerView.contentConfiguration = config
        }
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
        return flags.count
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("CELL FOR \(indexPath)")

        let cell = tableView.dequeueReusableCell(withIdentifier: "SNORGLE", for: indexPath)

        switch indexPath.row % 3 {
        case 0:
            cell.textLabel?.text = "\(indexPath)"
        case 1:
            var config = cell.defaultContentConfiguration()
            config.text = "celconf \(indexPath)"
            config.image = UIImage(systemName: "tortoise")
            cell.contentConfiguration = config
            print("    SETTING \(config.text)")
        case 2:
            var config = SnorgleContentConfiguration(text: "hello \(indexPath)",
                                                     flag: flags[indexPath.row])
            config.toggled = { [weak self] onOff in
                guard let self = self else { return }
                self.flags[indexPath.row] = onOff
                config.flag = onOff
                cell.contentConfiguration = config
            }

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

        let config = SnorgleContentConfiguration(text: "hello \(indexPath)", flag: false)
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
            pin(view)

            innerView = view
        }
    }
}

