//
//  HeaderView.swift
//  LabelTeste
//
//  Created by Rondinelli Morais on 11/09/15.
//  Copyright (c) 2015 Rondinelli Morais. All rights reserved.
//

import UIKit

@objc protocol HeaderViewDelegate: NSObjectProtocol {
    @objc func headerViewOpen(_ section:Int)
    @objc func headerViewClose(_ section:Int)
}

@objc protocol HeaderDelegate {
    @objc optional func headerView(_ headerView: HeaderView, didDelete section: Int)
}

class HeaderView: UIView {
    
    private var delegate:HeaderViewDelegate?
    var headerDelegate:HeaderDelegate?
    var section:Int?
    var tableView:UIExpandableTableView?
//    var btnHashTag:UIButton!
//    var lblCount: UILabel!
//    var btnDelete:UIButton!
    
    var Img_Header: UIImageView!
    var lbl_HeaderName: UILabel!
    var BgBottomView: UIView!
    
    
//    leading...72
    
    
    required init(tableView:UIExpandableTableView, section:Int){
        
        let height = tableView.delegate?.tableView!(tableView, heightForHeaderInSection: section)
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: height!)
        
        
        super.init(frame: frame)
        
        self.tableView = tableView
        self.delegate = tableView
        self.section = section
        
        let toggleButton = UIButton(type: .custom)
        toggleButton.addTarget(self, action: #selector(HeaderView.toggle(_:)), for: UIControlEvents.touchUpInside)
        toggleButton.backgroundColor = UIColor.clear
        toggleButton.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(toggleButton)
        
        self.Img_Header = UIImageView()
        self.Img_Header.frame = CGRect(x:28, y: 10, width: frame.size.height - 20, height: frame.size.height - 20)
        self.Img_Header.image = UIImage(named: "ic_hair_category")
        self.Img_Header.backgroundColor = UIColor.clear
        addSubview(Img_Header)
        
//        self.btnHashTag = UIButton()
//        self.btnHashTag.frame = CGRect(x:0, y: 0, width: frame.size.width - 100, height: frame.size.height)
//        self.btnHashTag.setTitleColor(.white, for: .normal)
//       
//        
//        self.btnHashTag.backgroundColor = .clear
//        self.btnHashTag.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        self.btnHashTag.tag = section
//        self.btnHashTag.isUserInteractionEnabled = false
//        addSubview(btnHashTag)
        
        lbl_HeaderName = UILabel(frame: CGRect(x:Img_Header.frame.origin.x + Img_Header.frame.size.width + 15, y: 10, width: self.frame.size.width - Img_Header.frame.origin.x - Img_Header.frame.size.width - 15, height: frame.size.height-20))
        addSubview(lbl_HeaderName)
        
        self.lbl_HeaderName.text = "Hair"
        self.lbl_HeaderName.textColor = .black
        self.lbl_HeaderName.backgroundColor = .clear
        self.lbl_HeaderName.textAlignment = .left
        
        
        BgBottomView = UIView(frame: CGRect(x:0, y: lbl_HeaderName.frame.origin.y + lbl_HeaderName.frame.size.height + 4, width: self.frame.size.width, height: 6))
        BgBottomView.backgroundColor = UIColor.white
        addSubview(BgBottomView)
        
//        lblCount = UILabel(frame: CGRect(x: btnHashTag.frame.size.width, y: 0, width: 65, height: frame.size.height))
//        addSubview(lblCount)
//        
//        self.lblCount.text = "30"
//        self.lblCount.textColor = .white
//        self.lblCount.backgroundColor = .clear
//        self.lblCount.textAlignment = .center
//        
//        self.btnDelete = UIButton(type: .custom)
//        self.btnDelete.setImage(UIImage(named: "ic_delete_peek.png"), for: .normal)
//        self.btnDelete.frame = CGRect(x: lblCount.frame.origin.x + lblCount.frame.size.width, y: 0, width: 35, height: frame.size.height)
//        self.btnDelete.backgroundColor = .clear
//        self.btnDelete.tag = section
//        self.btnDelete.addTarget(self, action: #selector(btnDeleteAction(_:)), for: .touchUpInside)
//        addSubview(btnDelete)
    }
    
    func btnDeleteAction(_ sender:UIButton) {
        if self.headerDelegate != nil {
            self.headerDelegate?.headerView!(self, didDelete: section!)
        }
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
    }
    
    func toggle(_ sender:AnyObject){
        
        if self.tableView!.sectionOpen != section! {
            self.delegate?.headerViewOpen(section!)
            
        } else if self.tableView!.sectionOpen != NSNotFound {
            self.delegate?.headerViewClose(self.tableView!.sectionOpen)
        }
    }
}
