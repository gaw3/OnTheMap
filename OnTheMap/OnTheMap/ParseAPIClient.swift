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

	struct StudentLocationKeys {
		static let FirstName = "firstName"
		static let LastName  = "lastName"
		static let Lat			= "latitude"
		static let Location  = "mapString"
		static let Long		= "longitude"
		static let MediaURL  = "mediaURL"
		static let UniqueKey = "uniqueKey"
	}

	// MARK: - Private Constants

	private struct API {
		static let BaseURL = "https://api.parse.com/1/classes/StudentLocation"
	}

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

	func postStudentLocation(completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let studentlocation = [ StudentLocationKeys.UniqueKey : "blap",
										StudentLocationKeys.FirstName : "Jonathan",
										StudentLocationKeys.LastName  : "Hemlock",
										StudentLocationKeys.Location  : "Dallas, TX",
										StudentLocationKeys.MediaURL  : "https://udacity.com",
										StudentLocationKeys.Lat       : 32.7767,
										StudentLocationKeys.Long      : 96.797]

		let URLRequest = NSMutableURLRequest(URL: NSURL(string: API.BaseURL)!)

		URLRequest.HTTPMethod = HTTPMethod.Post
		URLRequest.HTTPBody   = try! NSJSONSerialization.dataWithJSONObject(studentlocation, options: .PrettyPrinted)

		URLRequest.addValue(ParseAppIDField.Value,      forHTTPHeaderField: ParseAppIDField.Name)
		URLRequest.addValue(ParseRESTAPIKeyField.Value, forHTTPHeaderField: ParseRESTAPIKeyField.Name)
      URLRequest.addValue(MIMEType.ApplicationJSON,   forHTTPHeaderField: HTTPHeaderField.ContentType)

		let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)
		dataTaskWithRequest.resume()
	}

}
