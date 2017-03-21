//
//  LastMintOfferCell.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/20/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class LastMintOfferCell: UITableViewCell {
    
//    MARK:- LastMintOfferCell
    
    @IBOutlet weak var Img_LastMint: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Offer: UILabel!
    @IBOutlet weak var lbl_NewPrice: UILabel!
    @IBOutlet weak var lbl_OldPrice: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    
    
//    MARK:- LastMintOfferDetailCell

    @IBOutlet weak var lbl_HairStylishName: UILabel!
    @IBOutlet weak var lbl_Stylish: UILabel!
    @IBOutlet weak var lblRateStarView: TQStarRatingView!
    @IBOutlet weak var lbl_StarCount: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lbl_OtherStylishName: UILabel!
    @IBOutlet weak var lbl_OtherStylish: UILabel!
    @IBOutlet weak var lbl_Description: UILabel!
    @IBOutlet weak var lbl_Policy: UILabel!
    @IBOutlet weak var btn_BookNow: UIButton!
    
    @IBOutlet weak var lbl_StaticDescription: UILabel!
    @IBOutlet weak var lbl_StaticCancelPolicy: UILabel!
    
    
//    MARK:- LastMintOfferBookCell1,2,3
    
    @IBOutlet weak var Img_OfferBook: UIImageView!
    @IBOutlet weak var lbl_TitleName: UILabel!
    @IBOutlet weak var lblstarViewBook: TQStarRatingView!
    @IBOutlet weak var lbl_StarCountBook: UILabel!
    @IBOutlet weak var lbl_StaffName: UILabel!
    @IBOutlet weak var lbl_StylishNameBook: UILabel!
    @IBOutlet weak var lbl_StyleTypeBook: UILabel!
    @IBOutlet weak var lbl_DiscountBook: UILabel!
    @IBOutlet weak var lbl_NewPriceBook: UILabel!
    @IBOutlet weak var lbl_OldPriceBook: UILabel!
    @IBOutlet weak var lbl_TimeBook: UILabel!
    @IBOutlet weak var lbl_TotalBook: UILabel!
    @IBOutlet weak var lbl_SureTextBook: UILabel!
    @IBOutlet weak var btn_YesBook: UIButton!
    @IBOutlet weak var btnNoBook: UIButton!
    @IBOutlet weak var txt_Message: KMPlaceholderTextView!
    @IBOutlet weak var btn_PayVenyBook: UIButton!
    @IBOutlet weak var btn_PayUBook: UIButton!
    @IBOutlet weak var lbl_DescriptionBook: UILabel!
    @IBOutlet weak var btn_AcceptBook: UIButton!
    @IBOutlet weak var btn_FinishPaymentBook: UIButton!
    
    @IBOutlet weak var lbl_Static_staff: UILabel!
    @IBOutlet weak var lbl_Static_Yes: UILabel!
    @IBOutlet weak var lbl_Static_No: UILabel!
    @IBOutlet weak var lbl_Static_PayVenue: UILabel!
    @IBOutlet weak var lbl_Static_PayU: UILabel!
    @IBOutlet weak var lbl_Static_AcceptTNCSalonx: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    
    
    
    
    
    func setLocalizedStaticTextForLastMintOfferDetailCell() {
        lbl_StaticDescription.text = LocalizedString(key: "lbl_BookLastminOfferCell_Description")
        lbl_StaticCancelPolicy.text = LocalizedString(key: "lbl_BookLastminOfferCell_CancelPolicy")
        btn_BookNow.setTitle(LocalizedString(key: "btn_BookLastminOfferCell_BookNow"), for: .normal)
    }
    
    func setLocalizedStaticTextForLastMintOfferBookCell3() {
        
        lbl_Static_PayVenue.text = LocalizedString(key: "lbl_BookLastminOfferCell3_PayVenue")
        lbl_Static_PayU.text = LocalizedString(key: "lbl_BookLastminOfferCell3_PayU")
        lbl_Static_AcceptTNCSalonx.text = LocalizedString(key: "lbl_BookLastminOfferCell3_AcceptTNCSalon")
        btn_FinishPaymentBook.setTitle(LocalizedString(key: "lbl_BookLastminOfferCell3_FinishPayment"), for: .normal)
     }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
