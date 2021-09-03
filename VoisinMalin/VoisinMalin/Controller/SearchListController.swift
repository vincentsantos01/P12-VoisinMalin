//
//  SearchListController.swift
//  VoisinMalin
//
//  Created by vincent on 03/07/2021.
//
//import Foundation
import UIKit
//import FirebaseDatabase
//import Firebase
import CoreLocation

class SearchListController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var adsTableView: UITableView!
    @IBOutlet weak var presDeChezVous: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    
    
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var demo: DefaultAds?
    var sortDistance: Double?
    var privateAds = [DefaultAds]()
    var aaa: Double?
    var database = DatabaseManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styles()
        
        //sortBasedOnSegmentPressed()
        
        locationManager = CLLocationManager()
        locationManager?.startUpdatingLocation()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        adsTableView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        privateAds = []
        loadData()
        
        adsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let recipeVC = segue.destination as? DetailViewController else { return }
        recipeVC.demoAd = demo
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let currentGPS = "Lat: \(location.coordinate.latitude) Long: \(location.coordinate.longitude)"
            locationLabel.text = currentGPS
            locationManager?.stopUpdatingLocation()
            getAddress(fromLocation: location)
            
        }
    }
    
    func getAddress(fromLocation location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let _ = error {
                self.presentAlert(titre: "error", message: "error")
            }
            else if let placemarks = placemarks {
                for placemark in placemarks {
                    let address = [placemark.name,
                    placemark.postalCode,
                        placemark.locality].compactMap({$0}).joined(separator: ",  ")
                    print(address)
                }
            }
        }
    }
    
   /* func sortBasedOnSegmentPressed() {
        switch sortSegmentedControl.selectedSegmentIndex {
        case 0: // a-z
            privateAds.sort(by: {$0.title < $1.title})
        case 1: //distance
            privateAds.sort(by: {$0.gpsLocationLat > $1.gpsLocationLat && $0.gpsLocationLong > $1.gpsLocationLong})
        default:
            print("oups")
        }
        adsTableView.reloadData()
    }*/
    
    func loadData() {
        
        database.db.collection(K.FStore.collectionName).getDocuments { querySnapshot, error in
            if let e = error {
                print("on dirait \(e)")
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        print(doc.data())
                        let data = doc.data()
                        if let title = data[K.FStore.titleField] as? String, let description = data[K.FStore.descriptionField] as? String, let price = data[K.FStore.priceField] as? String, let gpslong = data[K.FStore.gpsLocationLong], let gpslat = data[K.FStore.gpsLocationLat], let sortD = data[K.FStore.sortDistance], let id = data[K.FStore.documentID], let phone = data[K.FStore.phoneField] as? String, let mail = data[K.FStore.mailField] as? String, let location = data[K.FStore.locationField] as? String, let image = data[K.FStore.imageAds] as? String {
                            let newad = DefaultAds(title: title, price: price, location: location, image: image, description: description, phone: phone, mail: mail, documentID: id as! String, gpsLocationLat: gpslat as! String, gpsLocationLong: gpslong as! String, sortDistance: sortD as! String)
                            self.privateAds.append(newad)
                            self.adsTableView?.reloadData()
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    func styles() {
        adsTableView.layer.cornerRadius = 40
        adsTableView.clipsToBounds = true
        presDeChezVous.layer.cornerRadius = 20
        presDeChezVous.clipsToBounds = true
        
    }
    
    @IBAction func sortSegmentPressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            privateAds.sort(by: {$0.title < $1.title})
            //print(privateAds)
            adsTableView.reloadData()
            
        } else if sender.selectedSegmentIndex == 1 {
            privateAds.sort(by: {$0.price < $1.price})
            adsTableView.reloadData()
            
        }
    }
 
    

    
}

extension SearchListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return privateAds.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdsCell", for: indexPath) as! TableViewCell
        
        
        var currentAd = privateAds[indexPath.row]
        cell.titleAd.text = currentAd.title
        cell.locationAd.text = currentAd.location
        cell.priceAd.text = currentAd.price + "€"
        let url = (URL(string: "\(currentAd.image)") ?? nil)!
        cell.imageAd.load(url: url)
        let lat = (currentAd.gpsLocationLat as NSString).doubleValue
        let long = (currentAd.gpsLocationLong as NSString).doubleValue
        //let sort = (currentAd.sortDistance as NSString).doubleValue
        let adDistance = CLLocation(latitude: lat, longitude: long)
        
        let distance = (locationManager?.location?.distance(from: adDistance) ?? 0)/1000
        
        cell.distanceLabel.text = "\(String(format: "%.0f",distance)) Kms"
        //currentAd.sortDistance = String(format: "%.0f",distance)
        //print(adDistance)
        
        return cell
        }
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adsDetail = privateAds[indexPath.row]
        demo = DefaultAds(title: adsDetail.title,price: adsDetail.price, location: adsDetail.location, image: adsDetail.image, description: adsDetail.description, phone: adsDetail.phone, mail: adsDetail.mail, documentID: adsDetail.documentID, gpsLocationLat: adsDetail.gpsLocationLat, gpsLocationLong: adsDetail.gpsLocationLong, sortDistance: adsDetail.sortDistance)
        performSegue(withIdentifier: "searchToDetail", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 250
    }
}


