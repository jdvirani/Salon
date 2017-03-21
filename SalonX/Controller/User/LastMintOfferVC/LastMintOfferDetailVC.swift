//
//  LastMintOfferDetailVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/20/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class LastMintOfferDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblOfferDetail: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        setupBackButton()
        
//        self.navigationController?.navigationBar.topItem?.title = "Last min Offer"
//        self.title = "Book Last min Offer"
        
        let lastMintNib = UINib(nibName: "LastMintOfferCell", bundle: nil)
        tblOfferDetail.register(lastMintNib, forCellReuseIdentifier: "LastMintOfferCell")
        let lastMintDetailNib = UINib(nibName: "LastMintOfferDetailCell", bundle: nil)
        tblOfferDetail.register(lastMintDetailNib, forCellReuseIdentifier: "LastMintOfferDetailCell")
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
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tblOfferDetail.dequeueReusableCell(withIdentifier: "LastMintOfferCell") as! LastMintOfferCell
            //        cell.Img_LastMint.image =
            cell.lbl_Title.text = "Haircut + Color + spa"
            cell.lbl_Offer.text = "\(indexPath.row + 10) % OFF"
            cell.lbl_NewPrice.text = "$ \(indexPath.row + 10)"
            cell.lbl_OldPrice.text = "$ \(indexPath.row + 70)"
            cell.lbl_OldPrice.attributedText = BasicStuff.setStrikethroughStyleAttributeedText(cell.lbl_OldPrice.text!)
//            cell.setStrikethroughStyleAttributeedText(cell.lbl_OldPrice.text!)
            cell.lbl_Time.text = "Today 12:00 P.M."
            
            return cell
        }
        else {
            
            let cell = tblOfferDetail.dequeueReusableCell(withIdentifier: "LastMintOfferDetailCell") as! LastMintOfferCell
            cell.setLocalizedStaticTextForLastMintOfferDetailCell()
            cell.lbl_Stylish.text = "Beauty Salon XYZ"
            cell.lbl_HairStylishName.text = "Dinala Royall"
            cell.lbl_Address.text = "Doc Street 32, Mutue, Romania fpgo dopfophfgophj fjhlfgjh oj hfgjhlpfg  hiofgjhlj h"
            cell.lbl_StarCount.text = "(90)"
            cell.lbl_OtherStylish.text = "- Hair stylish"
            cell.lbl_OtherStylishName.text = "Beba Veja iod fgkls dhgiodfhgld"
            cell.lbl_Description.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
            cell.lbl_Policy.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
            
            cell.btn_BookNow.tag = indexPath.row
            cell.btn_BookNow.addTarget(self, action: #selector(self.btn_BookNowAction(_:)), for: .touchUpInside)
            
            return cell
        }
        
        
    }
    
    //   MARK:- Button Action
    func btn_BookNowAction(_ sender:UIButton) {
        print("Book Now Click")
        
        let BookNow = LastMintOfferBookVC(nibName: "LastMintOfferBookVC", bundle: nil)
        self.navigationController?.pushViewController(BookNow, animated: true)
        
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
