//
//  ParseAPIClient.swift
//  OnTheMap
//
//  Created by Gregory White on 11/30/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

typealias ParseAPICompletionHandler = (result: AnyObject!, error: NSError?) -> Void

class ParseAPIClient: NSObject {

	class func getStudentLocations(completionHandler: ParseAPICompletionHandler) {
		let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=5")!)
		request.HTTPMethod = "GET"
		request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
		request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")

		let session = NSURLSession.sharedSession()
		let task    = session.dataTaskWithRequest(request) { (rawJSONResponse, httpResponse, urlSessionError) in

			guard urlSessionError == nil else {
				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey : "Network Error",
					                                     NSUnderlyingErrorKey      : urlSessionError!]
				let error = NSError(domain: "Parse API Get Student Locations", code: 1, userInfo: userInfo)

				completionHandler(result: nil, error: error)
				return
			}

			let httpURLResponse = httpResponse as? NSHTTPURLResponse

			guard httpURLResponse?.statusCodeClass == .Successful else {
				let httpStatusText = NSHTTPURLResponse.localizedStringForStatusCode((httpURLResponse?.statusCode)!)
				let failureReason  = "HTTP status code = \(httpURLResponse?.statusCode), HTTP status text = \(httpStatusText)"

				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey        : "HTTP Error",
																	 NSLocalizedFailureReasonErrorKey : failureReason]
				let error = NSError(domain: "Parse API Get Student Locations", code: 2, userInfo: userInfo)

				completionHandler(result: nil, error: error)
				return
			}

			guard let rawJSONResponse = rawJSONResponse else {
				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey        : "JSON Error",
																	 NSLocalizedFailureReasonErrorKey : "Could not find raw JSON data"]
				let error = NSError(domain: "Parse API Get Student Locations", code: 3, userInfo: userInfo)

				completionHandler(result: nil, error: error)
				return
			}

			do {
				let parsedJSONResponse = try NSJSONSerialization.JSONObjectWithData(rawJSONResponse, options: .AllowFragments) as! Dictionary<String, AnyObject>

				completionHandler(result: parsedJSONResponse, error: nil)
			} catch let jsonError as NSError {
				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey : "JSON Serialization Error",
																	 NSUnderlyingErrorKey      : jsonError]
				let error = NSError(domain: "Parse API Get Student Locations", code: 4, userInfo: userInfo)

				completionHandler(result: nil, error: error)
				return
			}

		}

		task.resume()
	}

	class func postStudentLocation(completionHandler: ParseAPICompletionHandler) {
		let student = [ "uniqueKey" : "blap",
			"firstName" : "Jonathan",
			"lastName" : "Hemlock",
			"mapString" : "Dallas, TX",
			"mediaURL" : "https://udacity.com",
			"latitude" : 32.7767,
			"longitude" : 96.797]

		let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)

		request.HTTPMethod = "POST"
		request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
		request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(student, options: .PrettyPrinted)

		let session = NSURLSession.sharedSession()
		let task    = session.dataTaskWithRequest(request) { (rawJSONResponse, httpResponse, urlSessionError) in

			guard urlSessionError == nil else {
				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey : "Network Error",
					NSUnderlyingErrorKey      : urlSessionError!]
				let error = NSError(domain: "Parse API Get Student Locations", code: 1, userInfo: userInfo)

				completionHandler(result: nil, error: error)
				return
			}

			let httpURLResponse = httpResponse as? NSHTTPURLResponse

			guard httpURLResponse?.statusCodeClass == .Successful else {
				let httpStatusText = NSHTTPURLResponse.localizedStringForStatusCode((httpURLResponse?.statusCode)!)
				let failureReason  = "HTTP status code = \(httpURLResponse?.statusCode), HTTP status text = \(httpStatusText)"

				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey        : "HTTP Error",
					NSLocalizedFailureReasonErrorKey : failureReason]
				let error = NSError(domain: "Parse API Get Student Locations", code: 2, userInfo: userInfo)

				completionHandler(result: nil, error: error)
				return
			}

			guard let rawJSONResponse = rawJSONResponse else {
				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey        : "JSON Error",
					NSLocalizedFailureReasonErrorKey : "Could not find raw JSON data"]
				let error = NSError(domain: "Parse API Get Student Locations", code: 3, userInfo: userInfo)

				completionHandler(result: nil, error: error)
				return
			}

			do {
				let parsedJSONResponse = try NSJSONSerialization.JSONObjectWithData(rawJSONResponse, options: .AllowFragments) as! Dictionary<String, AnyObject>

				completionHandler(result: parsedJSONResponse, error: nil)
			} catch let jsonError as NSError {
				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey : "JSON Serialization Error",
					NSUnderlyingErrorKey      : jsonError]
				let error = NSError(domain: "Parse API Get Student Locations", code: 4, userInfo: userInfo)

				completionHandler(result: nil, error: error)
				return
			}

		}

		task.resume()
	}


}
