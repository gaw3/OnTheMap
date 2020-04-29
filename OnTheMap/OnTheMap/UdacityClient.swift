//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Gregory White on 11/24/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

final class UdacityClient {
    static let shared = UdacityClient()
}



// MARK: -
// MARK: - API

extension UdacityClient {
    
    func getProfileData(forUserID userID: String, completionHandler: @escaping NetworkTaskCompletionHandler) {
        let urlRequest          = getURLRequest(UdacityClient.URL.user + userID, httpMethod: String.HTTP.Method.get)
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        
        dataTaskWithRequest.resume()
    }
    
    func getStudentLocation(forUserID id: String, completionHandler: @escaping NetworkTaskCompletionHandler) {
        let urlRequest          = getURLRequest(UdacityClient.URL.getStudentLocation(forUserID: id), httpMethod: String.HTTP.Method.get)
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, isSessionURL: false, completionHandler: completionHandler)
        
        dataTaskWithRequest.resume()
    }
    
    func login(username: String, password: String, completionHandler: @escaping NetworkTaskCompletionHandler) {
        let udacityLoginData     = UdacityLoginData(udacity: UdacityLoginData.Udacity(username: username, password: password))
        let encoder              = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let endodedData          = try! encoder.encode(udacityLoginData)
        
        login(endodedData, completionHandler: completionHandler)
    }
    
    func logout(completionHandler: @escaping NetworkTaskCompletionHandler) {
        let urlRequest = getURLRequest(UdacityClient.URL.session, httpMethod: String.HTTP.Method.delete)
        let cookies    = HTTPCookieStorage.shared.cookies!
        
        if let index = cookies.firstIndex(where: { $0.name == XSRFTokenField.cookieName }) {
            urlRequest.setValue(cookies[index].value, forHTTPHeaderField: XSRFTokenField.name)
        }
        
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        dataTaskWithRequest.resume()
    }
    
    func refreshStudentLocations(completionHandler: @escaping NetworkTaskCompletionHandler) {
        let urlRequest          = getURLRequest(UdacityClient.URL.getStudentLocations, httpMethod: String.HTTP.Method.get)
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, isSessionURL: false, completionHandler: completionHandler)
        
        dataTaskWithRequest.resume()
    }
    
}



// MARK: -
// MARK: - Private Helpers

private extension UdacityClient {
    
    func getURLRequest(_ urlString: String, httpMethod: String, httpQuery: String? = nil) -> NSMutableURLRequest {
        var components = URLComponents(string: urlString)
        
        if let _ = httpQuery { components?.query = httpQuery }
        
        let URLRequest = NSMutableURLRequest(url: (components?.url)!)
        URLRequest.httpMethod = httpMethod
        
        return URLRequest
    }
    
    func login(_ serializedData: Data, completionHandler: @escaping NetworkTaskCompletionHandler) {
        let urlRequest = getURLRequest(UdacityClient.URL.session, httpMethod: String.HTTP.Method.post, httpQuery: nil)
        
        urlRequest.httpBody = serializedData
        urlRequest.addValue(String.HTTP.MIMEType.applicationJSON, forHTTPHeaderField: String.HTTP.HeaderField.accept)
        urlRequest.addValue(String.HTTP.MIMEType.applicationJSON, forHTTPHeaderField: String.HTTP.HeaderField.contentType)
        
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        dataTaskWithRequest.resume()
    }
    
}

