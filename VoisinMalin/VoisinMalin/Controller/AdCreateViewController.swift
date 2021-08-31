//
//  AdCreateViewController.swift
//  VoisinMalin
//
//  Created by vincent on 25/07/2021.
//
//import Foundation
import UIKit
import CoreLocation
//import FirebaseStorage

class AdCreateViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var hiddenGPSLat: UILabel!
    @IBOutlet weak var hiddenGPSLong: UILabel!
    
    private let authService: AuthService = AuthService()
    private let FService: AuthFirestore = AuthFirestore()
    private let storage = DatabaseManager()
    private let unique = UUID().uuidString
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(authService.userMail, forKey: "userMail")
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            let long = "\(location.coordinate.longitude)"
            let lat = "\(location.coordinate.latitude)"
            hiddenGPSLat.text = lat
            hiddenGPSLong.text = long
            locationManager?.stopUpdatingLocation()
            getAddress(fromLocation: location)
            
        }
    }
    
    func getAddress(fromLocation location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                self.presentAlert(titre: "error", message: "error")
            }
            else if let placemarks = placemarks {
                for placemark in placemarks {
                    let address = [placemark.name,
                                   placemark.postalCode,
                                   placemark.locality].compactMap({$0}).joined(separator: ",  ")
                    self.locationLabel.text = address
                    print(address)
                }
            }
        }
    }
    
    
    @IBAction func uploadPressButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    @IBAction func publishButton(_ sender: UIButton) {
        
        let titleVerif = titleLabel.text
        let descriptionVerif = descriptionLabel.text
        let priceVerif = priceLabel.text
        let phoneVerif = phoneLabel.text
        if titleVerif!.isBlank || descriptionVerif!.isBlank || priceVerif!.isBlank || phoneVerif!.isBlank || priceVerif!.isNumeric || phoneVerif!.isNumeric {
            presentAlert(titre: "Attention", message: "Un champ est vide ou mal entrer")
        } else {
            if let currentUserMail = UserDefaults.standard.string(forKey: "userMail"), let title = titleLabel.text, let gpslat = hiddenGPSLat.text, let gpslong = hiddenGPSLong.text, let location = locationLabel.text, let image = UserDefaults.standard.string(forKey: "url"), let description = descriptionLabel.text, let price = priceLabel.text, let phone = phoneLabel.text {
                FService.db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.descriptionField: description, K.FStore.documentID: unique, K.FStore.locationField: location, K.FStore.gpsLocationLat: gpslat, K.FStore.gpsLocationLong: gpslong, K.FStore.phoneField: phone, K.FStore.imageAds : image, K.FStore.priceField : price, K.FStore.titleField: title, K.FStore.mailField: currentUserMail]) { (error) in
                    if let e = error {
                        print("raté, \(e)")
                    } else {
                        print("annonce sauvegardée")
                        self.navigationController?.popToRootViewController(animated: true)
                        
                    }
                }
            }
        }
    }
    
    
    @IBAction func adressHidden(_ sender: UISwitch) {
        if sender.isOn {
        locationLabel.text = ""
        } else {
            getAddress
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
