//
//  ConfirmBookingCell.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 3/4/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class ConfirmBookingCell: UITableViewCell {

    @IBOutlet weak var StaffView: UIView!
    @IBOutlet weak var DiscountView: UIView!
    @IBOutlet weak var img_BeautyType: UIImageView!
    @IBOutlet weak var lbl_BeautyName: UILabel!
    @IBOutlet weak var lbl_BeautyStyle: UILabel!
    @IBOutlet weak var lbl_OtherBeautyStyle: UILabel!
    @IBOutlet weak var StarView: TQStarRatingView!
    @IBOutlet weak var lbl_StarCount: UILabel!
    
    @IBOutlet weak var lbl_StaticDate: UILabel!
    @IBOutlet weak var lbl_StaticDuration: UILabel!
    @IBOutlet weak var lbl_StaticPrice: UILabel!
    @IBOutlet weak var lbl_StaticDiscount: UILabel!
    @IBOutlet weak var lbl_StaticPromocode: UILabel!
    @IBOutlet weak var lbl_StaticStaff: UILabel!
    @IBOutlet weak var lbl_StaticTotal: UILabel!
    
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Duration: UILabel!
    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var lbl_Discount: UILabel!
    @IBOutlet weak var lbl_Promocode: UILabel!
    @IBOutlet weak var lbl_Staff: UILabel!
    @IBOutlet weak var lbl_Total: UILabel!
    
    @IBOutlet weak var constantStaffViewHight: NSLayoutConstraint! // 31
    
    @IBOutlet weak var constantDiscountViewHeight: NSLayoutConstraint! //48
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setLocalizedStaticText()
    }
    
    func setLocalizedStaticText() {
        
        lbl_StaticDate.text = LocalizedString(key: "lbl_ConfirmBooking_Date")
        lbl_StaticDuration.text = LocalizedString(key: "lbl_ConfirmBooking_Duration")
        lbl_StaticPrice.text = LocalizedString(key: "lbl_ConfirmBooking_Price")
        lbl_StaticDiscount.text = LocalizedString(key: "lbl_ConfirmBooking_Discount")
        lbl_StaticPromocode.text = LocalizedString(key: "lbl_ConfirmBooking_Promocode")
        lbl_StaticStaff.text = LocalizedString(key: "lbl_BookLastminOfferCell1_Staff")
        lbl_StaticTotal.text = LocalizedString(key: "lbl_BookLastminOfferCell1_Total")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
