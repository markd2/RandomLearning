//
//  ViewController.swift
//  1-Splunge
//
//  Created by Mark Dalrymple on 7/27/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var textfield: UITextField!
    @IBOutlet var tableview: UITableView!
    
    private var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "Splunge")
        
        _ = StorageProvider.shared
        refreshMovies()
    }

    @IBAction func splunge() {
        guard let name = textfield.text,
            !name.isEmpty else {
            return
        }
        StorageProvider.shared.saveMovie(named: name)
        textfield.text = ""
        refreshMovies()
        tableview.reloadData()
    }

    func refreshMovies() {
        movies = StorageProvider.shared.getAllMovies()
        let names = movies.compactMap { $0.name }
        print(names)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Splunge",
            for: indexPath)
            
        let movie = movies[indexPath.row];
        
        var content = cell.defaultContentConfiguration()
        content.text = movie.name
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableview: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            let movie = movies[indexPath.row]
            movies.remove(at: indexPath.row)
            StorageProvider.shared.deleteMovie(movie)
            tableview.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
