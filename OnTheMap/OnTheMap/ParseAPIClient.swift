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
    
    func getStudentLocation(withUserID id: String, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let query               = "where={\"\(ParseAPIClient.API.UniqueKeyKey)\":\"\(id)\"}"
        let urlRequest          = getURLRequest(APIDataTaskWithRequest.HTTP.Method.Get, urlString: ParseAPIClient.API.BaseURL, httpQuery: query)
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        
        dataTaskWithRequest.resume()
    }
    
    func postStudentLocation(_ studentLocation: StudentLocation, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let urlRequest = getURLRequest(APIDataTaskWithRequest.HTTP.Method.Post, urlString: ParseAPIClient.API.BaseURL, httpQuery: nil)
        
        urlRequest.httpBody = studentLocation.newStudentSerializedData as Data
        urlRequest.addValue(APIDataTaskWithRequest.HTTP.MIMEType.ApplicationJSON,
                            forHTTPHeaderField: APIDataTaskWithRequest.HTTP.HeaderField.ContentType)
        
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        dataTaskWithRequest.resume()
    }
    
    func refreshStudentLocations(_ completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let query               = "limit=100&order=-updatedAt"
        let urlRequest          = getURLRequest(APIDataTaskWithRequest.HTTP.Method.Get, urlString: ParseAPIClient.API.BaseURL, httpQuery: query)
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        
        dataTaskWithRequest.resume()
    }
    
    func updateStudentLocation(_ studentLocation: StudentLocation, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let urlString  = ParseAPIClient.API.BaseURL + "/\(studentLocation.objectID)"
        let urlRequest = getURLRequest(APIDataTaskWithRequest.HTTP.Method.Put, urlString: urlString, httpQuery: nil)
        
        urlRequest.httpBody = studentLocation.newStudentSerializedData as Data
        urlRequest.addValue(APIDataTaskWithRequest.HTTP.MIMEType.ApplicationJSON, forHTTPHeaderField: APIDataTaskWithRequest.HTTP.HeaderField.ContentType)
        
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        dataTaskWithRequest.resume()
    }
    
}



// MARK: -
// MARK: - Private Helpers

private extension ParseAPIClient {

    struct ParseAppIDField {
        static let Name  = "X-Parse-Application-Id"
        static let Value = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
    struct ParseRESTAPIKeyField {
        static let Name  = "X-Parse-REST-API-Key"
        static let Value = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    func getURLRequest(_ httpMethod: String, urlString: String, httpQuery: String?) -> NSMutableURLRequest {
        var components = URLComponents(string: urlString)
        
        if let _ = httpQuery { components?.query = httpQuery }
        
        let URLRequest = NSMutableURLRequest(url: (components?.url)!)
        
        URLRequest.httpMethod = httpMethod
        URLRequest.addValue(ParseAppIDField.Value,      forHTTPHeaderField: ParseAppIDField.Name)
        URLRequest.addValue(ParseRESTAPIKeyField.Value, forHTTPHeaderField: ParseRESTAPIKeyField.Name)
        
        return URLRequest
    }
    
}
