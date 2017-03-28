//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Amarnath Manipatra on 25/03/17.
//  Copyright © 2017 otd. All rights reserved.
//

import Foundation

class ParseClient
{
    let session : Session
    
    init()
    {
        let data = appData(scheme: Components.Scheme, host: Components.Host, path: Components.Path, domain: "Parse")
        session=Session(data: data)
    }
    
    static var sharedInstance = ParseClient()
    
    class func singleton() -> ParseClient
    {
        return sharedInstance
    }
    
    
    
}
