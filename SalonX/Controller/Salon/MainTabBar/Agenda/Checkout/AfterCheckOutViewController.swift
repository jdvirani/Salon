//
//  AfterCheckOutViewController.swift
//  SalonX
//
//  Created by DK on 22/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class AfterCheckOutViewController: UIViewController {
    
     @IBOutlet weak var bottomOfMainView: NSLayoutConstraint!
    
    @IBOutlet  var viewCornerStyle: [UIView]!
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet var btnCheckOut: UIButton!
    @IBOutlet weak var lblDollerPrice: UILabel!
    
    @IBOutlet weak var lblHeaderInfo: UILabel!
    
    @IBOutlet weak var txtService: UITextField!
 
    @IBOutlet weak var txtPrice: UITextField!
    
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgClientPicture: UIImageView!
    
    var durationTag = 3 {
        didSet {
            if durationTag == 1 {
                lblDuration.text = "15 min"
            } else if durationTag == 2 {
                lblDuration.text = "30 min"
            } else if durationTag == 3 {
                lblDuration.text = "45 min"
            }
        }
    }
    
    convenience init() {
        self.init(nibName: R.nib.afterCheckoutVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomOfMainView.constant = self.view.bounds.height - UIScreen.main.bounds.height + 20
        
        self.title = "After Checkout"
        
        durationTag = 3
        
        setupBackButton()
        
        setupUI()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {

        
        btnCheckOut.layer.cornerRadius = btnCheckOut.frame.height / 2
        btnCheckOut.clipsToBounds = true
        
        imgClientPicture.layer.cornerRadius = 3.0
        imgClientPicture.clipsToBounds = true
        
        viewCornerStyle.forEach({ $0.addCornerAndBorderStyle() })
        
        txtPrice.addCornerAndBorderStyle()
        txtPrice.customizeTextfield()
        
        txtService.addCornerAndBorderStyle()
        txtService.customizeTextfield()
        
        let artistName = NSAttributedString(string: "Bebe Veja", attributes: [ NSFontAttributeName:UIFont(name: "Helvetica", size: 14.0)!, NSForegroundColorAttributeName: R.color.salonX.accent()])
        
        let precedingString = NSAttributedString(string: "Start at 17:00-17:45 Marti 27 Sept 2016 By ", attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 14.0)!, NSForegroundColorAttributeName: R.color.salonX.headerBG()])
        
        let finalHeaderString = NSMutableAttributedString()
        finalHeaderString.append(precedingString)
        finalHeaderString.append(artistName)
        
        lblHeaderInfo.attributedText = finalHeaderString
    }
    
    func setupTableView() {
        
        tableView.register(R.nib.previewMessageCell(), forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 30.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
    }
}

extension AfterCheckOutViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PreviewMessageTableViewCell
        
        if indexPath.row % 2 == 0 {
            cell.lblUserName.text = "BM"
        } else {
            cell.lblUserName.text = "ME"
            cell.lblMessage.text = "OK arrive on time."
        }
        
        return cell
    }
    
}

extension AfterCheckOutViewController {
    
    @IBAction func btnIncrementTapped(_ sender: UIButton) {
        if durationTag < 4 {
            durationTag += 1
        }
    }
    
    @IBAction func btnDecrementTapped(_ sender: UIButton) {
        if durationTag > 0 {
            durationTag -= 1
        }
    }
    
}
