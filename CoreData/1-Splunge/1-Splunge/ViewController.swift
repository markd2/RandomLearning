//
//  ViewController.swift
//  1-Splunge
//
//  Created by Mark Dalrymple on 7/27/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var textfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = StorageProvider.shared
    }

    @IBAction func splunge() {
        guard let name = textfield.text,
            !name.isEmpty else {
            return
        }
        StorageProvider.shared.saveMovie(named: name)
        textfield.text = ""
    }

}

