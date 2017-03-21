//
//  Contactus.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/17/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import UIKit

class Contactus: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblContactus: UITableView!
    var isFromSalon = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromSalon {
            setupBackButton()
        } else {
            self.navigationController?.navigationBar.isHidden = false
            let buttonMenu = UIBarButtonItem(image: UIImage(named: "ic_menubar_header"), style: .plain, target: self, action: #selector(self.btn_LeftMenuAction))
            self.navigationItem.leftBarButtonItem  = buttonMenu
        }
        
        
        let nibName = UINib(nibName: "ContactusCell", bundle:nil)
        self.tblContactus.register(nibName, forCellReuseIdentifier: "Cell1")
        
        let nibName1 = UINib(nibName: "ContactusCell1", bundle:nil)
        self.tblContactus.register(nibName1, forCellReuseIdentifier: "Cell2")
        
        let nibName2 = UINib(nibName: "ContactusCell2", bundle:nil)
        self.tblContactus.register(nibName2, forCellReuseIdentifier: "Cell3")
        
        tblContactus.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = LocalizedString(key: "lbl_ContactusHeader")
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
            let cell = tblContactus.dequeueReusableCell(withIdentifier: "Cell1") as! ContactusCell
            
            cell.lbl_Address.text = "51 Jump street, near dollance, abrico, New Yourk"
            cell.lbl_Phone.text = "13 - 46 - 789"
            cell.lbl_Email.text = "info@salonx.com"
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tblContactus.dequeueReusableCell(withIdentifier: "Cell2") as! ContactusCell
//            cell.img_Border.addDashedLine()
            cell.setLocalizedStaticText(ForCell: "Cell1")
            
            return cell
        }
        else {
            let cell = tblContactus.dequeueReusableCell(withIdentifier: "Cell3") as! ContactusCell
            cell.setLocalizedStaticText(ForCell: "Cell2")
            cell.btn_sendMessage.tag = indexPath.row
            cell.btn_sendMessage.addTarget(self, action: #selector(self.btn_SendMessageAction(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    
    func btn_SendMessageAction(_ sender:UIButton) {
        print("sender.tag=\(sender.tag)")
    }
    
    //   MARK:- LeftMenu Action
    func btn_LeftMenuAction(_ sender: UIButton) {
        let sideMenuController = slideMenuController()
        sideMenuController?.openLeft()
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
