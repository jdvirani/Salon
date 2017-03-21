//
//  ServiceItemTableViewCell.swift
//  SalonX
//
//  Created by DK on 16/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import FontAwesome_swift

class ServiceItemTableViewCell: UITableViewCell {

    @IBOutlet weak var viewRound: UIView!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDeleteService: UIButton!
    
    var index: IndexPath!
    
    var serviceIndexDelegate: ServiceIndexDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        btnDeleteService.titleLabel?.font = UIFont.fontAwesome(ofSize: 22.0)
        btnDeleteService.setTitleColor(R.color.salonX.accent(), for: .normal)
        btnDeleteService.setTitle("\(String.fontAwesomeIcon(name: .trash))", for: .normal)
        
        viewRound.layer.cornerRadius = viewRound.frame.width / 2
        viewRound.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btbEditTapped(_ sender: UIButton) {
        serviceIndexDelegate.editService!(atIndex: index)
    }
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        serviceIndexDelegate.deleteService!(atIndex: index)
    }

}






