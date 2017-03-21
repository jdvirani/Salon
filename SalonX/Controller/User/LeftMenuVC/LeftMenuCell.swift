//
//  LeftMenuCell.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/17/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class LeftMenuCell: UITableViewCell {

    
    @IBOutlet weak var Img_MenuIcon: UIImageView!
    
    @IBOutlet weak var lbl_MenuTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
