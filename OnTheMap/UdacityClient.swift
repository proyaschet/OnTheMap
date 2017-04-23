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
        var reqBody : String = ""
        //add header into the dict coming as arguments
        
        if let header = headers
        {
            for(k,v) in header
            {
                requireHeaders[k] = v
            }
        }
        if let body = body
        {
            reqBody = "{\"\(HTTPBodyKeys.Udacity)\": {\"\(HTTPBodyKeys.Username)\": \"\(body[HTTPBodyKeys.Username] as! String)\", \"\(HTTPBodyKeys.Password)\": \"\(body[HTTPBodyKeys.Password] as! String)\"}}"
            //print(reqBody)
        }
  session.makeRequestUdacity(url, method: method, headers: requireHeaders, body:  reqBody) { (data, error) in
    if let data = data
    {
        let parseResult = try! JSONSerialization.jsonObject(with: data.subdata(in: Range(5 ..< data.count)), options: .allowFragments) as! [String:AnyObject]
        responseHandler(parseResult , nil)
        //print(parseResult)
        //print("success 2")
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
        var login = [String : AnyObject]()
        
        login = [HTTPBodyKeys.Username : username as AnyObject , HTTPBodyKeys.Password : password as AnyObject]
       requestUdacity(url: loginUrl, method: .POST, body: login) { (parsedResult, error) in
        
     
        guard error == nil else {
            completionHandler(nil,error!)
          
            return
        }
        
        if let user = parsedResult?[JSONResponseKeys.Account] as? [String:AnyObject],
            let key = user[JSONResponseKeys.UserKey] as? String
        {
           // print(key)
           
            completionHandler(key, nil)
            return
   
        }
        completionHandler(nil,self.session.errorWithStatus(domainName: "Udacity", 0, description: Errors.UnableToLogin))

        }
        
        
     }
    
    func cookie(_ name : String) -> HTTPCookie?
    {
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == name {
                return cookie
            }
        }
        return nil
        
    }
    
   func logout(_ completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
    
    let logoutUrl = session.urlGenerator(URLMethods.session)
    var logout = [String : AnyObject]()
    let name = "XSRF-TOKEN"
     if let xsrfCookie = cookie(name)
     {
        logout[HeaderKeys.XSRFToken] = xsrfCookie
    }
    requestUdacity(url: logoutUrl, method: .DELETE) { (parsedResult, error) in
        guard error == nil else
        {
            completionHandler(false,error)
            return
        }
        if let parsedResult = parsedResult , let _ = parsedResult[JSONResponseKeys.Session] as? [String:AnyObject]
        {
            completionHandler(true,nil)
            return
        }
     completionHandler(false,self.session.errorWithStatus(domainName: "Udacity", 0, description: Errors.UnableToLogout))
    }
    
    }
    
    func getStudentDetails(_ userKey : String , completionHandler : @escaping(_ student :Student? , _ error : NSError?) -> Void)
    {
        let userurl = session.urlGenerator(URLMethods.user, withPathExtension: "/\(userKey)")
        requestUdacity(url: userurl, method: .GET) { (parsedResult, error) in
            guard error == nil else
            {
                completionHandler(nil,error)
                return
            }
            if let parsedResult = parsedResult , let user = parsedResult[JSONResponseKeys.User],let firstName = user[JSONResponseKeys.FirstName] as? String,let lastname = user[JSONResponseKeys.LastName] as? String
            {
                print(firstName)
                print(lastname)
                let student = Student(uniqueKey: userKey, firstName: firstName, lastName: lastname,mediaURL : "")
                completionHandler(student,nil)
                return
            }
            completionHandler(nil,self.session.errorWithStatus(domainName: "Udacity", 0, description: Errors.userData))

        }
            }
    
    
}
