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
    
    
    func ParseRequest(url : URL , methhod : HTTPMethod , body :[String : AnyObject]? = nil,completionhandler: @escaping(_ parsedResult :[String:AnyObject]?,_ error : NSError?) -> Void ){
        
       
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
    
    func getStudentLocation(uniqueKey : String , completionHandler : @escaping(_ user : userLocation?,_ error :NSError? ) -> Void )
    {
        //might be error have a look
        let locationUrl = session.urlGenerator(urlMethod.studentLocation, parameters: [ParameterKeys.Where :"{\"\(ParameterKeys.uniqueKey)\":\"\(uniqueKey)\"}" as AnyObject])
        //{"un":"12"}
        print(locationUrl)
        
        ParseRequest(url: locationUrl, methhod: .GET) { (parsedResult, error) in
            guard(error == nil) else
            {
                completionHandler(nil,error)
                return
            }
            if let parsedResult = parsedResult , let studentDictionary = parsedResult[JSONResponseKeys.Results] as? [[String:AnyObject]]
            {
                if studentDictionary.count == 1
                {
                    let studentInfo = userLocation(dictionary: studentDictionary[0])
                    completionHandler(studentInfo,nil)
                    return
                }
                completionHandler(nil,self.session.errorWithStatus(domainName: "Udacity", 0, description: Errors.noRecord))
            }
           
        }
    }
    
    
    func getStudentLocations(_ completionHandler : @escaping (_ user : [userLocation]? , _ error : NSError?
        )->Void)  {
        let locationUrl = session.urlGenerator(urlMethod.studentLocation, parameters: [ParameterKeys.limit : ParameterValues.value as AnyObject , ParameterKeys.order : ParameterValues.Updated as AnyObject])
        
        ParseRequest(url: locationUrl, methhod: .GET) { (parsedResult, error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            if let parsedResult = parsedResult , let use = parsedResult[JSONResponseKeys.Results] as?[[String:AnyObject]]
            {
                completionHandler(userLocation.generateStudentLocations(use),nil)
                return
                
            }
            completionHandler(nil,self.session.errorWithStatus(domainName: "Udacity", 0, description: Errors.noRecords))
        }
        
        
    }
    
    
    
    func postStudentLocation(_ mediaUrl : String , _ location : userLocation , completionHandler : @escaping(_ success : Bool? , _ error : NSError?) -> Void)
    {
        
        let postUrl = session.urlGenerator(urlMethod.studentLocation)
        let posturlBody : [String : AnyObject] = [BodyKeys.UniqueKey : location.student.uniqueKey as AnyObject,BodyKeys.FirstName : location.student.firstName as AnyObject,BodyKeys.LastName : location.student.lastName as AnyObject,BodyKeys.MapString : location.location.mapString as AnyObject,BodyKeys.MediaURL : location.student.mediaURL as AnyObject,BodyKeys.Latitude : location.location.latitude as AnyObject,BodyKeys.Longitude : location.location.longitude as AnyObject]
        
        /*let postBody = "{\"\(BodyKeys.UniqueKey)\": \"\(location.student.uniqueKey)\", \"\(BodyKeys.FirstName)\": \"\(location.student.firstName)\", \"\(BodyKeys.LastName)\": \"\(location.student.lastName )\",\"\(BodyKeys.MapString)\": \"\(location.location.mapString)\", \"\(BodyKeys.MediaURL)\": \"\(location.student.mediaURL)\",\"\(BodyKeys.Latitude)\": \(location.location.latitude), \"\(BodyKeys.Longitude)\": \(location.location.longitude)}"*/
       
        
      ParseRequest(url: postUrl, methhod: .POST, body: posturlBody) { (parsedResult, error) in
        guard(error == nil) else
        {
            completionHandler(false,error)
            return
        }
        if let parsedResult = parsedResult,let _ = parsedResult[JSONResponseKeys.ObjectID] as? String
        {
            completionHandler(true, nil)
            return
        }
         completionHandler(nil,self.session.errorWithStatus(domainName: "Udacity", 0, description: Errors.couldNotPostLocation))
        }
        
        
    }
    
    func updatingStudentLocation(_ objectId : String ,_ mediaUrl : String,_ location : userLocation,completionHandler : @escaping(_ success : Bool? , _ error : NSError?) -> Void)
    {
        let updateUrl = session.urlGenerator(urlMethod.studentLocation, withPathExtension: "\(objectId)")
        let updateurlBody : [String : AnyObject] = [BodyKeys.UniqueKey : location.student.uniqueKey as AnyObject,BodyKeys.FirstName : location.student.firstName as AnyObject,BodyKeys.LastName : location.student.lastName as AnyObject,BodyKeys.MapString : location.location.mapString as AnyObject,BodyKeys.MediaURL : location.student.mediaURL as AnyObject,BodyKeys.Latitude : location.location.latitude as AnyObject,BodyKeys.Longitude : location.location.longitude as AnyObject]
        ParseRequest(url: updateUrl, methhod: .PUT, body: updateurlBody) { (parsedResult, error) in
            guard(error == nil) else
            {
                completionHandler(false,error)
                return
            }
            if let parsedResult = parsedResult,let _ = parsedResult[JSONResponseKeys.UpdatedAt] as? String
            {
                completionHandler(true, nil)
                return
            }
             completionHandler(nil,self.session.errorWithStatus(domainName: "Udacity", 0, description: Errors.couldNotUpdateLocation))
            
        }
       
        
    }
    
    
    
}


