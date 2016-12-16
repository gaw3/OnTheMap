//
//  UdacityAPIClient.swift
//  OnTheMap
//
//  Created by Gregory White on 11/24/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation
import UIKit

import FBSDKLoginKit

private let _sharedClient = UdacityAPIClient()

final  class UdacityAPIClient: NSObject {
    
    class  var sharedClient: UdacityAPIClient {
        return _sharedClient
    }
    
    // MARK: - Private Constants
    
    fileprivate struct XSRFTokenField {
        static let Name       = "X-XSRF-TOKEN"
        static let CookieName = "XSRF-TOKEN"
    }
    
    // MARK: - API
    
     func getUserProfileData(_ userID: String, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let URLRequest          = getURLRequest(APIDataTaskWithRequest.HTTP.Method.Get,
                                                URLString: UdacityAPIClient.API.UsersURL + userID, HTTPQuery: nil)
        let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)
        
        dataTaskWithRequest.resume()
    }
    
     func loginWithFacebookAuthorization(_ facebookAccessToken: FBSDKAccessToken, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        login(UdacityFBAccessToken(accessToken: facebookAccessToken).serializedData as Data, completionHandler: completionHandler)
    }
    
     func loginWithUdacityUser(_ username: String, password: String, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        login(UdacityLogin(username: username, password: password).serializedData as Data, completionHandler: completionHandler)
    }
    
     func logout(_ completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let URLRequest = getURLRequest(APIDataTaskWithRequest.HTTP.Method.Delete,
                                       URLString: UdacityAPIClient.API.SessionURL, HTTPQuery: nil)
        let cookies    = HTTPCookieStorage.shared.cookies!
        
        if let index = cookies.index(where: { $0.name == XSRFTokenField.CookieName }) {
            URLRequest.setValue(cookies[index].value, forHTTPHeaderField: XSRFTokenField.Name)
        }
        
        let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)
        dataTaskWithRequest.resume()
    }
    
    // MARK: - Private
    
    override fileprivate init() {
        super.init()
    }
    
    fileprivate func getURLRequest(_ HTTPMethod: String, URLString: String, HTTPQuery: String?) -> NSMutableURLRequest {
        var components = URLComponents(string: URLString)
        
        if let _ = HTTPQuery { components?.query = HTTPQuery }
        
        let URLRequest = NSMutableURLRequest(url: (components?.url)!)
        URLRequest.httpMethod = HTTPMethod
        
        return URLRequest
    }
    
    fileprivate func login(_ serializedData: Data, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let URLRequest = getURLRequest(APIDataTaskWithRequest.HTTP.Method.Post,
                                       URLString: UdacityAPIClient.API.SessionURL, HTTPQuery: nil)
        
        URLRequest.httpBody = serializedData
        URLRequest.addValue(APIDataTaskWithRequest.HTTP.MIMEType.ApplicationJSON,
                            forHTTPHeaderField: APIDataTaskWithRequest.HTTP.HeaderField.Accept)
        URLRequest.addValue(APIDataTaskWithRequest.HTTP.MIMEType.ApplicationJSON,
                            forHTTPHeaderField: APIDataTaskWithRequest.HTTP.HeaderField.ContentType)
        
        let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)
        dataTaskWithRequest.resume()
    }
    
}

