//
//  APIDataTaskWithRequest.swift
//  OnTheMap
//
//  Created by Gregory White on 11/30/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation
import UIKit

typealias APIDataTaskWithRequestCompletionHandler = (_ result: AnyObject?, _ error: NSError?) -> Void
typealias JSONDictionary = Dictionary<String, AnyObject>

final class APIDataTaskWithRequest: NSObject {
    
    // MARK: - Private Constants
    
    fileprivate struct LocalizedError {
        static let Domain          = "OnTheMapExternalAPIInterfaceError"
        static let UdacityHostName = "www.udacity.com"
    }
    
    fileprivate struct LocalizedErrorCode {
        static let Network           = 1
        static let HTTP              = 2
        static let JSON              = 3
        static let JSONSerialization = 4
    }
    
    fileprivate struct LocalizedErrorDescription {
        static let Network           = "Network Error"
        static let HTTP              = "HTTP Error"
        static let JSON	             = "JSON Error"
        static let JSONSerialization = "JSON JSONSerialization Error"
    }
    
    // MARK: - Private Stored Variables
    
    fileprivate var URLRequest:        NSMutableURLRequest
    fileprivate var completionHandler: APIDataTaskWithRequestCompletionHandler
    
    // MARK: - API
    
    init(URLRequest: NSMutableURLRequest, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        self.URLRequest        = URLRequest
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    func resume() {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: URLRequest as URLRequest, completionHandler: { (rawJSONResponse, HTTPResponse, URLSessionError) in
            
            DispatchQueue.main.async(execute: {
                NetworkActivityIndicatorManager.shared.endActivity()
            })
            
            guard URLSessionError == nil else {
                let userInfo = [NSLocalizedDescriptionKey: LocalizedErrorDescription.Network,
                                NSUnderlyingErrorKey:      URLSessionError!] as [String : Any]
                let error    = NSError(domain: LocalizedError.Domain, code: LocalizedErrorCode.Network, userInfo: userInfo)
                
                self.completeWithHandler(self.completionHandler, result: nil, error: error)
                return
            }
            
            let HTTPURLResponse = HTTPResponse as? Foundation.HTTPURLResponse
            
            guard HTTPURLResponse?.statusCodeClass == .successful else {
                let HTTPStatusText = Foundation.HTTPURLResponse.localizedString(forStatusCode: (HTTPURLResponse?.statusCode)!)
                let failureReason  = "HTTP status code = \(HTTPURLResponse?.statusCode), HTTP status text = \(HTTPStatusText)"
                let userInfo       = [NSLocalizedDescriptionKey:        LocalizedErrorDescription.HTTP,
                                      NSLocalizedFailureReasonErrorKey: failureReason]
                let error          = NSError(domain: LocalizedError.Domain, code: LocalizedErrorCode.HTTP, userInfo: userInfo)
                
                self.completeWithHandler(self.completionHandler, result: nil, error: error)
                return
            }
            
            guard let rawJSONResponse = rawJSONResponse else {
                let userInfo = [NSLocalizedDescriptionKey: LocalizedErrorDescription.JSON]
                let error    = NSError(domain: LocalizedError.Domain, code: LocalizedErrorCode.JSON, userInfo: userInfo)
                
                self.completeWithHandler(self.completionHandler, result: nil, error: error)
                return
            }
            
            var JSONDataToParse = rawJSONResponse
            
            if self.URLRequest.url?.host == LocalizedError.UdacityHostName {
                JSONDataToParse = rawJSONResponse.subdata(in: 5..<rawJSONResponse.count)
                //				JSONDataToParse = rawJSONResponse.subdata(in: NSRange(location: 5, length: rawJSONResponse.count - 5))
            }
            
            do {
                let JSONData = try JSONSerialization.jsonObject(with: JSONDataToParse, options: .allowFragments) as! JSONDictionary
                
                self.completeWithHandler(self.completionHandler, result: JSONData as AnyObject!, error: nil)
            } catch let JSONError as NSError {
                let userInfo = [NSLocalizedDescriptionKey: LocalizedErrorDescription.JSONSerialization,
                                NSUnderlyingErrorKey:      JSONError] as [String : Any]
                let error    = NSError(domain: LocalizedError.Domain, code: LocalizedErrorCode.JSONSerialization, userInfo: userInfo)
                
                self.completeWithHandler(self.completionHandler, result: nil, error: error)
                return
            }
            
        }) 
        
        NetworkActivityIndicatorManager.shared.startActivity()
        task.resume()
    }
    
    // MARK: - Private
    
    fileprivate func completeWithHandler(_ completionHandler: @escaping APIDataTaskWithRequestCompletionHandler, result: AnyObject!, error: NSError?) {
        
        DispatchQueue.main.async {
            completionHandler(result, error)
        }
        
    }
    
}
