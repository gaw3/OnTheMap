//
//  UdacityAPIClient.swift
//  OnTheMap
//
//  Created by Gregory White on 11/24/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit
import FBSDKLoginKit

private let _shared = UdacityAPIClient()

final class UdacityAPIClient {
    
    class var shared: UdacityAPIClient {
        return _shared
    }
    
}



// MARK: -
// MARK: - API

extension UdacityAPIClient {
    
    func getProfileData(forUserID userID: String, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let urlRequest          = getURLRequest(UdacityAPIClient.API.UsersURL + userID, httpMethod: HTTP.Method.Get, httpQuery: nil)
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        
        dataTaskWithRequest.resume()
    }
    
    func login(facebookAccessToken: FBSDKAccessToken, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        login(UdacityFBAccessToken(accessToken: facebookAccessToken).serializedData as Data, completionHandler: completionHandler)
    }
    
    func login(username: String, password: String, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        login(UdacityLogin(username: username, password: password).serializedData as Data, completionHandler: completionHandler)
    }
    
    func logout(completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let urlRequest = getURLRequest(UdacityAPIClient.API.SessionURL, httpMethod: HTTP.Method.Delete, httpQuery: nil)
        let cookies    = HTTPCookieStorage.shared.cookies!
        
        if let index = cookies.index(where: { $0.name == XSRFTokenField.CookieName }) {
            urlRequest.setValue(cookies[index].value, forHTTPHeaderField: XSRFTokenField.Name)
        }
        
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        dataTaskWithRequest.resume()
    }
    
}



// MARK: -
// MARK: - Private Helpers

private extension UdacityAPIClient {

    func getURLRequest(_ urlString: String, httpMethod: String, httpQuery: String?) -> NSMutableURLRequest {
        var components = URLComponents(string: urlString)
        
        if let _ = httpQuery { components?.query = httpQuery }
        
        let URLRequest = NSMutableURLRequest(url: (components?.url)!)
        URLRequest.httpMethod = httpMethod
        
        return URLRequest
    }
    
    func login(_ serializedData: Data, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let urlRequest = getURLRequest(UdacityAPIClient.API.SessionURL, httpMethod: HTTP.Method.Post, httpQuery: nil)
        
        urlRequest.httpBody = serializedData
        urlRequest.addValue(HTTP.MIMEType.ApplicationJSON, forHTTPHeaderField: HTTP.HeaderField.Accept)
        urlRequest.addValue(HTTP.MIMEType.ApplicationJSON, forHTTPHeaderField: HTTP.HeaderField.ContentType)
        
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        dataTaskWithRequest.resume()
    }
    
}

