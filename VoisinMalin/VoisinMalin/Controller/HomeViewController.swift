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
    @IBOutlet weak var persoTableView: UITableView!
    @IBOutlet weak var postedAdsLabel: UILabel!
    @IBOutlet weak var noAdsLabel: UILabel!
    @IBOutlet weak var anooncePoste: UILabel!
    
    
    
    private let authService: AuthService = AuthService()
    private let databaseManager: DatabaseManager = DatabaseManager()
    var privateAds = [DefaultAds]()
    var fff: DefaultAds?
    var database = DatabaseManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(authService.userMail, forKey: "userMail")
        adPost.layer.cornerRadius = 20
        adPost.layer.borderWidth = 3
        anooncePoste.layer.cornerRadius = 20
        anooncePoste.layer.borderWidth = 1
        adPost.layer.borderColor = UIColor.black.cgColor
        persoTableView.layer.cornerRadius = 10
        bindUI()
        persoTableView.dataSource = self
        persoTableView.delegate = self
        uploadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let recipeVC = segue.destination as? DetailViewController else { return }
        recipeVC.demoAd = fff
    }
    
    private func uploadData() {
        privateAds = []
        database.db.collection(K.FStore.collectionName).getDocuments { querySnapshot, error in
            if let e = error {
                print("on dirait \(e)")
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        print(doc.data())
                        let data = doc.data()
                        if let title = data[K.FStore.titleField] as? String, let description = data[K.FStore.descriptionField] as? String, let id = data[K.FStore.documentID], let isFav = data[K.FStore.isFavorites], let gpslat = data[K.FStore.gpsLocationLat], let gpslong = data[K.FStore.gpsLocationLong], let price = data[K.FStore.priceField] as? String, let phone = data[K.FStore.phoneField] as? String, let mail = data[K.FStore.mailField] as? String, let location = data[K.FStore.locationField] as? String, let image = data[K.FStore.imageAds] as? String, let sortdistance = data[K.FStore.sortDistance] {
                            let newad = DefaultAds(title: title, price: price, location: location, image: image, description: description, phone: phone, mail: mail, documentID: id as! String, gpsLocationLat: gpslat as! String, gpsLocationLong: gpslong as! String, sortDistance: (sortdistance as! NSString).doubleValue, isFavotites: isFav as! Bool)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //privateAds.remove(at: 0)
            database.db.collection(K.FStore.collectionName).document().delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    //self.privateAds.remove(at: 0)
                    print("Document successfully removed!")
                    self.persoTableView.reloadData()
                }
            }
            persoTableView.reloadData()
        }
    }
    
    //  trouver comment filtrer les annonce par mail
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let persoAd = privateAds[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "persoCell", for: indexPath) as! PersonnalTableViewCell
        
        
        if persoAd.mail == UserDefaults.standard.string(forKey: "userMail") {
            cell.persoTitle.text = persoAd.title
            cell.persoPrice.text = persoAd.price + "€"
            let url = (URL(string: "\(persoAd.image)") ?? nil)!
            cell.persoImage.load(url: url)
        } else {
            persoTableView.isHidden = true
            noAdsLabel.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adsDetail = privateAds[indexPath.row]
        fff = DefaultAds(title: adsDetail.title, price: adsDetail.price, location: adsDetail.location, image: adsDetail.image, description: adsDetail.description, phone: adsDetail.phone, mail: adsDetail.mail, documentID: adsDetail.documentID, gpsLocationLat: adsDetail.gpsLocationLat, gpsLocationLong: adsDetail.gpsLocationLong, sortDistance: adsDetail.sortDistance, isFavotites: false)
        performSegue(withIdentifier: "homeToDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 95
    }
}
