//
//  UIViewController + Actions.swift
//  SalonX
//
//  Created by DK on 15/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setupBackButton() {
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(backAction(_ :)))
        backButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func backAction(_ :UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
}
