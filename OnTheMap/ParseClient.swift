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
    
    
    func makeRequestForUrl(url : URL , methhod : HTTPMethod , body :[String : AnyObject]? = nil,completionhandler: @escaping(_ parsedResult :[String:AnyObject]?,_ error : NSError?) -> Void ){
        
       
        let headers = [
            HeaderKeys.AppId: HeaderValues.AppId,
            HeaderKeys.APIKey: HeaderValues.APIKey,
            HeaderKeys.Accept: HeaderValues.JSON,
            HeaderKeys.ContentType: HeaderValues.JSON
        ]
        
       session.makeRequestCommon(url, method: methhod, headers: headers, body: body) { (data, error) in
        if let data = data
        {
            let parsedResult = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            completionhandler(parsedResult,nil)
            
        }
        else
        {
            completionhandler(nil,error)
        }
        }
    }
    
}


