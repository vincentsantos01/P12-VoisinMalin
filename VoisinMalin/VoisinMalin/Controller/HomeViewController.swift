//
//  HomeViewController.swift
//  VoisinMalin
//
//  Created by vincent on 23/07/2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var adPost: UIButton!
    
    
    private let authService: AuthService = AuthService()
    private let databaseManager: DatabaseManager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adPost.layer.cornerRadius = 20
        adPost.layer.borderWidth = 3
        adPost.layer.borderColor = UIColor.black.cgColor
        bindUI()
    }

    private func bindUI() {
        guard let uid = authService.currentUID else { return }
        databaseManager.getUserData(with: uid) { [unowned self] result in
            switch result {
            case .success(let userData):
                guard let userName: String = userData["username"] as? String else { return }
                self.nameLabel.text = userName
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    @IBAction func decoPressButton(_ sender: UIBarButtonItem) {
        
        authService.signOut { isSuccess in
            if !isSuccess {
                self.presentAlert(titre: "Erreur", message: "Impossible de vous déconnecter")
            }
        }

    }
    
    
    
}
