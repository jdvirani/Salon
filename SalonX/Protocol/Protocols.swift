//
//  Protocols.swift
//  SalonX
//
//  Created by DK on 16/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol NewGroupAddedDelegate {
    func didNewGroupAdded(groupName: String)
}


protocol TimePickerDelegate {
    func didSelectTime(time: String?)
}

@objc protocol ServiceIndexDelegate {
  @objc optional func editService(atIndex: IndexPath)
  @objc optional func deleteService(atIndex: IndexPath)
    
}

protocol ClientDetailChangedDelgate {
    func isDetailChanged(status: Bool)
}

enum PushType: Int{
    case login = 0
    case signup
}


