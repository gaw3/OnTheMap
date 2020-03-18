//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Gregory White on 11/24/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit
//import FBSDKLoginKit

final class UdacityClient {
    static let shared = UdacityClient()
}



// MARK: -
// MARK: - API

extension UdacityClient {
    
    func getProfileData(forUserID userID: String, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let urlRequest          = getURLRequest(UdacityClient.URL.user + userID, httpMethod: HTTP.Method.get, httpQuery: nil)
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        
        dataTaskWithRequest.resume()
    }
    
//    func login(facebookAccessToken: FBSDKAccessToken, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
//        login(UdacityFBAccessToken(accessToken: facebookAccessToken).serializedData as Data, completionHandler: completionHandler)
//    }
    
    func login(username: String, password: String, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let udacityLoginData     = UdacityLoginData(udacity: UdacityLoginData.Udacity(username: username, password: password))
        let encoder              = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let endodedData          = try! encoder.encode(udacityLoginData)
        
        login(endodedData, completionHandler: completionHandler)
    }
    
    func logout(completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let urlRequest = getURLRequest(UdacityClient.URL.session, httpMethod: HTTP.Method.delete, httpQuery: nil)
        let cookies    = HTTPCookieStorage.shared.cookies!
        
        if let index = cookies.firstIndex(where: { $0.name == XSRFTokenField.CookieName }) {
            urlRequest.setValue(cookies[index].value, forHTTPHeaderField: XSRFTokenField.Name)
        }
        
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        dataTaskWithRequest.resume()
    }

}



// MARK: -
// MARK: - Private Helpers

private extension UdacityClient {

    func getURLRequest(_ urlString: String, httpMethod: String, httpQuery: String?) -> NSMutableURLRequest {
        var components = URLComponents(string: urlString)
        
        if let _ = httpQuery { components?.query = httpQuery }
        
        let URLRequest = NSMutableURLRequest(url: (components?.url)!)
        URLRequest.httpMethod = httpMethod
        
        return URLRequest
    }
    
    func login(_ serializedData: Data, completionHandler: @escaping APIDataTaskWithRequestCompletionHandler) {
        let urlRequest = getURLRequest(UdacityClient.URL.session, httpMethod: HTTP.Method.post, httpQuery: nil)
        
        urlRequest.httpBody = serializedData
        urlRequest.addValue(HTTP.MIMEType.applicationJSON, forHTTPHeaderField: HTTP.HeaderField.accept)
        urlRequest.addValue(HTTP.MIMEType.applicationJSON, forHTTPHeaderField: HTTP.HeaderField.contentType)
        
        let dataTaskWithRequest = APIDataTaskWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
        dataTaskWithRequest.resume()
    }
    
}

