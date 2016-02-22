//
//  ParseAPIClient.swift
//  OnTheMap
//
//  Created by Gregory White on 11/30/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation
import UIKit

private let _sharedClient = ParseAPIClient()

final internal class ParseAPIClient: NSObject {

	class internal var sharedClient: ParseAPIClient {
		return _sharedClient
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

	internal func getStudentLocation(udacityUserID: String, completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let query               = "where={\"\(ParseAPIClient.API.UniqueKeyKey)\":\"\(udacityUserID)\"}"
		let URLRequest          = getURLRequest(APIDataTaskWithRequest.HTTP.Method.Get, URLString: ParseAPIClient.API.BaseURL, HTTPQuery: query)
		let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)

		dataTaskWithRequest.resume()
	}
	
	internal func postStudentLocation(studentLocation: StudentLocation, completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let URLRequest = getURLRequest(APIDataTaskWithRequest.HTTP.Method.Post, URLString: ParseAPIClient.API.BaseURL, HTTPQuery: nil)

		URLRequest.HTTPBody = studentLocation.newStudentSerializedData
		URLRequest.addValue(APIDataTaskWithRequest.HTTP.MIMEType.ApplicationJSON,
			                 forHTTPHeaderField: APIDataTaskWithRequest.HTTP.HeaderField.ContentType)

		let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)
		dataTaskWithRequest.resume()
	}
	
	internal func refreshStudentLocations(completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let query               = "limit=100&order=-updatedAt"
		let URLRequest          = getURLRequest(APIDataTaskWithRequest.HTTP.Method.Get, URLString: ParseAPIClient.API.BaseURL, HTTPQuery: query)
		let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)

		dataTaskWithRequest.resume()
	}

	internal func updateStudentLocation(studentLocation: StudentLocation, completionHandler: APIDataTaskWithRequestCompletionHandler) {
		let URLString  = ParseAPIClient.API.BaseURL + "/\(studentLocation.objectID)"
		let URLRequest = getURLRequest(APIDataTaskWithRequest.HTTP.Method.Put, URLString: URLString, HTTPQuery: nil)

		URLRequest.HTTPBody = studentLocation.newStudentSerializedData
		URLRequest.addValue(APIDataTaskWithRequest.HTTP.MIMEType.ApplicationJSON,
			                 forHTTPHeaderField: APIDataTaskWithRequest.HTTP.HeaderField.ContentType)

		let dataTaskWithRequest = APIDataTaskWithRequest(URLRequest: URLRequest, completionHandler: completionHandler)
		dataTaskWithRequest.resume()
	}
	
	// MARK: - Private

	override private init() {
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
