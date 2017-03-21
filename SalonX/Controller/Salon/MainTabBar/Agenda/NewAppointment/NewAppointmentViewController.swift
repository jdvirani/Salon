//
//  NewAppointmentViewController.swift
//  SalonX
//
//  Created by DK on 21/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class NewAppointmentViewController: UIViewController {
    
    @IBOutlet weak var lblHeaderInfo: UILabel!
    @IBOutlet weak var txtServiceName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var lblClientName: UILabel!
    @IBOutlet weak var imgClientPicture: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnSMSCheckBoc: UIButton!
    @IBOutlet weak var btnEmailCheckBox: UIButton!
    
    @IBOutlet var viewWithCorner: [UIView]!
    
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
        self.init(nibName: R.nib.newAppointmentVC.name, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "New Appointment"
        
        durationTag = 3
        
        setupUI()
        
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        viewWithCorner.forEach({ $0.addCornerAndBorderStyle() })
        imgClientPicture.layer.cornerRadius = 3.0
        imgClientPicture.clipsToBounds = true
        txtServiceName.addCornerAndBorderStyle()
        txtServiceName.customizeTextfield()
        txtPrice.addCornerAndBorderStyle()
        txtPrice.customizeTextfield()
        
        btnSMSCheckBoc.isSelected = true
        
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

extension NewAppointmentViewController {
    
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
    
    @IBAction func btnCallTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnEmailTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnSMSCheckBox(_ sender: UIButton) {
        if btnSMSCheckBoc.isSelected {
            btnSMSCheckBoc.isSelected = false
        } else {
            btnSMSCheckBoc.isSelected = true
        }
    }
    
    @IBAction func btnEmailCheckBox(_ sender: UIButton) {
        if btnEmailCheckBox.isSelected {
            btnEmailCheckBox.isSelected = false
        } else {
            btnEmailCheckBox.isSelected = true

        }
    }
    
    @IBAction func btnAcceptTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnRejectTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnModifyTapped(_ sender: UIButton) {
        
    }
}

extension NewAppointmentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PreviewMessageTableViewCell
        
        return cell
    }
    
}




