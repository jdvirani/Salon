//
//  SalonBookNowSubCell.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/21/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class SalonBookNowSubCell: UITableViewCell {

    @IBOutlet weak var Constanlbl_StyleNameBottom: NSLayoutConstraint! //3
    @IBOutlet weak var lbl_StyleName: UILabel!
    
    @IBOutlet weak var lbl_Time: UILabel!
    
    @IBOutlet weak var lbl_Price: UILabel!
    
    @IBOutlet weak var btn_BookNow: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btn_BookNow.setTitle(LocalizedString(key: "btn_BookLastminOfferCell_BookNow"), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
