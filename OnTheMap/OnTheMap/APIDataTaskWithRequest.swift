//
//  APIDataTaskWithRequest.swift
//  OnTheMap
//
//  Created by Gregory White on 11/30/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

typealias APIDataTaskWithRequestCompletionHandler = (_ result: AnyObject?, _ error: NSError?) -> Void
typealias JSONDictionary = Dictionary<String, AnyObject>

final class APIDataTaskWithRequest {
    
    // MARK: - Variables
    
    fileprivate var urlRequest:        NSMutableURLRequest
    fileprivate var completionHandler: APIDataTaskWithRequestCompletionHandler
    
    // MARK: - API
    
    init(urlRequest: NSMutableURLRequest, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        self.urlRequest        = urlRequest
        self.completionHandler = completionHandler
    }
    
    func resume() {
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest, completionHandler: { (rawJSONResponse, httpResponse, urlSessionError) in
            
            NetworkActivityIndicator.shared.stop()
            
            guard urlSessionError == nil else {
                let userInfo = [NSLocalizedDescriptionKey: LocalizedError.Description.Network, NSUnderlyingErrorKey: urlSessionError!] as [String : Any]
                let error    = NSError(domain: LocalizedError.Domain, code: LocalizedError.Code.Network, userInfo: userInfo)
                
                self.completionHandler(nil, error)
                return
            }
            
            let httpURLResponse = httpResponse as! Foundation.HTTPURLResponse
            
            guard httpURLResponse.statusCodeClass == .successful else {
                let httpStatusText = HTTPURLResponse.localizedString(forStatusCode: httpURLResponse.statusCode)
                let failureReason  = "HTTP status code = \(httpURLResponse.statusCode), HTTP status text = \(httpStatusText)"
                let userInfo       = [NSLocalizedDescriptionKey: LocalizedError.Description.HTTP, NSLocalizedFailureReasonErrorKey: failureReason]
                let error          = NSError(domain: LocalizedError.Domain, code: LocalizedError.Code.HTTP, userInfo: userInfo)
                
                self.completionHandler(nil, error)
                return
            }
            
            guard let rawJSONResponse = rawJSONResponse else {
                let userInfo = [NSLocalizedDescriptionKey: LocalizedError.Description.JSON]
                let error    = NSError(domain: LocalizedError.Domain, code: LocalizedError.Code.JSON, userInfo: userInfo)
                
                self.completionHandler(nil, error)
                return
            }
            
            var jsonDataToParse = rawJSONResponse
            
            if self.urlRequest.url?.host == LocalizedError.UdacityHostName {
                jsonDataToParse = rawJSONResponse.subdata(in: 5..<rawJSONResponse.count)
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: jsonDataToParse, options: .allowFragments) as! JSONDictionary
                
                self.completionHandler(jsonData as AnyObject!, nil)
            } catch let jsonError as NSError {
                let userInfo = [NSLocalizedDescriptionKey: LocalizedError.Description.JSONSerialization, NSUnderlyingErrorKey: jsonError] as [String : Any]
                let error    = NSError(domain: LocalizedError.Domain, code: LocalizedError.Code.JSONSerialization, userInfo: userInfo)
                
                self.completionHandler(nil, error)
                return
            }
            
        }) 
        
        NetworkActivityIndicator.shared.start()
        task.resume()
    }
    
}
