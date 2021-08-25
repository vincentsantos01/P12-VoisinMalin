//
//  DefaultAd.swift
//  VoisinMalin
//
//  Created by vincent on 20/07/2021.
//

import Foundation

struct adsData {
    let hit: [DefaultAds]
}
struct ooo {
    let recipe: DefaultAds
}
struct RecipeData {
    let hits: [DefaultAds]
}
struct DefaultAds {
    let title: String
    let price: String
    let location: String
    let image: String
    let description: String
    let phone: String
    let mail: String
    let documentID: String
}
class adessai {
    var key: String
    var price: String
    var location: String
    var image = ""
    var description: String
    var phone: String
    var mail: String
    
    init(dictionary: [String: AnyObject], key: String) {
        self.key = key
        self.price = dictionary["Price"] as! String
        self.location = dictionary["Location"] as! String
        self.image = dictionary["Image"] as! String
        self.description = dictionary["Description"] as! String
        self.phone = dictionary["Phone"] as! String
        self.mail = dictionary["Mail"] as! String
    }
    
}
