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

	// MARK: - Public Variables

	class var sharedClient: ParseAPIClient {
		return _sharedClient
	}
	
	// MARK: - API

	func getStudentLocations(completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let URLRequest = NSMutableURLRequest(URL: NSURL(string: API.BaseURL + "?limit=5")!)

		URLRequest.HTTPMethod = HTTPMethod.Get

		URLRequest.addValue(ParseAppIDField.Value,      forHTTPHeaderField: ParseAppIDField.Name)
		URLRequest.addValue(ParseRESTAPIKeyField.Value, forHTTPHeaderField: ParseRESTAPIKeyField.Name)

		let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)
		dataTaskWithRequest.resume()
	}

	func postStudentLocation(studentLocation: JSONDictionary, completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let URLRequest = NSMutableURLRequest(URL: NSURL(string: API.BaseURL)!)

		URLRequest.HTTPMethod = HTTPMethod.Post
		URLRequest.HTTPBody   = try! NSJSONSerialization.dataWithJSONObject(studentLocation, options: .PrettyPrinted)

		URLRequest.addValue(ParseAppIDField.Value,      forHTTPHeaderField: ParseAppIDField.Name)
		URLRequest.addValue(ParseRESTAPIKeyField.Value, forHTTPHeaderField: ParseRESTAPIKeyField.Name)
      URLRequest.addValue(MIMEType.ApplicationJSON,   forHTTPHeaderField: HTTPHeaderField.ContentType)

		let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)
		dataTaskWithRequest.resume()
	}

}
