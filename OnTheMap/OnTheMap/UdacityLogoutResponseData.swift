//
//  UdacityLogoutResponseData.swift
//  OnTheMap
//
//  Created by Gregory White on 1/12/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

struct UdacityLogoutResponseData {

	var expirationDate: String? {

		get {
			var expirationDate: String? = nil

			if let session = _data[UdacityAPIClient.API.SessionKey] as! JSONDictionary? {
				if let date = session[UdacityAPIClient.API.ExpirationDateKey] as! String? {
					expirationDate = date
				}
			}

			return expirationDate
		}
		
	}
	
	var isValid: Bool {

		get {
			var isValid = false

			if let _ = expirationDate {
				if let _ = sessionID {
					isValid = true
				}
			}

			return isValid
		}
		
	}
	
	var sessionID: String? {

		get {
			var sessionID: String? = nil

			if let session = _data[UdacityAPIClient.API.SessionKey] as! JSONDictionary? {
				if let id = session[UdacityAPIClient.API.SessionIDKey] as! String? {
					sessionID = id
				}
			}

			return sessionID
		}
		
	}
	
	// MARK: - Private Stored Variables

	private var _data: JSONDictionary

	// MARK: - API

	init(data: JSONDictionary) { _data = data }
}