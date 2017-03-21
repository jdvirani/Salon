//
//  AppointmentDetailViewController.swift
//  SalonX
//
//  Created by DK on 22/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import DropDown

class AppointmentDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomOfMainView: NSLayoutConstraint!
    
    @IBOutlet weak var lblHeaderInfo: UILabel!
    
    @IBOutlet var btnCornerStyle: [UIButton]!
    @IBOutlet  var viewCornerStyle: [UIView]!
    
    @IBOutlet weak var btnService: UIButton!
    @IBOutlet weak var lblService: UILabel!
    
    @IBOutlet weak var btnAddService: UIButton!
    
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var imgClientPicture: UIImageView!
    
    var serviceDD = DropDown()
    var serviceItems: [String] = ["item1","item2","item3"]
    
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
        self.init(nibName: R.nib.appointmentDetailVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomOfMainView.constant = (self.view.bounds.height - UIScreen.main.bounds.height) + 20
        
        serviceDD.dataSource = serviceItems
        
        self.title = "Click on Appointment"
        
        durationTag = 3
        
        setupUI()
        
        setupTableView()
        // Do any additional setup after loading the view.
    }

    func setupUI() {

        btnCornerStyle.forEach({ $0.layer.cornerRadius = $0.frame.height / 2
            $0.clipsToBounds = true
        })
        imgClientPicture.layer.cornerRadius = 3.0
        imgClientPicture.clipsToBounds = true
        
        viewCornerStyle.forEach({ $0.addCornerAndBorderStyle() })
        
        txtPrice.addCornerAndBorderStyle()
        txtPrice.customizeTextfield()
        
        btnAddService.titleLabel?.font = UIFont.fontAwesome(ofSize: 14.0)
        btnAddService.titleLabel?.tintColor = R.color.salonX.accent()
        btnAddService.setTitle("\(String.fontAwesomeIcon(name: .plusCircle)) Service", for: .normal)
        
        configDropdown(dropdown: serviceDD, sender: btnService)
        
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
    
    func configDropdown(dropdown: DropDown, sender: UIView) {
        dropdown.anchorView = sender
        dropdown.direction = .any
        dropdown.dismissMode = .onTap
        dropdown.bottomOffset = CGPoint(x: 0, y: sender.bounds.height)
        dropdown.width = sender.frame.width
        dropdown.cellHeight = 40.0
        dropdown.backgroundColor = UIColor.white
    }

}

extension AppointmentDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
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

extension AppointmentDetailViewController {
    
    @IBAction func btnCheckoutTapped(_ sender: UIButton) {
        navigationController?.pushViewController(AfterCheckOutViewController(), animated: true)
    }
    
    @IBAction func btnCallTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnEmailTapped(_ sender: UIButton) {
        
    }
    
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
    
    
    @IBAction func serviceDDTapped(_ sender: UIButton) {
        serviceDD.show()
        
        serviceDD.selectionAction = { (index,item) in
            self.lblService.text = item
        }
    }
    
    @IBAction func btnAddServiceTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnNoShowTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnRescheduleTapped(_ sender: UIButton) {
        
    }
}
