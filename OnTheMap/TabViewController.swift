//
//  TabViewController.swift
//  OnTheMap
//
//  Created by Amarnath Manipatra on 02/04/17.
//  Copyright © 2017 otd. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

let udacityClient = UdacityClient.singleton()
let parseClient = ParseClient.singleton()
let dataSource = DataSource.singleton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(studentLocationsDidError), name: NSNotification.Name(rawValue: "\(ParseClient.urlMethod.studentLocation)\(ParseClient.Notifications.ObjectUpdatedError)"), object: nil)
    }
    
    
    @IBAction func logout(_ sender : Any)
    {
        // crashing
     udacityClient.logout { (success, error) in
        self.performUIUpdatesOnMain {
            if(success == true)
            {
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
                print(error as Any)
            }
        }
        }
       
    }
    
    @IBAction func refreshUsers(_ sender : Any)
    {
        dataSource.studentLocations()
    }
    
    @IBAction func addUserLocation(_ sender : Any)
    {
        if let loggedInStudent = dataSource.studentLoggedIn
        {
            parseClient.getStudentLocation(uniqueKey: loggedInStudent.uniqueKey, completionHandler: { (location, error) in self.performUIUpdatesOnMain {
                if let location = location
                {
                    self.displayOverwriteAlert({ (alert) in
                        self.launchPostingController(location.objectId)
                    })
                }
                else{self.launchPostingController()}
                
                }
                
            })
        }
    }
    func studentLocationsDidError()
    {
        displayAlert("Could not Update Sudent Location")
    }
    
     func displayAlert(_ message: String) {
        let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func displayOverwriteAlert(_ completionHandler: ((UIAlertAction) -> Void)? = nil)
    {
        let alertView = UIAlertController(title: "Overwrite Location", message:"Would you like to overwrite", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: completionHandler))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func launchPostingController(_ objectID: String? = nil)
    {
         let postingViewController = self.storyboard!.instantiateViewController(withIdentifier: "PostingViewController") as! PostingViewController
        if let objectID = objectID {
            postingViewController.objectId = objectID
        }
        self.present(postingViewController, animated: true, completion: nil)
    }
   

}
