//
//  HomeViewController.swift
//  VoisinMalin
//
//  Created by vincent on 23/07/2021.
//

import UIKit
import FirebaseDatabase
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var adPost: UIButton!
    @IBOutlet weak var persoTableView: UITableView!
    @IBOutlet weak var postedAdsLabel: UILabel!
    
    
    
    private let authService: AuthService = AuthService()
    private let databaseManager: DatabaseManager = DatabaseManager()
    var databaseRef: DatabaseReference?
    var essai: [adessai] = [adessai]()
    var privateAds = [DefaultAds]()
    var db = Firestore.firestore()
    var exDb: DatabaseManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adPost.layer.cornerRadius = 20
        adPost.layer.borderWidth = 3
        adPost.layer.borderColor = UIColor.black.cgColor
        persoTableView.layer.cornerRadius = 10
        bindUI()
        persoTableView.dataSource = self
        persoTableView.delegate = self
        essai = [adessai]()
        
        privateAds = []
        
        db.collection(K.FStore.collectionName).getDocuments { querySnapshot, error in
            if let e = error {
                print("on dirait \(e)")
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        print(doc.data())
                        let data = doc.data()
                        if let title = data[K.FStore.titleField] as? String, let description = data[K.FStore.descriptionField] as? String, let price = data[K.FStore.priceField] as? String, let phone = data[K.FStore.phoneField] as? String, let mail = data[K.FStore.mailField] as? String, let location = data[K.FStore.locationField] as? String, let image = data[K.FStore.imageAds] as? String {
                            let newad = DefaultAds(title: title, price: price, location: location, image: image, description: description, phone: phone, mail: mail)
                            self.privateAds.append(newad)
                            self.persoTableView.reloadData()
                        }
                    }
                }
            }
        }
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
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return privateAds.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let persoAd = privateAds[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "persoCell", for: indexPath) as! PersonnalTableViewCell
        cell.persoTitle.text = persoAd.title
        cell.persoPrice.text = persoAd.price + "€"
        let url = (URL(string: "\(persoAd.image)") ?? nil)!
        cell.persoImage.load(url: url)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
}
