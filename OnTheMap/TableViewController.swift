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
    fileprivate func displayAlert(_ message: String) {
        let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userUrl = dataSource.student[indexPath.row].student.mediaURL
        
        if let url = URL(string: userUrl)
        {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else
        {
            displayAlert("InvalidURL")
        }
    }

  

}
