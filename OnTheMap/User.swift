//
//  User.swift
//  OnTheMap
//
//  Created by Amarnath Manipatra on 25/03/17.
//  Copyright © 2017 otd. All rights reserved.
//

import Foundation

struct userLocation
{
    let objectId : String
    let student : Student
    let location : Location


init(dictionary : [String : AnyObject])
{
    let uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String ?? "[No Object ID]"
    let firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String ?? "[No First Name]"
    let lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String ?? "[No Last Name]"
    let mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String ?? "[No Media URL]"
    
   student = Student(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mediaURL: mediaURL)
    let latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double ?? 0.0
    let longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double ?? 0.0
    let mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String ?? "[No Map String]"
    
     location = Location(latitude: latitude, longitude: longitude, mapString: mapString)
    
    objectId = dictionary[ParseClient.JSONResponseKeys.ObjectID] as? String ?? ""
    
}
    init(student: Student, location: Location) {
        objectId = ""
        self.student = student
        self.location = location
    }
    
    init(objectID: String, student: Student, location: Location) {
        self.objectId = objectID
        self.student = student
        self.location = location
    }
}

