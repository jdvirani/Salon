//
//  BookingCell.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/22/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class BookingCell: UITableViewCell {

    @IBOutlet weak var Img_Booking: UIImageView!
    
    @IBOutlet weak var lbl_StyleName: UILabel!
    
    
    @IBOutlet weak var lbl_Time: UILabel!
    
    @IBOutlet weak var lbl_NewPrice: UILabel!
    
    @IBOutlet weak var lbl_OldPrice: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
