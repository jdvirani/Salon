//
//  UIImage + Apperance.swift
//  SalonX
//
//  Created by DK on 10/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
