//
//  SearchListController.swift
//  VoisinMalin
//
//  Created by vincent on 03/07/2021.
//
import Foundation
import UIKit

class SearchListController: UIViewController {

    @IBOutlet weak var adsTableView: UITableView!
    @IBOutlet weak var presDeChezVous: UILabel!
    
    //var defaultAd: DemoAds?
    var adsRepresentable: AdsRepresentable?
    //var recipeData: RecipeData?
    var defaultAdsessai: [DemoAds] = []
    var demo: DemoAds?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //adsTableView.register(UINib(nibName: "adsTableViewCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
        demoAdProject()
        adsTableView.reloadData()
        styles()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let recipeVC = segue.destination as? DetailViewController else { return }
        recipeVC.demoAd = demo
    }
    
    func demoAdProject() {
        let ad1 = DemoAds(title: "VTT décathlon", price: "120", location: "Lyon 8", image: "vtt", description: "ceci est un joli VTT", phone: "0410111213", mail: "salut@lolol.fr")
        let ad2 = DemoAds(title: "Jeu video FIFA", price: "50", location: "Paris", image: "fifa", description: "Super jeu", phone: "0410111213", mail: "fff@lolol.fr")
        let ad3 = DemoAds(title: "Renault Clio II", price: "9000", location: "Dijon", image: "clio", description: "CT ok", phone: "0410111213", mail: "salut@lolol.fr")
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
        return defaultAdsessai.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdsCell", for: indexPath) as! TableViewCell
        let currentAd = defaultAdsessai[indexPath.row]
        cell.titleAd.text = currentAd.title
        cell.locationAd.text = currentAd.location
        cell.priceAd.text = currentAd.price + "€"
        cell.imageAd.image = UIImage(named: currentAd.image)
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adsDetail = defaultAdsessai[indexPath.row]
        demo = DemoAds(title: adsDetail.title,price: adsDetail.price, location: adsDetail.location, image: adsDetail.image, description: adsDetail.description, phone: adsDetail.phone, mail: adsDetail.mail)
        performSegue(withIdentifier: "searchToDetail", sender: self)
    }
}
extension SearchListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 250
    }
}


