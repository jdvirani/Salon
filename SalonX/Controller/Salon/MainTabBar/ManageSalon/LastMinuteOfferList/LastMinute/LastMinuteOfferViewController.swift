//
//  LastMinuteOfferViewController.swift
//  SalonX
//
//  Created by DK on 23/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import DropDown

class LastMinuteOfferViewController: UIViewController {
    
    @IBOutlet weak var lblHeaderInfo: UILabel!
    
    @IBOutlet var viewCornerStyle: [UIView]!
    
    @IBOutlet weak var lblServiceHeader: UILabel!
    @IBOutlet weak var lblNormalPriceHeader: UILabel!
    @IBOutlet weak var lblDurationHeader: UILabel!
    @IBOutlet weak var lblDiscountHeader: UILabel!
    @IBOutlet weak var lblOfferPriceHeader: UILabel!
    @IBOutlet weak var lblDescriptionHeader: UILabel!
    @IBOutlet weak var lblCategoryHeader: UILabel!
    
    @IBOutlet weak var btnServiceDD: UIButton!
    @IBOutlet weak var lblServiceName: UILabel!
    
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var txtNormalPrice: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBOutlet weak var txtOfferPrice: UITextField!
    
    @IBOutlet weak var txtDiscription: UITextView!
    
    @IBOutlet weak var btnCategoryDD: UIButton!
    @IBOutlet weak var lblCategory: UILabel!

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!

    
    var serviceDD = DropDown()
    var categoryDD = DropDown()
    
    var serviceItems: [String] = ["item1","item2","item3"]
    var categoryItems: [String] = ["item1","item2","item3"]
    
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
    
    var discount = 20 {
        didSet {
            lblDuration.text = ""
        }
    }
    
    convenience init() {
        self.init(nibName: R.nib.lastMinuteOfferVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serviceDD.dataSource = serviceItems
        categoryDD.dataSource = categoryItems
        
        durationTag = 3
        
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {

        viewCornerStyle.forEach({ $0.addCornerAndBorderStyle() })
        
        txtNormalPrice.addCornerAndBorderStyle()
        txtNormalPrice.customizeTextfield()
        
        configDropdown(dropdown: serviceDD, sender: btnServiceDD)
        configDropdown(dropdown: categoryDD, sender: btnServiceDD)
        
        localizeUI()
    }
    
    func localizeUI() {
        self.title = LocalizedString(key: "lastMinutes")
        
        lblServiceHeader.text = LocalizedString(key: "serviceHeader")
        lblDurationHeader.text = LocalizedString(key: "durationHeader")
        lblNormalPriceHeader.text = LocalizedString(key: "normalPrice")
        lblDiscountHeader.text = LocalizedString(key: "dicount")
        lblOfferPriceHeader.text = LocalizedString(key: "offerPrice")
        lblDescriptionHeader.text = LocalizedString(key: "descriptionHeader")
        lblCategoryHeader.text = LocalizedString(key: "categoryHeader")
        btnSave.setTitle(LocalizedString(key: "save"), for: .normal)
        btnCancel.setTitle(LocalizedString(key: "cancel"), for: .normal)
        
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

extension LastMinuteOfferViewController {
    
    
    @IBAction func btnIncrementTapped(_ sender: UIButton) {
        
        if sender.tag == 22 {
            //duration incerement
            if durationTag < 4 {
                durationTag += 1
            }
        } else if sender.tag == 24 {
            //discount increment
            if discount <= 100 {
                discount += 1
            }
        }
    }
    
    @IBAction func btnDecrementTapped(_ sender: UIButton) {
        
        if sender.tag == 21 {
            //duration incerement
            if durationTag > 0 {
                durationTag -= 1
            }
        } else if sender.tag == 23 {
            //discount increment
            
            if discount > 0 {
                discount -= 1
            }
        }
    }
    
    @IBAction func serviceDDTapped(_ sender: UIButton) {
        serviceDD.show()
        
        serviceDD.selectionAction = { (index,item) in
            self.lblServiceName.text = item
        }
    }
    
    @IBAction func categoryDDTapped(_ sender: UIButton) {
        categoryDD.show()
        
        categoryDD.selectionAction = { (index,item) in
            self.lblCategory.text = item
        }
    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        
    }
    
    
}
