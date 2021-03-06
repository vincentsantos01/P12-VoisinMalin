//
//  SearchListController.swift
//  VoisinMalin
//
//  Created by vincent on 03/07/2021.
//
import UIKit
import CoreLocation

class SearchListController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var adsTableView: UITableView!
    @IBOutlet weak var presDeChezVous: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    
    
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var demo: DefaultAds?
    var privateAds = [DefaultAds]()
    var database = DatabaseManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styles()
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
/// Load current user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let currentGPS = "Lat: \(location.coordinate.latitude) Long: \(location.coordinate.longitude)"
            locationLabel.text = currentGPS
            locationManager?.stopUpdatingLocation()
            getAddress(fromLocation: location)
            
        }
    }
/// Get address with currenent user location
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
    
    func loadData() {
/// Load Ads in firebase
        database.db.collection(K.FStore.collectionName).getDocuments { querySnapshot, error in
            if let e = error {
                print("on dirait \(e)")
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let title = data[K.FStore.titleField] as? String, let description = data[K.FStore.descriptionField] as? String, let price = data[K.FStore.priceField] as? String, let gpslong = data[K.FStore.gpsLocationLong], let gpslat = data[K.FStore.gpsLocationLat], let sortD = data[K.FStore.sortDistance], let id = data[K.FStore.documentID], let phone = data[K.FStore.phoneField] as? String, let mail = data[K.FStore.mailField] as? String, let location = data[K.FStore.locationField] as? String, let image = data[K.FStore.imageAds] as? String, let isFav = data[K.FStore.isFavorites] as? Bool {
                            let lat = (data[K.FStore.gpsLocationLat] as! NSString).doubleValue
                            let long = (data[K.FStore.gpsLocationLong] as! NSString).doubleValue
                            let adDistance = CLLocation(latitude: lat, longitude: long)
                            let distance = (self.locationManager?.location?.distance(from: adDistance) ?? 0)/1000
                            let roundedDistance = distance.rounded()
                            var newad = DefaultAds(title: title, price: price, location: location, image: image, description: description, phone: phone, mail: mail, documentID: id as! String, gpsLocationLat: gpslat as! String, gpsLocationLong: gpslong as! String, sortDistance: (sortD as! NSString).doubleValue, isFavotites: isFav )
                            newad.sortDistance = roundedDistance
                            self.privateAds.append(newad)
                            self.privateAds.sort(by: {$0.title < $1.title})
                            self.adsTableView?.reloadData()
                        }
                    }
                }
            }
        }
        
    }
/// Modify styles UI
    func styles() {
        adsTableView.layer.cornerRadius = 40
        adsTableView.clipsToBounds = true
        presDeChezVous.layer.cornerRadius = 20
        presDeChezVous.clipsToBounds = true
        
    }
    
    @IBAction func sortSegmentPressed(_ sender: UISegmentedControl) {
        
        switch sortSegmentedControl.selectedSegmentIndex {
        case 0:
            privateAds.sort(by: {$0.title < $1.title})
            adsTableView.reloadData()
        case 1:
            privateAds.sort(by: {$0.sortDistance < $1.sortDistance})
            adsTableView.reloadData()
        default:
            break
        }
    }
}

extension SearchListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return privateAds.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdsCell", for: indexPath) as! TableViewCell
        
        
        let currentAd = privateAds[indexPath.row]
        cell.titleAd.text = currentAd.title
        cell.locationAd.text = currentAd.location
        cell.priceAd.text = currentAd.price + "???"
        let url = (URL(string: "\(currentAd.image)") ?? nil)!
        cell.imageAd.load(url: url)
        cell.distanceLabel.text = "\(String(format: "%.0f",currentAd.sortDistance)) Kms"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adsDetail = privateAds[indexPath.row]
        demo = DefaultAds(title: adsDetail.title,price: adsDetail.price, location: adsDetail.location, image: adsDetail.image, description: adsDetail.description, phone: adsDetail.phone, mail: adsDetail.mail, documentID: adsDetail.documentID, gpsLocationLat: adsDetail.gpsLocationLat, gpsLocationLong: adsDetail.gpsLocationLong, sortDistance: adsDetail.sortDistance, isFavotites: adsDetail.isFavotites)
        performSegue(withIdentifier: "searchToDetail", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 250
    }
}


