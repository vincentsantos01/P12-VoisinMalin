//
//  TableViewCell.swift
//  VoisinMalin
//
//  Created by vincent on 22/07/2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imageAd: UIImageView!
    @IBOutlet weak var titleAd: UILabel!
    @IBOutlet weak var locationAd: UILabel!
    @IBOutlet weak var priceAd: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
