//
//  DetailViewController.swift
//  VoisinMalin
//
//  Created by vincent on 21/07/2021.
//

//import Foundation
import UIKit
//import Firebase
import MessageUI

class DetailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    
    @IBOutlet weak var adDescriptionImage: UIImageView!
    @IBOutlet weak var descriptinTitleLabel: UILabel!
    @IBOutlet weak var descriptionPriceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var delButton: UIButton!
    
    
    
    var demoAd: DefaultAds?
    var privateAds = [DefaultAds]()
    private let authService: AuthService = AuthService()
    //var fbm = DatabaseManager()
    //var db = Firestore.firestore()
    var database = DatabaseManager()
    //var uid = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAds()
        styles()
        
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
    
    
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["\(demoAd?.mail ?? "??")"])
        mailComposeVC.setSubject("Annonce: \(demoAd?.title ?? "??")")
        mailComposeVC.setMessageBody("", isHTML: false)
        return mailComposeVC
    }
    
    func showMailError() {
        let sendMailAlert = UIAlertController(title: "Mail impossible", message: "Impossible d'envoyer un mail", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "ok", style: .default, handler: nil)
        sendMailAlert.addAction(dismiss)
        self.present(sendMailAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func favoriteButton(_ sender: UIBarButtonItem) {
        
    }
    
    
    @IBAction func callButton(_ sender: UIButton) {
        let url:NSURL = URL(string: "TEL://\(demoAd?.phone ?? "??")")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    
    
    @IBAction func mailButton(_ sender: UIButton) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
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
