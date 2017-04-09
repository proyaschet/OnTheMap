//
//  DataSource.swift
//  OnTheMap
//
//  Created by Amarnath Manipatra on 01/04/17.
//  Copyright © 2017 otd. All rights reserved.
//

import Foundation
import UIKit

public class DataSource : NSObject
{
    let parseClient = ParseClient.singleton()
    var student = [userLocation]()
    var studentLoggedIn : Student!
    
    override init()
    {
        super.init()
    }
    
    static var sharedinstance = DataSource()
    class func singleton() -> DataSource
    {
        return sharedinstance
    }
    
    
    //use notification for data
    func dataNotification(_ name : String) {
        NotificationCenter.default.post(name: Notification.Name(rawValue : name), object: nil)
        
    }
    
    
    func studentLocations()
    {
        parseClient.getStudentLocations { (users, error) in
            guard error == nil else
            {
                self.dataNotification("\(ParseClient.urlMethod.studentLocation)Error")
                return
                
            }
            self.student = users!
            self.dataNotification("\(ParseClient.urlMethod.studentLocation)Updated")
        }
    }
}

extension DataSource : UITableViewDataSource
{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(student.count)
        return student.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserTableViewCell
        
       let user = student[indexPath.item].student
        cell.uiForCell(user: user)
        return cell
    }
}







    
    
    

