//
//  BookingPaymentCells.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/25/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class BookingPaymentCells: UITableViewCell {
//    MARK:- BookingPaymentPromocodeCell
    
    @IBOutlet weak var txtPromocode: UITextField!
    
    @IBOutlet weak var btn_Apply: UIButton!
    
//    MARK:- BookingPaymentCells
    
    @IBOutlet weak var Img_Person: UIImageView!
    @IBOutlet weak var lbl_Owner: UILabel!
    @IBOutlet weak var lbl_RateView: TQStarRatingView!
    @IBOutlet weak var lbl_StarCount: UILabel!
    @IBOutlet weak var lbl_OwnerStyleType: UILabel!
    @IBOutlet weak var lbl_StaffName: UILabel!
    @IBOutlet weak var lbl_StaffStyleType: UILabel!
    @IBOutlet weak var lbl_SpecialStyleType: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_TotalPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
