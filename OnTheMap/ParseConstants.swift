//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Amarnath Manipatra on 25/03/17.
//  Copyright © 2017 otd. All rights reserved.
//

import Foundation

extension ParseClient
{
    struct Components {
        static let Scheme = "https"
        static let Host = "parse.udacity.com"
        static let Path = "/parse/classes"
    }
    struct Errors {
        static let noRecord = "No object record at key."
        static let couldNotPostLocation = "Student location could not be posted."
        static let couldNotUpdateLocation = "Student location could not be updated."
    }
    
    struct urlMethod {
        static let studentLocation = "/StudentLocation"
    }
    
    struct ParameterKeys {
        static let limit = "limit"
        static let order = "order"
        static let Where = "where"
        static let uniqueKey = "uniqueKey"
    }
    
    struct ParameterValues {
        static let value  = 100
        static let Updated = "-updatedAt"
        static let Created = "-createdAt"
    }
    
    struct HeaderKeys {
        static let AppId = "X-Parse-Application-Id"
        static let APIKey = "X-Parse-REST-API-Key"
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
    }
    struct HeaderValues {
        static let AppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let JSON = "application/json"
    }
    struct BodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
    }
    struct JSONResponseKeys {
        static let Error = "error"
        static let Results = "results"
        static let ObjectID = "objectId"
        static let UpdatedAt = "updatedAt"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
    }
    

    struct Notifications {
        static let ObjectUpdated = "Updated"
        static let ObjectUpdatedError = "Error"
    }
}
