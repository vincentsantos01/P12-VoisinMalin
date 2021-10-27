//
//  FavoritListController.swift
//  VoisinMalin
//
//  Created by vincent on 03/07/2021.
//

import UIKit
import FirebaseFirestore


class FavoriteListController: UIViewController {
    
    
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var annonceSaveLabel: UILabel!
    
    var privateAds = [DefaultAds]()
    var database = DatabaseManager()
    var favoriteTableViewData: DefaultAds?
    private let authService: AuthService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styles()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        privateAds = []
        loadData()
        favoriteTableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let recipeVC = segue.destination as? DetailViewController else { return }
        recipeVC.demoAd = favoriteTableViewData
    }
    
    func loadData() {
 /// Load Ads in firebase and add favorite filter for use
        database.db.collection(K.FStore.collectionName).whereField("\(authService.currentUID ?? "oups")", isEqualTo: "").getDocuments { querySnapshot, error in
            if let e = error {
                print("on dirait \(e)")
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let title = data[K.FStore.titleField] as? String, let description = data[K.FStore.descriptionField] as? String, let price = data[K.FStore.priceField] as? String, let gpslong = data[K.FStore.gpsLocationLong], let gpslat = data[K.FStore.gpsLocationLat], let sortD = data[K.FStore.sortDistance], let id = data[K.FStore.documentID], let phone = data[K.FStore.phoneField] as? String, let mail = data[K.FStore.mailField] as? String, let location = data[K.FStore.locationField] as? String, let image = data[K.FStore.imageAds] as? String, let isFav = data[K.FStore.isFavorites] as? Bool {
                            
                            
                            let newad = DefaultAds(title: title, price: price, location: location, image: image, description: description, phone: phone, mail: mail, documentID: id as! String, gpsLocationLat: gpslat as! String, gpsLocationLong: gpslong as! String, sortDistance: (sortD as! NSString).doubleValue, isFavotites: isFav )
                            
                            self.privateAds.append(newad)
                            self.privateAds.sort(by: {$0.title < $1.title})
                            self.favoriteTableView?.reloadData()
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    func styles() {
        favoriteTableView.layer.cornerRadius = 40
        favoriteTableView.clipsToBounds = true
        annonceSaveLabel.layer.cornerRadius = 20
        annonceSaveLabel.clipsToBounds = true
    }
    
    
    
}
extension FavoriteListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return privateAds.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavoriteTableViewCell
        
        
        let favoriteAd = privateAds[indexPath.row]
        
        database.db.collection(K.FStore.collectionName).whereField("Title", isEqualTo: favoriteAd.title).whereField("\(authService.currentUID ?? "oups")", isEqualTo: "")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for _ in querySnapshot!.documents {
                        cell.favoriteTitle.text = favoriteAd.title
                        cell.favoritePrice.text = favoriteAd.price + "€"
                        let url = (URL(string: "\(favoriteAd.image)") ?? nil)!
                        cell.favoriteImage.load(url: url)
                    }
                }
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let favoriteAd = privateAds[indexPath.row]
            
            database.db.collection(K.FStore.collectionName).whereField("Title", isEqualTo: favoriteAd.title).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        self.database.db.collection(K.FStore.collectionName).document(document.documentID).updateData(["\(self.authService.currentUID ?? "???")": FieldValue.delete()]) { err in
                            if let err = err {
                                print("error \(err)")
                            } else {
                                print("Favoris removed!")
                                self.favoriteTableView.reloadData()
                            }
                        }
                    }
                }
                
            }
            
        }
        favoriteTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adsDetail = privateAds[indexPath.row]
        favoriteTableViewData = DefaultAds(title: adsDetail.title, price: adsDetail.price, location: adsDetail.location, image: adsDetail.image, description: adsDetail.description, phone: adsDetail.phone, mail: adsDetail.mail, documentID: adsDetail.documentID, gpsLocationLat: adsDetail.gpsLocationLat, gpsLocationLong: adsDetail.gpsLocationLong, sortDistance: adsDetail.sortDistance, isFavotites: false)
        performSegue(withIdentifier: "favToDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 250
    }
}
