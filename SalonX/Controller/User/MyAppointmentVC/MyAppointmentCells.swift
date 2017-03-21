//
//  MyAppointmentCells.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/24/17.
//  Copyright © 2017 dignizant. All rights reserved.
//


import UIKit

class MyAppointmentCells: UITableViewCell {

//    MARK:- MyAppointmentHeaderCell
    @IBOutlet weak var Img_Header: UIImageView!
    @IBOutlet weak var lbl_StylishName: UILabel!
    @IBOutlet weak var lbl_Style: UILabel!
    @IBOutlet weak var lbl_RateView: TQStarRatingView!
    @IBOutlet weak var lbl_StarCount: UILabel!
    
//    MARK:- MyAppointmentUpcomingCell
    @IBOutlet weak var lbl_UpStylishName: UILabel!
    @IBOutlet weak var lbl_UpTime: UILabel!
    @IBOutlet weak var lbl_UpPrice: UILabel!
    @IBOutlet weak var lbl_UpDateTime: UILabel!
    @IBOutlet weak var btn_UpMessage: UIButton!
    @IBOutlet weak var btn_UpModify: UIButton!
    @IBOutlet weak var btn_UpCancel: UIButton!
    
//    MARK:- MyAppointmentUpcomingLastMinCell
    @IBOutlet weak var lbl_UpLast_StylishName: UILabel!
    @IBOutlet weak var lbl_UpLast_Time: UILabel!
    @IBOutlet weak var lbl_UpLast_ByName: UILabel!
    @IBOutlet weak var lbl_UpLast_NewPrice: UILabel!
    @IBOutlet weak var lbl_UpLast_OldPrice: UILabel!
    @IBOutlet weak var lbl_UpLast_DateTime: UILabel!
    @IBOutlet weak var btn_UpLast_Message: UIButton!
    @IBOutlet weak var btn_UpLast_Cancel: UIButton!
    
    @IBOutlet weak var btn_UpLastStaticLastMintOffer: UIButton!

/*    Localized Keys below:-
      btn_MyAppointmentCell_Message
      btn_MyAppointmentCell_Reshedule
      btn_MyAppointmentCell_Fedback
      btn_MyAppointmentCell_Modify
      btn_MyAppointmentCell_Cancel
      btn_MyAppointmentLastMintOffer
*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
