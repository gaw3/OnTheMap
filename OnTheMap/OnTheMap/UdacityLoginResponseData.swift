//
//  UdacityLoginResponseData.swift
//  OnTheMap
//
//  Created by Gregory White on 1/11/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

struct UdacityLoginResponseData {

	// MARK: - Public Computed Variables
	
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
	
	var isRegistered: Bool? {

		get {
			var isRegistered: Bool? = nil

			if let account = _data[UdacityAPIClient.API.AccountKey] as! JSONDictionary? {
				if let isReg = account[UdacityAPIClient.API.RegisteredKey] as! Bool? {
					isRegistered = isReg
				}
			}

			return isRegistered
		}
		
	}

	var isValid: Bool {

		get {
			var isValid = false

			if let _ = userID {
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

	var userID: String? {

		get {
			var userID: String? = nil

			if let account = _data[UdacityAPIClient.API.AccountKey] as! JSONDictionary? {
				if let id = account[UdacityAPIClient.API.UserIDKey] as! String? {
					userID = id
				}
			}

			return userID
		}

	}

	// MARK: - Private Stored Variables

	private var _data: JSONDictionary

	// MARK: - API

	init(data: JSONDictionary) { _data = data }
}
