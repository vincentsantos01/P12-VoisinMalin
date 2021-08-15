//
//  DetailViewController.swift
//  VoisinMalin
//
//  Created by vincent on 21/07/2021.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var adDescriptionImage: UIImageView!
    @IBOutlet weak var descriptinTitleLabel: UILabel!
    @IBOutlet weak var descriptionPriceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    
    
       
    var demoAd: DemoAds?
    //var adsRepresentable: AdsRepresentable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAds()
        styles()
        
    }
    
    func styles() {
        descriptionLabel.layer.cornerRadius = 40
        descriptionLabel.clipsToBounds = true
        descriptionPriceLabel.layer.cornerRadius = 20
        descriptionPriceLabel.clipsToBounds = true
        descriptinTitleLabel.layer.cornerRadius = 20
        descriptinTitleLabel.clipsToBounds = true
    }
    
    
    func updateAds() {
        guard let ads = demoAd else { return }
        descriptinTitleLabel.text = ads.title
        descriptionLabel.text = ads.description
        descriptionPriceLabel.text = ads.price + " €"
        adDescriptionImage.image = UIImage(named: ads.image)
        
    }
}
