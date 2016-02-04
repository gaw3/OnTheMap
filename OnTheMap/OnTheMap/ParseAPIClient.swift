//
//  ParseAPIClient.swift
//  OnTheMap
//
//  Created by Gregory White on 11/30/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

private let _sharedClient = ParseAPIClient()

class ParseAPIClient: NSObject {

	class var sharedClient: ParseAPIClient {
		return _sharedClient
	}

	// MARK: - Public Constants

	struct API {
		static let BaseURL        = "https://api.parse.com/1/classes/StudentLocation"
		
		static let DateCreatedKey = "createdAt"
		static let DateUpdatedKey = "updatedAt"
		static let FirstNameKey   = "firstName"
		static let LastNameKey    = "lastName"
		static let LatKey			  = "latitude"
		static let MapStringKey   = "mapString"
		static let LongKey		  = "longitude"
		static let MediaURLKey    = "mediaURL"
		static let ObjectIDKey    = "objectId"
		static let ResultsKey     = "results"
		static let UniqueKeyKey   = "uniqueKey"
	}

	// MARK: - Private Constants

	private struct ParseAppIDField {
		static let Name  = "X-Parse-Application-Id"
		static let Value = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
	}

	private struct ParseRESTAPIKeyField {
		static let Name  = "X-Parse-REST-API-Key"
		static let Value = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
	}

	// MARK: - API

	func getStudentLocation(udacityUserID: String, completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let URLRequest          = getURLRequest(HTTPMethod.Get, URLString: API.BaseURL, HTTPQuery: "where={\"\(API.UniqueKeyKey)\":\"\(udacityUserID)\"}")
		let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)

		dataTaskWithRequest.resume()
	}
	
	func postStudentLocation(studentLocation: StudentLocation, completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let URLRequest = getURLRequest(HTTPMethod.Post, URLString: API.BaseURL, HTTPQuery: nil)

		URLRequest.HTTPBody = studentLocation.newStudentSerializedData
		URLRequest.addValue(MIMEType.ApplicationJSON, forHTTPHeaderField: HTTPHeaderField.ContentType)

		let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)
		dataTaskWithRequest.resume()
	}
	
	func refreshStudentLocations(completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let URLRequest          = getURLRequest(HTTPMethod.Get, URLString: API.BaseURL, HTTPQuery: "limit=100&order=-updatedAt")
		let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)

		dataTaskWithRequest.resume()
	}

	func updateStudentLocation(studentLocation: StudentLocation, completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let URLRequest = getURLRequest(HTTPMethod.Put, URLString: API.BaseURL + "/\(studentLocation.objectID)", HTTPQuery: nil)

		URLRequest.HTTPBody = studentLocation.newStudentSerializedData
		URLRequest.addValue(MIMEType.ApplicationJSON, forHTTPHeaderField: HTTPHeaderField.ContentType)

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
		URLRequest.addValue(ParseAppIDField.Value,      forHTTPHeaderField: ParseAppIDField.Name)
		URLRequest.addValue(ParseRESTAPIKeyField.Value, forHTTPHeaderField: ParseRESTAPIKeyField.Name)

		return URLRequest
	}

}
