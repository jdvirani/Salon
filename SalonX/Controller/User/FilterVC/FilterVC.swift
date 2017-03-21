//
//  FilterVC.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/21/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class FilterVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblFilter: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
        setupBackButton()
        
        let buttonDone = UIBarButtonItem(title: LocalizedString(key: "Comman_btn_Done"), style: .plain, target: self, action: #selector(self.btn_DoneAction(_:)))
        self.navigationItem.rightBarButtonItem = buttonDone
        
//        self.title = "Filter"
        
        let FilterNib = UINib(nibName: "FilterCells", bundle: nil)
        tblFilter.register(FilterNib, forCellReuseIdentifier: "FilterCells")
        
        let FilterMainCategoryNib = UINib(nibName: "FilterMainCategoryCell", bundle: nil)
        tblFilter.register(FilterMainCategoryNib, forCellReuseIdentifier: "FilterMainCategoryCell")
        
        let FilterSubCategoryNib = UINib(nibName: "FilterSubCategoryCell", bundle: nil)
        tblFilter.register(FilterSubCategoryNib, forCellReuseIdentifier: "FilterSubCategoryCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = LocalizedString(key: "lbl_FilterHeader")
    }
    
    
    //    MARK:- Tableview Delegate & DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tblFilter.dequeueReusableCell(withIdentifier: "FilterCells") as! FilterCells
            cell.setLocalizedStaticText()
            cell.setSliderRange()
            cell.configDropdown(dropdown: cell.LocationDD, sender: cell.btn_Location)
            cell.LocationDD.dataSource = ["fios","fihsfh","dfiosdf"]
            cell.setMapviewCustomLocationandPin()
            cell.btn_Location.accessibilityElements = [indexPath]
            cell.btn_Location.addTarget(self, action: #selector(self.btn_LocationAction(_:)), for: .touchUpInside)
            return cell
        }
        else if indexPath.row == 1 || indexPath.row == 5 {
            let cell = tblFilter.dequeueReusableCell(withIdentifier: "FilterMainCategoryCell") as! FilterCells
            if indexPath.row == 1 {
                cell.lbl_MainCategoryName.text = "CATEGORIES"
            }
            else {
                cell.lbl_MainCategoryName.text = "SERVICES"
            }
            return cell
        }
        else {
            
            let cell = tblFilter.dequeueReusableCell(withIdentifier: "FilterSubCategoryCell") as! FilterCells
            cell.lbl_SubCategoryName.text = "Haircut \(indexPath.row + 2)"
            if indexPath.row > 5 {
                cell.setConfigFiltersubCategorySmallButton()
            }
            else {
                cell.setConfigFiltersubCategoryRegularButtons()
            }
            cell.btn_SubCategory.accessibilityElements = [indexPath]
            cell.btn_SubCategory.addTarget(self, action: #selector(self.btn_SubCategoryAction(_:)), for: .touchUpInside)
            return cell
        }
            
    }

//    MARK:- Button Action
    func btn_backAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    func btn_DoneAction(_ sender: UIButton) {
        print("Done Click")
        _ = self.navigationController?.popViewController(animated: true)
    }
    func btn_LocationAction(_ sender:UIButton) {
        let indexpath = sender.accessibilityElements?.first as! IndexPath
        let cell = tblFilter.cellForRow(at: indexpath) as! FilterCells
        cell.LocationDD.show()
        cell.LocationDD.selectionAction = { (index,item) in
            cell.txt_Location.text = item
        }
        
    }
    func btn_SubCategoryAction(_ sender:UIButton) {
        print("subcategory click")
        let indexpath = sender.accessibilityElements?.first as! IndexPath
        let cell = tblFilter.cellForRow(at: indexpath) as! FilterCells
        if cell.btn_SubCategory.isSelected {
            cell.btn_SubCategory.isSelected = false
        }
        else {
            cell.btn_SubCategory.isSelected = true
        }
        
        
        
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
