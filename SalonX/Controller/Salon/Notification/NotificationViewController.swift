//
//  NotificationViewController.swift
//  SalonX
//
//  Created by DK on 23/02/17.
//  Copyright © 2017 Jaydeep Vora. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    convenience init() {
        self.init(nibName: R.nib.notificatonVC.name, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = LocalizedString(key: "notifications")

        setupBackButton()
        
        setupTableUI()
        
        // Do any additional setup after loading the view.
    }
    
    func setupTableUI() {
        tableView.register(R.nib.notificationCell(), forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 30.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationTableViewCell

        
        return cell
    }
    
}
