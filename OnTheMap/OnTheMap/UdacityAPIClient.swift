//
//  UdacityAPIClient.swift
//  OnTheMap
//
//  Created by Gregory White on 11/24/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

private let _sharedClient = UdacityAPIClient()

class UdacityAPIClient: NSObject {

	class var sharedClient: UdacityAPIClient {
		return _sharedClient
	}

	// MARK: - Public Constants

	struct API {
		static let BaseURL           = "https://www.udacity.com/api/"
		static let SessionURL        = "\(BaseURL)session"
		static let UsersURL          = "\(BaseURL)users/"

		static let AccountKey        = "account"
		static let ExpirationDateKey = "expiration"
		static let FirstNameKey      = "first_name"
		static let LastNameKey       = "last_name"
		static let PasswordKey       = "password"
		static let RegisteredKey     = "registered"
		static let SessionIDKey      = "id"
		static let SessionKey        = "session"
		static let UdacityKey        = "udacity"
		static let UserIDKey         = "key"
		static let UserKey		     = "user"
		static let UserNameKey       = "username"
	}

	// MARK: - Private Constants

	private struct XSRFTokenField {
		static let Name       = "X-XSRF-TOKEN"
		static let CookieName = "XSRF-TOKEN"
	}

	// MARK: - API

	func getUserData(userID: String, completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let URLRequest = NSMutableURLRequest(URL: NSURL(string: "\(API.UsersURL)\(userID)")!)

		URLRequest.HTTPMethod = HTTPMethod.Get
		
		let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)
		dataTaskWithRequest.resume()
	}

	func login(username: String, password: String, completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let JSONLogin  = [ API.UdacityKey : [ API.UserNameKey : username, API.PasswordKey : password ] ]
		let URLRequest = NSMutableURLRequest(URL: NSURL(string: API.SessionURL)!)

		URLRequest.HTTPMethod = HTTPMethod.Post
		URLRequest.HTTPBody   = try! NSJSONSerialization.dataWithJSONObject(JSONLogin, options: .PrettyPrinted)

		URLRequest.addValue(MIMEType.ApplicationJSON, forHTTPHeaderField: HTTPHeaderField.Accept)
		URLRequest.addValue(MIMEType.ApplicationJSON, forHTTPHeaderField: HTTPHeaderField.ContentType)

		let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)
		dataTaskWithRequest.resume()
	}
	
	func logout(completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let URLRequest = NSMutableURLRequest(URL: NSURL(string: API.SessionURL)!)

		URLRequest.HTTPMethod = HTTPMethod.Delete

		let cookies: [NSHTTPCookie] = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies!
		
		let index = cookies.indexOf { (cookie) -> Bool in
			return (cookie.name == XSRFTokenField.CookieName)
		}

		if let index = index {
			URLRequest.setValue(cookies[index].value, forHTTPHeaderField: XSRFTokenField.Name)
		}

		let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)
		dataTaskWithRequest.resume()
	}

	// MARK: - Private

	private override init() {
		super.init()
	}

}

