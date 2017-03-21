//
//  ContactusCell.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/17/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class ContactusCell: UITableViewCell {

    @IBOutlet weak var lbl_Address: UILabel!
    
    @IBOutlet weak var img_Border: UIImageView!
    @IBOutlet weak var lbl_Phone: UILabel!
    
    @IBOutlet weak var lbl_Email: UILabel!
    
    @IBOutlet weak var txt_Name: UITextField!
    
    @IBOutlet weak var txt_Email: UITextField!
    
    @IBOutlet weak var txt_Phone: UITextField!
    
    @IBOutlet weak var txt_Subject: UITextField!
    
    @IBOutlet weak var txt_Comment: KMPlaceholderTextView!
//    @IBOutlet weak var txt_Comment: UITextView!

    @IBOutlet weak var btn_sendMessage: UIButton!
    
    
    @IBOutlet weak var lbl_StaticFullName: UILabel!
    @IBOutlet weak var lbl_StaticEmailID: UILabel!
    @IBOutlet weak var lbl_StaticPhone: UILabel!
    @IBOutlet weak var lbl_StaticSubject: UILabel!
    @IBOutlet weak var lbl_StaticComment: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setLocalizedStaticText(ForCell:String) {

        if ForCell == "Cell1" {
            lbl_StaticFullName.text = LocalizedString(key: "lbl_ContactusFullName")
            lbl_StaticEmailID.text = LocalizedString(key: "lbl_ContactusEmailID")
            lbl_StaticPhone.text = LocalizedString(key: "lbl_ContactusPhone")
            txt_Name.placeholder = LocalizedString(key: "txtPlace_ContactusFullName")
            txt_Email.placeholder = LocalizedString(key: "txtPlace_ContactusEmailID")
            txt_Phone.placeholder = LocalizedString(key: "txtPlace_ContactusPhone")
        }
        else {
            lbl_StaticSubject.text = LocalizedString(key: "lbl_ContactusSubject")
            lbl_StaticComment.text = LocalizedString(key: "lbl_ContactusComment")
            txt_Subject.placeholder = LocalizedString(key: "txtPlace_ContactusSubject")
            txt_Comment.placeholder = LocalizedString(key: "txtPlace_ContactusComment")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
