//
//  AdCreateViewController.swift
//  VoisinMalin
//
//  Created by vincent on 25/07/2021.
//
//import Foundation
import UIKit
//import FirebaseStorage

class AdCreateViewController: UIViewController {
    
    
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    
    private let authService: AuthService = AuthService()
    private let FService: AuthFirestore = AuthFirestore()
    private let storage = DatabaseManager()
    private let unique = UUID().uuidString
    let ggg = SearchListController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(authService.userMail, forKey: "userMail")
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    
    @IBAction func uploadPressButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    @IBAction func publishButton(_ sender: UIButton) {
        
        if let currentUserMail = UserDefaults.standard.string(forKey: "userMail"), let title = titleLabel.text, let location = locationLabel.text, let image = UserDefaults.standard.string(forKey: "url"), let description = descriptionLabel.text, let price = priceLabel.text, let phone = phoneLabel.text {
            FService.db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.descriptionField: description, K.FStore.locationField: location, K.FStore.phoneField: phone, K.FStore.imageAds : image, K.FStore.priceField : price, K.FStore.titleField: title, K.FStore.mailField: currentUserMail]) { (error) in
                if let e = error {
                    print("raté, \(e)")
                } else {
                    print("annonce sauvegardée")
                    
                    self.ggg.privateAds = []
                    self.ggg.loadData()
                    self.ggg.adsTableView?.reloadData()
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }
            }
        }
        
        
    }
}
extension AdCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")]as? UIImage {
            uploadImage.image = image
            guard let imageData = image.pngData() else {
                return
            }
            storage.storage.child("image/\(unique)").putData(imageData, metadata: nil, completion: { _, error in
                guard error == nil else {
                    print("fail")
                    return
                }
                self.storage.storage.child("image/\(self.unique)").downloadURL(completion: { url, error in
                    guard let url = url, error == nil else {
                        return
                    }
                    let urlString = url.absoluteString
                    print("url: \(urlString)")
                    UserDefaults.standard.set(urlString, forKey: "url")
                })
            })
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
