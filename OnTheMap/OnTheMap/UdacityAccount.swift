//
//  UdacityAccount.swift
//  OnTheMap
//
//  Created by Gregory White on 1/14/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

internal struct UdacityAccount {

	// MARK: - Private Stored Variables

	fileprivate var _account: JSONDictionary
	
	// MARK: - Internal Computed Variables

	internal var isRegistered: Bool {
		if let isRegistered = _account[UdacityAPIClient.API.RegisteredKey] as! Bool? { return isRegistered }
		return false
	}
	
	internal var userID: String? {
		if let userID = _account[UdacityAPIClient.API.UserIDKey] as! String? { return userID }
		return nil
	}

	// MARK: - API

	internal init(accountDict: JSONDictionary) { _account = accountDict }
}
