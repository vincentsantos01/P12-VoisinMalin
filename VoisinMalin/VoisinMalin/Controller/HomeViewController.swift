//
//  HomeViewController.swift
//  VoisinMalin
//
//  Created by vincent on 23/07/2021.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = Auth.auth().currentUser {
            nameLabel.text = user.email
        } else {
            fatalError("ERROR aucuns utilisateur")
        }
    }


}
