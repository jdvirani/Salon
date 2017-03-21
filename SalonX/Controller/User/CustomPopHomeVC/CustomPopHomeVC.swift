//
//  CustomPopHomeVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/27/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class CustomPopHomeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var ConstatTblBgViewHeight: NSLayoutConstraint! //197
    @IBOutlet weak var tblCustomPopHome: UITableView!
    
    var HomePopDataArray:NSArray = NSArray()
    var Home:HomeVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let HomePopServiceCellNib = UINib(nibName: "CustomPopHomeCell", bundle: nil)
        tblCustomPopHome.register(HomePopServiceCellNib, forCellReuseIdentifier: "CustomPopHomeCell")
        
        DispatchQueue.main.async {
            self.tblCustomPopHome.reloadData()
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tblCustomPopHome.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions(), context: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tblCustomPopHome.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is UITableView {
            ConstatTblBgViewHeight.constant = tblCustomPopHome.contentSize.height
            if tblCustomPopHome.contentSize.height >= (self.view.frame.size.height - 60) {
                ConstatTblBgViewHeight.constant = (self.view.frame.size.height - 80)
            }
        }
    }
    

//    MARK:- Tableview Delegate and DataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomePopDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblCustomPopHome.dequeueReusableCell(withIdentifier: "CustomPopHomeCell") as! CustomPopHomeCell
        let dicData = HomePopDataArray[indexPath.row] as! NSDictionary
        
        cell.lbl_ServiceName.text = dicData.value(forKey: "sub_category_name") as? String
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dicData = HomePopDataArray[indexPath.row] as! NSDictionary
        Home.CustomPopHomeSelectedData(SelectedData:dicData)
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
