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
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task    = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (rawJSONResponse, httpResponse, urlSessionError) in
            
            NetworkActivityIndicatorManager.shared.endActivity()
            
            guard urlSessionError == nil else {
                let userInfo = [NSLocalizedDescriptionKey: LocalizedErrorDescription.Network, NSUnderlyingErrorKey: urlSessionError!] as [String : Any]
                let error    = NSError(domain: LocalizedError.Domain, code: LocalizedErrorCode.Network, userInfo: userInfo)
                
                self.complete(withCompletionHandler: self.completionHandler, result: nil, error: error)
                return
            }
            
            let HTTPURLResponse = httpResponse as? Foundation.HTTPURLResponse
            
            guard HTTPURLResponse?.statusCodeClass == .successful else {
                let HTTPStatusText = Foundation.HTTPURLResponse.localizedString(forStatusCode: (HTTPURLResponse?.statusCode)!)
                let failureReason  = "HTTP status code = \(HTTPURLResponse?.statusCode), HTTP status text = \(HTTPStatusText)"
                let userInfo       = [NSLocalizedDescriptionKey: LocalizedErrorDescription.HTTP, NSLocalizedFailureReasonErrorKey: failureReason]
                let error          = NSError(domain: LocalizedError.Domain, code: LocalizedErrorCode.HTTP, userInfo: userInfo)
                
                self.complete(withCompletionHandler: self.completionHandler, result: nil, error: error)
                return
            }
            
            guard let rawJSONResponse = rawJSONResponse else {
                let userInfo = [NSLocalizedDescriptionKey: LocalizedErrorDescription.JSON]
                let error    = NSError(domain: LocalizedError.Domain, code: LocalizedErrorCode.JSON, userInfo: userInfo)
                
                self.complete(withCompletionHandler: self.completionHandler, result: nil, error: error)
                return
            }
            
            var JSONDataToParse = rawJSONResponse
            
            if self.urlRequest.url?.host == LocalizedError.UdacityHostName {
                JSONDataToParse = rawJSONResponse.subdata(in: 5..<rawJSONResponse.count)
            }
            
            do {
                let JSONData = try JSONSerialization.jsonObject(with: JSONDataToParse, options: .allowFragments) as! JSONDictionary
                
                self.complete(withCompletionHandler: self.completionHandler, result: JSONData as AnyObject!, error: nil)
            } catch let JSONError as NSError {
                let userInfo = [NSLocalizedDescriptionKey: LocalizedErrorDescription.JSONSerialization, NSUnderlyingErrorKey: JSONError] as [String : Any]
                let error    = NSError(domain: LocalizedError.Domain, code: LocalizedErrorCode.JSONSerialization, userInfo: userInfo)
                
                self.complete(withCompletionHandler: self.completionHandler, result: nil, error: error)
                return
            }
            
        }) 
        
        NetworkActivityIndicatorManager.shared.startActivity()
        task.resume()
    }
    
}



// MARK - Private Helpers

private extension APIDataTaskWithRequest {
    
    struct LocalizedError {
        static let Domain          = "OnTheMapExternalAPIInterfaceError"
        static let UdacityHostName = "www.udacity.com"
    }
    
    struct LocalizedErrorCode {
        static let Network           = 1
        static let HTTP              = 2
        static let JSON              = 3
        static let JSONSerialization = 4
    }
    
    struct LocalizedErrorDescription {
        static let Network           = "Network Error"
        static let HTTP              = "HTTP Error"
        static let JSON	             = "JSON Error"
        static let JSONSerialization = "JSON JSONSerialization Error"
    }
    
    func complete(withCompletionHandler handler: @escaping APIDataTaskWithRequestCompletionHandler, result: AnyObject!, error: NSError?) {
        
        DispatchQueue.main.async(execute:  {
            self.completionHandler(result, error)
        })
        
    }
    
}
