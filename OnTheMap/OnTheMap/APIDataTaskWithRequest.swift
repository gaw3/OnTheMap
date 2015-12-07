//
//  APIDataTaskWithRequest.swift
//  OnTheMap
//
//  Created by Gregory White on 11/30/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

typealias APIDataTaskWithRequestCompletionHandler = (result: AnyObject!, error: NSError?) -> Void

class APIDataTaskWithRequest: NSObject {

	// MARK: - Class Constants

	private struct LocalizedError {
		static let Domain          = "OnTheMapExternalAPIInterfaceError"
		static let UdacityHostName = "www.udacity.com"

	}
	
	private struct LocalizedErrorCode {
		static let Network           = 1
		static let HTTP              = 2
		static let JSON              = 3
		static let JSONSerialization = 4
	}

	private struct LocalizedErrorDescription {
		static let Network           = "Network Error"
		static let HTTP              = "HTTP Error"
		static let JSON	           = "JSON Error"
		static let JSONSerialization = "JSON JSONSerialization Error"
	}

	var URLRequest: NSMutableURLRequest
	var completionHandler: APIDataTaskWithRequestCompletionHandler

	// MARK: - API

	init(URLRequest: NSMutableURLRequest, completionHandler: APIDataTaskWithRequestCompletionHandler) {
		self.URLRequest        = URLRequest
		self.completionHandler = completionHandler

		super.init()
	}

	func resume() {
		
		let task = NSURLSession.sharedSession().dataTaskWithRequest(URLRequest) { (rawJSONResponse, HTTPResponse, URLSessionError) in

			guard URLSessionError == nil else {
				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey : LocalizedErrorDescription.Network,
																	 NSUnderlyingErrorKey      : URLSessionError!]
				let error = NSError(domain: LocalizedError.Domain, code: LocalizedErrorCode.Network, userInfo: userInfo)

				self.completeWithHandler(self.completionHandler, result: nil, error: error)
				return
			}

			let HTTPURLResponse = HTTPResponse as? NSHTTPURLResponse

			guard HTTPURLResponse?.statusCodeClass == .Successful else {
				let HTTPStatusText = NSHTTPURLResponse.localizedStringForStatusCode((HTTPURLResponse?.statusCode)!)
				let failureReason  = "HTTP status code = \(HTTPURLResponse?.statusCode), HTTP status text = \(HTTPStatusText)"

				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey        : LocalizedErrorDescription.HTTP,
																	 NSLocalizedFailureReasonErrorKey : failureReason]
				let error = NSError(domain: LocalizedError.Domain, code: LocalizedErrorCode.HTTP, userInfo: userInfo)

				self.completeWithHandler(self.completionHandler, result: nil, error: error)
				return
			}

			guard let rawJSONResponse = rawJSONResponse else {
				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey : LocalizedErrorDescription.JSON]
				let error = NSError(domain: LocalizedError.Domain, code: LocalizedErrorCode.JSON, userInfo: userInfo)

				self.completeWithHandler(self.completionHandler, result: nil, error: error)
				return
			}

			var JSONDataToParse = rawJSONResponse

			if self.URLRequest.URL?.host == LocalizedError.UdacityHostName {
				JSONDataToParse = rawJSONResponse.subdataWithRange(NSMakeRange(5, rawJSONResponse.length - 5))
			}

			do {
				let JSONData = try NSJSONSerialization.JSONObjectWithData(JSONDataToParse, options: .AllowFragments) as! Dictionary<String, AnyObject>

				self.completeWithHandler(self.completionHandler, result: JSONData, error: nil)
			} catch let JSONError as NSError {
				let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey : LocalizedErrorDescription.JSONSerialization,
																	 NSUnderlyingErrorKey      : JSONError]
				let error = NSError(domain: LocalizedError.Domain, code: LocalizedErrorCode.JSONSerialization, userInfo: userInfo)

				self.completeWithHandler(self.completionHandler, result: nil, error: error)
				return
			}

		}

		task.resume()
	}

	// MARK: - Private

	private func completeWithHandler(completionHandler: APIDataTaskWithRequestCompletionHandler, result: AnyObject!, error: NSError?) {

		dispatch_async(dispatch_get_main_queue()) {
			completionHandler(result: result, error: error)
		}
		
	}

}