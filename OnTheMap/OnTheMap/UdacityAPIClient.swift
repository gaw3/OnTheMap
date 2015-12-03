//
//  UdacityAPIClient.swift
//  OnTheMap
//
//  Created by Gregory White on 11/24/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

class UdacityAPIClient: NSObject {

	// MARK: - Constants

	private struct API {
		static let BaseURL     = "https://www.udacity.com/api/session"
		static let UdacityKey  = "udacity"
		static let UserNameKey = "username"
		static let PasswordKey = "password"
	}

	private struct XSRFTokenField {
		static let Name       = "X-XSRF-TOKEN"
		static let CookieName = "XSRF-TOKEN"
	}

	// MARK: - API

	class func loginWithUsername(username: String, password: String, completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let JSONLogin  = [ API.UdacityKey : [ API.UserNameKey : username, API.PasswordKey : password ] ]
		let URLRequest = NSMutableURLRequest(URL: NSURL(string: API.BaseURL)!)

		URLRequest.HTTPMethod = HTTPMethod.Post
		URLRequest.HTTPBody   = try! NSJSONSerialization.dataWithJSONObject(JSONLogin, options: .PrettyPrinted)

		URLRequest.addValue(MIMEType.ApplicationJSON, forHTTPHeaderField: HTTPHeaderField.Accept)
		URLRequest.addValue(MIMEType.ApplicationJSON, forHTTPHeaderField: HTTPHeaderField.ContentType)

		APIDataTaskWithRequest.resume(URLRequest, completionHandler: completionHandler)
	}
	
	class func logout(completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let URLRequest = NSMutableURLRequest(URL: NSURL(string: API.BaseURL)!)

		URLRequest.HTTPMethod = HTTPMethod.Delete

		let cookies: [NSHTTPCookie] = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies!
		
		let index = cookies.indexOf { (cookie) -> Bool in
			return (cookie.name == XSRFTokenField.CookieName)
		}

		if let index = index {
			URLRequest.setValue(cookies[index].value, forHTTPHeaderField: XSRFTokenField.Name)
		}

		APIDataTaskWithRequest.resume(URLRequest, completionHandler: completionHandler)
	}

}

