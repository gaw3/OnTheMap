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



// MARK: - API

extension UdacityAPIClient {
    
    func getUserProfileData(_ userID: String, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let urlRequest          = getURLRequest(APIDataTaskWithRequest.HTTP.Method.Get, urlString: UdacityAPIClient.API.UsersURL + userID, httpQuery: nil)
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        
        dataTaskWithRequest.resume()
    }
    
    func loginWithFacebookAuthorization(_ facebookAccessToken: FBSDKAccessToken, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        login(UdacityFBAccessToken(accessToken: facebookAccessToken).serializedData as Data, completionHandler: completionHandler)
    }
    
    func loginWithUdacityUser(_ username: String, password: String, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        login(UdacityLogin(username: username, password: password).serializedData as Data, completionHandler: completionHandler)
    }
    
    func logout(_ completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let urlRequest = getURLRequest(APIDataTaskWithRequest.HTTP.Method.Delete, urlString: UdacityAPIClient.API.SessionURL, httpQuery: nil)
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

    struct XSRFTokenField {
        static let Name       = "X-XSRF-TOKEN"
        static let CookieName = "XSRF-TOKEN"
    }
    
    func getURLRequest(_ httpMethod: String, urlString: String, httpQuery: String?) -> NSMutableURLRequest {
        var components = URLComponents(string: urlString)
        
        if let _ = httpQuery { components?.query = httpQuery }
        
        let URLRequest = NSMutableURLRequest(url: (components?.url)!)
        URLRequest.httpMethod = httpMethod
        
        return URLRequest
    }
    
    func login(_ serializedData: Data, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let urlRequest = getURLRequest(APIDataTaskWithRequest.HTTP.Method.Post, urlString: UdacityAPIClient.API.SessionURL, httpQuery: nil)
        
        urlRequest.httpBody = serializedData
        urlRequest.addValue(APIDataTaskWithRequest.HTTP.MIMEType.ApplicationJSON, forHTTPHeaderField: APIDataTaskWithRequest.HTTP.HeaderField.Accept)
        urlRequest.addValue(APIDataTaskWithRequest.HTTP.MIMEType.ApplicationJSON, forHTTPHeaderField: APIDataTaskWithRequest.HTTP.HeaderField.ContentType)
        
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        dataTaskWithRequest.resume()
    }
    
}

