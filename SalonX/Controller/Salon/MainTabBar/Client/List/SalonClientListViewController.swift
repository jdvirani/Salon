    //
    //  SalonClientListViewController.swift
    //  SalonX
    //
    //  Created by DK on 11/02/17.
    //  Copyright © 2017 Jaydeep Vora. All rights reserved.
    //
    
    import UIKit
    import SwiftyJSON
    
    class SalonClientListViewController: UIViewController {
        
        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var txtSearch: UITextField!
        
        var searchString = ""
        var isSerchMode = false
        
        var clientListItems: [JSON] = []
        var filteredClientList: [JSON] = []
        
        var offset = 0 {
            didSet {
                if offset == 0 {
                    clientListItems = []
                }
            }
        }
        
        convenience init() {
            self.init(nibName: R.nib.salonClientList.name, bundle: nil)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            NotificationCenter.default.addObserver(self, selector: #selector(isDetailChanged), name: NSNotification.Name(rawValue: "isDetailChanged"), object: nil)
            
            txtSearch.delegate = self
            setupUI()
            setUpTableUI()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            view.endEditing(true)
        }
        
        func setupUI() {
            
            self.tabBarItem.title = LocalizedString(key: "client")
            
            let btn1 = UIButton(type: .custom)
            btn1.setImage(UIImage(named: "ic_add_client"), for: .normal)
            btn1.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            btn1.addTarget(self, action: #selector(SalonClientListViewController.addClientTapped(_:)), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: btn1)
            
            navigationItem.rightBarButtonItem = item1
            
            txtSearch.layer.cornerRadius = txtSearch.frame.height / 2
            txtSearch.borderWidth = 2.0
            txtSearch.borderColor = R.color.salonX.accent()
            txtSearch.clipsToBounds = true
            txtSearch.placeholder = LocalizedString(key: "searchClient")
            
            let leftView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
            leftView.backgroundColor = UIColor.clear
            txtSearch.leftView = leftView
            txtSearch.leftViewMode = UITextFieldViewMode.always
            
            let rightView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
            rightView.backgroundColor = UIColor.clear
            txtSearch.rightView = rightView
            txtSearch.rightViewMode = UITextFieldViewMode.always
        }
        
        func setUpTableUI() {
            tableView.register(R.nib.clientListCell(), forCellReuseIdentifier: "cell")
            tableView.estimatedRowHeight = 96.0
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.separatorStyle = .none
        }
        
        func isDetailChanged() {
            clientListItems.removeAll()
            isSerchMode = false
            txtSearch.text = ""
            getClientList()
        }
    }
    
    //MARK: - Netwok Helper
    extension SalonClientListViewController {
        
        func getClientList() {
            
            if Rechability.isConnectedToNetwork() {
                
                BasicStuff.showLoader(self.view)
                
                let param = [R.string.keys.salon_id() : getUserDetail(R.string.keys.salon_id()),
                             R.string.keys.access_token() : getUserDetail(R.string.keys.access_token()),
                             R.string.keys.lang() : Language.shared.Lang,
                             "flag_view" : "0",
                             "offset" : "\(offset)"]
                
                ClientServices().clientRequest(param: param, completion: { (result) in
                    print(result.value)
                    BasicStuff.dismissLoader()
                    if let json = result.value {
                        if json[R.string.keys.flag()].stringValue == "1" {
                            self.offset = json["next_offset"].intValue
                            self.clientListItems += json["data"].arrayValue
                            self.tableView.reloadData()
                        }
                    }
                })
 
            } else  {
                BasicStuff.showAlert(title: LocalizedString(key: "salonx"), message: LocalizedString(key: "noInternet"))
            }
        }
    }
    
    extension SalonClientListViewController {
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            if scrollView == tableView {
                if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
                {
                    if offset == -1 {
                        return
                    } else {
                        getClientList()
                    }
                }
            }
        }
    }
    
    //MARK: - Actions
    extension SalonClientListViewController {
        func addClientTapped(_ sender: UIBarButtonItem) {
            print("tapped")
            let vc = AddClientViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: TableView delegate Methods
    extension SalonClientListViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if isSerchMode {
                return filteredClientList.count
            } else {
                return clientListItems.count
            }
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ClientListTableViewCell
            cell.selectionStyle = .none
            
            let item: JSON
            
            if isSerchMode {
              item =  filteredClientList[indexPath.row]
            } else{
                item = clientListItems[indexPath.row]
            }
            
            if let url = URL(string: item["user_profile_pic"].stringValue) {
                cell.imgClientPicture.sd_setImage(with: url, placeholderImage: R.image.placeholder__client(), options: .lowPriority)
            } else {
                cell.imgClientPicture.image = R.image.placeholder__client()
            }
            
            cell.lblClientName.text = "\(item["first_name"].stringValue) \(item["last_name"].stringValue)".trimmed()
            
            cell.lblAppointmentCount.text = item["user_appointment"].stringValue
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = ClientDetailViewController()
            let item: JSON
            if isSerchMode {
                item = filteredClientList[indexPath.row]
            } else {
                item = clientListItems[indexPath.row]
            }
            vc.clientDetail = item
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    extension SalonClientListViewController: UITextFieldDelegate {
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            isSerchMode = true
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range:
            NSRange, replacementString string: String) -> Bool {
            
            print(textField.text)
            print(string)
            
            if string == "" {
               searchString = String(searchString.characters.dropLast())
            } else {
                searchString = textField.text! + string
            }
            
            print(searchString)
            
            if searchString.isEmpty {
                isSerchMode = false
                tableView.reloadData()
            } else {
                isSerchMode = true
                searchClient(searchString: searchString)
            }
            
            return true
        }
    
        func searchClient(searchString: String) {
            print("searchString\(searchString)")

            filteredClientList = clientListItems.filter({ (json: JSON) -> Bool in
                let nameMatch = json["first_name"].stringValue.range(of: searchString, options: .caseInsensitive, range: nil, locale: nil)
                return nameMatch != nil
            })
            
            tableView.reloadData()
            print(filteredClientList)
        }
    }
    
    
    
    
