//
//  LastMinuteOfferListViewController.swift
//  SalonX
//
//  Created by DK on 23/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit
import SwiftyJSON

class LastMinuteOfferListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pushType: PushType = .login
    
    var offerListItems: [JSON] = []
    
    convenience init() {
        self.init(nibName: R.nib.lastMinuteOfferList.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if pushType == .login {
            setupBackButton()
        } else {
            self.navigationItem.hidesBackButton = true
        }
        
        setupTableUI()

        getLastMinuteOfferList()
        // Do any additional setup after loading the view.
    }
    
    func localizeUI() {
        self.title = LocalizedString(key: "lastMinuteOffer")

    }
    
    func setupTableUI() {
        
        tableView.register(R.nib.lastMinuteOfferCell(), forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 62.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
    }
    
}

//MARK: - Network Helper
extension LastMinuteOfferListViewController {
    
    func getLastMinuteOfferList() {
        
        if Rechability.isConnectedToNetwork() {
            
            BasicStuff.showLoader(self.view)
            
            LastMinuteOfferWebService().lastMinuteOfferRequest { (result) in
                print(result.value)
                BasicStuff.dismissLoader()
                if let json = result.value {
                    if json[R.string.keys.flag()].stringValue == "1" {
                        self.offerListItems = json["data"].arrayValue
                        self.tableView.reloadData()
                        print(self.offerListItems)
                    }
                }
            }
        } else  {
            BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
        }
  
    }
}

//MARK: - Table View delegate methods
extension LastMinuteOfferListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if offerListItems.count < 0 {
            let lbl = UILabel()
            lbl.text = "No Last Minute Offer."
            lbl.center = tableView.center
            lbl.textColor = R.color.salonX.fontDark()
            tableView.backgroundView = lbl
            return 0
        } else {
             return offerListItems.count
        }
  
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LastMinuteOfferTableViewCell
        cell.selectionStyle = .none
        let item = offerListItems[indexPath.row]
        
        if let imgURL = URL(string: item["offer_image"].stringValue) {
            cell.imgOffer.sd_setImage(with: imgURL, placeholderImage: R.image.placeholder_map(), options: .lowPriority)
        } else {
            cell.imgOffer.image = R.image.placeholder_map()
        }
        
        cell.lblOfferName.text = item["description"].stringValue
        cell.lblOldPrice.text = item["regular_price"].stringValue
        cell.lblDiscount.text = "\(item["discount"].stringValue) % OFF"
        cell.lblNewPrice.text = item["offer_price"].stringValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(LastMinuteOfferViewController(), animated: true)
    }
}

