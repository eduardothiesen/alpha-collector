//
//  RestAPIManager.swift
//  Accelerometer Collector
//
//  Created by Eduardo Thiesen on 15/08/16.
//  Copyright © 2016 thiesen. All rights reserved.
//

import UIKit

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestAPIManager: NSObject {

    static let sharedInstance = RestAPIManager()
    
    //TODO: your url here"
    let baseURL = "//https://myserver.com"
    
    
    func uploadFile(file: NSData, onCompletion: (JSON) -> Void) {
        let route = baseURL + "/api/v1/server/upload/"
        
        makeHTTPPostRequest(route, file: file, onCompletion: {json, err in onCompletion(json as JSON)})
    }
    
    private func makeHTTPPostRequest(path: String, file: NSData, onCompletion: ServiceResponse) {
        let boundary = generateBoundaryString()
        
        let request = NSMutableURLRequest(URL: NSURL(string: path)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30.0)
        
        request.HTTPMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
        
        let body = NSMutableData()
        
        let fname = NSString(format: "%@-%f.csv", UIDevice.currentDevice().name, NSDate().timeIntervalSince1970)
        let mimeType = "text/txt"
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        body.appendData("Content-Disposition:form-data; name=\"arquivo\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        body.appendData("Content-Type: \(mimeType)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        body.appendData(file)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        
        request.HTTPBody = body
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json, nil)
            } else {
                onCompletion(nil, error)
            }
        })
        task.resume()
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
}
