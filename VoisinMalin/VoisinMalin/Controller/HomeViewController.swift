//
//  HomeViewController.swift
//  VoisinMalin
//
//  Created by vincent on 23/07/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var adPost: UIButton!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        adPost.layer.cornerRadius = 20
        adPost.layer.borderWidth = 3
        adPost.layer.borderColor = UIColor.black.cgColor

        if Auth.auth().currentUser != nil {
            let ref = Database.database(url:"https://p12voisinmalin-default-rtdb.europe-west1.firebasedatabase.app").reference()
            let userid = Auth.auth().currentUser?.uid
            ref.child("users").child(userid!).observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let username = value?["username"] as? String ?? "no username"
                self.nameLabel.text = username
            }
            
            
            
        } else {
            presentAlert(titre: "Erreur", message: "Vous n'etes pas connecté")
        }
    }
    
    @IBAction func decoPressButton(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("deconnection impossible")
        }
    }
    


}
