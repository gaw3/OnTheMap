//
//  UdacityUser.swift
//  OnTheMap
//
//  Created by Gregory White on 1/11/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

struct UdacityUser {
	
	// MARK: - Private Stored Variables

	private var _user: JSONDictionary? = nil

	// MARK: - Public Computed Variables
	
	var firstName: String? {
		get {
			if let _ = _user {
				if let name = _user![UdacityAPIClient.API.FirstNameKey] as! String? { return name }
			}
			return nil
		}
	}

	var lastName: String? {
		get {
			if let _ = _user {
				if let name = _user![UdacityAPIClient.API.LastNameKey] as! String? { return name }
			}
			return nil
		}
	}

	var userID: String? {
		get {
			if let _ = _user {
				if let id = _user![UdacityAPIClient.API.UserIDKey] as! String? { return id }
			}
			return nil
		}
	}
	
	// MARK: - Public Computed Meta Variables

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

	// MARK: - API

	init(userDict: JSONDictionary) {

		if let user = userDict[UdacityAPIClient.API.UserKey] as! JSONDictionary? {
			_user = user
		}

	}

}