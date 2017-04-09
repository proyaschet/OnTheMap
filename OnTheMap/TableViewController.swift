//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Amarnath Manipatra on 03/04/17.
//  Copyright © 2017 otd. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
   let dataSource = DataSource.singleton()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = dataSource
        NotificationCenter.default.addObserver(self, selector: #selector(studentLocationsUpdate), name: NSNotification.Name(rawValue: "\(ParseClient.urlMethod.studentLocation)\(ParseClient.Notifications.ObjectUpdatedError)"), object: nil)
    }
    
    func studentLocationsUpdate()
    {
        tableView.reloadData()
    }

  

}
