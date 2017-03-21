//
//  LastMintOfferBookVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/20/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class LastMintOfferBookVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblLastMintOfferBook: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        setupBackButton()        
        //        self.navigationController?.navigationBar.topItem?.title = "Last min Offer"
//        self.title = "Book Last Minute Offer"
        
        let lastMintBookNib1 = UINib(nibName: "LastMintOfferBookCell1", bundle: nil)
        tblLastMintOfferBook.register(lastMintBookNib1, forCellReuseIdentifier: "LastMintOfferBookCell1")
        
        let lastMintBookNib2 = UINib(nibName: "LastMintOfferBookCell2", bundle: nil)
        tblLastMintOfferBook.register(lastMintBookNib2, forCellReuseIdentifier: "LastMintOfferBookCell2")
        
        let lastMintBookNib3 = UINib(nibName: "LastMintOfferBookCell3", bundle: nil)
        tblLastMintOfferBook.register(lastMintBookNib3, forCellReuseIdentifier: "LastMintOfferBookCell3")
//        let lastMintDetailNib = UINib(nibName: "LastMintOfferDetailCell", bundle: nil)
//        tblLastMintOfferBook.register(lastMintDetailNib, forCellReuseIdentifier: "LastMintOfferDetailCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = LocalizedString(key: "lbl_BookLastminOfferHeader")
        
    }
    
    //    MARK:- Tableview Delegate & DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tblLastMintOfferBook.dequeueReusableCell(withIdentifier: "LastMintOfferBookCell1") as! LastMintOfferCell
//                    cell.Img_OfferBook.image =
            cell.lbl_TitleName.text = "TAYKUN"
//            cell.lblstarViewBook
            cell.lbl_StaffName.text = "Jhon Dayer"
            cell.lbl_StylishNameBook.text = "Massage"
            cell.lbl_StyleTypeBook.text = "Massage"
            cell.lbl_DiscountBook.text = "30 % OFF"
            cell.lbl_OldPriceBook.text = "$ 25"
            cell.lbl_OldPriceBook.attributedText = BasicStuff.setStrikethroughStyleAttributeedText(cell.lbl_OldPriceBook.text!)
            cell.lbl_NewPriceBook.text = "$ 20"
            cell.lbl_Static_staff.text = LocalizedString(key: "lbl_BookLastminOfferCell1_Staff")
            cell.lbl_TotalBook.text = LocalizedString(key: "lbl_BookLastminOfferCell1_Total") + "   $180"
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tblLastMintOfferBook.dequeueReusableCell(withIdentifier: "LastMintOfferBookCell2") as! LastMintOfferCell
            cell.txt_Message.placeholder = LocalizedString(key: "txtPlace_BookLastminOfferCell2_Comment")
            
            
            cell.lbl_Static_Yes.text = LocalizedString(key: "Comman_btn_Yes")
            cell.lbl_Static_No.text = LocalizedString(key: "Comman_btn_No")
            
            let attrs1 = [NSFontAttributeName : UIFont.init(name: "Helvetica", size: 14), NSForegroundColorAttributeName : UIColor.init(hexString: "#2B2D2D")]
            
            let attrs2 = [NSFontAttributeName : UIFont.init(name: "Helvetica-Bold", size: 14), NSForegroundColorAttributeName : UIColor.init(hexString: "#2B2D2D")]
            
            let attrs3 = [NSFontAttributeName : UIFont.init(name: "Helvetica", size: 14), NSForegroundColorAttributeName : UIColor.init(hexString: "#2B2D2D")]
            
            let attributedString1 = NSMutableAttributedString(string:LocalizedString(key: "lbl_BookLastminOfferCell2_SuareTextBook"), attributes:attrs1)
            
            let attributedString2 = NSMutableAttributedString(string:" Daniel Royal ", attributes:attrs2)
            
            let attributedString3 = NSMutableAttributedString(string:"?", attributes:attrs3)
            
            attributedString1.append(attributedString2)
            attributedString1.append(attributedString3)
            cell.lbl_SureTextBook.attributedText = attributedString1
            
//            cell.lbl_SureTextBook.text = "Is the first time you book a Daniel Royal ?"
            cell.btn_YesBook.tag = indexPath.row
            cell.btn_YesBook.addTarget(self, action: #selector(self.btn_YesBook(_:)), for: .touchUpInside)
            cell.btnNoBook.tag = indexPath.row
            cell.btnNoBook.addTarget(self, action: #selector(self.btnNoBook(_:)), for: .touchUpInside)
            
            
            return cell
        }
        else {
            
            let cell = tblLastMintOfferBook.dequeueReusableCell(withIdentifier: "LastMintOfferBookCell3") as! LastMintOfferCell
            cell.setLocalizedStaticTextForLastMintOfferBookCell3()
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
        let cell = tblLastMintOfferBook.cellForRow(at: Indexpath) as! LastMintOfferCell
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
        let cell = tblLastMintOfferBook.cellForRow(at: Indexpath) as! LastMintOfferCell
        
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
        let cell = tblLastMintOfferBook.cellForRow(at: Indexpath) as! LastMintOfferCell
        
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
        let cell = tblLastMintOfferBook.cellForRow(at: Indexpath) as! LastMintOfferCell
        
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
        let cell = tblLastMintOfferBook.cellForRow(at: Indexpath) as! LastMintOfferCell
        
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
    
    func btn_backAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
