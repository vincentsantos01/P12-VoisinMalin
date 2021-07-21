//
//  adsTableViewCell.swift
//  VoisinMalin
//
//  Created by vincent on 20/07/2021.
//

import UIKit

class adsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var ImageAd: UIImageView!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    
    
}
