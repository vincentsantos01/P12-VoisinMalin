//
//  PersonnalTableViewCell.swift
//  VoisinMalin
//
//  Created by vincent on 19/08/2021.
//

import UIKit


class PersonnalTableViewCell: UITableViewCell {

    
    @IBOutlet weak var persoImage: UIImageView!
    @IBOutlet weak var persoTitle: UILabel!
    @IBOutlet weak var persoPrice: UILabel!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
