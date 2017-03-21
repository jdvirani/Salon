//
//  UITextField + Apperance.swift
//  SalonX
//
//  Created by DK on 10/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func customizeTextfield()
    {
        let leftView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        leftView.backgroundColor = UIColor.clear
        self.leftView = leftView
        self.leftViewMode = UITextFieldViewMode.always
        
        let rightView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        rightView.backgroundColor = UIColor.clear
        self.rightView = rightView
        self.rightViewMode = UITextFieldViewMode.always
        self.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        self.alpha = 0.8
    }
}
