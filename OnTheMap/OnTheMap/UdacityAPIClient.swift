//
//  UdacityAPIClient.swift
//  OnTheMap
//
//  Created by Gregory White on 11/24/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

typealias LoginCompletionHandler = (result: AnyObject!, error: NSError?) -> Void

class UdacityAPIClient: NSObject {

	class func logout(completionHandler: LoginCompletionHandler) {
		let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
		request.HTTPMethod = "DELETE"

		let cookies: [NSHTTPCookie] = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies!
		
		let index = cookies.indexOf { (cookie) -> Bool in
			return (cookie.name == "XSRF-TOKEN")
		}

		if let index = index {
			request.setValue(cookies[index].value, forHTTPHeaderField: "X-XSRF-TOKEN")
		}

		let session = NSURLSession.sharedSession()
		let task    = session.dataTaskWithRequest(request) { (rawJSONResponse, httpResponse, urlSessionError) in

			guard urlSessionError == nil else {
				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey : "Network Error",
					NSUnderlyingErrorKey      : urlSessionError!]
				let error = NSError(domain: "Udacity API Logout", code: 1, userInfo: userInfo)

				completionHandler(result: nil, error: error)
				return
			}

			let httpURLResponse = httpResponse as? NSHTTPURLResponse

			guard httpURLResponse?.statusCodeClass == .Successful else {
				let httpStatusText = NSHTTPURLResponse.localizedStringForStatusCode((httpURLResponse?.statusCode)!)
				let failureReason  = "HTTP status code = \(httpURLResponse?.statusCode), HTTP status text = \(httpStatusText)"

				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey        : "HTTP Error",
					NSLocalizedFailureReasonErrorKey : failureReason]
				let error = NSError(domain: "Udacity API Logout", code: 2, userInfo: userInfo)

				completionHandler(result: nil, error: error)
				return
			}

			guard let rawJSONResponse = rawJSONResponse else {
				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey        : "JSON Error",
					NSLocalizedFailureReasonErrorKey : "Could not find raw JSON data"]
				let error = NSError(domain: "Udacity API Logout", code: 3, userInfo: userInfo)

				completionHandler(result: nil, error: error)
				return
			}

			let actualJSONData = rawJSONResponse.subdataWithRange(NSMakeRange(5, rawJSONResponse.length - 5))

			do {
				let parsedJSONResponse = try NSJSONSerialization.JSONObjectWithData(actualJSONData, options: .AllowFragments) as! Dictionary<String, AnyObject>

				completionHandler(result: parsedJSONResponse, error: nil)
			} catch let jsonError as NSError {
				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey : "JSON Serialization Error",
					NSUnderlyingErrorKey      : jsonError]
				let error = NSError(domain: "Udacity API Logout", code: 4, userInfo: userInfo)

				completionHandler(result: nil, error: error)
				return
			}

		}

		task.resume()
	}

	class func loginWithUsername(username: String, password: String, completionHandler: LoginCompletionHandler) {
		let request        = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
		let udacityJSONObj = [ "udacity": [ "username": username, "password": password ] ]


		request.HTTPMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(udacityJSONObj, options: .PrettyPrinted)

      let session = NSURLSession.sharedSession()
		let task    = session.dataTaskWithRequest(request) { (rawJSONResponse, httpResponse, urlSessionError) in

			guard urlSessionError == nil else {
				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey : "Network Error",
																	 NSUnderlyingErrorKey      : urlSessionError!]
				let error = NSError(domain: "Udacity API Login", code: 1, userInfo: userInfo)

				completionHandler(result: nil, error: error)
				return
			}

			let httpURLResponse = httpResponse as? NSHTTPURLResponse

			guard httpURLResponse?.statusCodeClass == .Successful else {
				let httpStatusText = NSHTTPURLResponse.localizedStringForStatusCode((httpURLResponse?.statusCode)!)
				let failureReason  = "HTTP status code = \(httpURLResponse?.statusCode), HTTP status text = \(httpStatusText)"

				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey        : "HTTP Error",
																	 NSLocalizedFailureReasonErrorKey : failureReason]
				let error = NSError(domain: "Udacity API Login", code: 2, userInfo: userInfo)

				completionHandler(result: nil, error: error)
				return
			}

			guard let rawJSONResponse = rawJSONResponse else {
				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey        : "JSON Error",
																	 NSLocalizedFailureReasonErrorKey : "Could not find raw JSON data"]
				let error = NSError(domain: "Udacity API Login", code: 3, userInfo: userInfo)

				completionHandler(result: nil, error: error)
				return
			}

			let actualJSONData = rawJSONResponse.subdataWithRange(NSMakeRange(5, rawJSONResponse.length - 5))

			do {
				let parsedJSONResponse = try NSJSONSerialization.JSONObjectWithData(actualJSONData, options: .AllowFragments) as! Dictionary<String, AnyObject>

				completionHandler(result: parsedJSONResponse, error: nil)
			} catch let jsonError as NSError {
				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey : "JSON Serialization Error",
																	 NSUnderlyingErrorKey      : jsonError]
				let error = NSError(domain: "Udacity API Login", code: 4, userInfo: userInfo)

				completionHandler(result: nil, error: error)
				return
			}

		}

		task.resume()
	}

}

