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
    
    var defaultAd: DemoAds?
    var essai: adsData?
    var defaultAdsessai: [DemoAds] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adsTableView.register(UINib(nibName: "adsTableViewCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
        demoAdProject()
        styles()
        
    }
    
    func demoAdProject() {
        let ad1 = DemoAds(title: "VTT décathlon", price: "120", location: "Lyon 8", image: "vtt")
        let ad2 = DemoAds(title: "Jeu video FIFA", price: "50", location: "Paris", image: "fifa")
        let ad3 = DemoAds(title: "Renault Clio II", price: "9000", location: "Dijon", image: "clio")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdsCell", for: indexPath) as? adsTableViewCell else {
            fatalError("Cell can't be loaded")
        }
        let currentAd = defaultAdsessai[indexPath.row]
        cell.TitleLabel.text = currentAd.title
        cell.LocationLabel.text = currentAd.location
        cell.PriceLabel.text = currentAd.price + "€"
        cell.ImageAd.image = UIImage(named: currentAd.image)
        
        return cell
    }
}
extension SearchListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 250
    }
}
