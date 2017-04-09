//
//  Session.swift
//  OnTheMap
//
//  Created by Amarnath Manipatra on 26/03/17.
//  Copyright © 2017 otd. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

struct appData {
    let scheme: String
    let host: String
    let path: String
    let domain: String
}

class Session 
{
    let session : URLSession
    let data : appData
    init(data: appData) {
        let configuration = URLSessionConfiguration.default
        //this helps us to configure session later accordingly therby setting it to default while initializing
        
        self.session = URLSession(configuration: configuration)
        self.data = data
    }
    
    func makeRequestCommon(_ url: URL, method: HTTPMethod, headers: [String:String]? = nil, body: [String:AnyObject]? = nil, responseHandler: @escaping (Data?, NSError?) -> Void)
    {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method.rawValue
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        if let body = body {
            request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
            
          
        }
        
       // print(url)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data1, response, error) in
            
            // was there an error?
            if let error = error {
                responseHandler(nil, error as NSError?)
                return
            }
            
            // did we get a successful 2XX response?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 200 && statusCode > 299 {
              
                
                responseHandler(nil, error as NSError?)
                return
            }
            
            responseHandler(data1, nil)
            //print("success 1")
            //print(data1 as Any)
        })
        task.resume()
    }
    func makeRequestUdacity(_ url: URL, method: HTTPMethod, headers: [String:String]? = nil, body: String? = nil, responseHandler: @escaping (Data?, NSError?) -> Void)
    {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method.rawValue
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        if let body = body {
            
            request.httpBody = body.data(using: String.Encoding.utf8)
            
        }
        
        print(url)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data1, response, error) in
            
            // was there an error?
            if let error = error {
                responseHandler(nil, error as NSError?)
                return
            }
            
            // did we get a successful 2XX response?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 200 && statusCode > 299 {
                
                
                responseHandler(nil, error as NSError?)
                return
            }
            
            responseHandler(data1, nil)
            //print("success 1")
            //print(data1 as Any)
        })
        task.resume()
    }



    
    
    func urlGenerator(_ method: String?, withPathExtension: String? = nil, parameters: [String:AnyObject]? = nil) -> URL
    {
        var components = URLComponents()
        components.scheme = data.scheme
        components.host = data.host
        components.path = data.path + (method ?? "") + (withPathExtension ?? "")
        print(method)
        print(withPathExtension)
        if let parameters = parameters {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
    }
    
    
}
