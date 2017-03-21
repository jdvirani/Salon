//
//  HomeSearchHeaderSubCell.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/25/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class HomeSearchHeaderSubCell: UITableViewCell {
    
//    MARK:- HomeSearchHeaderSubCell
    @IBOutlet weak var lbl_SubName: UILabel!
    
    
    
//    MARK:- HomeSearchResultSubCell
    @IBOutlet weak var lbl_ResultSubName: UILabel!
    
    @IBOutlet weak var Img_Resultsubcell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
