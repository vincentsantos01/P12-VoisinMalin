//
//  DetailViewController.swift
//  VoisinMalin
//
//  Created by vincent on 21/07/2021.
//

import UIKit
//import MessageUI
import FirebaseFirestore

class DetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var adDescriptionImage: UIImageView!
    @IBOutlet weak var descriptinTitleLabel: UILabel!
    @IBOutlet weak var descriptionPriceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var delButton: UIButton!
    @IBOutlet weak var favIcon: UIBarButtonItem!
    
    
    
    var demoAd: DefaultAds?
    var privateAds = [DefaultAds]()
    private let authService: AuthService = AuthService()
    private let unique = UUID().uuidString
    var database = DatabaseManager()
    var inFavorite: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAds()
        styles()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkFavorites()
        
        
    }
    
    
    func styles() {
        descriptionLabel.layer.cornerRadius = 20
        descriptionLabel.clipsToBounds = true
        descriptionPriceLabel.layer.cornerRadius = 10
        descriptionPriceLabel.clipsToBounds = true
        descriptinTitleLabel.layer.cornerRadius = 10
        descriptinTitleLabel.clipsToBounds = true
        callButton.layer.cornerRadius = 10
        callButton.clipsToBounds = true
        mailButton.layer.cornerRadius = 10
        mailButton.clipsToBounds = true
    }
    
    
    func updateAds() {
        guard let ads = demoAd else { return }
        descriptinTitleLabel.text = ads.title
        descriptionLabel.text = ads.description
        descriptionPriceLabel.text = ads.price + " €"
        let url = (URL(string: "\(ads.image)") ?? nil)!
        adDescriptionImage.load(url: url)
        UserDefaults.standard.set(authService.userMail, forKey: "userMail")
        if ads.mail == UserDefaults.standard.string(forKey: "userMail") {
            delButton.isHidden = false
        } else {
            delButton.isHidden = true
        }
    }
    
    func checkFavorites() {
        database.db.collection(K.FStore.collectionName).whereField("Title", isEqualTo: descriptinTitleLabel.text!).whereField("\(authService.currentUID ?? "oups")", isEqualTo: "")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for _ in querySnapshot!.documents {
                        self.favIcon.image = UIImage(named: "icon-blackstar")
                        self.inFavorite = true
                    }
                }
            }
    }
    
    @IBAction func favoriteButton(_ sender: UIBarButtonItem) {
        
        database.db.collection(K.FStore.collectionName).whereField("Title", isEqualTo: descriptinTitleLabel.text!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if self.inFavorite != true {
                        
                        self.database.db.collection(K.FStore.collectionName).document(document.documentID).setData(["\(self.authService.currentUID ?? "???")": ""], merge: true) { err in
                            if let err = err {
                                print("error \(err)")
                            } else {
                                print("mis en favoris")
                                self.favIcon.image = UIImage(named: "icon-blackstar")
                                self.inFavorite = true
                            }
                        }
                    } else {
                        self.database.db.collection(K.FStore.collectionName).document(document.documentID).updateData(["\(self.authService.currentUID ?? "???")": FieldValue.delete()]) { err in
                            if let err = err {
                                print("error \(err)")
                            } else {
                                print("Favoris removed!")
                                self.favIcon.image = UIImage(named: "icon-star")
                                self.inFavorite = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func callButton(_ sender: UIButton) {
        let url:NSURL = URL(string: "TEL://\(demoAd?.phone ?? "??")")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    
    @IBAction func mailButton(_ sender: UIButton) {
        let email = "\(demoAd?.mail ?? "error")"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 13.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    
    @IBAction func delButtonPressed(_ sender: Any) {
        
        database.db.collection(K.FStore.collectionName).whereField("Title", isEqualTo: descriptinTitleLabel.text!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.database.db.collection(K.FStore.collectionName).document(document.documentID).delete() { err in
                        if let err = err {
                            print("error \(err)")
                        } else {
                            print("annonce suprimée")
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
        
    }
}
