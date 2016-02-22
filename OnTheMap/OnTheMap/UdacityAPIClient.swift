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

final class UdacityAPIClient: NSObject {

	class var sharedClient: UdacityAPIClient {
		return _sharedClient
	}

	// MARK: - Private Constants

	private struct XSRFTokenField {
		static let Name       = "X-XSRF-TOKEN"
		static let CookieName = "XSRF-TOKEN"
	}

	// MARK: - API

	func getUserProfileData(userID: String, completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let URLRequest          = getURLRequest(APIDataTaskWithRequest.HTTP.Method.Get,
			                                     URLString: UdacityAPIClient.API.UsersURL + userID, HTTPQuery: nil)
		let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)

		dataTaskWithRequest.resume()
	}

	func loginWithFacebookAuthorization(facebookAccessToken: FBSDKAccessToken, completionHandler: APIDataTaskWithRequestCompletionHandler) {
		login(UdacityFBAccessToken(accessToken: facebookAccessToken).serializedData, completionHandler: completionHandler)
	}
	
	func loginWithUdacityUser(username: String, password: String, completionHandler: APIDataTaskWithRequestCompletionHandler) {
		login(UdacityLogin(username: username, password: password).serializedData, completionHandler: completionHandler)
	}

	func logout(completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let URLRequest = getURLRequest(APIDataTaskWithRequest.HTTP.Method.Delete,
			                            URLString: UdacityAPIClient.API.SessionURL, HTTPQuery: nil)
		let cookies    = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies!

		if let index = cookies.indexOf({ $0.name == XSRFTokenField.CookieName }) {
			URLRequest.setValue(cookies[index].value, forHTTPHeaderField: XSRFTokenField.Name)
		}

		let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)
		dataTaskWithRequest.resume()
	}

	// MARK: - Private

	private override init() {
		super.init()
	}

	private func getURLRequest(HTTPMethod: String, URLString: String, HTTPQuery: String?) -> NSMutableURLRequest {
		let components = NSURLComponents(string: URLString)

		if let _ = HTTPQuery { components?.query = HTTPQuery }

		let URLRequest = NSMutableURLRequest(URL: (components?.URL)!)
		URLRequest.HTTPMethod = HTTPMethod

		return URLRequest
	}

	private func login(serializedData: NSData, completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let URLRequest = getURLRequest(APIDataTaskWithRequest.HTTP.Method.Post,
											    URLString: UdacityAPIClient.API.SessionURL, HTTPQuery: nil)

		URLRequest.HTTPBody = serializedData
		URLRequest.addValue(APIDataTaskWithRequest.HTTP.MIMEType.ApplicationJSON,
			                 forHTTPHeaderField: APIDataTaskWithRequest.HTTP.HeaderField.Accept)
		URLRequest.addValue(APIDataTaskWithRequest.HTTP.MIMEType.ApplicationJSON,
			                 forHTTPHeaderField: APIDataTaskWithRequest.HTTP.HeaderField.ContentType)

		let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)
		dataTaskWithRequest.resume()
	}

}

