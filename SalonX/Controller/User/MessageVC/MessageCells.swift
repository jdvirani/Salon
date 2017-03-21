//
//  MessageCells.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/25/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class MessageCells: UITableViewCell {
//    MARK:- MessageSenderCell
    
    @IBOutlet weak var Img_Sender: UIImageView!
    @IBOutlet weak var lbl_SenderMessage: UILabel!
    @IBOutlet weak var lbl_SenderName: UILabel!
    @IBOutlet weak var lbl_SenderTime: UILabel!
    
    //  MARK:- MessageRecieverCell
    
    @IBOutlet weak var Img_bgText: UIImageView!
    @IBOutlet weak var Img_Reciver: UIImageView!
    @IBOutlet weak var lbl_ReciverMessage: UILabel!
    @IBOutlet weak var lbl_ReciverName: UILabel!
    @IBOutlet weak var lbl_ReciverTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
