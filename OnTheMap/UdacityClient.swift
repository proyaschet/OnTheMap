//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Amarnath Manipatra on 25/03/17.
//  Copyright © 2017 otd. All rights reserved.
//

import Foundation

class UdacityClient  {
    
    let session : Session
    
    init() {
        let data = appData(scheme: Urlcomponents.Scheme, host: Urlcomponents.Host, path: Urlcomponents.Path, domain: Domain.domain)
        session = Session(data: data)
    }
    
  static var sharedInstance = UdacityClient()
class func singleton() -> UdacityClient
{
    return sharedInstance
}
    
    func requestUdacity (url: URL, method: HTTPMethod, body: [String:AnyObject]? = nil, headers: [String:String]? = nil, responseHandler: @escaping (_ parsedResult: [String:AnyObject]?, _ error: NSError?) -> Void) {
        
        //dictionary of headers to add in the request
        
        var requireHeaders = [HeaderKeys.Accept : HeaderValues.JSON,HeaderKeys.ContentType : HeaderValues.JSON]
        //add header into the dict coming as arguments
        
        if let header = headers
        {
            for(k,v) in header
            {
                requireHeaders[k] = v
            }
        }
  session.makeRequestCommon(url, method: method, headers: requireHeaders, body: body) { (data, error) in
    if let data = data
    {
        let parseResult = try! JSONSerialization.jsonObject(with: data.subdata(in: Range(5 ..< data.count)), options: .allowFragments) as! [String:AnyObject]
        responseHandler(parseResult , nil)
    }
    else {
        responseHandler(nil, error)
    }
        }
    }
    
    
    
    func login(_ username: String, password: String ,headers: [String:String]? = nil,completionHandler : @escaping(_ userKey : String?,_ error : NSError?)->Void)
    {
        
        let loginUrl = session.urlGenerator(URLMethods.session)
        print(loginUrl)
        var loginBody = [String : AnyObject]()
        
        loginBody = [HTTPBodyKeys.Username : username as AnyObject , HTTPBodyKeys.Password : password as AnyObject]
       requestUdacity(url: loginUrl, method: .POST, body: loginBody, headers: nil) { (parsedResult, error) in
        guard error == nil else {
            completionHandler(nil,error!)
            return
        }
        if let user = parsedResult?[JSONResponseKeys.Account] as? [String:AnyObject],
            let key = user[JSONResponseKeys.UserKey] as? String
        {
            completionHandler(key, nil)
            return
   
        }
        }
     //to add error
        
     
        
        
    }
    
    
}
