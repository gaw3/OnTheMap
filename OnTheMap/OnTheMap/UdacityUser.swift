//
//  UdacityUser.swift
//  OnTheMap
//
//  Created by Gregory White on 1/11/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

struct UdacityUser {
	
	// MARK: - Public Computed Variables
	
	var firstName: String? {

		get {
			var firstName: String? = nil

			if let user = _user {
				if let fn = user[UdacityAPIClient.API.FirstNameKey] as! String? {
					firstName = fn
				}
			}

			return firstName
		}
		
	}

	var fullName: String? {

		get {
			var fullName = String()

			if let _ = firstName {
				fullName.appendContentsOf(firstName!)
			}

			if let _ = lastName{
				if !fullName.isEmpty { fullName.appendContentsOf(" ") }
				
				fullName.appendContentsOf(lastName!)
			}

			return (!fullName.isEmpty) ? fullName : nil
		}

	}

	var isValid: Bool {

		get {
			var isValid = false

			if let _ = userID {
				if let _ = fullName {
					isValid = true
				}
			}

			return isValid
		}
		
	}

	var lastName: String? {

		get {
			var lastName: String? = nil

			if let user = _user {
				if let ln = user[UdacityAPIClient.API.LastNameKey] as! String? {
					lastName = ln
				}
			}

			return lastName
		}

	}

	var userID: String? {

		get {
			var userID: String? = nil

			if let user = _user {
				if let uID = user[UdacityAPIClient.API.UserIDKey] as! String? {
					userID = uID
				}
			}

			return userID
		}
		
	}

	// MARK: - Private Stored Variables

	private var _user: JSONDictionary? = nil
	
	// MARK: - API

	init(userDict: JSONDictionary) {

		if let user = userDict[UdacityAPIClient.API.UserKey] as! JSONDictionary? {
			_user = user
		}

	}

}