//
//  ServicesVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/23/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class ServicesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblServices: UITableView!
    let ServicesDataArray = ["All Services","Women Haircut","Mens Haircut","Color","Treatments","Updo","Braids"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.isHidden = false
        setupBackButton()        
        //        self.navigationController?.navigationBar.topItem?.title = "Last min Offer"
//        self.title = "Select Services"
        
        
        let NibName = UINib(nibName: "ServicesCell", bundle: nil)
        tblServices.register(NibName, forCellReuseIdentifier: "ServicesCell")
        
        tblServices.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = LocalizedString(key: "lbl_ServicesHeader")
       
    }

    //    MARK:- Tableview Delegate & DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ServicesDataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblServices.dequeueReusableCell(withIdentifier: "ServicesCell") as! ServicesCell
        cell.lbl_ServiceName.text = ServicesDataArray[indexPath.row]
        cell.lbl_Count.text = "\(indexPath.row)"
        cell.btn_Check.accessibilityElements = [indexPath]
        cell.btn_Check.addTarget(self, action: #selector(self.btn_CheckAction(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
//    MARK:- Button Action
    func btn_CheckAction(_ sender:UIButton) {
        
        let indexpath = sender.accessibilityElements?.first as! IndexPath
        let cell = tblServices.cellForRow(at: indexpath) as! ServicesCell
        if cell.btn_Check.isSelected == true {
            cell.btn_Check.isSelected = false
        }
        else {
            cell.btn_Check.isSelected = true
        }
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
