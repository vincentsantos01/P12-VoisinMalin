//
//  SearchListController.swift
//  VoisinMalin
//
//  Created by vincent on 03/07/2021.
//
import Foundation
import UIKit
import FirebaseDatabase
import Firebase

class SearchListController: UIViewController {

    @IBOutlet weak var adsTableView: UITableView!
    @IBOutlet weak var presDeChezVous: UILabel!
    
    var databaseRef: DatabaseReference?
    var data = Database.database()
    var defaultAdsessai: [DefaultAds] = []
    var demo: DefaultAds?
    var exDb: DatabaseManager?
    var privateAds = [DefaultAds]()
    var db = Firestore.firestore()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        demoAdProject()
        //adsTableView.reloadData()
        styles()
        loadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let recipeVC = segue.destination as? DetailViewController else { return }
        recipeVC.demoAd = demo
    }
    
    func loadData() {
        
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
                            self.adsTableView.reloadData()
                        }
                    }
                }
            }
        }
        
    }
    
    func demoAdProject() {
        let ad1 = DefaultAds(title: "VTT décathlon", price: "120", location: "Lyon 8", image: "vtt", description: "ceci est un joli VTT", phone: "0410111213", mail: "salut@lolol.fr")
        let ad2 = DefaultAds(title: "Jeu video FIFA", price: "50", location: "Paris", image: "fifa", description: "Super jeu", phone: "0410111213", mail: "fff@lolol.fr")
        let ad3 = DefaultAds(title: "Renault Clio II", price: "9000", location: "Dijon", image: "clio", description: "CT ok", phone: "0410111213", mail: "salut@lolol.fr")
        defaultAdsessai = [ad1, ad2, ad3]
    }
    func styles() {
        adsTableView.layer.cornerRadius = 40
        adsTableView.clipsToBounds = true
        presDeChezVous.layer.cornerRadius = 20
        presDeChezVous.clipsToBounds = true
        
    }


}
extension SearchListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return privateAds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdsCell", for: indexPath) as! TableViewCell
        let currentAd = privateAds[indexPath.row]
        cell.titleAd.text = currentAd.title
        
        cell.locationAd.text = currentAd.location
        cell.priceAd.text = currentAd.price + "€"
        let url = (URL(string: "\(currentAd.image)") ?? nil)!
        cell.imageAd.load(url: url)
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adsDetail = defaultAdsessai[indexPath.row]
        demo = DefaultAds(title: adsDetail.title,price: adsDetail.price, location: adsDetail.location, image: adsDetail.image, description: adsDetail.description, phone: adsDetail.phone, mail: adsDetail.mail)
        performSegue(withIdentifier: "searchToDetail", sender: self)
    }
}

extension SearchListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 250
    }
}


