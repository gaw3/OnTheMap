//
//  ParseAPIClient.swift
//  OnTheMap
//
//  Created by Gregory White on 11/30/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

private let _shared = ParseAPIClient()

final class ParseAPIClient {
    
    class var shared: ParseAPIClient {
        return _shared
    }
    
}



// MARK: - API

extension ParseAPIClient {
    
    func getStudentLocation(forUserID id: String, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let query               = "where={\"\(ParseAPIClient.API.UniqueKeyKey)\":\"\(id)\"}"
        let urlRequest          = getURLRequest(HTTP.Method.Get, urlString: ParseAPIClient.API.BaseURL, httpQuery: query)
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        
        dataTaskWithRequest.resume()
    }
    
    func post(studentLocation: StudentLocation, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let urlRequest = getURLRequest(HTTP.Method.Post, urlString: ParseAPIClient.API.BaseURL, httpQuery: nil)
        
        urlRequest.httpBody = studentLocation.newStudentSerializedData as Data
        urlRequest.addValue(HTTP.MIMEType.ApplicationJSON, forHTTPHeaderField: HTTP.HeaderField.ContentType)
        
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        dataTaskWithRequest.resume()
    }
    
    func refreshStudentLocations(completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let query               = "limit=100&order=-updatedAt"
        let urlRequest          = getURLRequest(HTTP.Method.Get, urlString: ParseAPIClient.API.BaseURL, httpQuery: query)
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        
        dataTaskWithRequest.resume()
    }
    
    func update(studentLocation: StudentLocation, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let urlString  = ParseAPIClient.API.BaseURL + "/\(studentLocation.objectID)"
        let urlRequest = getURLRequest(HTTP.Method.Put, urlString: urlString, httpQuery: nil)
        
        urlRequest.httpBody = studentLocation.newStudentSerializedData as Data
        urlRequest.addValue(HTTP.MIMEType.ApplicationJSON, forHTTPHeaderField: HTTP.HeaderField.ContentType)
        
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        dataTaskWithRequest.resume()
    }
    
}



// MARK: -
// MARK: - Private Helpers

private extension ParseAPIClient {

    func getURLRequest(_ httpMethod: String, urlString: String, httpQuery: String?) -> NSMutableURLRequest {
        var components = URLComponents(string: urlString)
        
        if let _ = httpQuery { components?.query = httpQuery }
        
        let URLRequest = NSMutableURLRequest(url: (components?.url)!)
        
        URLRequest.httpMethod = httpMethod
        URLRequest.addValue(AppIDField.Value,      forHTTPHeaderField: AppIDField.Name)
        URLRequest.addValue(RESTAPIKeyField.Value, forHTTPHeaderField: RESTAPIKeyField.Name)
        
        return URLRequest
    }
    
}
