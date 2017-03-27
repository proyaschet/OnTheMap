//
//  UdacityConstant.swift
//  OnTheMap
//
//  Created by Amarnath Manipatra on 25/03/17.
//  Copyright © 2017 otd. All rights reserved.
//


extension UdacityClient
{
    struct SignUp
    {
        static let SignUpURL = "https://www.udacity.com/account/auth#!/signup"
    }
    
    struct Domain {
        static let domain = "UdacityClient"
    }
    
    struct Errors {
        static let UnableToLogin = "Unable to login."
        static let UnableToLogout = "Unable to logout."
        static let userData = "Cannot access user data."
    }
    
    struct Urlcomponents {
        static let Scheme = "https"
        static let Host = "www.udacity.com"
        static let Path = "/api"
    }
    
    struct URLMethods {
        static let session = "/session"
        static let user = "/users"
        static let delete = "DELETE"
    }
    
  
    struct HeaderKeys {
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
        static let XSRFToken = "X-XSRF-TOKEN"
    }
    
    struct HeaderValues {
        static let JSON = "application/json"
    }
    
    struct HTTPBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    struct JSONResponseKeys {
        static let Account = "account"
        static let UserKey = "key"
        static let Status = "status"
        static let Session = "session"
        static let Error = "error"
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
    
    
}
