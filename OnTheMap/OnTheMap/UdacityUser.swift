//
//  UdacityUser.swift
//  OnTheMap
//
//  Created by Gregory White on 1/11/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

internal struct UdacityUser {
	
	// MARK: - Internal Stored Variables

	fileprivate var _user: JSONDictionary? = nil

	// MARK: - Internal Computed Variables
	
	internal var firstName: String? {
		if let _ = _user {
			if let name = _user![UdacityAPIClient.API.FirstNameKey] as! String? { return name }
		}
		return nil
	}

	internal var lastName: String? {
			if let _ = _user {
				if let name = _user![UdacityAPIClient.API.LastNameKey] as! String? { return name }
			}
			return nil
	}

	internal var userID: String? {
		if let _ = _user {
			if let id = _user![UdacityAPIClient.API.UserIDKey] as! String? { return id }
		}
		return nil
	}
	
	// MARK: - Internal Computed Meta Variables

	internal var fullName: String? {
		var fullName = String()

		if let _ = firstName {
			fullName.append(firstName!)
		}

		if let _ = lastName{
			if !fullName.isEmpty { fullName.append(" ") }
			
			fullName.append(lastName!)
		}

		return (!fullName.isEmpty) ? fullName : nil
	}

	// MARK: - API

	internal init(userDict: JSONDictionary) {

		if let user = userDict[UdacityAPIClient.API.UserKey] as! JSONDictionary? {
			_user = user
		}

	}

}
