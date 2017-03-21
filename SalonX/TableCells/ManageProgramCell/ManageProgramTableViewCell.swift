//
//  ManageProgramTableViewCell.swift
//  SalonX
//
//  Created by DK on 17/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import DropDown

class ManageProgramTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var lblDayName: UILabel!
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var btnStartTime: UIButton!
    @IBOutlet weak var txtCloseTime: UITextField!
    @IBOutlet weak var lblCloseTime: UILabel!
    @IBOutlet weak var btnCloseTime: UIButton!
    
    @IBOutlet var viewOfTime: [UIView]!
    
    var startDD = DropDown()
    var closeDD = DropDown()
    
    var timeItem = ["am","pm"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        [txtStartTime,txtCloseTime,btnCloseTime,btnCloseTime].forEach({ $0.isEnabled = false })

        viewOfTime.forEach({ $0.addCornerAndBorderStyle() })
        txtStartTime.addCornerAndBorderStyle()
        txtCloseTime.addCornerAndBorderStyle()
        configDropdown(dropdown: startDD, sender: btnStartTime)
        configDropdown(dropdown: closeDD, sender: btnCloseTime)
        startDD.dataSource = timeItem
        closeDD.dataSource = timeItem
        txtStartTime.delegate = self
        txtCloseTime.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configDropdown(dropdown: DropDown, sender: UIView) {
        dropdown.anchorView = sender
        dropdown.direction = .any
        dropdown.dismissMode = .onTap
        dropdown.bottomOffset = CGPoint(x: 0, y: sender.bounds.height)
        dropdown.width = sender.frame.width
        dropdown.cellHeight = 30
        dropdown.backgroundColor = UIColor.white
    }
    
    @IBAction func btnStartDDTapped(_ sender: UIButton) {
        startDD.show()
        startDD.selectionAction = { (index,item) in
            self.lblStartTime.text = item
        }
    }
    
    @IBAction func btnEndDDTapped(_ sender: UIButton) {
        closeDD.show()
        closeDD.selectionAction = { (index,item) in
            self.lblCloseTime.text = item
        }
    }
}


extension ManageProgramTableViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print(textField.tag)
        selectedTextBoxTag = textField.tag
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "openDatePicker")))
        return false
    }
}
