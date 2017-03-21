//
//  UIView + Apperance.swift
//  SalonX
//
//  Created by DK on 11/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addDashedLine(color: UIColor = .lightGray) {
        layer.sublayers?.filter({ $0.name == "DashedTopLine" }).map({ $0.removeFromSuperlayer() })
        backgroundColor = .clear
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DashedTopLine"
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [4, 4]
        
        let path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        shapeLayer.path = path
        
        layer.addSublayer(shapeLayer)
    }
    
    func addCornerAndBorderStyle() {
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = true
        self.borderWidth = 1.5
        self.borderColor = R.color.salonX.seperator()
    }
}
