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
