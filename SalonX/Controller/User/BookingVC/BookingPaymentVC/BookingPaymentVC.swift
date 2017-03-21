//
//  BookingPaymentVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/25/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class BookingPaymentVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblBookPayment: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        setupBackButton()
        
        //        self.navigationController?.navigationBar.topItem?.title = "Last min Offer"
        self.title = "Book Last Minute Offer"
        
        let BookingPromocodeNib = UINib(nibName: "BookingPaymentPromocodeCell", bundle: nil)
        tblBookPayment.register(BookingPromocodeNib, forCellReuseIdentifier: "BookingPaymentPromocodeCell")
        
        let BookingPaymentNib = UINib(nibName: "BookingPaymentCells", bundle: nil)
        tblBookPayment.register(BookingPaymentNib, forCellReuseIdentifier: "BookingPaymentCells")
        
//        let lastMintBookNib1 = UINib(nibName: "LastMintOfferBookCell1", bundle: nil)
//        tblBookPayment.register(lastMintBookNib1, forCellReuseIdentifier: "LastMintOfferBookCell1")
        
        let lastMintBookNib2 = UINib(nibName: "LastMintOfferBookCell2", bundle: nil)
        tblBookPayment.register(lastMintBookNib2, forCellReuseIdentifier: "LastMintOfferBookCell2")
        
        let lastMintBookNib3 = UINib(nibName: "LastMintOfferBookCell3", bundle: nil)
        tblBookPayment.register(lastMintBookNib3, forCellReuseIdentifier: "LastMintOfferBookCell3")
        
        tblBookPayment.reloadData()
    }
    
    //    MARK:- Tableview Delegate & DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tblBookPayment.dequeueReusableCell(withIdentifier: "BookingPaymentPromocodeCell") as! BookingPaymentCells
           
//            cell.txtPromocode.text = "TAYKUN"
            //            cell.lblstarViewBook
            cell.btn_Apply.accessibilityElements = [indexPath]
            cell.btn_Apply.addTarget(self, action: #selector(self.btn_ApplyPromocodeAction(_:)), for: .touchUpInside)
            
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tblBookPayment.dequeueReusableCell(withIdentifier: "BookingPaymentCells") as! BookingPaymentCells
//            cell.Img_Person.image =
            cell.lbl_Owner.text = "TAYKUN TANG YAN"
            cell.lbl_RateView.setScore(1, withAnimation: false)
            cell.lbl_StarCount.text = "\(78)"
            cell.lbl_OwnerStyleType.text = "Beauty Salon"
            cell.lbl_StaffName.text = "Bebe Vejada"
            cell.lbl_StaffStyleType.text = "- Hair Stylisht"
            cell.lbl_SpecialStyleType.text = "Hair + Cut + Color + Spa"
            cell.lbl_Time.text = "Today 12:00 P.M."
            cell.lbl_TotalPrice.text = "Total   $180"
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tblBookPayment.dequeueReusableCell(withIdentifier: "LastMintOfferBookCell2") as! LastMintOfferCell
            cell.lbl_SureTextBook.text = "Is the first time you book a Daniel Royal ?"
            cell.btn_YesBook.tag = indexPath.row
            cell.btn_YesBook.addTarget(self, action: #selector(self.btn_YesBook(_:)), for: .touchUpInside)
            cell.btnNoBook.tag = indexPath.row
            cell.btnNoBook.addTarget(self, action: #selector(self.btnNoBook(_:)), for: .touchUpInside)
            cell.txt_Message.text = "Any message type here"
            
            return cell
        }
        else {
            
            let cell = tblBookPayment.dequeueReusableCell(withIdentifier: "LastMintOfferBookCell3") as! LastMintOfferCell
            
            cell.btn_PayVenyBook.tag = indexPath.row
            cell.btn_PayVenyBook.isSelected = true
            cell.btn_PayVenyBook.addTarget(self, action: #selector(self.btn_PayVenyBook(_:)), for: .touchUpInside)
            cell.btn_PayUBook.tag = indexPath.row
            cell.btn_PayUBook.addTarget(self, action: #selector(self.btn_PayUBook(_:)), for: .touchUpInside)
            cell.btn_AcceptBook.tag = indexPath.row
            cell.btn_AcceptBook.addTarget(self, action: #selector(self.btn_AcceptBook(_:)), for: .touchUpInside)
            cell.btn_FinishPaymentBook.tag = indexPath.row
            cell.btn_FinishPaymentBook.addTarget(self, action: #selector(self.btn_FinishPaymentBook(_:)), for: .touchUpInside)
            cell.lbl_DescriptionBook.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
            
            return cell
        }
        
        
    }
    
    //   MARK:- Button Action
    
    func btn_YesBook(_ sender: UIButton) {
        print("Yes Click")
        let Indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = tblBookPayment.cellForRow(at: Indexpath) as! LastMintOfferCell
        if cell.btn_YesBook.isSelected {
            cell.btn_YesBook.isSelected = false
        }
        else {
            cell.btn_YesBook.isSelected = true
            if cell.btnNoBook.isSelected {
                cell.btnNoBook.isSelected = false
            }
        }
        
        
        
    }
    func btnNoBook(_ sender: UIButton) {
        print("No Click")
        let Indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = tblBookPayment.cellForRow(at: Indexpath) as! LastMintOfferCell
        
        if cell.btnNoBook.isSelected {
            cell.btnNoBook.isSelected = false
        }
        else {
            cell.btnNoBook.isSelected = true
            if cell.btn_YesBook.isSelected {
                cell.btn_YesBook.isSelected = false
            }
        }
        
    }
    
    func btn_PayVenyBook(_ sender: UIButton) {
        print("PayVeny Click")
        let Indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = tblBookPayment.cellForRow(at: Indexpath) as! LastMintOfferCell
        
        if cell.btn_PayVenyBook.isSelected {
            cell.btn_PayVenyBook.isSelected = false
            if !(cell.btn_PayUBook.isSelected) {
                cell.btn_PayUBook.isSelected = true
            }
        }
        else {
            cell.btn_PayVenyBook.isSelected = true
            if cell.btn_PayUBook.isSelected {
                cell.btn_PayUBook.isSelected = false
            }
        }
    }
    func btn_PayUBook(_ sender: UIButton) {
        print("PayU Click")
        let Indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = tblBookPayment.cellForRow(at: Indexpath) as! LastMintOfferCell
        
        if cell.btn_PayUBook.isSelected {
            cell.btn_PayUBook.isSelected = false
            if !(cell.btn_PayVenyBook.isSelected) {
                cell.btn_PayVenyBook.isSelected = true
            }
        }
        else {
            cell.btn_PayUBook.isSelected = true
            if cell.btn_PayVenyBook.isSelected {
                cell.btn_PayVenyBook.isSelected = false
            }
        }
    }
    func btn_AcceptBook(_ sender: UIButton) {
        print("Accept Click")
        let Indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = tblBookPayment.cellForRow(at: Indexpath) as! LastMintOfferCell
        
        if cell.btn_AcceptBook.isSelected {
            cell.btn_AcceptBook.isSelected = false
        }
        else {
            cell.btn_AcceptBook.isSelected = true
        }
    }
    func btn_FinishPaymentBook(_ sender: UIButton) {
        print("Finish Click")
        let Appointment = MyAppointmentVC(nibName: "MyAppointmentVC", bundle: nil)
        self.navigationController?.pushViewController(Appointment, animated: true)
    }
    func btn_ApplyPromocodeAction(_ sender:UIButton) {
        print("Apply Promocode Click")
    }
    func btn_backAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
